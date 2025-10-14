<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!--
사용한 것: ai2(/ai3/stt, /ai3/chat-text), ai4(/ai3/image-generate), ai3(/ai3/image-analysis)
동작: 음성으로 이미지 설명 → 이미지 생성 → 생성된 이미지를 자동 분석(설명 텍스트 스트리밍 표시) → 설명을 음성으로 재생
!-->

<script>
  let ai5 = {
    init: function () {
      this.startQuestion();
      $('#spinner').css('visibility', 'hidden');
    },

    // 1) 음성 녹음 유도 및 마이크 초기화 (ai2 패턴 재사용)
    startQuestion: function () {
      springai.voice.initMic(this); // 녹음 완료 시 this.handleVoice(mp3Blob) 호출됨

      let qForm = `
        <div class="media border p-3">
          <div class="speakerPulse" style="width:30px;height:30px;background:url('/image/speaker-yellow.png') no-repeat center center/contain;"></div>
          만들고자 하는 이미지를 <b>음성으로</b> 설명하세요
        </div>`;
      $('#result').prepend(qForm);
    },

    //  음성 → STT → 이미지 생성 호출 (ai2 + ai4 조합)
    handleVoice: async function (mp3Blob) {
      $('#spinner').css('visibility', 'visible');

      //  STT 요청
      const formData = new FormData();
      formData.append('speech', mp3Blob, 'speech.mp3');
      const sttResponse = await fetch('/ai3/stt', {
        method: 'post',
        headers: { 'Accept': 'text/plain' },
        body: formData
      });
      const description = await sttResponse.text();

      // 사용자 말풍선 출력
      let qForm = `
        <div class="media border p-3">
          <img src="/image/user.png" alt="User" class="mr-3 mt-3 rounded-circle" style="width:60px;">
          <div class="media-body">
            <h6>사용자</h6>
            <p>` + description + `</p>
          </div>
        </div>`;
      $('#result').prepend(qForm);

      //  이미지 생성
      await this.generateImage(description);
    },

    //  이미지 생성 (ai4 패턴 재사용)
    generateImage: async function (promptText) {
      try {
        const response = await fetch('/ai3/image-generate', {
          method: 'post',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/x-ndjson'
          },
          body: new URLSearchParams({ question: promptText })
        });

        const b64 = await response.text();
        if (b64.includes('Error')) {
          alert(b64);
          return;
        }

        // 미리보기 이미지 반영
        const base64Src = 'data:image/png;base64,' + b64;
        this.ensurePreviewImage();
        const generatedImage = document.getElementById('generatedImage');
        generatedImage.src = base64Src;

        // 다운로드 링크 제공
        const alink = document.createElement('a');
        alink.innerHTML = 'Download';
        alink.href = base64Src;
        alink.download = 'output-' + new Date().getTime() + '.png';
        $('#result').prepend(alink);

        // 안내 버블
        let uuid = this.makeUi('result');
        $('#' + uuid).html('이미지 생성 완료. 자동으로 설명을 요청합니다…');

        // 생성된 이미지를 자동으로 분석 요청 → 설명 스트리밍 표시 후 TTS 재생
        await this.analyzeAndSpeak(base64Src);
      } catch (e) {
        console.error(e);
        alert('이미지 생성 중 오류가 발생했습니다.');
      } finally {
        $('#spinner').css('visibility', 'hidden');
        // 다음 음성 입력을 다시 받을 준비
        this.startQuestion();
      }
    },

    // 생성 이미지 자동 분석(스트리밍 수신) + 설명 TTS 재생 (ai3 + ai2 조합)
    analyzeAndSpeak: async function (dataUrl) {
      // dataURL → Blob 변환
      const blob = this.dataURLtoBlob(dataUrl);

      // 멀티파트 구성 (ai3 패턴 재사용)
      const formData = new FormData();
      formData.append('question', '이 이미지를 자세히 설명해줘. 핵심 요소와 분위기, 배경/피사체, 색감/스타일을 포함해서.');
      formData.append('attach', new File([blob], 'generated.png', { type: 'image/png' }));

      const response = await fetch('/ai3/image-analysis', {
        method: 'post',
        headers: { 'Accept': 'application/x-ndjson' },
        body: formData
      });

      let uuid = this.makeUi('result');

      // 스트리밍으로 들어오는 텍스트를 화면에 누적 표시
      const reader = response.body.getReader();
      const decoder = new TextDecoder('utf-8');
      let content = '';
      while (true) {
        const { value, done } = await reader.read();
        if (done) break;
        const chunk = decoder.decode(value);
        content += chunk;
        $('#' + uuid).html(content);
      }

      // 스트리밍 수신 완료 후, 설명 텍스트를 음성으로 출력 (ai2의 /ai3/chat-text 사용)
      await this.speak(content);
    },

    // ===== 5) 설명 텍스트를 음성으로 출력 (ai2.chat 로직을 단일 함수로 단순화) =====
    speak: async function (textToSpeak) {
      try {
        const response = await fetch('/ai3/chat-text', {
          method: 'post',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Accept': 'application/json'
          },
          body: new URLSearchParams({ question: textToSpeak })
        });

        const answerJson = await response.json();
        console.log('TTS answer:', answerJson);

        const audioPlayer = document.getElementById('audioPlayer');
        audioPlayer.src = 'data:audio/mp3;base64,' + answerJson.audio;

        // 재생 시작시(선택) 화면 텍스트 갱신을 넣을 수도 있으나, 여기서는 이미 content를 표시했으므로 생략
        audioPlayer.play();
      } catch (e) {
        console.error(e);
        // 음성 생성 실패 시에도 UI 흐름은 계속
      }
    },

    dataURLtoBlob: function (dataurl) {
      const arr = dataurl.split(','), mime = arr[0].match(/:(.*?);/)[1];
      const bstr = atob(arr[1]);
      let n = bstr.length;
      const u8arr = new Uint8Array(n);
      while (n--) { u8arr[n] = bstr.charCodeAt(n); }
      return new Blob([u8arr], { type: mime });
    },

    ensurePreviewImage: function () {
      if (!document.getElementById('generatedImage')) {
        const img = document.createElement('img');
        img.id = 'generatedImage';
        img.className = 'img-fluid';
        img.alt = 'Generated Image';
        $('#result').prepend(img);
      }
    },

    makeUi: function (target) {
      let uuid = 'id-' + crypto.randomUUID();
      let aForm = `
        <div class="media border p-3">
          <div class="media-body">
            <h6>Assistant</h6>
            <p><pre id="` + uuid + `"></pre></p>
          </div>
          <img src="/image/assistant.png" alt="Assistant" class="ml-3 mt-3 rounded-circle" style="width:60px;">
        </div>`;
      $('#' + target).prepend(aForm);
      return uuid;
    }
  };

  $(() => { ai5.init(); });
</script>

<div class="col-sm-10">
  <h2>Spring AI 5 (Voice → Image → Auto Describe → TTS)</h2>
  <div class="row">
    <div class="col-sm-8">
      <h4>음성으로 만들 이미지를 설명하세요</h4>
      <audio id="audioPlayer" controls style="display:none;"></audio>
    </div>
    <div class="col-sm-2"></div>
    <div class="col-sm-2">
      <button class="btn btn-primary" disabled>
        <span class="spinner-border spinner-border-sm" id="spinner"></span>
        Loading..
      </button>
    </div>
  </div>

  <div id="result" class="container p-3 my-3 border" style="overflow:auto;width:auto;height:800px;"></div>
</div>

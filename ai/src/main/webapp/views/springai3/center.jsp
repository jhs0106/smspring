<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
  let center = {
    init:function(){
      this.previewCamera('video');

      $('#send_btn').click(()=>{
        this.captureFrame("video", (pngBlob) => {
          this.send(pngBlob);
        });
      });
    },
    previewCamera:function(videoId){
      const video = document.getElementById(videoId);
      //카메라를 활성화하고 <video>에서 보여주기
      navigator.mediaDevices.getUserMedia({ video: true })
              .then((stream) => {
                video.srcObject = stream;
                video.play();
              })
              .catch((error) => {
                console.error('카메라 접근 에러:', error);
              });
    },
    captureFrame:function(videoId, handleFrame){
      const video = document.getElementById(videoId);
      $('#capture').empty();

      //캔버스를 생성해서 비디오 크기와 동일하게 맞춤
      const canvas = document.createElement('canvas');
      $('#capture').append(canvas);

      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;

      // 캔버스로부터  2D로 드로잉하는 Context를 얻어냄
      const context = canvas.getContext('2d');

      // 비디오 프레임을 캔버스에 드로잉
      context.drawImage(video, 0, 0, canvas.width, canvas.height);

      // 드로잉된 프레임을 PNG 포맷의 blob 데이터로 얻기
      canvas.toBlob((blob) => {
        handleFrame(blob);
      }, 'image/png');
    },
    send: async function(pngBlob){
      $('#spinner').css('visibility','visible');

      // 멀티파트 폼 구성하기
      const formData = new FormData();
      formData.append('attach', pngBlob, 'frame.png');

      // AJAX 요청
      const response = await fetch('${adminserver}aimsg2', {
        method: "post",
        headers: {
          'Accept': 'application/json'
        },
        body: formData
      });

      if(response.ok){
        alert('Success');
      }else{
        alert('Fail');
      }


    }
  }

  $(()=>{
    center.init();
  });
</script>


<div class="col-sm-10">
  <h2>Spring AI Center</h2>

  <div class="row">
    <div class="col-sm-12">
      <div class="row">
        <div class="col-sm-2">
          <button class="btn btn-primary" id="send_btn">
            Send
          </button>
        </div>
      </div>
      <div class="container p-3 my-3 border" style="overflow: auto;width:auto;height: 300px;">
        <div class="row">
          <div class="col-sm-6">
            <video id="video" src="" alt="" height="200" autoplay />
          </div>
          <div class="col-sm-6" id="capture">
          </div>
        </div>
      </div>
    </div>

  </div>

</div>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>--%>

<%--<script>--%>
<%--  let center = {--%>
<%--    init:function (){--%>
<%--      this.previewCamera('video');--%>
<%--      $('#status').text('Camera ready.');--%>

<%--      $('#send_btn').click(()=>{--%>
<%--        $('#status').text('Capturing image...');--%>
<%--        this.captureFrame('video', (pngBlob) => {--%>
<%--          this.send(pngBlob);--%>
<%--        });--%>
<%--      });--%>
<%--    },--%>
<%--    previewCamera:function(videoId){--%>
<%--      const video = document.getElementById(videoId);--%>
<%--      navigator.mediaDevices.getUserMedia({ video: true })--%>
<%--              .then((stream) => {--%>
<%--                video.srcObject = stream;--%>
<%--                video.play();--%>
<%--              })--%>
<%--              .catch((error) => {--%>
<%--                console.error('카메라 접근 에러:', error);--%>
<%--                $('#status').text('카메라 접근 에러: ' + error.message);--%>
<%--              });--%>
<%--    },--%>
<%--    captureFrame:function(videoId, handleFrame){--%>
<%--      const video = document.getElementById(videoId);--%>
<%--      const canvas = document.createElement('canvas');--%>
<%--      canvas.width = video.videoWidth;--%>
<%--      canvas.height = video.videoHeight;--%>
<%--      const context = canvas.getContext('2d');--%>
<%--      context.drawImage(video, 0, 0, canvas.width, canvas.height);--%>
<%--      canvas.toBlob((blob) => {--%>
<%--        handleFrame(blob);--%>
<%--      }, 'image/png');--%>
<%--    },--%>
<%--    send: async function (pngBlob){--%>
<%--      $('#status').text('이미지 전송 중...');--%>

<%--      const formData = new FormData();--%>
<%--      formData.append('image', pngBlob, 'capture.png');--%>

<%--      try {--%>
<%--        const response = await fetch('${adminserver}aiimage', {--%>
<%--          method: 'POST',--%>
<%--          body: formData--%>
<%--        });--%>

<%--        if(!response.ok){--%>
<%--          throw new Error('Server responded with status ' + response.status);--%>
<%--        }--%>

<%--        const resultText = await response.text();--%>
<%--        $('#status').text(resultText);--%>
<%--      } catch (error){--%>
<%--        console.error('이미지 전송 실패:', error);--%>
<%--        $('#status').text('이미지 전송 실패: ' + error.message);--%>
<%--      }--%>
<%--    }--%>
<%--  }--%>

<%--  $(()=>{--%>
<%--    center.init();--%>
<%--  })--%>
<%--</script>--%>

<%--<div class="col-sm-10">--%>
<%--  <h2>Spring AI3 Center</h2>--%>
<%--  <div class="row mb-3">--%>
<%--    <div class="col-sm-8">--%>
<%--      <video id="video" src="" alt="" style="width: 100%; max-width: 320px;" autoplay muted></video>--%>
<%--    </div>--%>
<%--  </div>--%>
<%--  <button id="send_btn" class="btn btn-primary">Capture &amp; Send</button>--%>
<%--  <div id="status" class="mt-3 text-info"></div>--%>
<%--</div>--%>

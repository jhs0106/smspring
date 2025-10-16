<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script>
  let center = {
    init:function (){
      this.previewCamera('video');
      $('#status').text('Camera ready.');

      $('#send_btn').click(()=>{
        $('#status').text('Capturing image...');
        this.captureFrame('video', (pngBlob) => {
          this.send(pngBlob);
        });
      });
    },
    previewCamera:function(videoId){
      const video = document.getElementById(videoId);
      navigator.mediaDevices.getUserMedia({ video: true })
              .then((stream) => {
                video.srcObject = stream;
                video.play();
              })
              .catch((error) => {
                console.error('카메라 접근 에러:', error);
                $('#status').text('카메라 접근 에러: ' + error.message);
              });
    },
    captureFrame:function(videoId, handleFrame){
      const video = document.getElementById(videoId);
      const canvas = document.createElement('canvas');
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;
      const context = canvas.getContext('2d');
      context.drawImage(video, 0, 0, canvas.width, canvas.height);
      canvas.toBlob((blob) => {
        handleFrame(blob);
      }, 'image/png');
    },
    send: async function (pngBlob){
      $('#status').text('이미지 전송 중...');

      const formData = new FormData();
      formData.append('image', pngBlob, 'capture.png');

      try {
        const response = await fetch('${adminserver}aiimage', {
          method: 'POST',
          body: formData
        });

        if(!response.ok){
          throw new Error('Server responded with status ' + response.status);
        }

        const resultText = await response.text();
        $('#status').text(resultText);
      } catch (error){
        console.error('이미지 전송 실패:', error);
        $('#status').text('이미지 전송 실패: ' + error.message);
      }
    }
  }

  $(()=>{
    center.init();
  })
</script>

<div class="col-sm-10">
  <h2>AI3 Voice Image Chat System</h2>
  <h5>${adminserver}</h5>
  <div class="row mb-3">
    <div class="col-sm-8">
      <video id="video" src="" alt="" style="width: 100%; max-width: 320px;" autoplay muted></video>
    </div>
  </div>
  <button id="send_btn" class="btn btn-primary">Capture &amp; Send</button>
  <div id="status" class="mt-3 text-info"></div>
</div>

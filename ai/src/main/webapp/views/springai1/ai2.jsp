<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script>
  ai2 = {
    init:function(){
      $('#send').click(()=>{
        this.send();
      });
      $ ('#spinner').css('visibility', 'hidden');
    },
    send:async function() {
      //1. spinner 열고
      $('#spinner').css('visibility', 'visible');

      //2. question, ajax 요청
      const question = $('#question').val();
      let qForm = `
            <div class="media border p-3">
              <img src="/image/user.png" alt="User" class="mr-3 mt-3 rounded-circle" style="width:60px;">
              <div class="media-body">
                <h6>User</h6>
                <p>` + question + `</p>
              </div>
            </div>
    `;
      $('#result').prepend(qForm);

      const response = await fetch('<c:url value="/ai1/chat-model-stream"/>', {
        method: "post",
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/x-ndjson' //라인으로 구분된 청크 텍스트
        },
        body: new URLSearchParams({question})
      });

      //3. 결과를 받는다.
      //4. makeUi를 해서 결과를 출력할 화면을 만든다.
      const uuid = this.makeUi('result');
      //5. Stream으로 들어오는 텍스트를 만들어진 화면에 출력한다.
      const reader = response.body.getReader();
      const decoder = new TextDecoder("utf-8");
      let content = "";
      while (true) {
        const {value, done} = await reader.read();
        if (done) break;
        let chunk = decoder.decode(value);
        content += chunk;
        console.log(content);
        $('#' + uuid).html(content)
      }
      $('#spinner').css('visibility', 'hidden');
    },
    makeUi:function(target){
        let uuid = "id-" + crypto.randomUUID();

        let aForm = `
          <div class="media border p-3">
            <div class="media-body">
              <h6>GPT4 </h6>
              <p><pre id="`+uuid+`"></pre></p>
            </div>
            <img src="/image/assistant.png" alt="John Doe" class="ml-3 mt-3 rounded-circle" style="width:60px;">
          </div>
    `;
        $('#'+target).prepend(aForm);
        return uuid;
    }
  }
  $(()=>{
    ai2.init();
  });
</script>

<div class="col-sm-10">
  <h2>Spring AI2 Chat Stream</h2>
  <div class="row">
    <div class="col-sm-8">
      <textarea id="question" class="form-control">Spring AI에 대해 300자 이내로 설명해줘</textarea>
    </div>
    <div class="col-sm-2">
      <button type="button" class="btn btn-primary" id="send">Send</button>
    </div>
    <div class="col-sm-2">
      <button class="btn btn-primary" disabled >
        <span class="spinner-border spinner-border-sm" id="spinner"></span>
        Loading..
      </button>
    </div>
  </div>


  <div id="result" class="container p-3 my-3 border" style="overflow: auto;width:auto;height: 500px;">

  </div>

</div>
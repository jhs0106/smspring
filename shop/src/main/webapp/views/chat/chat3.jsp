<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  /* 채팅창 컨테이너 스타일 */
  .chat-box {
    width: 100%;
    height: 400px;
    overflow-y: auto;
    border: 1px solid #ddd;
    padding: 15px;
    display: flex;
    flex-direction: column-reverse; /* 새 메시지가 아래에 오는 것처럼 보이게 함 */
  }

  /* 받은 메시지 말풍선 스타일 (왼쪽) */
  .message-bubble-received {
    background-color: #f1f0f0;
    border: 1px solid #e0e0e0;
  }

  /* 보낸 메시지 말풍선 스타일 (오른쪽) */
  .message-bubble-sent {
    background-color: #007bff;
    color: white;
    border: 1px solid #006fe6;
  }
</style>

<script>
  let chat2 = {
    id: '',
    stompClient: null,
    init: function () {
      this.id = $('#user_id').text();
      $('#connect').click(() => {
        this.connect();
      });
      $('#disconnect').click(() => {
        this.disconnect();
      });
      $('#sendall').click(() => {
        let msg = JSON.stringify({
          'sendid': this.id,
          'content1': $("#alltext").val()
        });
        this.stompClient.send("/receiveall", {}, msg);
        $("#alltext").val('');
      });
      $('#sendme').click(() => {
        let msg = JSON.stringify({
          'sendid': this.id,
          'content1': $("#metext").val()
        });
        this.stompClient.send("/receiveme", {}, msg);
        $("#metext").val('');
      });
      $('#sendto').click(() => {
        var msg = JSON.stringify({
          'sendid': this.id,
          'receiveid': $('#target').val(),
          'content1': $('#totext').val()
        });
        this.stompClient.send('/receiveto', {}, msg);
        $('#totext').val('');
      });
    },
    // 메시지 UI를 생성하여 화면에 표시하는 새 함수
    // 기존 showMessage 함수를 아래 코드로 전체 교체해주세요.
    // 기존 showMessage 함수를 아래 디버깅용 코드로 완전히 교체해주세요.
    showMessage: function (message, targetDivId) {
      // --- 1. 함수가 정상적으로 호출되었는지 확인 ---
      console.log("1. showMessage 함수 시작됨. 대상 ID:", targetDivId);

      // --- 2. 수신된 message 객체 전체를 확인 ---
      console.log("2. 서버로부터 받은 원본 메시지:", message);

      const senderId = message.sendid;
      const content = message.content1;

      // --- 3. content 변수에 값이 제대로 담겼는지 확인 ---
      console.log("3. content 변수 값:", content);

      // [중요] 만약 3번 로그의 content 값이 여기서 비어있다면, 데이터에 문제가 있는 것입니다.
      if (!content || content.trim() === '') {
        console.error("오류: content 값이 비어있어 표시할 수 없습니다.");
        return;
      }

      const myId = this.id;
      let html;

      if (senderId === myId) {
        html = `
            <div class="d-flex justify-content-end mb-3">
                <div class="text-right">
                    <h6 class="mt-0 mb-1 small text-muted">${senderId}</h6>
                    <div class="message-bubble-sent p-2 rounded" style="display: inline-block; text-align: left;">
                        ${content}
                    </div>
                </div>
            </div>`;
      } else {
        html = `
            <div class="d-flex justify-content-start mb-3">
                <div class="media-body">
                    <h6 class="mt-0 mb-1 small text-muted">${senderId}</h6>
                    <div class="message-bubble-received p-2 rounded d-inline-block">
                        ${content}
                    </div>
                </div>
            </div>`;
      }

      // --- 4. 완성된 HTML 코드를 확인 ---
      console.log("4. 화면에 추가될 HTML:", html);

      // --- 5. 메시지를 추가할 대상을 jQuery가 제대로 찾았는지 확인 ---
      console.log("5. jQuery 선택자 결과:", $(targetDivId));
      if ($(targetDivId).length === 0) {
        console.error("치명적 오류: " + targetDivId + " 요소를 찾을 수 없습니다! HTML의 id를 확인하세요!");
      }

      // --- 6. 화면에 메시지 추가 ---
      $(targetDivId).prepend(html);
      console.log("6. 성공적으로 화면에 메시지를 추가했습니다.");
    },
            // 기존의 connect 함수를 아래 코드로 통째로 교체하세요.
            connect: function () {
              const self = this; // self를 사용해 this 문제 해결
              let sid = this.id;
              let socket = new SockJS('${websocketurl}chat');
              this.stompClient = Stomp.over(socket);

              // [수정됨] function(frame)을 (frame) => 로 바꾸거나, 아래처럼 self를 사용해야 합니다.
              this.stompClient.connect({}, function(frame) {
                console.log('Connected: ' + frame);
                self.setConnected(true);

                // [수정됨] self.stompClient.subscribe() 로 호출해야 정상 동작합니다.
                self.stompClient.subscribe('/send', function(msg) {
                  $("#all").prepend(
                          "<h4>" + JSON.parse(msg.body).sendid + ":" +
                          JSON.parse(msg.body).content1
                          + "</h4>");
                });

                self.stompClient.subscribe('/send/' + sid, function(msg) {
                  $("#me").prepend(
                          "<h4>" + JSON.parse(msg.body).sendid + ":" +
                          JSON.parse(msg.body).content1 + "</h4>");
                });

                self.stompClient.subscribe('/send/to/' + sid, function(msg) {
                  $("#to").prepend(
                          "<h4>" + JSON.parse(msg.body).sendid + ":" +
                          JSON.parse(msg.body).content1
                          + "</h4>");
                });
              });
            },
    disconnect: function () {
      if (this.stompClient !== null) {
        this.stompClient.disconnect();
      }
      this.setConnected(false);
      console.log("Disconnected");
    },
    setConnected: function (connected) {
      $("#connect").prop("disabled", connected);
      $("#disconnect").prop("disabled", !connected);
      if (connected) {
        $("#status").text("Connected").removeClass("text-danger").addClass("text-success");
      } else {
        $("#status").text("Disconnected").removeClass("text-success").addClass("text-danger");
      }
    }
  }

  $(() => {
    chat2.init();
    chat2.setConnected(false);
  });
</script>


<div class="col-sm-10">
  <h2>Chat2</h2>
  <div class="container mt-3">
    <div class="col-sm-6">
      <p>Your ID: <strong id="user_id">${sessionScope.cust.custId}</strong></p>
      <p>Status: <strong id="status" class="text-danger">Disconnected</strong></p>
      <button id="connect" class="btn btn-success">Connect</button>
      <button id="disconnect" class="btn btn-danger">Disconnect</button>
    </div>
    <br>
    <ul class="nav nav-tabs">
      <li class="nav-item">
        <a class="nav-link active" data-toggle="tab" href="#All">All</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" data-toggle="tab" href="#Me">Me</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" data-toggle="tab" href="#To">To</a>
      </li>
    </ul>

    <div class="tab-content border border-top-0 p-3">
      <div id="All" class="container tab-pane active"><br>
        <h3>All</h3>
        <div class="input-group mb-3">
          <input type="text" class="form-control" placeholder="Message..." id="alltext">
          <div class="input-group-append">
            <button class="btn btn-primary" id="sendall">Send</button>
          </div>
        </div>
        <div id="all" class="chat-box"></div>
      </div>
      <div id="Me" class="container tab-pane fade"><br>
        <h3>Me</h3>
        <div class="input-group mb-3">
          <input type="text" class="form-control" placeholder="Message..." id="metext">
          <div class="input-group-append">
            <button class="btn btn-primary" id="sendme">Send</button>
          </div>
        </div>
        <div id="me" class="chat-box"></div>
      </div>
      <div id="To" class="container tab-pane fade"><br>
        <h3>To</h3>
        <div class="input-group mb-3">
          <input type="text" class="form-control" placeholder="Recipient ID" id="target">
          <input type="text" class="form-control" placeholder="Message..." id="totext">
          <div class="input-group-append">
            <button class="btn btn-primary" id="sendto">Send</button>
          </div>
        </div>
        <div id="to" class="chat-box"></div>
      </div>
    </div>
  </div>
</div>
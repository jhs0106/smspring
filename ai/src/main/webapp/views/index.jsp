<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Bootstrap 4 Website Example</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.7.1/dist/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/lamejs@1.2.0/lame.min.js"></script>
    <link href="<c:url value="/css/springai.css"/>" rel="stylesheet" />
    <script src="<c:url value="/js/springai.js"/>" ></script>
    <script>
        let index = {
            init:function(){
                this.startQuestion();
                this.startVoice();
            },
            startVoice: async function(){
                const audioPlayer = document.getElementById("mainAudioPlayer");
                await audioPlayer.play();
            },
            startQuestion:function(){
                springai.voice.initMic(this);
                $('#mainspinner').css('visibility','hidden');
            },
            handleVoice: async function(mp3Blob){

                //스피너 보여주기
                $('#mainspinner').css('visibility','visible');

                // 멀티파트 폼 구성
                const formData = new FormData();
                formData.append("speech", mp3Blob, 'speech.mp3');

                // 녹화된 음성을 텍스트로 변환 요청
                const response = await fetch("/ai3/stt2", {
                    method: "post",
                    headers: {
                        'Accept': 'text/plain'
                    },
                    body: formData
                });

                // 텍스트 질문을 채팅 패널에 보여주기
                const target = await response.text();
                console.log('Handle:'+target);
                location.href=target;

                //
                // $.ajax({
                //     url:'/ai3/target',
                //     data:{'questionText':questionText},
                //     success:(target)=>{
                //         location.href=target;
                //     }
                // });
            }
        }

        $((()=>{
            index.init();
        }));

        // $(async function() {
        //     const $spinner = $("#mainspinner");
        //     $spinner.css('visibility','hidden');
        //     let inFlight = false;
        //
        //     // 텍스트→URL 매핑 함수 (클라이언트 하드코딩)
        //     function resolveUrl(text) {
        //         const s = (text || '').trim().toLowerCase();
        //         const rules = [
        //             { kws: ["홈","메인","처음","home"], url: "/" },
        //             { kws: ["로그인","login","로그 온"], url: "/login" },
        //             { kws: ["회원가입","레지스터","register","가입"], url: "/register" },
        //             // 필요시 추가:
        //             // { kws: ["인생"], url: "/springai1/ai1" },
        //             // { kws: ["민생"], url: "/springai2/ai1" },
        //             // { kws: ["중생"], url: "/springai3/ai1" },
        //         ];
        //         for (const r of rules) {
        //             if (r.kws.some(k => s.includes(k))) return r.url;
        //         }
        //         return null; // 매칭 없으면 아무 동작 안함
        //     }
        //
        //     const listener = {
        //         async handleVoice(mp3Blob) {
        //             if (inFlight) return;
        //             inFlight = true;
        //             $spinner.css("visibility","visible");
        //
        //             try {
        //                 // 1) STT
        //                 const fd = new FormData();
        //                 fd.append("speech", mp3Blob, "speech.mp3");
        //                 const sttRes = await fetch("/ai3/stt", {
        //                     method: "POST",
        //                     headers: { "Accept": "text/plain" },
        //                     body: fd
        //                 });
        //                 const text = (await sttRes.text()).trim();
        //                 console.log("인식 결과:", text);
        //                 if (!text) return;
        //
        //                 // 2) 클라이언트에서 바로 라우팅
        //                 const url = resolveUrl(text);
        //                 if (url) {
        //                     location.href = url;
        //                     return;
        //                 }
        //                 // 매칭 없으면 그대로 유지
        //             } catch (err) {
        //                 console.error("음성 처리 오류:", err);
        //             } finally {
        //                 $spinner.css("visibility","hidden");
        //                 inFlight = false;
        //                 // 계속 듣기 유지
        //                 try { await springai.voice.initMic(listener); } catch(_) {}
        //             }
        //         }
        //     };
        //
        //     // 다시 시작
        //     try { await springai.voice.initMic(listener); }
        //     catch (e) { console.error("마이크 접근 실패:", e); }
        // });
    </script>


    <style>
        .fakeimg {
            height: 200px;
            background: #aaa;
        }
    </style>
</head>
<body>

<div class="jumbotron text-center" style="margin-bottom:0">
    <h1>SpringAI System</h1>
</div>
<ul class="nav justify-content-end">
    <li class="nav-item">
        <a class="nav-link" href="<c:url value="/login"/>">LOGIN</a>
    </li>
    <li class="nav-item">
        <a class="nav-link" href="<c:url value="/register"/>">REGISTER</a>
    </li>
    <button class="btn btn-primary" disabled >
        <span class="spinner-border spinner-border-sm" id="mainspinner"></span>
    </button>
</ul>
<nav class="navbar navbar-expand-sm bg-dark navbar-dark">
    <a class="navbar-brand" href="<c:url value="/"/>">Home</a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#collapsibleNavbar">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="collapsibleNavbar">
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/springai1"/>">SpringAI1</a>
            </li>
        </ul>
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/springai2"/>">SpringAI2</a>
            </li>
        </ul>
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/springai3"/>">SpringAI3</a>
            </li>
        </ul>
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/springai4"/>">SpringAI4</a>
            </li>
        </ul>
        <ul class="navbar-nav">
            <li class="nav-item">
                <a class="nav-link" href="<c:url value="/springai5"/>">SpringAI5</a>
            </li>
        </ul>
    </div>
</nav>
<div class="container" style="margin-top:30px; margin-bottom: 30px;">
    <div class="row">
        <%-- Left Menu Start ........  --%>
        <c:choose>
            <c:when test="${left == null}">
                <jsp:include page="left.jsp"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="${left}.jsp"/>
            </c:otherwise>
        </c:choose>

        <%-- Left Menu End ........  --%>
        <c:choose>
            <c:when test="${center == null}">
                <jsp:include page="center.jsp"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="${center}.jsp"/>
            </c:otherwise>
        </c:choose>
        <%-- Center Start ........  --%>

        <%-- Center End ........  --%>
    </div>
</div>

<div class="text-center" style="background-color:black; color: white; margin-bottom:0; max-height: 50px;">
    <p>Footer</p>
</div>

</body>
</html>

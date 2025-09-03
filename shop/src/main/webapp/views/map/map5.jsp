<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%-- 1. 스타일(Style) 정의 --%>
<style>
  #map_container {
    padding: 20px;
  }
  #map {
    width: 700px;
    height: 600px;
    border: 2px solid #007bff;
    border-radius: 8px;
  }
  .btn-container {
    margin-bottom: 15px;
    text-align: center;
  }
</style>

<%-- 2. 스크립트(Script) 로직 --%>
<script>
  (function() {
    // 변수 선언
    let map; // 지도 객체를 담을 변수
    let intervalId = null; // setInterval의 고유 ID를 저장할 변수

    /**
     * 지도 초기화 함수
     */
    function initMap() {
      const mapContainer = document.getElementById('map');
      const mapOptions = {
        center: new kakao.maps.LatLng(36.0, 127.5), // 대한민국 중앙 좌표
        level: 12
      };
      map = new kakao.maps.Map(mapContainer, mapOptions);
    }

    /**
     * 서버에 랜덤 마커 데이터를 요청하고 지도에 추가하는 함수
     */
    function fetchAndAddMarker() {
      const url = '<c:url value="/map/randommarker"/>';

      $.ajax({
        url: url,
        type: 'GET',
        success: function(data) {
          console.log('새로운 좌표 수신:', data);
          const markerPosition = new kakao.maps.LatLng(data.lat, data.lng);

          // 마커를 생성합니다
          const marker = new kakao.maps.Marker({
            position: markerPosition
          });

          // 지도에 마커를 표시합니다
          marker.setMap(map);
        },
        error: function(xhr, status, error) {
          console.error("랜덤 마커 데이터 요청 실패:", error);
          // 에러 발생 시 안전하게 반복을 중지합니다.
          stopMarkerGeneration();
        }
      });
    }

    /**
     * 마커 생성 시작 함수
     */
    function startMarkerGeneration() {
      if (intervalId !== null) {
        alert('이미 시작되었습니다.');
        return;
      }
      console.log('마커 생성을 시작합니다.');
      // 1.5초(1500ms)마다 fetchAndAddMarker 함수를 반복 실행합니다.
      intervalId = setInterval(fetchAndAddMarker, 1500);
    }

    /**
     * 마커 생성 정지 함수
     */
    function stopMarkerGeneration() {
      if (intervalId === null) {
        alert('시작되지 않았습니다.');
        return;
      }
      console.log('마커 생성을 정지합니다.');
      clearInterval(intervalId); // setInterval의 반복 실행을 중지합니다.
      intervalId = null; // ID 변수를 초기화합니다.
    }

    /**
     * 페이지 로딩 완료 후 실행 (jQuery의 $(function() { ... }) 과 동일)
     */
    $(document).ready(function() {
      // 가장 먼저 지도를 초기화합니다.
      initMap();

      // 버튼에 클릭 이벤트를 연결합니다.
      $('#startBtn').on('click', startMarkerGeneration);
      $('#stopBtn').on('click', stopMarkerGeneration);
    });

  })();
</script>

<%-- 3. 페이지 컨텐츠(HTML) --%>
<div id="map_container">
  <h2>Map5 Page</h2>
  <div class="btn-container">
    <button id="startBtn" class="btn btn-success">시작</button>
    <button id="stopBtn" class="btn btn-danger">정지</button>
  </div>
  <div id="map"></div>
</div>
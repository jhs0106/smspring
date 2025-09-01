<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #map {
    width: auto;
    height: 400px;
    border: 2px solid blue;
  }
</style>
<script>
  let map2 = {
    init:function (){
      this.makeMap(37.579779, 126.977027, '경복궁', 's1.jpg', 100);
      //37.579779, 126.977027 경복궁
      $('#sbtn').click(()=>{
        this.makeMap(37.579779, 126.977027, '경복궁', 's1.jpg', 100);
      });
      //35.156311, 129.057979 서면시장
      $('#bbtn').click(()=>{
        this.makeMap(35.156311, 129.057979, '서면시장', 's2.jpg', 200);
      });
      //33.363208, 126.533051 한라산
      $('#jbtn').click(()=>{
        this.makeMap(33.363208, 126.533051, '한라산', 's3.jpg', 300);
      });
    },
    makeMap:function(lat, lng, title, imgName, target){
      let mapContainer = document.getElementById('map');
      let mapOptions = {
        center : new kakao.maps.LatLng(lat, lng), // 지도의 중심좌표
        level: 7
      }
      let map = new kakao.maps.Map(mapContainer, mapOptions); // 지도를 생성합니다
      let mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      let zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
      // 마커
      let markerPosition  = new kakao.maps.LatLng(lat, lng);
      let marker = new kakao.maps.Marker({
        position: markerPosition,
        map:map
      });


      // Infowinndow
      // 인포윈도우를 생성합니다
      let iwContent = '<p>'+title+'</p>';
      iwContent += '<img src="<c:url value="/imgs/'+imgName+'"/> " style="width:80px;">';
      let infowindow = new kakao.maps.InfoWindow({
        content : iwContent
      });

      // Event
      kakao.maps.event.addListener(marker, 'mouseover', function() {
        infowindow.open(map,marker);
      });
      kakao.maps.event.addListener(marker, 'mouseout', function() {
        infowindow.close(map,marker);
      });
      kakao.maps.event.addListener(marker, 'click', function() {
        location.href='<c:url value="/cust/get"/>'
      });
    }


  }

  $(function() {
    map2.init();
  })
</script>
<div class="col-sm-10">
  <h2>Map2</h2>
  <button id="sbtn" class="btn btn-primary">Seoul</button>
  <button id="bbtn" class="btn btn-primary">Busan</button>
  <button id="jbtn" class="btn btn-primary">Jeju</button>
  <div id="map"></div>
</div>

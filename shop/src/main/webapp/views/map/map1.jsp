<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #map1{
    width:auto;
    height:400px;
    border:2px solid red;
  }
</style>
<script>
  let map1 = {
   init:function(){
    let mapContainer = document.getElementById('map1');
    let mapOptions = {
      center : new kakao.maps.LatLng(36.798861, 127.075975), // 지도의 중심좌표
      level: 7
    }
     let map = new kakao.maps.Map(mapContainer, mapOptions); // 지도를 생성합니다
     let mapTypeControl = new kakao.maps.MapTypeControl();
     map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
     let zoomControl = new kakao.maps.ZoomControl();
     map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

     // 마커
     let markerPosition  = new kakao.maps.LatLng(36.798861, 127.075975);
     let marker = new kakao.maps.Marker({
       position: markerPosition
     });
     marker.setMap(map);

     // Infowinndow
     // 인포윈도우를 생성합니다
     let iwContent = '<p>Info window<p>'
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
  $(function (){
    map1.init()
  })
</script>
<div class="col-sm-10">
  <h2>Map1</h2>

  <div id="map1"></div>
</div>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  #map4{
    width:auto;
    height:400px;
    border:2px solid lawngreen;
  }
</style>
<script>
  let map4 = {
    init:function(){
      let mapContainer = document.getElementById('map4');
      let mapOptions = {
        center : new kakao.maps.LatLng(37.538453, 127.053110), // 지도의 중심좌표
        level: 7
      }
      this.map = new kakao.maps.Map(mapContainer, mapOptions); // 지도를 생성합니다
      let mapTypeControl = new kakao.maps.MapTypeControl();
      this.map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      let zoomControl = new kakao.maps.ZoomControl();
      this.map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);


      // HTML5의 geolocation으로 사용할 수 있는지 확인합니다
      if (navigator.geolocation) {
        // GeoLocation을 이용해서 접속 위치를 얻어옵니다
        navigator.geolocation.getCurrentPosition((position) => {
          let lat = position.coords.latitude; // 위도
          let lng = position.coords.longitude; // 경도
          let locPosition = new kakao.maps.LatLng(lat, lng);
          this.goMap(locPosition);
        });

      } else {
        alert('지원하지 않습니다');
      }// end if
    },
    goMap:function (locPosition) {
      //마커 생성
      let marker = new kakao.maps.Marker({
        map: this.map,
        position: locPosition
      });
      this.map.panTo(locPosition);

    }
  }

  $(function (){
    map4.init()
  })
</script>
<div class="col-sm-10">
  <h2>Map4</h2>

  <div id="map4"></div>
</div>

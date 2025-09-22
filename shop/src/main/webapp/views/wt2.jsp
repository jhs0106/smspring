<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #map {
    width: auto;
    height: 300px;
    border: 2px solid blue;
  }
  #result{
    width: 900px;
    border : 2px solid aquamarine;
  }
  #result2{
    width: 400px;
    border : 2px solid mediumpurple;
  }
</style>
<script>
  let wtmap2 = {
    currentLocName: '서울',
    init: function () {
      this.makeMap(37.538453, 127.053110, '서울'); //디폴트
      this.getData("109", "11B10101");

      // 37.538453, 127.053110
      $('#sbtn').click(() => {
        this.makeMap(37.538453, 127.053110, '서울');
        this.currentLocName = $('#sbtn').val();
        this.getData('109', "11B10101");

      });
      // 35.170594, 129.175159
      $('#bbtn').click(() => {
        this.makeMap(35.170594, 129.175159, '부산');
        this.currentLocName = $('#bbtn').val();
        this.getData("159", "11H20201");
      });
      // 33.250645, 126.414800
      $('#jbtn').click(() => {
        this.makeMap(33.363208, 126.533051, '제주');
        this.currentLocName = $('#jbtn').val();
        this.getData("184", "11G00201");
      });
    },
    makeMap: function (lat, lng, title) {
      let mapContainer = document.getElementById('map');
      let mapOptions = {
        center: new kakao.maps.LatLng(lat, lng), // 지도의 중심좌표
        level: 7
      }
      let map = new kakao.maps.Map(mapContainer, mapOptions); // 지도를 생성
      let mapTypeControl = new kakao.maps.MapTypeControl();
      map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
      let zoomControl = new kakao.maps.ZoomControl();
      map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
      // 마커
      let markerPosition = new kakao.maps.LatLng(lat, lng);
      let marker = new kakao.maps.Marker({
        position: markerPosition,
        map: map
      });


    },
    makeMarkers: function (map, datas) {
      let imgSrc1 = 'https://t1.daumcdn.net/localimg/localimages/07/2012/img/marker_p.png';
      let result = '';
      $(datas).each((index, item) => {
        let imgSize = new kakao.maps.Size(30, 30);
        let markerImg = new kakao.maps.MarkerImage(imgSrc2, imgSize);
        let markerPosition = new kakao.maps.LatLng(item.lat, item.lng);
      });
    },
    getData: function(loc1, loc2) {
      $.ajax({
        url: '<c:url value="/getwt2"/>',
        data: { 'loc': loc1, 'loc2': loc2 },
        success: (data) => {
          this.displayWeather1(data);
          this.displayWeather2(data);
        },
        error: (xhr, status, error) => {
          console.error("AJAX Error: " + status + ", " + error);
        }
      });
    },

    displayWeather1: function(data){
      let txt1 = data.weather1.response.body.items.item[0].wfSv;
      $('#result').html(txt1);
    },

    displayWeather2: function(data){
      let dailyTemps = data.weather2.response.body.items.item[0];
      let html = '<h4>'+ this.currentLocName + ': ' + '4일 후 ~ 10일 후 기온 정보' + '</h4><ul>' ;

      // 4일부터 10일까지 반복하며 데이터 추출
      for(let i = 4; i <= 10; i++){
        let minTemp = dailyTemps['taMin' + i]; // taMin4, taMin5...
        let maxTemp = dailyTemps['taMax' + i]; // taMax4, taMax5...

        // 데이터가 유효한 경우에만 표시
        if(minTemp !== undefined && maxTemp !== undefined && minTemp !== "" && maxTemp !== ""){
          html += '<li>' + i + '일 후: 최저 ' + minTemp + '°C, 최고 ' + maxTemp + '°C</li>';
        }
      }
      html += "</ul>";
      $('#result2').html(html);
    }
  };
  $(function(){
    wtmap2.init();
  })



</script>
<div class="col-sm-10">
  <h2>Weather 2 Page</h2>
  <button id="sbtn" value="서울" class="btn btn-primary">Seoul</button>
  <button id="bbtn" value="부산" class="btn btn-primary">Busan</button>
  <button id="jbtn" value="제주"class="btn btn-primary">Jeju</button>
  <div id="map"></div>
  <div id="result"></div>
  <div id="result2"></div>
</div>

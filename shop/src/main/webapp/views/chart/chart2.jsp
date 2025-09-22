<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<style>
  #container1{
    width:300px;
    border: 1px solid black;

  }
  #container2{
    width:300px;
    border: 1px solid gray;

  }
  #container3{
    width:300px;
    border: 1px solid darkblue;

  }
  #container4{
    width:300px;
    border: 1px solid cadetblue;

  }

</style>
<script>
  chart2={
    init:function () {
      this.getdata1();
      this.getdata2();
      this.getdata3();
      this.getdata4();
    },
    getdata1:function() {
      $.ajax({
        url:'<c:url value="/chart2_1"/>',
        success:(data)=>{
          this.chart1(data);

        }
      });
    },
    getdata2:function() {
      $.ajax({
        url:'<c:url value="/chart2_2"/>',
        success:(data)=>{
          this.chart2(data);

        }
      });
    },
    getdata3:function() {
      $.ajax({
        url:'<c:url value="/chart2_3"/>',
        success:(data)=>{

          this.chart3(data);
        }
      });
    },
    getdata4:function() {
      $.ajax({
        url:'<c:url value="/chart2_4"/>',
        success:(data)=>{

          this.chart4(data);
        }
      });
    },
    chart1:function(data){
      Highcharts.chart('container1', {
        chart: {
          type: 'pie',
          options3d: {
            enabled: true,
            alpha: 45
          }
        },
        title: {
          text: 'Beijing 2022 gold medals by country'
        },
        subtitle: {
          text: '3D donut in Highcharts'
        },
        plotOptions: {
          pie: {
            innerSize: 100,
            depth: 45
          }
        },
        series: [{
          name: 'Medals',
          data: data
        }]
      });
    },
    chart2:function(data){
      Highcharts.chart('container2', {
        chart: {
          type: 'cylinder',
          options3d: {
            enabled: true,
            alpha: 15,
            beta: 15,
            depth: 50,
            viewDistance: 25
          }
        },
        title: {
          text: 'Number of confirmed COVID-19'
        },
        subtitle: {
          text: 'Source: ' +
                  '<a href="https://www.fhi.no/en/id/infectious-diseases/coronavirus/daily-reports/daily-reports-COVID19/"' +
                  'target="_blank">FHI</a>'
        },
        xAxis: {
          categories: data.cate,
          title: {
            text: 'Age groups'
          },
          labels: {
            skew3d: true
          }
        },
        yAxis: {
          title: {
            margin: 20,
            text: 'Reported cases'
          },
          labels: {
            skew3d: true
          }
        },
        tooltip: {
          headerFormat: '<b>Age: {category}</b><br>'
        },
        plotOptions: {
          series: {
            depth: 25,
            colorByPoint: true
          }
        },
        series: [{
          data: data.data,
          name: 'Cases',
          showInLegend: false
        }]
      });
    },
    chart3:function(txt){
      const text = txt,
              lines = text.replace(/[():'?0-9]+/g, '').split(/[,\. ]+/g),
              data = lines.reduce((arr, word) => {
                let obj = Highcharts.find(arr, obj => obj.name === word);
                if (obj) {
                  obj.weight += 1;
                } else {
                  obj = {
                    name: word,
                    weight: 1
                  };
                  arr.push(obj);
                }
                return arr;
              }, []);

      Highcharts.chart('container3', {
        accessibility: {
          screenReaderSection: {
            beforeChartFormat: '<h5>{chartTitle}</h5>' +
                    '<div>{chartSubtitle}</div>' +
                    '<div>{chartLongdesc}</div>' +
                    '<div>{viewTableButton}</div>'
          }
        },
        chart: {
          zooming: {
            type: 'xy'
          },
          panning: {
            enabled: true,
            type: 'xy'
          },
          panKey: 'shift'
        },
        series: [{
          type: 'wordcloud',
          data,
          name: 'Occurrences'
        }],
        title: {
          text: '유승준의 굴욕',
          align: 'left'
        },
        subtitle: {
          text: '이건 첫 번째 레슨: 나갔으면 짜져 살기',
          align: 'left'
        },
        tooltip: {
          headerFormat: '<span style="font-size: 16px"><b>{point.name}</b>' +
                  '</span><br>'
        }
      });

    },

    chart4:function(result){
      Highcharts.chart('container4', {
        chart: {
          type: 'pie'
        },
        title: {
          text: '한국 휴대폰 시장 점유율'
        },
        subtitle: {
          text: 'Click the slices to view versions. Source: <a href="http://statcounter.com" target="_blank">statcounter.com</a>'
        },

        accessibility: {
          announceNewData: {
            enabled: true
          },
          point: {
            valueSuffix: '%'
          }
        },

        plotOptions: {
          pie: {
            borderRadius: 5,
            dataLabels: [{
              enabled: true,
              distance: 15,
              format: '{point.name}'
            }, {
              enabled: true,
              distance: '-30%',
              filter: {
                property: 'percentage',
                operator: '>',
                value: 5
              },
              format: '{point.y:.1f}%',
              style: {
                fontSize: '0.9em',
                textOutline: 'none'
              }
            }]
          }
        },

        tooltip: {
          headerFormat: '<span style="font-size:11px">{series.name}</span><br>',
          pointFormat: '<span style="color:{point.color}">{point.name}</span>: ' +
                  '<b>{point.y:.2f}%</b> of total<br/>'
        },

        series: result.series,
        drilldown: {
          series: result.drilldownSeries
        },
        navigation: {
          breadcrumbs: {
            buttonTheme: {
              style: {
                color: 'var(--highcharts-highlight-color-100)'
              }
            }
          }
        }
      });
    }

  }
  $(()=>{
    chart2.init();
  })
</script>


<div class="col-sm-10">
  <h2>Chart2</h2>
  <div class="row">
    <div class="col-sm-6" id="container1"></div>
    <div class="col-sm-6" id="container2"></div>
  </div>
  <div class="row">
    <div class="col-sm-6" id="container3"></div>
    <div class="col-sm-6" id="container4"></div>
  </div>
</div>

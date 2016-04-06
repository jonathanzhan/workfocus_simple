<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>echarts-甘特图</title>
    <%@include file="/WEB-INF/views/include/head.jsp" %>
    <!-- ECharts -->
    <%--<script src="${ctxStatic}/plugins/echarts/2.2.7/echarts-all.js"></script>--%>

<script src="${ctxStatic}/plugins/echarts/3.1.4/echarts.min.js"></script>

<script src="${ctxStatic}/plugins/echarts/3.1.4/theme/macarons.js"></script>
</head>

<body class="gray-bg">
<script type="text/javascript">
    $(function(){

        var myChart = echarts.init(document.getElementById("chart1"),"macarons");

        var option1 = {
            title : {
                x:'center',
                text: '对标重点工作项及保障要求',
                subtext: '数据来自信通公司3月份'
            },
            legend: {                                   // 图例配置
                orient : 'vertical',
                x : 'left',
                data: ['实际时长','预计时长']
            },
            grid: {
                x:100,
                x2:30
            },
            tooltip : {
                trigger: 'axis',
                axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                    type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                },
                formatter: function (params) {
                    var res =  params[0].name;
                    for (var i = 0, l = params.length; i < l; i++) {
                        res += '<br/>' + params[i].seriesName  +' : ' + params[i].value;
                    };
                    return res;
                }
            },
            toolbox: {
                show : false,
                orient: 'vertical',
                x: 'left',
                y: 'center',
                feature : {
                    mark : {show: false},
                    dataView : {show: false, readOnly: true},
                    magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            yAxis : [
                {
                    type : 'category',
                    data : [
                        '对标模拟填报',
                        '成本费用率指标计算',
                        '系统运行过程评价',
                        '一体化平台',
                        '管控评价',
                        '建设指标保障'
                    ]
                }
            ],
            xAxis : [
                {
                    type : 'value',
                    min :1,
                    max:12,
                    splitNumber :11,
                    splitArea: {show : true}
                }
            ],
            series : [
                {
                    name:'实际开始',
                    type:'bar',
                    stack: 'actual',
                    itemStyle:{
                        normal:{
                            borderColor:'rgba(0,0,0,0)',
                            color:'rgba(0,0,0,0)'
                        },
                        emphasis:{
                            borderColor:'rgba(0,0,0,0)',
                            color:'rgba(0,0,0,0)'
                        }
                    },
                    data:[5, 1, 2, 4, 5, 1]
                },
                {
                    name:'实际时长',
                    type:'bar',
                    stack: 'actual',
                    itemStyle : {
                        normal: {
                            label : {
                                show: false,
                                position: 'inside'
                            }
                        }
                    },
                    data:[1, 3, 3, 8, 7, 10]
                },
                {
                    name:'预计开始',
                    type:'bar',
                    stack: 'plan',
                    itemStyle:{
                        normal:{
                            borderColor:'rgba(0,0,0,0)',
                            color:'rgba(0,0,0,0)'
                        },
                        emphasis:{
                            borderColor:'rgba(0,0,0,0)',
                            color:'rgba(0,0,0,0)'
                        }
                    },
                    data:[1, 2, 4, 2, 1, 1]
                },
                {
                    name:'预计时长',
                    type:'bar',
                    stack: 'plan',
                    itemStyle : { normal: {label : {show: false, position: 'inside'}}},
                    data:[11, 4, 6, 8, 9, 1]
                }
            ]
        };

        var option2 = {
            title : {
                text: '管控评价部门完成情况'
            },
            tooltip : {
                trigger: 'axis',
                axisPointer : {
                    type: 'shadow'
                }
            },
            legend: {
                show:false,
                orient : 'vertical',
                x : 'left',
                y:'center',
                data:['管控评价']
            },
            toolbox: {
                show : true,
                orient : 'vertical',
                y : 'center',
                feature : {
                    mark : {show: false},
                    magicType : {show: true, type: ['line', 'bar', 'stack', 'tiled']},
                    restore : {show: true},
                    saveAsImage : {show: true}
                }
            },
            xAxis : [
                {
                    type : 'category',
                    data : ['信息部灭灾中心','信息部工程中心','信息部']
                }
            ],
            yAxis : [
                {
                    type : 'value',
                    min:0,
                    max:100,

                    splitArea : {show : true}
                }
            ],
            grid: {
                x:100,
                x2:30
            },
            series : [
                {
                    name:'项目1',
                    type:'bar',
                    data:[20, 50, 70]
                }

            ]
        };

        myChart.setOption(option1);
        myChart.on("click",eConsole1);

        function eConsole1(param) {

            var mes = '【' + param.type + '】';
            if (typeof param.seriesIndex != 'undefined') {
                mes += '  项目名 : ' + param.name;
                mes += '  总时长 : ' + param.value;
            }

            alert(mes);


            option2.title.text = param.name+'部门完成情况';
            option2.title.subtext = '时长:'+param.value;
            option2.xAxis[0].data = ['部门2','部门3','部门4','部门5'];
            option2.series[0].data = [
                parseInt(Math.random()*100,10)+1,
                parseInt(Math.random()*100,10)+1,
                parseInt(Math.random()*100,10)+1,
                parseInt(Math.random()*100,10)+1
            ];
            myChart2.setOption(option2);
        }

        var myChart2 = echarts.init(document.getElementById('chart2'),'infographic');
        myChart2.setOption(option2);


        setTimeout(function (){
            window.onresize = function () {
                myChart.resize();
                myChart2.resize();
            }
        },200)
    })


</script>
<div class="row  border-bottom white-bg dashboard-header">
    <div class="col-sm-12">
        <p>ECharts开源来自百度商业前端数据可视化团队，基于html5 Canvas，是一个纯Javascript图表库，提供直观，生动，可交互，可个性化定制的数据可视化图表。创新的拖拽重计算、数据视图、值域漫游等特性大大增强了用户体验，赋予了用户对数据进行挖掘、整合的能力。 <a href="http://echarts.baidu.com/doc/about.html" target="_blank">了解更多</a>
        </p>
        <p>ECharts官网：<a href="http://echarts.baidu.com/" target="_blank">http://echarts.baidu.com/</a>
        </p>
    </div>
</div>
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-6">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5>甘特图</h5>
                </div>
                <div class="ibox-content">
                    <div class="echarts" id="chart1" style="width: 500px;height: 500px;">

                    </div>
                </div>
            </div>
        </div>
        <div class="col-sm-6">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h5>甘特图点击实时刷新柱状图</h5>
                </div>
                <div class="ibox-content">
                    <div class="echarts" id="chart2">

                    </div>
                </div>
            </div>
        </div>
    </div>
</div>






</body>


</html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
  <title>日历维护管理</title>
  <meta name="decorator" content="default"/>
  <style>
    .black_overlay{  display: none;  position: absolute;  top: 0%;  left: 0%;  width: 100%;  height: 100%;  background-color: black;  z-index:1001;  -moz-opacity: 0.8;  opacity:.80;  filter: alpha(opacity=80);  }  .white_content {  display: none;  position: absolute;  top: 25%;  left: 25%;  width:450px;  height: 210px;  padding: 16px;  border: 1px solid black;  background-color: white;  z-index:1002;  overflow: auto;  }
  </style>
  <script type="text/javascript">
    function openEditPage(obj){
      var dt = obj.children[1].value;
      $("#id").val(obj.children[0].value);
      $("#cdate").val(obj.children[1].value);
      if(obj.children[2].value=="0"){
        $("#isWorkday1").attr("checked",true);
      }else{
        $("#isWorkday2").attr("checked",true);
      }
      $("#wkdaykNd").val(obj.children[3].value);
      $("#wkdaykNd").parent().children(":first").children(":first").children(":first").text(obj.children[4].value);
      document.getElementById('light').style.display='block';
      document.getElementById('fade').style.display='block'
    }

    function closeEditPage(){
      document.getElementById('light').style.display='none';
      document.getElementById('fade').style.display='none'
    }

    $(document).ready(function() {
      $("#inputForm").validate({
        submitHandler: function(form){
          loading('正在提交，请稍等...');
          form.submit();
        },
        errorContainer: "#messageBox",
        errorPlacement: function(error, element) {
          $("#messageBox").text("输入有误，请先更正。");
          if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
            error.appendTo(element.parent().parent());
          } else {
            error.insertAfter(element);
          }
        }
      });
    });

  </script>
</head>
<body>
<ul class="nav nav-tabs">
  <shiro:hasPermission name="sys:sysCalendar:edit"><li class="active"><a href="${ctx}/sys/calendarPage/calendarTable">日历维护</a></li></shiro:hasPermission>
</ul>
<form:form id="searchForm" modelAttribute="tableCalendar" action="${ctx}/sys/sysCalendar/calendarTable/" method="post" class="breadcrumb form-search">
<ul class="ul-form">
    <label>年份：</label>
      <form:select path="year" id="year" class="input-medium required">
        <form:options items="${yearList}" itemLabel="label" itemValue="value" htmlEscape="false"/>
      </form:select>

    <label>月份：</label>
      <form:select path="month" id="month" class="input-medium required">
        <form:options items="${monthList}" itemLabel="label" itemValue="value" htmlEscape="false"/>
      </form:select>
    <input id="btnSubmit1" class="btn" type="submit" value="查 询" />
    <%--<input id="btnReset" class="btn" type="button" onclick="resetSearch()" value="重 置" />--%>
  </ul>


  <form:hidden path="addMonthNumber"></form:hidden>
  <%--<input id="ltMonth" type="button" value="上月" class="btn" onclick="lastMonth()">--%>
  <%--<input id="ntMonth" type="button" value="下月" class="btn" onclick="nextMonth()">--%>
  <%--<input id="ctMonth" type="button" value="本月" class="btn" onclick="currMonth()">--%>
  <table id="contentTable" class="table table-bordered table-condensed">
    <thead>
    <tr>
      <th style="text-align:center;vertical-align:middle;" >星期日</th>
      <th style="text-align:center;vertical-align:middle;" >星期一</th>
      <th style="text-align:center;vertical-align:middle;" >星期二</th>
      <th style="text-align:center;vertical-align:middle;" >星期三</th>
      <th style="text-align:center;vertical-align:middle;" >星期四</th>
      <th style="text-align:center;vertical-align:middle;" >星期五</th>
      <th style="text-align:center;vertical-align:middle;" >星期六</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach items="${page.list}" var="tableCalendarList">
      <tr>
        <td height="100px" width="100px" onclick="openEditPage(this)" bgcolor="${tableCalendarList.sun.cellColor}" style="color: ${tableCalendarList.sun.txtColor}">
          <input value="${tableCalendarList.sun.sysCalendar.id}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.sun.dateTxt}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.sun.sysCalendar.isWorkday}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.sun.sysCalendar.wkdaykNd}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.sun.sysCalendar.wkdaykNm}" readonly="readonly" style="display: none">
          <b style="font-size: xx-large">${tableCalendarList.sun.dayTxt}</b><br>
          <c:if test="${tableCalendarList.sun.sysCalendar.cdate!=null}">
            <b>是否工作日：</b> ${tableCalendarList.sun.sysCalendar.isWorkday eq 0 ?'否':'是'} <br>
            <b>日期类型：</b> ${fns:getDictLabel(tableCalendarList.sun.sysCalendar.wkdaykNd,"WKDAYKND" , "")}<br>
          </c:if>

        </td>
        <td height="100px" width="100px" onclick="openEditPage(this)" bgcolor="${tableCalendarList.mon.cellColor}" style="color: ${tableCalendarList.mon.txtColor}">
          <input value="${tableCalendarList.mon.sysCalendar.id}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.mon.dateTxt}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.mon.sysCalendar.isWorkday}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.mon.sysCalendar.wkdaykNd}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.mon.sysCalendar.wkdaykNm}" readonly="readonly" style="display: none">
          <b style="font-size: xx-large">${tableCalendarList.mon.dayTxt}</b><br>
          <c:if test="${tableCalendarList.mon.sysCalendar.cdate!=null}">
            <b>是否工作日：</b> ${tableCalendarList.mon.sysCalendar.isWorkday eq 0 ?'否':'是'} <br>
            <b>日期类型：</b> ${fns:getDictLabel(tableCalendarList.mon.sysCalendar.wkdaykNd,"WKDAYKND" , "")}<br>
          </c:if>
        </td>
        <td height="100px" width="100px" onclick="openEditPage(this)" bgcolor="${tableCalendarList.tue.cellColor}" style="color: ${tableCalendarList.tue.txtColor}">
          <input value="${tableCalendarList.tue.sysCalendar.id}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.tue.dateTxt}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.tue.sysCalendar.isWorkday}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.tue.sysCalendar.wkdaykNd}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.tue.sysCalendar.wkdaykNm}" readonly="readonly" style="display: none">
          <b style="font-size: xx-large">${tableCalendarList.tue.dayTxt}</b><br>
          <c:if test="${tableCalendarList.tue.sysCalendar.cdate!=null}">
            <b>是否工作日：</b> ${tableCalendarList.tue.sysCalendar.isWorkday eq 0 ?'否':'是'} <br>
            <b>日期类型：</b> ${fns:getDictLabel(tableCalendarList.tue.sysCalendar.wkdaykNd,"WKDAYKND" , "")}<br>
          </c:if>
        </td>
        <td height="100px" width="100px" onclick="openEditPage(this)" bgcolor="${tableCalendarList.wed.cellColor}" style="color: ${tableCalendarList.wed.txtColor}">
          <input value="${tableCalendarList.wed.sysCalendar.id}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.wed.dateTxt}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.wed.sysCalendar.isWorkday}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.wed.sysCalendar.wkdaykNd}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.wed.sysCalendar.wkdaykNm}" readonly="readonly" style="display: none">
          <b style="font-size: xx-large">${tableCalendarList.wed.dayTxt}</b><br>
          <c:if test="${tableCalendarList.wed.sysCalendar.cdate!=null}">
            <b>是否工作日：</b> ${tableCalendarList.wed.sysCalendar.isWorkday eq 0 ?'否':'是'} <br>
            <b>日期类型：</b> ${fns:getDictLabel(tableCalendarList.wed.sysCalendar.wkdaykNd,"WKDAYKND" , "")}<br>
          </c:if>
        </td>
        <td height="100px" width="100px" onclick="openEditPage(this)" bgcolor="${tableCalendarList.thu.cellColor}" style="color: ${tableCalendarList.thu.txtColor}">
          <input value="${tableCalendarList.thu.sysCalendar.id}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.thu.dateTxt}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.thu.sysCalendar.isWorkday}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.thu.sysCalendar.wkdaykNd}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.thu.sysCalendar.wkdaykNm}" readonly="readonly" style="display: none">
          <b style="font-size: xx-large">${tableCalendarList.thu.dayTxt}</b><br>
          <c:if test="${tableCalendarList.thu.sysCalendar.cdate!=null}">
            <b>是否工作日：</b> ${tableCalendarList.thu.sysCalendar.isWorkday eq 0 ?'否':'是'} <br>
            <b>日期类型：</b> ${fns:getDictLabel(tableCalendarList.thu.sysCalendar.wkdaykNd,"WKDAYKND" , "")}<br>
          </c:if>
        </td>
        <td height="100px" width="100px" onclick="openEditPage(this)" bgcolor="${tableCalendarList.fri.cellColor}" style="color: ${tableCalendarList.fri.txtColor}">
          <input value="${tableCalendarList.fri.sysCalendar.id}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.fri.dateTxt}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.fri.sysCalendar.isWorkday}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.fri.sysCalendar.wkdaykNd}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.fri.sysCalendar.wkdaykNm}" readonly="readonly" style="display: none">
          <b style="font-size: xx-large">${tableCalendarList.fri.dayTxt}</b><br>
          <c:if test="${tableCalendarList.fri.sysCalendar.cdate!=null}">
            <b>是否工作日：</b> ${tableCalendarList.fri.sysCalendar.isWorkday eq 0 ?'否':'是'} <br>
            <b>日期类型：</b> ${fns:getDictLabel(tableCalendarList.fri.sysCalendar.wkdaykNd,"WKDAYKND" , "")}<br>
          </c:if>
        </td>
        <td height="100px" width="100px" onclick="openEditPage(this)" bgcolor="${tableCalendarList.sat.cellColor}" style="color: ${tableCalendarList.sat.txtColor}">
          <input value="${tableCalendarList.sat.sysCalendar.id}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.sat.dateTxt}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.sat.sysCalendar.isWorkday}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.sat.sysCalendar.wkdaykNd}" readonly="readonly" style="display: none">
          <input value="${tableCalendarList.sat.sysCalendar.wkdaykNm}" readonly="readonly" style="display: none">
          <b style="font-size: xx-large">${tableCalendarList.sat.dayTxt}</b><br>
          <c:if test="${tableCalendarList.sat.sysCalendar.cdate!=null}">
            <b>是否工作日：</b> ${tableCalendarList.sat.sysCalendar.isWorkday eq 0 ?'否':'是'} <br>
            <b>日期类型：</b> ${fns:getDictLabel(tableCalendarList.sat.sysCalendar.wkdaykNd,"WKDAYKND" , "")}<br>
          </c:if>
        </td>
      </tr>
    </c:forEach>
    </tbody>
  </table>

</form:form>
<sys:message content="${message}"/>
<shiro:hasPermission name="sys:sysCalendar:edit">
  <div id="light" class="white_content">
    <h1 style="font-size: 18px;">设置日期类型</h1>
    <h></h>
    <form:form id="inputForm" modelAttribute="sysCalendar" action="${ctx}/sys/sysCalendar/save" method="post" class="form-horizontal">
      <form:hidden path="id"></form:hidden>
      <div class="control-group">
        <label class="control-label">日期：</label>
        <div class="controls">
          <input name="cdate" id="cdate" type="text" readonly="readonly" maxlength="20" class="input-medium required"
                 value="<fmt:formatDate value="${sysCalendar.cdate}" pattern="yyyy-MM-dd"/>"
                  />
        </div>
      </div>
      <div class="control-group">
        <label class="control-label">是否工作日：</label>
        <div class="controls">
          <form:radiobuttons path="isWorkday" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
        </div>
      </div>
      <div class="control-group">
        <label class="control-label">日期类型：</label>
        <div class="controls">
          <form:select path="wkdaykNd" id="wkdaykNd" class="input-medium">
            <form:option  htmlEscape="false" value="-1" label=""></form:option>
            <form:options items="${fns:getDictList('WKDAYKND')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
          </form:select>
        </div>
      </div>
      <input id="btnCancel" class="btn" type="button" onclick="closeEditPage()" value="取 消" />
      <input id="btnSubmit" class="btn" type="submit" value="保 存" />
    </form:form>
  </div>

</shiro:hasPermission>

</body>
</html>
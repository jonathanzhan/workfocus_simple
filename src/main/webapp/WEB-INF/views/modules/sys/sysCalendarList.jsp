<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>日历维护管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#searchForm").validate({
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
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
        	return false;
        }
	</script>
</head>
<body>
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/sys/sysCalendar/">日历维护列表</a></li>
		<shiro:hasPermission name="sys:sysCalendar:edit"><li><a href="${ctx}/sys/sysCalendar/calendarTable">日历维护添加</a></li></shiro:hasPermission>
	</ul>
	<form:form id="searchForm" modelAttribute="sysCalendar" action="${ctx}/sys/sysCalendar/" method="post" class="breadcrumb form-search">
		<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
		<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		<ul class="ul-form">
			<li><label>年份：</label>
				<form:input path="year" htmlEscape="false" class="digits input-small"/>
			</li>
			<li><label>月份：</label>
				<form:input path="month" htmlEscape="false" class="digits input-small"/>
			</li>
			<li><label>日期：</label>
				<input name="cdate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate"
					value="<fmt:formatDate value="${sysCalendar.cdate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
			</li>
			<li><label>是否工作日：</label>
				<form:radiobuttons path="isWorkday" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>

			</li>
			<li class="btns"><input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/></li>
			<li class="clearfix"></li>
		</ul>
	</form:form>
	<sys:message content="${message}"/>
	<table id="contentTable" class="table table-striped table-bordered table-condensed">
		<thead>
			<tr>
				<th>年份</th>
				<th>月份</th>
				<th>日期</th>
				<th>日期类型</th>
				<th>是否工作日</th>
				<shiro:hasPermission name="sys:sysCalendar:edit"><th>操作</th></shiro:hasPermission>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="sysCalendar">
			<tr>
				<td>${sysCalendar.year}</td>
				<td>${sysCalendar.month}</td>
				<td><fmt:formatDate value="${sysCalendar.cdate}" pattern="yyyy-MM-dd"/></td>
				<td>${fns:getDictLabel(sysCalendar.wkdaykNd,"WKDAYKND" , "")}</td>
				<td>${sysCalendar.isWorkday eq 0 ?'否':'是'}</td>
				<shiro:hasPermission name="sys:sysCalendar:edit"><td>
    				<a href="${ctx}/sys/sysCalendar/form?id=${sysCalendar.id}">修改</a>
					<a href="${ctx}/sys/sysCalendar/delete?id=${sysCalendar.id}" onclick="return confirmx('确认要删除该日历维护吗？', this.href)">删除</a>
				</td></shiro:hasPermission>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="pagination">${page}</div>
</body>
</html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>结束的流程</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function(){

		});

	</script>
</head>


<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
	<!--查询表单开始-->
	<div class="ibox m-b-sm border-bottom">
		<div class="ibox-title">
			<a href="${ctx}/act/process/finish/list"><h5>结束的流程</h5></a>
		</div>

		<div class="ibox-content">
			<form:form id="searchForm" modelAttribute="act" action="${ctx}/act/process/finish/list/" method="post"
					   cssClass="form-inline">

				<div class="form-group">
					<span>流程分类</span>
				</div>
				<div class="form-group">
					<form:input path="procDefKey" cssClass="form-control"/>
				</div>
				<div class="form-group">
					<span>完成时间</span>
				</div>
				<div class="form-group">
					<input id="beginDate"  name="beginDate"  type="text" readonly="readonly" maxlength="20" class="form-control input-sm" style="width:163px;"
						   value="<fmt:formatDate value="${act.beginDate}" pattern="yyyy-MM-dd hh:mm:ss"/>"
						   onclick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'});"/>--
					<input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="form-control input-sm" style="width:163px;"
						   value="<fmt:formatDate value="${act.endDate}" pattern="yyyy-MM-dd hh:mm:ss"/>"
						   onclick="WdatePicker({dateFmt:'yyyy-MM-dd  HH:mm:ss'});"/>
				</div>
				<div class="form-group">
					<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
					<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
					<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
				</div>
			</form:form>
		</div>
	</div>



	<%--数据展示开始--%>
	<div class="ibox">
		<div class="ibox-content">

			<sys:message content="${message}"/>
			<table class="table table-striped table-hover table-bordered table-condensed">
				<thead>
				<tr>
					<th>流程实例ID</th>
					<th>流程名称</th>
					<th>开始时间</th>
					<th>截止时间</th>
					<th>历时</th>
					<th>结束原因</th>
					<th>操作</th>
				</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="hpi">
					<tr>
						<td>${hpi.id}</td>
						<td>${hpi.processDefinitionName}(${hpi.processDefinitionKey})</td>
						<td><fmt:formatDate value="${hpi.startTime}" type="both"/></td>
						<td><fmt:formatDate value="${hpi.endTime}" type="both"/></td>
						<td>${fns:toTimeString(hpi.durationInMillis)}</td>
						<td>${empty hpi.deleteReason ? "正常结束" : hpi.deleteReason}</td>
						<td>
							<a href="#" onclick="openDialogView('详细信息', '${ctx}/act/process/view/${hpi.id}','800px', '620px')" class="btn btn-primary btn-xs" ><i class="fa fa-search-plus"></i>查看</a>
						</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>

			<div>
				${page.html}
			</div>
		</div>
	</div>


</div>
</body>

</html>
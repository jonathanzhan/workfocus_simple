<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>运行中的流程</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function(){

		});

	</script>
	<script type="text/template" id="categoryBox">
		<form id="categoryForm" action="${ctx}/act/process/updateCategory" method="post" enctype="multipart/form-data"
			style="text-align:center;" class="form-search" onsubmit="loading('正在设置，请稍等...');"><br/>
			<input id="categoryBoxId" type="hidden" name="procDefId" value="" />
			<select id="categoryBoxCategory" name="category">
				<c:forEach items="${fns:getDictList('act_category')}" var="dict">
					<option value="${dict.value}">${dict.label}</option>
				</c:forEach>
			</select>
			<br/><br/>　　
			<input id="categorySubmit" class="btn btn-primary" type="submit" value="   保    存   "/>　　
		</form>
	</script>
</head>


<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeIn">
	<!--查询表单开始-->
	<div class="ibox m-b-sm border-bottom">
		<div class="ibox-title">
			<a href="${ctx}/act/process/running"><h5>运行中的流程</h5></a>
		</div>

		<div class="ibox-content">
			<form id="searchForm" action="${ctx}/act/process/running/" method="post" class="form-horizontal">
				<div class="row">
					<div class="col-md-10">
						<label class="col-md-2 control-label">流程实例ID:</label>
						<div class="col-md-2">
							<input type="text" id="procInsId" name="procInsId" value="${procInsId}" class="form-control"/>
						</div>

						<label class="col-md-2 control-label">流程定义Key:</label>
						<div class="col-md-2">
							<input type="text" id="procDefKey" name="procDefKey" value="${procDefKey}" class="form-control"/>
						</div>

						<div class="col-md-1">
							<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
						</div>
						<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
						<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
					</div>
				</div>
			</form>
		</div>
	</div>



	<%--数据展示开始--%>
	<div class="ibox">
		<div class="ibox-content">

			<sys:message content="${message}"/>
			<table class="table table-striped table-hover table-bordered table-condensed">
				<thead>
				<tr>
					<th>执行ID</th>
					<th>流程实例ID</th>
					<th>流程定义ID</th>
					<th>当前环节</th>
					<th>是否挂起</th>
					<th>操作</th>
				</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="procIns">
					<tr>
						<td>${procIns.id}</td>
						<td>${procIns.processInstanceId}</td>
						<td>${procIns.processDefinitionId}</td>
						<td>${procIns.activityId}</td>
						<td>
							<c:if test="${procIns.suspended }">
								<a href="${ctx}/act/process/processInstance/update/active/${procIns.processInstanceId}">激活</a>
							</c:if>
							<c:if test="${!procIns.suspended }">
								<a href="${ctx}/act/process/processInstance/update/suspend/${procIns.processInstanceId}">挂起</a>
							</c:if>
						</td>
						<td>
							<shiro:hasPermission name="act:process:edit">
								<a href="${ctx}/act/process/deleteProcIns?procInsId=${procIns.processInstanceId}&reason=" onclick="return promptx('删除流程','删除原因',this.href);">删除流程</a>
							</shiro:hasPermission>&nbsp;
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
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>待办任务</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
	</script>
</head>

<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeIn">
	<!--查询表单开始-->
	<div class="ibox m-b-sm border-bottom">
		<div class="ibox-title">
			<a href="${ctx}/act/task/todo/"><h5>待办任务</h5></a>
		</div>

		<div class="ibox-content">
			<form:form id="searchForm" modelAttribute="act" action="${ctx}/act/task/todo/list" method="post"
					   cssClass="form-inline">

				<div class="form-group">
					<span>流程分类</span>
				</div>
				<div class="form-group">
					<form:select path="procDefKey" class="form-control input-sm">
						<form:option value="" label="全部流程"/>
						<form:options items="${fns:getDictList('act_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
					</form:select>
				</div>
				<div class="form-group">
					<span>创建时间</span>
				</div>
				<div class="form-group">
					<input id="beginDate"  name="beginDate"  type="text" readonly="readonly" maxlength="20" class="form-control input-sm" style="width:163px;"
						   value="<fmt:formatDate value="${act.beginDate}" pattern="yyyy-MM-dd"/>"
						   onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>--
					<input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="form-control input-sm" style="width:163px;"
						   value="<fmt:formatDate value="${act.endDate}" pattern="yyyy-MM-dd"/>"
						   onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"/>
				</div>
				<div class="form-group">
					<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
				</div>
			</form:form>
		</div>
	</div>
	<!--查询表单结束-->
	<sys:message content="${message}"/>
	<%--数据展示开始--%>
	<div class="ibox">
		<div class="ibox-content">
			<table id="contentTable" class="table table-striped table-bordered table-condensed">
				<thead>
				<tr>
					<th>任务ID</th>
					<th>当前环节</th>
					<th>流程名称</th>
					<th>创建时间</th>
					<th>逾期时间</th>
					<th>任务所属人</th>
					<th>操作</th>
				</tr>
				</thead>
				<tbody>
				<c:forEach items="${list}" var="act">
					<c:set var="task" value="${act.task}" />
					<c:set var="vars" value="${act.vars}" />
					<c:set var="procDef" value="${act.procDef}" />
					<c:set var="status" value="${act.status}" />
					<tr>
						<td>
							<a href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">${fns:abbr(not empty vars.map.title ? vars.map.title : task.id, 60)}</a>
						</td>
						<td>
							<a target="_blank" href="${ctx}/act/task/trace/photo/${task.processDefinitionId}/${task.executionId}">${task.name}</a>
							<a target="_blank" href="${pageContext.request.contextPath}/diagram-viewer/index.html?processDefinitionId=${task.processDefinitionId}&processInstanceId=${task.processInstanceId}">跟踪1</a>

						</td>
						<td>${procDef.name}</td>
						<td><fmt:formatDate value="${task.createTime}" type="both"/></td>
						<td><fmt:formatDate value="${task.dueDate}" type="both"/></td>
						<td>${task.owner}</td>
						<td>
							<c:if test="${not empty task.assignee}">
								<a href="#" onclick="openDialog('任务办理', '${ctx}/act/task/form/${task.id}','800px', '620px')" class="btn btn-primary btn-xs" >任务办理</a>
							</c:if>

							<%--<a href="${ctx}/act/dynamic/completeForm?taskId=${task.id}">动态办理</a>--%>
							<%--<c:if test="${not empty task.assignee}">--%>
								<%--<a href="${ctx}/act/task/form?taskId=${task.id}&taskName=${fns:urlEncode(task.name)}&taskDefKey=${task.taskDefinitionKey}&procInsId=${task.processInstanceId}&procDefId=${task.processDefinitionId}&status=${status}">任务办理</a>--%>
							<%--</c:if>--%>
							<shiro:hasPermission name="act:process:edit">
								<c:if test="${empty task.executionId}">
									<a href="${ctx}/act/task/deleteTask?taskId=${task.id}&reason=" onclick="return promptx('删除任务','删除原因',this.href);" class="btn btn-danger btn-xs">删除任务</a>
								</c:if>
							</shiro:hasPermission>

						</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

</div>
</body>



</html>

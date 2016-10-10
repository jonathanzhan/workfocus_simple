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
<div class="wrapper wrapper-content animated fadeInRight">
	<!--查询表单开始-->
	<div class="ibox m-b-sm border-bottom">
		<div class="ibox-title">
			<a href="${ctx}/act/task/todo/list"><h5>待办任务</h5></a>
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
				<c:forEach items="${list}" var="task">
					<tr>
						<td>${task.id}</td>
						<td>
							<a href="#" onclick="openDialogView('流程跟踪', '${ctx}/act/task/trace/photo/${task.processDefinitionId}/${task.executionId}','800px', '620px')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i>${task.name}</a>
						</td>
						<td>
							<a href="#" onclick="openDialogView('流程跟踪', '${pageContext.request.contextPath}/activiti/diagram-viewer/index.html?processDefinitionId=${task.processDefinitionId}&processInstanceId=${task.processInstanceId}','900px', '650px')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i>${task.name}</a>
						</td>
						<td><fmt:formatDate value="${task.createTime}" type="both"/></td>
						<td><fmt:formatDate value="${task.dueDate}" type="both"/></td>
						<td>${task.owner}</td>
						<td>
							<c:if test="${not empty task.assignee}">
								<a href="#" onclick="openDialog('任务办理', '${ctx}/act/task/form/${task.id}','800px', '620px')" class="btn btn-primary btn-xs" >任务办理</a>
							</c:if>
							<shiro:hasPermission name="act:process:edit">
								<c:if test="${empty task.executionId}">
									<a href="${ctx}/act/task/deleteTask?taskId=${task.id}&reason=" onclick="return promptx('删除原因',this.href);" class="btn btn-danger btn-xs"><i class="fa fa-trash">删除任务</i></a>
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

<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>动态表单-任务办理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script src="${ctxStatic}/plugins/layer/laydate/laydate.js"></script>
	<script>


	</script>
	<script src="${ctxStatic}/js/modules/act/task-events.js"></script>


	<script type="text/javascript">

		var taskId = '${task.id}';
		var processInstanceId = '${task.processInstanceId}';

		var validateForm;
		function doSubmit() {//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
			if (validateForm.form()) {
				$("#inputForm").submit();
				return true;
			}
			return false;
		}


		/**
		 * 修改任务的处理人和拥有人
		 * @param propertyName owner或者assignee
		 */
		function addUserIdentityLink(propertyName){
			$.post(ctx+"/act/task/changeTaskProperty/"+taskId,{
				propertyName:propertyName,
				value:$("#"+propertyName+"Id").val()
			},function(data){
				console.log("priority change result is:"+data);
				loadEvents();
			})
		}


		$(document).ready(function () {



			validateForm = $("#inputForm").validate({
				submitHandler: function (form) {
					layer.load();
					form.submit();
				},
				highlight: function (e) {
					$(e).parent().removeClass('has-success').addClass('has-error');
				},
				unhighlight: function(e) {
					$(e).parent().removeClass('has-error').addClass('has-success');
				},
				errorContainer: "#messageBox",
				errorPlacement: function (error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-group")) {
						error.appendTo(element.parent().parent());
					} else {
						error.appendTo(element.parent());
					}
				}
			});
		});
	</script>
</head>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="ibox">
		<div class="ibox-content">
			<h4 class="text-navy">任务办理-[${task.name}] 任务ID:${task.id} 流程实例ID:${task.processInstanceId}</h4>
			<div class="hr-line-dashed"></div>

			<form id="inputForm" action="${ctx}/act/dynamic/complete" method="post" class="form-horizontal">
				<input type="hidden" name="taskId" value="${task.id}"/>
				<sys:message content="${message}"/>
				<c:forEach items="${list}" var="property">
					<c:set var="enumKeyList" value="enum_${property.id}"></c:set>
					<c:set var="datePattern" value="pattern_${property.id}"></c:set>
					<div class="form-group">
						<label class="col-xs-2 control-label">${property.name}</label>
						<div class="col-xs-3">
							<c:choose>
								<c:when test="${property.type.name=='string' || property.type.name=='long'}">
									<input id="${property.id}" name="fp_${property.id}" value="${property.value}" type="text" <c:if test="${!property.writable}">readonly disabled</c:if> class="form-control <c:if test="${property.required}">required</c:if>" />
								</c:when>
								<c:when test="${property.type.name=='date'}">
									<input id="${property.id}" name="fp_${property.id}" value="${property.value}" type="text" readonly="readonly" <c:if test="${!property.writable}">disabled</c:if> class="form-control input-sm <c:if test="${property.required}">required</c:if>" <c:if test="${property.writable}">onclick="WdatePicker({dateFmt:'${datePatterns[datePattern]}'});"</c:if> />
								</c:when>
								<c:when test="${property.type.name=='enum'}">
									<select id="${property.id}" <c:if test="${property.writable}">name="fp_${property.id}" </c:if> <c:if test="${!property.writable}">readonly</c:if> class="form-control <c:if test="${property.required}">required</c:if>" />
									<c:forEach items="${result[enumKeyList]}" var="enums">
										<option value="${enums.key}" <c:if test="${property.value eq enums.key}">selected</c:if> >${enums.value}</option>
									</c:forEach>
									</select>
								</c:when>
								<c:otherwise>
									<input id="${property.id}" name="fp_${property.id}" type="text" value="${property.value}" <c:if test="${!property.writable}">readonly disabled</c:if> class="form-control <c:if test="${property.required}">required</c:if>" />
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:forEach>
			</form>
		</div>

		<div class="ibox-content">
			<h4 class="text-navy">流程属性</h4>
			<div class="hr-line-dashed"></div>
			<div class="row dashboard-header">
				<form id="propertyForm" method="post" class="form-horizontal">
					<div class="form-group">
						<label class="col-sm-2 control-label">拥有人</label>
						<div class="col-sm-4">
							<sys:treeselect id="owner" name="owner" value="${task.owner}" labelName="ownerName"
											labelValue="${task.owner}"
											title="拥有人" url="/sys/org/treeData?type=7" cssClass="form-control"
											dataMsgRequired="请选择用户" notAllowSelectRoot="true" notAllowSelectParent="true" treeEvent="addUserIdentityLink('owner')"/>
							<%--<div class="input-group">--%>
								<%--<input type="text" name="owner" id="owner" class="form-control" value="${task.owner}" readonly>--%>

								<%--<span class="input-group-btn">--%>
									<%--<button id="ownerButton" href="javascript:" type="button" class="btn btn-primary"><i class="fa fa-search"></i></button>--%>
								<%--</span>--%>
							<%--</div>--%>
						</div>

						<label class="col-sm-2 control-label">办理人</label>
						<div class="col-sm-4">
							<sys:treeselect id="assignee" name="assignee" value="${task.assignee}" labelName="assigneeName"
											labelValue="${task.assignee}"
											title="办理人" url="/sys/org/treeData?type=7" cssClass="form-control"
											dataMsgRequired="请选择用户" notAllowSelectRoot="true" notAllowSelectParent="true" treeEvent="addUserIdentityLink('assignee')"/>
						</div>
					</div>

					<div class="form-group">
						<label class="col-sm-2 control-label">到期日</label>
						<div class="col-sm-4">
							<input id="dueDate"  name="dueDate"  type="text"  maxlength="20" class="form-control laydate-icon layer-date"
								   value="<fmt:formatDate value="${task.dueDate}" pattern="yyyy-MM-dd HH:mm:ss"/>" />
						</div>
						<label class="col-sm-2 control-label">优先级</label>
						<div class="col-sm-4">
							<input id="priority" name="priority" type="number" value="${task.priority}" class="form-control">
						</div>
					</div>
				</form>
			</div>
		</div>

		<div class="ibox-content">
			<h4 class="text-navy">添加意见</h4>
			<div class="hr-line-dashed"></div>
			<div class="row dashboard-header">
				<div class="col-sm-12">

					<%--<label class="col-sm-2 control-label">拥有人</label>--%>
					<%--<div class="col-sm-4">--%>
						<%--<input type="text" class="form-control" value="${task.owner}">--%>
					<%--</div>--%>
					<%--<label class="col-sm-2 control-label">办理人</label>--%>
					<%--<div class="col-sm-4">--%>
						<%--<input type="text" class="form-control" value="${task.assignee}">--%>
					<%--</div>--%>
				</div>

				<div class="col-sm-12">
					<div class="input-group">
						<input type="text" id="comment" placeholder="添加意见" class="input form-control" />
						<span class="input-group-btn">
							<button type="button" id="btnAddComment" class="btn btn btn-primary"><i class="fa fa-plus"></i>保存意见</button>
						</span>
					</div>
					<div class="col-sm-12" style="margin-top: 10px" id="eventList">
						<ul>

						</ul>
					</div>

				</div>


			</div>

		</div>

		<act:histoicFlow procInsId="${task.processInstanceId}" />

		<act:historicVariable procInsId="${task.processInstanceId}" />
	</div>





</div>
</body>


</html>
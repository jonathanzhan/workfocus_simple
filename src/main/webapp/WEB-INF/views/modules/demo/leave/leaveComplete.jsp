<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>请假流程-办理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		var validateForm;
		function doSubmit() {//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
			if (validateForm.form()) {
				$("#inputForm").submit();
				return true;
			}
			return false;
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
<body>
<div class="wrapper wrapper-content">
	<div class="ibox">
		<div class="ibox-content">
			<h4 class="text-navy">
				任务办理
			</h4>
			<div class="hr-line-dashed"></div>

			<form:form action="${ctx}/demo/leave/complete" id="inputForm" modelAttribute="leave" method="post" class="form-horizontal">

				<form:hidden path="act.procDefId"/>
				<form:hidden path="act.taskId"/>
				<form:hidden path="act.taskName"/>
				<form:hidden path="act.taskDefKey"/>
				<form:hidden path="act.procInsId"/>
				<sys:message content="${message}"/>
				<div class="form-group">
					<label class="col-xs-4 control-label">请假开始时间 ${leave.act.taskDefKey}</label>
					<div class="col-xs-4">
						<input id="beginDate" <c:if test="${leave.act.taskDefKey eq 'reApply'}"> name="beginDate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"</c:if>   type="text" readonly="readonly" class="form-control input-sm required"
							   value="<fmt:formatDate value="${leave.beginDate}" pattern="yyyy-MM-dd"/>"
							   />
					</div>
				</div>
				<div class="form-group">
					<label class="col-xs-4 control-label">请假截止时间</label>
					<div class="col-xs-4">
						<input id="endDate" <c:if test="${leave.act.taskDefKey eq 'reApply'}"> name="endDate" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});"</c:if>   type="text" readonly="readonly" class="form-control input-sm required"
							   value="<fmt:formatDate value="${leave.endDate}" pattern="yyyy-MM-dd"/>"
						/>
					</div>
				</div>
				<div class="form-group">
					<label class="col-xs-4 control-label">原因</label>
					<div class="col-xs-4">
						<input type="text" id="reason" value="${leave.reason}" <c:if test="${leave.act.taskDefKey eq 'reApply'}"> name="reason" </c:if> class="form-control input-sm required" />
					</div>
				</div>
				<c:choose>
					<c:when test="${leave.act.taskDefKey eq 'reportBack'}">
						<div class="form-group">
							<label class="col-xs-4 control-label">销假日期</label>
							<div class="col-xs-4">
								<form:input path="backDate" readonly="readonly" class="form-control input-sm required" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});" />
							</div>
						</div>
					</c:when>
					<c:otherwise>
						<div class="form-group">
							<label class="col-xs-4 control-label">${leave.act.taskName}</label>
							<div class="col-xs-4">
								<select id="${leave.act.taskDefKey}" name="${leave.act.taskDefKey}" class="form-control input-sm required">
									<option value="true">通过</option>
									<option value="false">拒绝</option>
								</select>
							</div>
						</div>
					</c:otherwise>
				</c:choose>


			</form:form>
		</div>
	</div>
	<act:histoicFlow procInsId="${leave.act.procInsId}" />

</div>
</body>
</html>

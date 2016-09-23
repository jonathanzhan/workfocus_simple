<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>请假流程-启动</title>
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
	<form:form action="${ctx}/demo/leave/start" id="inputForm" modelAttribute="leave" method="post" class="form-horizontal">

		<form:hidden path="act.procDefId"/>
		<sys:message content="${message}"/>
		<div class="form-group">
			<label class="col-xs-4 control-label">请假开始时间</label>
			<div class="col-xs-4">
				<form:input path="beginDate" readonly="readonly" class="form-control input-sm required" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});" />
			</div>
		</div>
		<div class="form-group">
			<label class="col-xs-4 control-label">请假截止时间</label>
			<div class="col-xs-4">
				<form:input path="endDate" readonly="readonly" class="form-control input-sm required" onclick="WdatePicker({dateFmt:'yyyy-MM-dd'});" />
			</div>
		</div>
		<div class="form-group">
			<label class="col-xs-4 control-label">原因</label>
			<div class="col-xs-4">
				<form:input path="reason" class="form-control input-sm required" />
			</div>
		</div>
	</form:form>
</div>
</body>
</html>

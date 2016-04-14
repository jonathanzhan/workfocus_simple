<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
	<title>员工管理</title>
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

		function setEmployeeRequired(){
			if($("#userType").val()=='1'){
				$("#employeeName").removeClass("required");
				$("#employeeName").parent().removeClass('has-error').addClass('has-success');
				$("#employeeName-error").remove();

			}else{
				$("#employeeName").addClass("required");
				$("#employeeName").parent().removeClass('has-success').addClass('has-error');
			}
		}
		$(document).ready(function () {
			$("#name").focus();

			$("#userType").on("change",function(){
				setEmployeeRequired();
			});
			validateForm = $("#inputForm").validate({
				rules: {
					loginName: {remote: "${ctx}/sys/user/checkLoginName?oldLoginName=" + encodeURIComponent('${user.loginName}')}
				},
				messages: {
					loginName: {remote: "用户登录名已存在"},
					confirmNewPassword: {equalTo: "输入与上面相同的密码"}
				},
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

			//在ready函数中预先调用一次远程校验函数，是一个无奈的回避案
			//否则打开修改对话框，不做任何更改直接submit,这时再触发远程校验，耗时较长，
			//submit函数在等待远程校验结果然后再提交，而layer对话框不会阻塞会直接关闭同时会销毁表单，因此submit没有提交就被销毁了导致提交表单失败。
			$("#inputForm").validate().element($("#loginName"));
		});
	</script>
</head>
<body>
<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/save" method="post" class="form-horizontal">
	<form:hidden path="id"/>
	<sys:message content="${message}"/>
	<table class="table table-bordered table-condensed">
		<tbody>
		<tr class="form-group">
			<td class="active col-xs-2">
				<label class="pull-right">登录名:</label>
			</td>
			<td class="col-xs-4">
				<input id="oldLoginName" name="oldLoginName" type="hidden" value="${user.loginName}">
				<form:input path="loginName" htmlEscape="false" maxlength="8" class="form-control inline required"/>
				<span class="required-wrapper">*</span>
			</td>
			<td class="active col-xs-2">
				<label class="pull-right">用户名:</label>
			</td>
			<td class="col-xs-4">
				<form:input path="name" htmlEscape="false" maxlength="8" class="form-control inline required"/>
				<span class="required-wrapper">*</span>

			</td>
		</tr>
		<tr class="form-group">
			<td class="active col-xs-2">
				<label class="pull-right">用户类型:</label>
			</td>
			<td class="col-xs-4">
				<form:select path="userType" items="${fns:getDictList('sys_user_type')}" itemLabel="label" itemValue="value" cssClass="form-control inline required"/>
				<span class="required-wrapper">*</span>
			</td>

			<td class="active col-xs-2">
				<label class="pull-right">对应员工:</label>
			</td>
			<td class="col-xs-4">
				<sys:treeselect id="employee" name="employee.id" value="${user.employee.id}" labelName="employeeName"
								labelValue="${user.employee.name}" allowClear="true"
								title="员工" url="/sys/org/treeData?type=5" cssClass="form-control"
								dataMsgRequired="请选择员工" notAllowSelectParent="true"/>
			</td>

		</tr>
		<tr class="form-group">
			<td class="active col-xs-2">
				<label class="pull-right">密码:</label>
			</td>
			<td class="col-xs-4">
				<input id="newPassword" name="newPassword" type="password" value="" maxlength="50" minlength="3" placeholder="${empty user.id?'':'若不修改,请留空'}" class="form-control ${empty user.id?'inline required':''}" />
				<c:if test="${empty user.id}">
					<span class="required-wrapper">*</span>
				</c:if>
			</td>

			<td class="active col-xs-2">
				<label class="pull-right">确认密码:</label>
			</td>
			<td class="col-xs-4">
				<input id="confirmNewPassword" name="confirmNewPassword" type="password" value="" maxlength="50" minlength="3" equalTo="#newPassword" class="form-control ${empty user.id?'inline required':''}"/>
				<c:if test="${empty user.id}">
					<span class="required-wrapper">*</span>
				</c:if>
			</td>
		</tr>
		<tr class="form-group">
			<td class="active col-xs-2">
				<label class="pull-right">头像:</label>
			</td>
			<td class="col-xs-4">
				<form:hidden path="img" htmlEscape="false" maxlength="255" class="input-xlarge"/>
				<sys:ckfinder input="img" type="images" uploadPath="/photo" selectMultiple="false" maxWidth="100" maxHeight="100"/>
			</td>
			<td class="active col-xs-2">
				<label class="pull-right">用户角色:</label>
			</td>
			<td class="col-xs-4">
				<form:checkboxes path="roleIdList" items="${fns:getRoleList()}" itemLabel="name" itemValue="id" htmlEscape="false" cssClass="i-checks inline required"/>
				<span class="required-wrapper">*</span>
			</td>
		</tr>
		<c:if test="${not empty user.id}">
			<tr class="form-group">
				<td class="active col-xs-2">
					<label class="pull-right">创建时间:</label>
				</td>
				<td class="col-xs-4">
					<label class="control-label"><fmt:formatDate value="${user.createAt}" type="both" dateStyle="full"/></label>
				</td>
				<td class="active col-xs-2">
					<label class="pull-right">上次登录IP:</label>
				</td>
				<td class="col-xs-4">
					<label class="control-label">IP: ${user.thisLoginIp}&nbsp;&nbsp;&nbsp;&nbsp;时间：<fmt:formatDate value="${user.thisLoginAt}" type="both"/></label>
				</td>
			</tr>
		</c:if>

		</tbody>
	</table>
</form:form>

</body>
</html>
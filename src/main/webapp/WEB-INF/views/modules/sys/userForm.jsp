<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>用户管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#no").workfocus();
			$("#inputForm").validate({
				rules: {
					userName: {remote: "${ctx}/sys/user/checkLoginName?oldLoginName=" + encodeURIComponent('${user.userName}')}
				},
				messages: {
					userName: {remote: "用户登录名已存在"},
					confirmNewPassword: {equalTo: "输入与上面相同的密码"}
				},
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
<div class="panel" id="mainPanel">
	<div class="panel-heading">
		<ul class="nav nav-tabs">
			<li><a href="${ctx}/sys/user/list">用户列表</a></li>
			<li class="active"><a href="${ctx}/sys/user/form?id=${user.id}">用户<shiro:hasPermission name="sys:user:edit">${not empty user.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:user:edit">查看</shiro:lacksPermission></a></li>
		</ul><br/>
	</div>
	<div class="panel-body">
		<div class="tab-content col-md-12">
			<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/save" method="post" class="form-horizontal">
				<form:hidden path="id"/>
				<sys:message content="${message}"/>
				<div class="form-group">
					<div class="row-group">
						<label class="col-md-1 control-label">头像:</label>
						<div class="col-md-3">
							<form:hidden id="nameImage" path="img" htmlEscape="false" maxlength="255" cssClass="form-control"/>
							<sys:ckfinder input="nameImage" type="images" uploadPath="/photo" selectMultiple="false" maxWidth="100" maxHeight="100"/>
						</div>
					</div>

				</div>
				<%--<div class="control-group">--%>
				<%--<label class="control-label">归属公司:</label>--%>
				<%--<div class="controls">--%>
				<%--<sys:treeselect id="company" name="company.id" value="${user.company.id}" labelName="company.name" labelValue="${user.company.name}"--%>
				<%--title="公司" url="/sys/office/treeData?type=1" cssClass="required"/>--%>
				<%--</div>--%>
				<%--</div>--%>
				<%--<div class="control-group">--%>
				<%--<label class="control-label">归属部门:</label>--%>
				<%--<div class="controls">--%>
				<%--<sys:treeselect id="office" name="office.id" value="${user.office.id}" labelName="office.name" labelValue="${user.office.name}"--%>
				<%--title="部门" url="/sys/office/treeData?type=2" cssClass="required" notAllowSelectParent="true"/>--%>
				<%--</div>--%>
				<%--</div>--%>
				<%--<div class="control-group">--%>
				<%--<label class="control-label">工号:</label>--%>
				<%--<div class="controls">--%>
				<%--<form:input path="no" htmlEscape="false" maxlength="50" class="required"/>--%>
				<%--<span class="help-inline"><font color="red">*</font> </span>--%>
				<%--</div>--%>
				<%--</div>--%>
				<%--<div class="control-group">--%>
				<%--<label class="control-label">姓名:</label>--%>
				<%--<div class="controls">--%>
				<%--<form:input path="name" htmlEscape="false" maxlength="50" class="required"/>--%>
				<%--<span class="help-inline"><font color="red">*</font> </span>--%>
				<%--</div>--%>
				<%--</div>--%>
				<div class="form-group">
					<div class="row-group">
						<label class="col-md-1 control-label">登录名:</label>
						<div class="col-md-3">
							<input id="oldLoginName" name="oldLoginName" type="hidden" value="${user.userName}">
							<form:input path="userName" htmlEscape="false" maxlength="50" class=" form-control required userName layerBox"/>
						</div>
						<div class="required-wrapper"></div>
					</div>
					<div class="row-group">
						<label class="col-md-1 control-label">用户名称:</label>
						<div class="col-md-3">
							<form:input path="name" htmlEscape="false" maxlength="50" class="form-control required layerBox"/>
						</div>
						<div class="required-wrapper"></div>
					</div>

				</div>
				<c:if test="${not empty user.id}">
					<div class="form-group">
						<div class="row-group">
							<div class="col-md-1 "></div>
							<div class="col-md-3 ">
							<div class="help-inline">若不修改密码，请留空。</div>
							</div>
						</div>
					</div>
				</c:if>
				<div class="form-group">
					<div class="row-group">
						<label class="col-md-1 control-label">密码:</label>
						<div class="col-md-3">
							<input id="newPassword" name="newPassword" type="password" value="" maxlength="50" minlength="3" class="form-control ${empty user.id?'required layerBox':''}" />

						</div>
						<c:if test="${empty user.id}"><div class="required-wrapper"></div></c:if>
						<%--<c:if test="${not empty user.id}"><div class="help-inline">若不修改密码，请留空。</div></c:if>--%>
					</div>
					<div class="row-group">
						<label class="col-md-1 control-label">确认密码:</label>
						<div class="col-md-3">
							<input id="confirmNewPassword" name="confirmNewPassword" type="password" value="" maxlength="50" minlength="3" equalTo="#newPassword" class="form-control"/>
						</div>
						<c:if test="${empty user.id}"><div class="required-wrapper"></div></c:if>
					</div>
				</div>

				<div class="form-group">
					<div class="row-group">
						<label class="col-md-1 control-label">用户角色:</label>
						<div class="col-md-3">
							<label class="radio-inline">
								<form:checkboxes path="roleIdList" items="${fns:getRoleList()}" itemLabel="roleName" itemValue="id" htmlEscape="false" class="required layerBox"/>

							</label>
						</div>
						<div class="required-wrapper"></div>
					</div>
				</div>
								<%--<div class="control-group">--%>
				<%--<label class="control-label">邮箱:</label>--%>
				<%--<div class="controls">--%>
				<%--<form:input path="email" htmlEscape="false" maxlength="100" class="email"/>--%>
				<%--</div>--%>
				<%--</div>--%>
				<%--<div class="control-group">--%>
				<%--<label class="control-label">电话:</label>--%>
				<%--<div class="controls">--%>
				<%--<form:input path="phone" htmlEscape="false" maxlength="100"/>--%>
				<%--</div>--%>
				<%--</div>--%>
				<%--<div class="control-group">--%>
				<%--<label class="control-label">手机:</label>--%>
				<%--<div class="controls">--%>
				<%--<form:input path="mobile" htmlEscape="false" maxlength="100"/>--%>
				<%--</div>--%>
				<%--</div>--%>
				<%--<div class="control-group">--%>
				<%--<label class="control-label">是否允许登录:</label>--%>
				<%--<div class="controls">--%>
				<%--<form:select path="loginFlag">--%>
				<%--<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false"/>--%>
				<%--</form:select>--%>
				<%--<span class="help-inline"><font color="red">*</font> “是”代表此账号允许登录，“否”则表示此账号不允许登录</span>--%>
				<%--</div>--%>
				<%--</div>--%>
				<%--<div class="control-group">--%>
				<%--<label class="control-label">用户类型:</label>--%>
				<%--<div class="controls">--%>
				<%--<form:select path="userType" class="input-large">--%>
				<%--<form:option value="1" label="请选择"/>--%>
				<%--<form:options items="${fns:getDictList('sys_user_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>--%>
				<%--</form:select>--%>
				<%--</div>--%>
				<%--</div>--%>
				<c:if test="${not empty user.id}">
				<div class="form-group">
					<div class="row-group">
						<label class="col-md-1 control-label">创建时间:</label>
						<div class="col-md-3">
							<label class="control-label"><fmt:formatDate value="${user.createAt}" type="both" dateStyle="full"/></label>
						</div>
					</div>
					<div class="row-group">
						<label class="col-md-1 control-label">最后登陆:</label>
						<div class="col-md-3">
							<label class="control-label">IP: ${user.lastLoginIp}&nbsp;&nbsp;&nbsp;&nbsp;时间：<fmt:formatDate value="${user.lastLoginAt}" type="both" dateStyle="full"/></label>
						</div>
					</div>
				</div>
				</c:if>

				<div class="form-group">
					<div class="col-md-offset-2">
					    <shiro:hasPermission name="sys:user:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
					    <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
				    </div>
				</div>
			</form:form>
		</div>
	</div>


</div>
</body>
</html>
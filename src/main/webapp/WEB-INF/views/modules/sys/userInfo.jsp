<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>个人信息</title>
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
					confirmNewPassword: {equalTo: "输入与上面相同的密码"},
					email:{email:"请输入正确的电子邮箱！"},
					tel:{mobile:"请输入正确的联系电话！"}
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
<div class="panel" id="mainPanel">
	<div class="panel-heading">
	    <ul class="nav nav-tabs">
	    	<li class="active"><a href="${ctx}/sys/user/info">个人信息</a></li>
	    	<li><a href="${ctx}/sys/user/modifyPwd">修改密码</a></li>
	    </ul><br/>
	</div>
	<div class="panel-body">
		<div class="tab-content col-md-12">
			<form:form id="inputForm" modelAttribute="user" action="${ctx}/sys/user/info" method="post" class="form-horizontal">
				<input type="hidden" id="isSave" name="isSave" value="1" >
				<form:hidden path="id" />
				<%--
                    <form:hidden path="email" htmlEscape="false" maxlength="255" class="input-xlarge"/>
                    <sys:ckfinder input="email" type="files" uploadPath="/mytask" selectMultiple="false"/> --%>
				<sys:message content="${message}"/>
				<div class="form-group">
					<div class="row-group">
						<label class="col-md-1 control-label">头像:</label>
						<div class="col-md-3">
							<form:hidden id="nameImage" path="img" htmlEscape="false" maxlength="255" class="form-control required layerBox"/>
							<sys:ckfinder input="nameImage" type="images" uploadPath="/photo" selectMultiple="false" maxWidth="100" maxHeight="100"  />
						</div>
						<div class="required-wrapper"></div>
					</div>
					<div class="row-group">
						<label class="col-md-1 control-label requiredLabel">登录名:</label>
						<div class="col-md-3">
							<input id="oldLoginName" name="oldLoginName" type="hidden" value="${user.userName}">
							<form:input path="userName" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
						<div class="required-wrapper"></div>
					</div>
				</div>
				<div class="form-group">
					<div class="row-group">
						<label class="col-md-1 control-label">用户名称:</label>
						<div class="col-md-3">
							<form:input path="name" htmlEscape="false" maxlength="50" class="required"/>
						</div>
						<div class="required-wrapper"></div>
					</div>
				</div>
				<c:if test="${user.employee.id!=null}">
				    <div class="form-group">
						<div class="row-group">
							<label class="control-label">员工编号:</label>
							<div class="col-md-3">
								<label class="lbl">
									<form:hidden path="employee.id" />
										${user.employee.employeeCd}
								</label>
							</div>
						</div>

						<div class="row-group">
							<label class="col-md-1 control-label">中文名称:</label>
							<div class="col-md-3">
								<form:input path="employee.employeeCnm" htmlEscape="false" maxlength="50" class="form-control"/>
							</div>
							<div class="required-wrapper"></div>
						</div>
					</div>
				<div class="form-group">
					<div class="row-group">
						<label class="col-md-1 control-label">英文名称:</label>
						<div class="col-md-3">
								<form:input path="employee.employeeEnm" htmlEscape="false" maxlength="50" class="form-control required"/>
						</div>
						<div class="required-wrapper"></div>
					</div>

					<div class="row-group">
						<label class="col-md-1 control-label">归属部门:</label>
						<div class="col-md-3">
							<label class="form-control ">${user.employee.org.orgNm}</label>
						</div>
						<div class="required-wrapper"></div>
					</div>

				</div>
				<div class="form-group">
					<div class="row-group">
						<label class="col-md-1 control-label">电子邮箱:</label>
						<div class="col-md-3">
							<form:input path="employee.email" id="email" htmlEscape="false" maxlength="50" class="form-control email required"/>
						</div>
					</div>
					<div class="row-group">
						<label class="col-md-1 control-label">联系电话:</label>
						<div class="col-md-3">
							<form:input path="employee.tel" id="tel" class="form-control phone required" htmlEscape="false" maxlength="25"/>
						</div>
					</div>
				</div>


				</c:if>
				<div class="form-group">
					<div class="row-group">
						<label class="col-md-1 control-label">用户类型:</label>
						<div class="col-md-3">
							<label class="lbl">
									${fns:getDictLabel(user.userType, 'sys_user_type', '无')}</label>
						</div>
					</div>
					<div class="row-group">
						<label class="col-md-1 control-label">上次登录:</label>
						<div class="col-md-3">
							<label class="lbl">IP: ${user.lastLoginIp}&nbsp;&nbsp;&nbsp;&nbsp;时间：<fmt:formatDate value="${user.lastLoginAt}" type="both" dateStyle="full"/></label>
						</div>
					</div>
				</div>

				<div class="form-group">
					<div class="col-md-offset-2">
					    <input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>
					</div>
				</div>
			</form:form>
		</div>
	</div>
</div>

</body>
</html>
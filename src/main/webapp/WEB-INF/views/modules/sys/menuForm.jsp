<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>菜单管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<%@include file="/WEB-INF/views/include/treeview.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#name").focus();
			$("#inputForm").validate({
				submitHandler: function(form){
					layer.load();
					form.submit();
				},
				highlight: function (e) {
					$(e).closest('.form-group').removeClass('has-success').addClass('has-error');
				},
				unhighlight: function(e) {
					$(e).closest('.form-group').removeClass('has-error').addClass('has-success');

				},
				invalidHandler: function () {
					showMessageBox('保存失败,信息填写不完整!');
				},
				errorPlacement: function (error, element) {
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-group")){
						error.appendTo(element.parent().parent().parent());
					} else {
						error.appendTo(element.parent().parent());
					}
				}
			});
		});
	</script>
	<style>

	</style>
</head>

<body class="gray-bg">
<div class="wrapper wrapper-content">

	<div class="ibox">
		<div class="ibox-title">
			<a href="${ctx}/sys/menu/form?id=${menu.id}&parent.id=${menu.parent.id}"><h5>菜单信息</h5></a>
			<div class="ibox-tools">
				<a href="${ctx}/sys/menu/" class="btn btn-primary btn-xs">返回菜单列表</a>
			</div>
		</div>

		<div class="ibox-content">

			<form:form id="inputForm" modelAttribute="menu" action="${ctx}/sys/menu/save" method="post" class="form-horizontal">
				<form:hidden path="id"/>
				<sys:message content="${message}"/>
				<div class="form-group">
					<label class="col-md-2 control-label">上级菜单</label>
					<div class="col-md-4">
						<sys:treeselect id="menu" name="parent.id" value="${menu.parent.id}" labelName="parent.name" labelValue="${menu.parent.name}"
										title="菜单" url="/sys/menu/treeData" extId="${menu.id}" cssClass="form-control required" dataMsgRequired="请选择上级菜单"/>
					</div>
				</div>

				<div class="form-group">
					<label class="col-md-2 control-label">名称</label>
					<div class="col-md-4">
						<form:input path="name" htmlEscape="false" maxlength="20" class="form-control inline required" placeholder="菜单名称" />
						<span class="required-wrapper">*</span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-2 control-label">链接</label>
					<div class="col-md-4">
						<form:input path="href" htmlEscape="false" maxlength="100" class="form-control" placeholder="点击菜单跳转的页面"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-2 control-label">目标 </label>
					<div class="col-md-4">
						<form:input path="target" htmlEscape="false" maxlength="20" class="form-control" placeholder="链接地址打开的目标窗口，默认：mainFrame"/>
					</div>
					<div class="required-wrapper"></div>
				</div>
				<div class="form-group">
					<label class="col-md-2 control-label">图标</label>
					<div class="col-md-4">
						<sys:iconselect id="icon" name="icon" value="${menu.icon}"/>
					</div>

				</div>
				<div class="form-group">
					<label class="col-md-2 control-label">排序</label>
					<div class="col-md-4">
						<form:input path="seq" htmlEscape="false" class="required form-control digits" range="[0,1000]" data-msg-digits="排序只能为0-100的整数"/>
						<span class="help-inline">排列顺序，升序。</span>
					</div>
					<div class="required-wrapper"></div>
				</div>
				<div class="form-group">
					<label class="col-md-2 control-label">可见</label>
					<div class="col-md-4">
						<form:radiobuttons path="isShow" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
					</div>
				</div>

				<div class="form-group">
					<label class="col-md-2 control-label">权限标识</label>
					<div class="col-md-4">
						<form:input path="permission" htmlEscape="false" maxlength="100" class="form-control"/>
						<span class="help-inline">控制器中定义的权限标识，如：@RequiresPermissions("权限标识")</span>
					</div>
				</div>

				<div class="form-group">
					<label class="col-md-2 control-label">备注</label>
					<div class="col-md-4">
						<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="200"  class='form-control'/>
					</div>
				</div>

				<div class="form-group">
					<div class="col-md-offset-2">
						<shiro:hasAnyPermissions name="sys:menu:add,sys:menu:edit">
							<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
						</shiro:hasAnyPermissions>
						<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
					</div>
				</div>
			</form:form>
		</div>
	</div>

</div>


</body>

</html>
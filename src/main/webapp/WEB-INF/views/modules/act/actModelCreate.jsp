<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
	<title>新建模型 - 模型管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">

		$(document).ready(function () {
			$("#name").focus();

			$("#inputForm").validate({
				submitHandler: function (form) {
					layer.load();
					form.submit();
					setTimeout(function(){location='${ctx}/act/model/'}, 1000);
				},
				highlight: function (e) {
					$(e).closest('.form-group').removeClass('has-success').addClass('has-error');
				},
				unhighlight: function (e) {
					$(e).closest('.form-group').removeClass('has-error').addClass('has-success');

				},
				invalidHandler: function () {
					showMessageBox('保存失败,信息填写不完整!');
				},
				errorPlacement: function (error, element) {
					error.appendTo(element.parent().parent());
				}
			});

		});
	</script>
</head>


<body class="gray-bg">
<div class="wrapper wrapper-content">

	<div class="ibox">
		<div class="ibox-title">
			<a href="${ctx}/act/model/create"><h5>模型添加</h5></a>

			<div class="ibox-tools">
				<a href="${ctx}/act/model" class="btn btn-primary btn-xs">返回模型列表</a>
			</div>
		</div>

		<div class="ibox-content">

			<form id="inputForm" target="_blank" action="${ctx}/act/model/create" method="post"
					   class="form-horizontal">
				<sys:message content="${message}"/>
				<div class="form-group">
					<label class="col-md-2 control-label">流程分类</label>

					<div class="col-md-3">
						<select id="category" name="category" class="form-control inline required">
							<c:forEach items="${fns:getDictList('act_category')}" var="dict">
								<option value="${dict.value}">${dict.label}</option>
							</c:forEach>
						</select>
						<span class="required-wrapper">*</span>
					</div>
				</div>

				<div class="form-group">
					<label class="col-md-2 control-label">模块名称</label>

					<div class="col-md-3">
						<input id="name" name="name" maxlength="20" type="text" class="form-control inline required" />
						<span class="required-wrapper">*</span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-2 control-label">模块标识</label>

					<div class="col-md-3">
						<input id="key" name="key" type="text" maxlength="20" class="form-control inline required" />
						<span class="required-wrapper">*</span>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-2 control-label">模块描述</label>

					<div class="col-md-3">
						<input id="description" name="description" htmlEscape="false" maxlength="50"
									class="form-control"/>
					</div>
				</div>
				<div class="form-group">
					<div class="col-md-offset-2">
						<shiro:hasAnyPermissions name="act:model:edit">
							<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
						</shiro:hasAnyPermissions>
						<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
					</div>

				</div>
			</form>
		</div>
	</div>

</div>


</body>


</html>
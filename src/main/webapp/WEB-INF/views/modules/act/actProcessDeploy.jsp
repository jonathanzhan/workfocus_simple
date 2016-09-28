<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>部署流程 - 流程管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#inputForm").validate({
				submitHandler: function (form) {
					layer.load();
					form.submit();
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
<div class="wrapper wrapper-content animated fadeInRight">

	<!--查询表单开始-->
	<div class="ibox m-b-sm border-bottom">
		<div class="ibox-title">
			<a href="${ctx}/act/process/deploy"><h5>流程部署</h5></a>
		</div>

		<div class="ibox-content">
			<sys:message content="${message}"/>
			<form id="inputForm" enctype="multipart/form-data" action="${ctx}/act/process/deploy"  method="post"
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
					<label class="col-md-2 control-label">流程文件</label>
					<div class="col-md-3">
						<input type="file" id="file" name="file" class="form-control required"/>
						<span class="help-inline">支持文件格式：zip、bar、bpmn、bpmn20.xml</span>
					</div>
				</div>
				<div class="form-group">
					<div class="col-md-offset-2">
						<shiro:hasAnyPermissions name="act:model:edit">
							<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>
						</shiro:hasAnyPermissions>
					</div>
				</div>

			</form>

		</div>
	</div>
</div>

</body>
</html>

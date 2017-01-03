<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
	<title>生成方案管理</title>
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
			$("#name").focus();

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
<form:form id="inputForm" modelAttribute="genScheme" action="${ctx}/gen/genScheme/save" method="post" class="form-horizontal">
	<form:hidden path="id"/>
	<sys:message content="${message}"/>
	<table class="table table-bordered table-condensed dataTable">
		<tbody>
		<tr class="form-group">
			<td class="active col-xs-4">
				<label class="pull-right">方案名称:</label>
			</td>
			<td class="col-xs-8">
				<form:input path="name" htmlEscape="false" maxlength="20" class="form-control inline required"/>
				<span class="required-wrapper">*</span>

			</td>
		</tr>
		<tr class="form-group">
			<td class="active col-xs-4">
				<label class="pull-right">模板分类:</label>
			</td>
			<td class="col-xs-8">
				<form:select path="category" cssClass="form-control inline required" items="${config.categoryList}" itemLabel="label" itemValue="value">
				</form:select>
				<span class="required-wrapper">*</span>
			</td>

		</tr>
		<tr class="form-group">
			<td class="active col-xs-4">
				<label class="pull-right">生成包路径:</label>
			</td>
			<td class="col-xs-8">
				<form:input path="packageName" placeholder="建议模块包：com.mfnets.workfocus.modules" htmlEscape="false" maxlength="500" class="form-control inline required"/>
				<span class="required-wrapper">*</span>

			</td>
		</tr>
		<tr class="form-group">
			<td class="active col-xs-4">
				<label class="pull-right">生成模块名:</label>
			</td>
			<td class="col-xs-8">
				<form:input path="moduleName" placeholder="可理解为子系统名，例如 sys" htmlEscape="false" maxlength="500" class="form-control inline required"/>
				<span class="required-wrapper">*</span>

			</td>
		</tr>
		<tr class="form-group">
			<td class="active col-xs-4">
				<label class="pull-right">生成子模块名:</label>
			</td>
			<td class="col-xs-8">
				<form:input path="subModuleName" placeholder="可选，分层下的文件夹，例如" htmlEscape="false" maxlength="500" class="form-control"/>
			</td>
		</tr>
		<tr class="form-group">
			<td class="active col-xs-4">
				<label class="pull-right">生成功能描述:</label>
			</td>
			<td class="col-xs-8">
				<form:input path="functionName" placeholder="将设置到类描述" htmlEscape="false" maxlength="500" class="form-control inline required"/>
				<span class="required-wrapper">*</span>
			</td>
		</tr>
		<tr class="form-group">
			<td class="active col-xs-4">
				<label class="pull-right">生成功能名:</label>
			</td>
			<td class="col-xs-8">
				<form:input path="functionNameSimple" placeholder="用作功能提示，如：保存“某某”成功" htmlEscape="false" maxlength="500" class="form-control inline required"/>
				<span class="required-wrapper">*</span>
			</td>
		</tr>
		<tr class="form-group">
			<td class="active col-xs-4">
				<label class="pull-right">生成功能作者:</label>
			</td>
			<td class="col-xs-8">
				<form:input path="functionAuthor" placeholder="功能开发者" htmlEscape="false" maxlength="500" class="form-control"/>
			</td>
		</tr>
		<tr class="form-group">
			<td class="active col-xs-4">
				<label class="pull-right">业务表名:</label>
			</td>
			<td class="col-xs-8">
				<form:select path="genTable.id" cssClass="form-control inline required" items="${tableList}" itemLabel="nameAndComments" itemValue="id">
				</form:select>
				<span class="required-wrapper">*</span>
			</td>
		</tr>
		<tr class="form-group">
			<td class="active col-xs-4">
				<label class="pull-right">备注:</label>
			</td>
			<td class="col-xs-8">
				<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="200" class="form-control"/>
			</td>
		</tr>
		<tr class="form-group">
			<td class="active col-xs-4">

				<label class="pull-right">生成选项:</label>
			</td>
			<td class="col-xs-8">
				<form:checkbox path="replaceFile" cssClass="i-checks" label="替换现有文件"/>
			</td>
		</tr>
		</tbody>
	</table>
</form:form>

</body>
</html>
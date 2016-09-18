<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>动态表单-启动</title>
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
	<form id="inputForm" action="${ctx}/act/dynamic/start" method="post" class="form-horizontal">
		<input type="hidden" name="procDefId" value="${formData.processDefinition.id}"/>
		<sys:message content="${message}"/>
		<c:forEach items="${list}" var="property">
			<c:set var="enumKeyList" value="enum_${property.id}"></c:set>
			<c:set var="datePattern" value="pattern_${property.id}"></c:set>
			<div class="form-group">
				<label class="col-xs-4 control-label">${property.name} </label>
				<div class="col-xs-4">
					<c:choose>
						<c:when test="${property.type.name=='string' || property.type.name=='long'}">
							<input id="${property.id}" name="fp_${property.id}" type="text" <c:if test="${!property.writable}">readonly</c:if> class="form-control <c:if test="${property.required}">required</c:if>" />
						</c:when>
						<c:when test="${property.type.name=='date'}">
							<input id="${property.id}"  name="fp_${property.id}"  type="text" readonly="readonly" class="form-control input-sm <c:if test="${property.required}">required</c:if>" <c:if test="${property.writable}">onclick="WdatePicker({dateFmt:'${datePatterns[datePattern]}'});"</c:if> />
						</c:when>
						<c:when test="${property.type.name=='enum'}">
							<select id="${property.id}" name="fp_${property.id}" <c:if test="${!property.writable}">readonly</c:if> class="form-control <c:if test="${property.required}">required</c:if>" />
								<c:forEach items="${result[enumKeyList]}" var="enums">
									<option value="${enums.key}">${enums.value}</option>
								</c:forEach>
							</select>
						</c:when>
						<c:otherwise>
							<input id="${property.id}" name="fp_${property.id}" type="text" <c:if test="${!property.writable}">readonly</c:if> class="form-control <c:if test="${property.required}">required</c:if>" />
						</c:otherwise>
					</c:choose>
				</div>

			</div>
		</c:forEach>
	</form>
</div>
</body>
</html>

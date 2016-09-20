<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>动态表单-任务办理</title>
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
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="ibox">
		<div class="ibox-content">
			<h4 class="text-navy">
				任务办理
			</h4>
			<div class="hr-line-dashed"></div>

			<form id="inputForm" action="${ctx}/act/dynamic/complete" method="post" class="form-horizontal">
				<input type="hidden" name="taskId" value="${task.id}"/>
				<sys:message content="${message}"/>
				<c:forEach items="${list}" var="property">
					<c:set var="enumKeyList" value="enum_${property.id}"></c:set>
					<c:set var="datePattern" value="pattern_${property.id}"></c:set>
					<div class="form-group">
						<label class="col-xs-2 control-label">${property.name}</label>
						<div class="col-xs-3">
							<c:choose>
								<c:when test="${property.type.name=='string' || property.type.name=='long'}">
									<input id="${property.id}" name="fp_${property.id}" value="${property.value}" type="text" <c:if test="${!property.writable}">readonly disabled</c:if> class="form-control <c:if test="${property.required}">required</c:if>" />
								</c:when>
								<c:when test="${property.type.name=='date'}">
									<input id="${property.id}" name="fp_${property.id}" value="${property.value}" type="text" readonly="readonly" <c:if test="${!property.writable}">disabled</c:if> class="form-control input-sm <c:if test="${property.required}">required</c:if>" <c:if test="${property.writable}">onclick="WdatePicker({dateFmt:'${datePatterns[datePattern]}'});"</c:if> />
								</c:when>
								<c:when test="${property.type.name=='enum'}">
									<select id="${property.id}" <c:if test="${property.writable}">name="fp_${property.id}" </c:if> <c:if test="${!property.writable}">readonly</c:if> class="form-control <c:if test="${property.required}">required</c:if>" />
									<c:forEach items="${result[enumKeyList]}" var="enums">
										<option value="${enums.key}" <c:if test="${property.value eq enums.key}">selected</c:if> >${enums.value}</option>
									</c:forEach>
									</select>
								</c:when>
								<c:otherwise>
									<input id="${property.id}" name="fp_${property.id}" type="text" value="${property.value}" <c:if test="${!property.writable}">readonly disabled</c:if> class="form-control <c:if test="${property.required}">required</c:if>" />
								</c:otherwise>
							</c:choose>
						</div>
					</div>
				</c:forEach>
			</form>
		</div>
	</div>

	<act:histoicFlow procInsId="${task.processInstanceId}" />

</div>
</body>


</html>
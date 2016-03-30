<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>新建模型 - 模型管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function(){
			top.$.jBox.tip.mess = null;
			$("#inputForm").validate({
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
	<ul class="nav nav-tabs">
		<li class="active"><a href="${ctx}/act/dynamic/completeForm?taskId=${task.id}">${task.name}</a></li>
	</ul><br/>
	<sys:message content="${message}"/>
	<form id="inputForm" action="${ctx}/act/dynamic/complete" method="post" class="form-horizontal">
		<input type="hidden" name="taskId" value="${task.id}"/>
		<c:forEach items="${list}" var="property">
			<c:set var="enumKeyList" value="enum_${property.id}"></c:set>

			<div class="control-group">
				<label class="control-label">${property.name} ${property.value} </label>
				<div class="controls">
					<c:choose>
						<c:when test="${property.type.name=='string' || property.type.name=='long'}">
							<input id="${property.id}" name="fp_${property.id}" value="${property.value}" type="text" <c:if test="${!property.writable}">readonly disabled</c:if> class="digits <c:if test="${property.required}">required</c:if>" />
						</c:when>
						<c:when test="${property.type.name=='enum'}">
							<select id="${property.id}" <c:if test="${property.writable}">name="fp_${property.id}" </c:if> <c:if test="${!property.writable}">readonly</c:if> class="<c:if test="${property.required}">required</c:if>" />
								<c:forEach items="${result[enumKeyList]}" var="enums">
									<option value="${enums.key}" <c:if test="${property.value eq enums.key}">selected</c:if> >${enums.value}</option>
								</c:forEach>
							</select>
						</c:when>
						<c:otherwise>
							<input id="${property.id}" name="fp_${property.id}" type="text" value="${property.value}" <c:if test="${!property.writable}">readonly disabled</c:if> class="<c:if test="${property.required}">required</c:if>" />
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</c:forEach>
		<div class="form-actions">
			<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>
			<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
		</div>
	</form>

	<act:histoicFlow procInsId="${task.processInstanceId}" />

</body>
</html>

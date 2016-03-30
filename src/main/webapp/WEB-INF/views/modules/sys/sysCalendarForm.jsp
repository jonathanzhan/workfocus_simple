<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>日历维护管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		$(document).ready(function() {
			//$("#name").workfocus();

			$("#isWorkday2").attr("checked",true);

//			$("#isWorkday2").on("change",function(){
//				alert($("#isWorkday2").val());
//			})

//			$("#isWorkday2").change(function(){
//
//					alert($("#isWorkday2").val());
//
//			})



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
	<%--<ul class="nav nav-tabs">--%>
		<%--<li><a href="${ctx}/sys/sysCalendar/">日历维护列表</a></li>--%>
		<%--<li class="active"><a href="${ctx}/sys/sysCalendar/form?id=${sysCalendar.id}">日历维护<shiro:hasPermission name="sys:sysCalendar:edit">${not empty sysCalendar.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:sysCalendar:edit">查看</shiro:lacksPermission></a></li>--%>
	<%--</ul><br/>--%>
	<form:form id="inputForm" modelAttribute="sysCalendar" action="${ctx}/sys/sysCalendar/save" method="post" class="form-horizontal">
		<form:hidden path="id"/>
		<sys:message content="${message}"/>
		<div class="control-group">
			<label class="control-label">日期：</label>
			<div class="controls">
				<input name="cdate" type="text" readonly="readonly" maxlength="20" class="input-medium Wdate required"
					value="<fmt:formatDate value="${sysCalendar.cdate}" pattern="yyyy-MM-dd"/>"
					onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">是否工作日：</label>
			<div class="controls">
				<form:radiobuttons path="isWorkday" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class=""/>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">日期类型：</label>
			<div class="controls">
				<form:select path="wkdaykNd" class="input-medium required">
					<form:option value="" label=""/>
					<form:options items="${fns:getDictList('WKDAYKND')}" itemLabel="label" itemValue="value" htmlEscape="false"/>
				</form:select>
				<span class="help-inline"><font color="red">*</font> </span>
			</div>
		</div>
		<%--<div class="form-actions">--%>
			<%--<shiro:hasPermission name="sys:sysCalendar:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>--%>
			<%--<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>--%>
		<%--</div>--%>
	</form:form>
</body>
</html>
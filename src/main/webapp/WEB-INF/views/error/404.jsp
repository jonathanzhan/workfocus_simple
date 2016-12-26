<%--<%--%>
<%--response.setStatus(404);--%>

<%--// 如果是异步请求或是手机端，则直接返回信息--%>
<%--if (Servlets.isAjaxRequest(request)) {--%>
	<%--out.print("页面不存在.");--%>
<%--}--%>

<%--//输出异常信息页面--%>
<%--else {--%>
<%--%>--%>
<%--<%@page import="com.mfnets.workfocus.common.web.Servlets"%>--%>
<%@page contentType="text/html;charset=UTF-8" isErrorPage="true"%>
<%--<%@include file="/WEB-INF/views/include/taglib.jsp"%>--%>
<!DOCTYPE html>
<html>
<head>
	<title>404 - 页面不存在</title>

</head>
<body>
	<div class="container-fluid">
		<div class="page-header"><h1>页面不存在.</h1></div>
		<div><a href="javascript:" onclick="history.go(-1);" class="btn">返回上一页</a></div>
		<div>${msg}</div>
		<div>${status}</div>
		<div>${timestamp}</div>

	</div>
</body>
</html>

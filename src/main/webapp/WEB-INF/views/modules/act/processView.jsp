<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>流程历史-详细页面</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">

	</script>
</head>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">


	<div class="ibox">
		<act:histoicFlow procInsId="${proInsId}" />

		<act:historicVariable procInsId="${proInsId}" />
	</div>

</div>
</body>


</html>
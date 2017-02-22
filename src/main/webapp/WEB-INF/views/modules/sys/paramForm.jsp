<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>系统参数</title>
    <%@include file="/WEB-INF/views/include/head.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#name").focus();
            $("#inputForm").validate({
                ignore: "",
                rules: {
                    paramName: {remote: "${ctx}/sys/param/checkParamName?oldName=" + encodeURIComponent("${params.name}")}
                },
                messages: {
                    paramName: {remote: "参数名已存在！"}
                },
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
<div class="wrapper wrapper-content">

    <div class="ibox">
        <div class="ibox-title">
            <a href="${ctx}/sys/param/form?name=${param.name}"><h5>系统参数编辑</h5></a>

            <div class="ibox-tools">
                <a href="${ctx}/sys/param/list" class="btn btn-primary btn-xs">返回系统参数列表</a>
            </div>
        </div>

        <div class="ibox-content">

            <form:form id="inputForm" modelAttribute="param" action="${ctx}/sys/param/save" method="post"
                       cssClass="form-horizontal">
                <form:hidden path="id"/>
                <sys:message content="${message}"/>
                <div class="form-group">
                    <label class="col-md-2 control-label">参数名:</label>
                    <div class="col-md-3">
                        <form:input path="name" htmlEscape="false" maxlength="20" class="form-control inline required"
                                    readonly="${not empty param.name?'true':'false'}"/>
                        <span class="required-wrapper">*</span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-2 control-label">参数值:</label>
                    <div class="col-md-3">
                        <form:input path="value" htmlEscape="false" maxlength="100" class="form-control inline required"/>
                        <span class="required-wrapper">*</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-2 control-label">标签名:</label>
                    <div class="col-md-3">
                        <form:input path="label" htmlEscape="false" maxlength="50" class="form-control inline required"/>
                        <span class="required-wrapper">*</span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-md-offset-2">
                        <shiro:hasPermission name="sys:param:edit">
                            <input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
                        </shiro:hasPermission>
                        <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
                    </div>

                </div>
            </form:form>
        </div>
    </div>

</div>


</body>

</html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>任务管理</title>
    <%@include file="/WEB-INF/views/include/head.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#value").focus();
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
<div class="wrapper wrapper-content">
    <div class="ibox">
        <div class="ibox-title">
            <a href="${ctx}/sys/scheduleJob/form?name=${scheduleJob.name}&group=${scheduleJob.group}&cronExpression=${scheduleJob.cronExpression}&className=${scheduleJob.className}&description=${scheduleJob.description}">
                <h5>任务编辑</h5></a>

            <div class="ibox-tools">
                <a href="${ctx}/sys/scheduleJob" class="btn btn-primary btn-xs">返回任务列表</a>
            </div>
        </div>
        <div class="ibox-content">
            <form:form id="inputForm" modelAttribute="scheduleJob" action="${ctx}/sys/scheduleJob/${actionUrl}"
                       method="post"
                       class="form-horizontal">
                <sys:message content="${message}"/>

                <div class="form-group">
                    <label class="col-md-2 control-label">任务名</label>
                    <div class="col-md-3">
                        <form:input path="name" htmlEscape="false" maxlength="100" class="form-control  required"
                                    readonly="${not empty scheduleJob.name and not empty scheduleJob.group?'true':'false'}"/>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-2 control-label">任务组</label>
                    <div class="col-md-3">
                        <form:input path="group" htmlEscape="false" maxlength="100" class="form-control required"
                                    readonly="${not empty scheduleJob.name and not empty scheduleJob.group?'true':'false'}"/>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-2 control-label">表达式</label>

                    <div class="col-md-3">
                        <form:input path="cronExpression" htmlEscape="false" maxlength="100"
                                    class="form-control required"/>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-2 control-label">任务类</label>

                    <div class="col-md-3">
                        <form:input path="className" htmlEscape="false" maxlength="250" class="form-control required"
                                    readonly="${not empty scheduleJob.name and not empty scheduleJob.group?'true':'false'}"/>
                    </div>
                </div>


                <div class="form-group">
                    <label class="col-md-2 control-label">描述</label>
                    <div class="col-md-3">
                        <form:input path="description" htmlEscape="false" maxlength="100" class="form-control"
                                    readonly="${not empty scheduleJob.name and not empty scheduleJob.group?'true':'false'}"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-md-offset-2">
                        <shiro:hasPermission name="sys:scheduleJob:edit">
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
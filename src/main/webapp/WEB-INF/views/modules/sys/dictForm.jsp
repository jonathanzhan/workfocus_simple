<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>字典管理</title>
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
            <a href="${ctx}/sys/dict/form?id=${dict.id}"><h5>数据字典编辑</h5></a>

            <div class="ibox-tools">
                <a href="${ctx}/sys/dict/list" class="btn btn-primary btn-xs">返回数据字典列表</a>
            </div>
        </div>

        <div class="ibox-content">

            <form:form id="inputForm" modelAttribute="dict" action="${ctx}/sys/dict/save" method="post"
                       cssClass="form-horizontal">
                <form:hidden path="id"/>
                <sys:message content="${message}"/>
                <div class="form-group">
                    <label class="col-md-2 control-label">键值</label>

                    <div class="col-md-3">
                        <form:input path="value" htmlEscape="false" maxlength="20" class="form-control inline required"/>
                        <span class="required-wrapper">*</span>
                    </div>
                </div>

                <div class="form-group">
                    <label class="col-md-2 control-label">标签</label>

                    <div class="col-md-3">
                        <form:input path="label" htmlEscape="false" maxlength="50"
                                    class="form-control inline required"/>
                        <span class="required-wrapper">*</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-2 control-label">类型</label>

                    <div class="col-md-3">
                        <form:input path="type" htmlEscape="false" maxlength="20" class="form-control inline required"/>
                        <span class="required-wrapper">*</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-2 control-label">描述</label>

                    <div class="col-md-3">
                        <form:input path="description" htmlEscape="false" maxlength="50"
                                    class="form-control inline required"/>
                        <span class="required-wrapper">*</span>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-2 control-label">排序</label>

                    <div class="col-md-3">
                        <form:input path="seq" htmlEscape="false" range="[0,100]"
                                    class="form-control inline required digits"/>
                        <span class="required-wrapper">*</span>
                    </div>
                </div>
                <div class="form-group">
                    <div class="col-md-offset-2">
                        <shiro:hasAnyPermissions name="sys:dict:add,sys:dict:edit">
                            <input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
                        </shiro:hasAnyPermissions>
                        <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
                    </div>

                </div>
            </form:form>
        </div>
    </div>

</div>


</body>


</html>
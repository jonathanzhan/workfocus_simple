<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>文件上传</title>
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
            <a href="${ctx}/demo/fileUpload"><h5>文件上传demo</h5></a>
        </div>

        <div class="ibox-content">

            <form:form id="inputForm" modelAttribute="fileUpload" action="${ctx}/demo/fileUpload/save" method="post"
                       class="form-horizontal" enctype="multipart/form-data">
                <form:hidden path="id"/>
                <sys:message content="${message}"/>
                <div class="form-group">
                    <label class="col-md-2 control-label">键值</label>

                    <div class="col-md-3">
                        <form:input path="name" htmlEscape="false" maxlength="20" class="form-control inline required"/>
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-md-2 control-label">文件</label>

                    <div class="col-md-3">
                        <input type="file" id="file" name="file" class="form-control required">
                        <%--<form:hidden path="file" htmlEscape="false" maxlength="20" class="form-control inline required"/>--%>
                    </div>
                </div>


                <div class="form-group">
                    <div class="col-md-offset-2">
                        <input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
                        <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
                    </div>

                </div>
            </form:form>
        </div>
    </div>

</div>


</body>


</html>
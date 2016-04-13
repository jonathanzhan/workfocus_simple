<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>员工管理</title>
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
            $("#name").focus();
            validateForm = $("#inputForm").validate({
                <%--rules: {--%>
                    <%--code: {remote: "${ctx}/sys/employee/checkEmployeeCd?oldEmployeeCd=" + encodeURIComponent("${employee.code}")}--%>
                <%--},--%>
                <%--messages: {--%>
                    <%--code: {remote: "员工编号已存在！"}--%>
                <%--},--%>
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
<form:form id="inputForm" modelAttribute="employee" action="${ctx}/sys/employee/save" method="post" class="form-horizontal">
    <form:hidden path="id"/>
    <sys:message content="${message}"/>
    <table class="table table-bordered table-condensed dataTable">
        <tbody>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">所属机构:</label>
            </td>
            <td class="col-xs-4">
                <sys:treeselect id="org" name="org.id" value="${employee.org.id}" labelName="org.name"
                                labelValue="${employee.org.name}"
                                title="机构" url="/sys/org/treeData" cssClass="form-control"
                                dataMsgRequired="请选择所属机构"/>
            </td>
            <td class="active col-xs-2">
                <label class="pull-right">员工编码:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="code" htmlEscape="false" maxlength="8" class="form-control inline required"/>
                <span class="required-wrapper">*</span>
            </td>
        </tr>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">中文名:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="name" htmlEscape="false" maxlength="20" class="form-control inline required"/>
                <span class="required-wrapper">*</span>
            </td>

            <td class="active col-xs-2">
                <label class="pull-right">英文名:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="eName" htmlEscape="false" maxlength="20" class="form-control inline required"/>
                <span class="required-wrapper">*</span>
            </td>

        </tr>
        <tr class="form-group">

        </tr>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">性别:</label>
            </td>
            <td class="col-xs-4">
                <form:radiobuttons path="sex" items="${fns:getDictList('sex')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
                <span class="required-wrapper">*</span>
            </td>
            <td class="active col-xs-2">
                <label class="pull-right">身份证:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="idCode" htmlEscape="false" maxlength="50" class="form-control"/>
            </td>

        </tr>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">联系电话:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="tel" htmlEscape="false" maxlength="50" class="form-control"/>
            </td>

            <td class="active col-xs-2">
                <label class="pull-right">出生年月:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="birthday" htmlEscape="false" maxlength="50" class="form-control"/>
            </td>
        </tr>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">QQ:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="qq" htmlEscape="false" maxlength="50" class="form-control"/>
            </td>

            <td class="active col-xs-2">
                <label class="pull-right">email:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="email" htmlEscape="false" maxlength="50" class="form-control email"/>
            </td>
        </tr>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">学历:</label>
            </td>
            <td class="col-xs-4">
                <form:select path="education" items="${fns:getDictList('education')}" itemLabel="label" itemValue="value" htmlEscape="false" cssClass="form-control"/>
            </td>

            <td class="active col-xs-2">
                <label class="pull-right">是否开通系统:</label>
            </td>
            <td class="col-xs-4">
                <form:radiobuttons path="isOpen" items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value" htmlEscape="false" class="required"/>
            </td>
        </tr>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">地址:</label>
            </td>
            <td class="col-xs-10" colspan="3">
                <form:textarea path="address" htmlEscape="false" rows="2" maxlength="200"  class="form-control" cssStyle="width: 98%"/>
            </td>
        </tr>

        </tbody>
    </table>
</form:form>

</body>
</html>
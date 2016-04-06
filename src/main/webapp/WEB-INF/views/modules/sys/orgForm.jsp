<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>机构管理</title>
    <%@include file="/WEB-INF/views/include/head.jsp" %>
    <%@include file="/WEB-INF/views/include/treetable.jsp" %>
    <script type="text/javascript">
        function doAlert(){
            alert("orgForm");
        }
        var validateForm;
        function doSubmit() {//回调函数，在编辑和保存动作时，供openDialog调用提交表单。
            if (validateForm.form()) {
                alert("before");
                $("#inputForm").submit();
                alert("dassda");
                return true;
            }
            return false;
        }

        $(document).ready(function () {
            $("#name").focus();
            validateForm = $("#inputForm").validate({
                submitHandler: function (form) {
                    layer.load();
                    form.submit();
                    alert("submit");
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

<form:form id="inputForm" modelAttribute="org" action="${ctx}/sys/org/save" method="post" class="form-horizontal">
    <form:hidden path="id"/>
    <sys:message content="${message}"/>
    <table class="table table-bordered table-condensed dataTable">
        <tbody>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">上级机构:</label>
            </td>
            <td class="col-xs-4">
                <sys:treeselect id="parent" name="parent.id" value="${org.parent.id}" labelName="parent.name"
                                labelValue="${org.parent.name}"
                                title="机构" url="/sys/org/treeData" extId="${org.id}" cssClass="form-control required"
                                allowClear="true" dataMsgRequired="请选择上级机构"/>
            </td>
            <td class="active col-xs-2">
                <label class="pull-right"><font color="red">*</font>机构名称:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="name" htmlEscape="false" maxlength="30" class="form-control inline required"/>
                <span class="required-wrapper">*</span>
            </td>
        </tr>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">机构编码:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="code" htmlEscape="false" maxlength="8" class="form-control inline required"/>
            </td>
            <td class="active col-xs-2">
                <label class="pull-right">机构类型:</label>
            </td>
            <td class="col-xs-4">
                <form:select path="type" class="form-control inline required">
                    <form:options items="${fns:getDictList('org_type')}" itemLabel="label"
                                  itemValue="value" htmlEscape="false"/>
                </form:select>
                <span class="required-wrapper">*</span>
            </td>
        </tr>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">排序:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="sort" htmlEscape="false" range="[1,100]" class="form-control inline required digits"/>
            </td>
            <td class="active col-xs-2">
                <label class="pull-right">负责人:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="master" htmlEscape="false" maxlength="20" class="form-control inline required"/>
                <span class="required-wrapper">*</span>
            </td>
        </tr>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">联系电话:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="phone" htmlEscape="false" maxlength="20" class="form-control inline required"/>
            </td>
            <td class="active col-xs-2">
                <label class="pull-right">地址:</label>
            </td>
            <td class="col-xs-4">
                <form:input path="address" htmlEscape="false" maxlength="50" class="form-control"/>
            </td>
        </tr>
        <tr class="form-group">
            <td class="active col-xs-2">
                <label class="pull-right">备注:</label>
            </td>
            <td class="col-xs-10" colspan="3">
                <button type="button" onclick="doSubmit()"> ssdsa</button>
                <%--<form:textarea path="remarks" htmlEscape="false" rows="2" maxlength="200"  class="form-control" cssStyle="width: 98%"/>--%>
            </td>
        </tr>

        </tbody>
    </table>
</form:form>
</body>
</html>
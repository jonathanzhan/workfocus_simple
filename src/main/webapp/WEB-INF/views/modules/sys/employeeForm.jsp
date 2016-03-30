<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>员工管理</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#value").workfocus();
            $("#inputForm").validate({
                ignore:"#parentName",
                rules: {
                    employeeCd: {remote: "${ctx}/sys/employee/checkEmployeeCd?oldEmployeeCd=" + encodeURIComponent("${employee.employeeCd}")}

                },
                messages: {
                    employeeCd: {remote: "员工编号已存在！"},
                    idCode:{card:"请输入正确的身份证号！"},
                    qq:{qq:"请输入正确的qq！"},
                    email:{email:"请输入正确的电子邮箱！"},
                    tel:{phone:"请输入正确的联系电话！"}
                },
                submitHandler: function (form) {
                    layer.load();
                    form.submit();
                },
                highlight: function (e) {
                    $(e).closest('.row-group').removeClass('has-success').addClass('has-error');
                },
                unhighlight: function(e) {
                    $(e).closest('.row-group').removeClass('has-error').addClass('has-success');

                },
                invalidHandler: function (form, validator) {
                    var msg = new $.zui.Messager('<i class="icon-exclamation-sign"></i>信息填写不完整', {type :'danger'});
                    var errors = validator.numberOfInvalids();
                    if (errors) {
                        msg.show();
                    }else{
                        msg.hide();
                    }
                },
                errorPlacement: function (error, element) {
                    if(element.is(".layerBox")){
                        error.appendTo(element.parent().parent());
                    }
                    else if (element.is(":checkbox") || element.is(":radio")) {
                        error.appendTo(element.parent().parent());
                    } else {
                        error.insertAfter(element);
                    }
                }
            });
            $.validator.addMethod("cardNo",function(value,element){
                var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
                return this.optional(element) || (reg.test(value));
            },"<font color='#E47068'>身份证号错误</font>");
        });
        function isCardNo(card)
        {
            // 身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X
            var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
            if(reg.test(card) === false)
            {
                alert("身份证输入不合法");
                return  false;
            }
            return true;
        }
    </script>
    <style>

    </style>
</head>
<body>
<div class="panel" id="mainPanel">
    <div class="panel-heading">
        <ul class="nav nav-tabs">
            <li><a href="${ctx}/sys/employee/">员工列表</a></li>
            <li class="active"><a href="${ctx}/sys/employee/form?id=${employee.id}">员工<shiro:hasPermission
                    name="sys:employee:edit">${not empty employee.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission
                    name="sys:employee:edit">查看</shiro:lacksPermission></a></li>
        </ul>
    </div>

    <%--<div class="messager-content"><i class="icon-exclamation-sign"></i>提示消息：危险</div>--%>
    <div class="panel-body">
        <div class="tab-content col-md-12">
            <form:form id="inputForm" modelAttribute="employee" action="${ctx}/sys/employee/save" method="post" class="form-horizontal">
                <form:hidden path="id"/>

                <div class="form-group">
                    <div class="row-group">
                        <label class="col-md-1 control-label">部门</label>
                        <div class="col-md-3">
                                <%--弹出层如果有验证的话 class = layerBox 必填--%>
                            <sys:treeselect id="parent" name="org.id" value="${employee.org.id}" labelName="org.orgNm" labelValue="${employee.org.orgNm}"
                                            title="部门" url="/sys/org/treeData"  allowClear="true" cssClass="form-control required layerBox"/>
                        </div>
                            <%--红色*--%>
                        <div class="required-wrapper"></div>
                    </div>




                        <div class="row-group">
                        <label class="col-md-1 control-label">员工编号</label>
                        <div class="col-md-3">
                            <form:input path="employeeCd" htmlEscape="false" maxlength="50" class="form-control required"/>
                        </div>
                        <div class="required-wrapper"></div>
                        </div>

                </div>

                <div class="form-group">
                    <div class="row-group">
                        <label class="col-md-1 control-label">中文名称</label>
                        <div class="col-md-3">
                            <form:input path="employeeCnm" htmlEscape="false" maxlength="50" class="form-control required"/>
                        </div>
                        <div class="required-wrapper"></div>
                    </div>

                    <div class="row-group">
                        <label class="col-md-1 control-label requiredLabel">英文名称</label>
                        <div class="col-md-3">
                            <form:input path="employeeEnm" htmlEscape="false" maxlength="64" class="form-control required"/>
                        </div>
                        <div class="required-wrapper"></div>
                    </div>
                </div>


                <div class="form-group">
                    <div class="row-group">
                        <label class="col-md-1 control-label">性别</label>
                        <div class="col-md-3 ">
                                <%--radio的写法--%>
                            <div class="input-append ">
                                <c:forEach items="${fns:getDictList('sex')}" var="dict">
                                    <label class="radio-inline">
                                        <input type="radio" name="sex" id="sex" class="required" value="${dict.value}" <c:if test="${dict.value==employee.sex}">checked</c:if>> ${dict.label}
                                    </label>
                                </c:forEach>
                                <div class="inline-required"></div>
                            </div>
                        </div>
                    </div>

                    <div class="row-group">
                        <label class="col-md-1 control-label">出生日期</label>
                        <div class="col-md-3">
                            <input name="birthday" type="text" readonly="readonly" maxlength="20" class="form-control"
                                   value="<fmt:formatDate value="${employee.birthday}" pattern="yyyy-MM-dd"/>"
                                   onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>
                        </div>
                        <div class="required-wrapper"></div>
                    </div>
                </div>

                <div class="form-group">
                    <div class="row-group">
                        <label class="col-md-1 control-label">身份证号</label>
                        <div class="col-md-3">
                            <form:input path="idCode" htmlEscape="false" maxlength="18" class="form-control cardNo"/>
                        </div>
                        <div class="required-wrapper"></div>
                    </div>

                    <%--<div class="row-group">--%>
                        <%--<label class="col-md-1 control-label">学历</label>--%>
                        <%--<div class="col-md-3">--%>
                            <%--<form:select path="education" class="form-control">--%>
                                <%--<form:options items="${fns:getDictList('education')}" itemLabel="paramName" itemValue="paramValue" htmlEscape="false"/>--%>
                            <%--</form:select>--%>
                        <%--</div>--%>
                    <%--</div>--%>

                </div>

                <div class="form-group">
                    <div class="row-group">
                        <label class="col-md-1 control-label">爱好</label>
                        <div class="col-md-3">
                            <form:input path="hobbies" htmlEscape="false" maxlength="50" cssClass="form-control"/>
                        </div>
                    </div>
                        <div class="row-group">
                        <label class="col-md-1 control-label">岗位</label>
                        <div class="col-md-3">
                        <form:select path="job.id" class="form-control">
                        <form:options items="${fns:getJobList()}" itemLabel="jobName" itemValue="id" htmlEscape="false"/>
                        </form:select>
                        </div>
                        <div class="required-wrapper"></div>
                        </div>

                </div>

                <div class="form-group">
                    <div class="row-group">
                        <label class="col-md-1 control-label">电子邮箱</label>
                        <div class="col-md-3">
                            <form:input path="email" class="email" htmlEscape="false" maxlength="50" cssClass="form-control"/>
                        </div>
                    </div>

                    <div class="row-group">
                        <label class="col-md-1 control-label">联系电话</label>
                        <div class="col-md-3">
                            <form:input path="tel" class="phone" htmlEscape="false" maxlength="25" cssClass="form-control"/>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <div class="row-group">
                        <label class="col-md-1 control-label">QQ</label>
                        <div class="col-md-3">
                            <form:input path="qq" htmlEscape="false" maxlength="20" cssClass="form-control qq"/>
                        </div>
                    </div>
                    <div class="row-group">
                        <label class="col-md-1 control-label">联系地址</label>
                        <div class="col-md-3">
                            <form:input path="address" htmlEscape="false" maxlength="100" cssClass="form-control"/>
                        </div>
                    </div>


                </div>
                <div class="form-group">
                    <div class="row-group">
                        <label class="col-md-1 control-label">是否开通帐号</label>
                        <div class="col-md-3">
                            <div class="input-append">
                                <%--<c:forEach items="${fns:getDictList('yes_no')}" var="dict">--%>
                                    <%--<label class="radio-inline">--%>
                                        <%--<input type="radio" name="isOpenSys" id="isOpenSys" class="required"  value="${dict.paramValue}" <c:if test="${dict.paramValue==employee.isOpenSys}">checked </c:if>> ${dict.paramName}--%>
                                    <%--</label>--%>

                                <%--</c:forEach>--%>
                                <div class="inline-required"></div>
                            </div>
                        </div>
                    </div>
                </div>


                <%--<div class="form-group">--%>
                <%--<label class="col-md-1 control-label">照片</label>--%>
                <%--<div class="col-md-3">--%>
                <%--<form:hidden id="nameImage" path="photo" htmlEscape="false" maxlength="255" class="input-xlarge"/>--%>
                <%--<sys:ckfinder input="nameImage" type="images" uploadPath="/photo" selectMultiple="false" maxWidth="100" maxHeight="100"/>--%>
                <%--</div>--%>
                <%--</div>--%>


                <div class="form-group">
                    <div class="col-md-offset-2">
                        <shiro:hasPermission name="sys:employee:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
                        <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
                    </div>

                </div>

            </form:form>
        </div>
    </div>
</div>
</body>
</html>
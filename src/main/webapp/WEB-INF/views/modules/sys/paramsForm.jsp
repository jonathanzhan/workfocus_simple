<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
  <title>系统参数</title>
  <meta name="decorator" content="default"/>
  <script type="text/javascript">
    $(document).ready(function() {
      $("#name").workfocus();
      $("#inputForm").validate({
           ignore:"",
           rules: {
           paramName: {remote: "${ctx}/sys/params/checkParamName?oldParamName=" + encodeURIComponent("${params.paramName}")}
           },
           messages: {
           paramName: {remote: "参数名已存在！"}
           },
        submitHandler: function(form){
          loading('正在提交，请稍等...');
          form.submit();
        },
        highlight: function (e) {
          $(e).closest('.form-group').removeClass('has-success').addClass('has-error');
        },
        unhighlight: function(e) {
          $(e).closest('.form-group').removeClass('has-error').addClass('has-success');

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
          error.appendTo(element.parent().parent());
        }
      });
    });
  </script>
</head>
<body>
<div class="panel" id="mainPanel">
    <div class="panel-heading">
        <ul class="nav nav-tabs">
            <li><a href="${ctx}/sys/params/">系统参数列表</a></li>
            <li class="active"><a href="form?paramName=${params.paramName}">系统参数<shiro:hasPermission name="sys:params:edit">${not empty params.paramName?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:params:edit">查看</shiro:lacksPermission></a></li>
        </ul>
    </div>
  </div>

    <div class="panel-body">
        <div class="tab-content col-md-12">
            <form:form id="inputForm" modelAttribute="params" action="${ctx}/sys/params/save" method="post" class="form-horizontal">
                <sys:message content="${message}"/>

                <div class="form-group">
                    <label class="col-md-2 control-label">参数名:</label>
                    <div class="col-md-3">
                        <form:input path="paramName" htmlEscape="false" maxlength="8" class="form-control required"
                                    readonly="${not empty params.paramName?'true':'false'}"/>
                    </div>
                    <div class="required-wrapper"></div>
                </div>
                <div class="form-group">
                    <label class="col-md-2 control-label">参数值:</label>
                    <div class="col-md-3">
                      <form:input path="paramValue" htmlEscape="false" maxlength="128" class="form-control required" />
                    </div>
                    <div class="required-wrapper"></div>
                </div>
                <div class="form-group">
                    <label class="col-md-2 control-label">标签名:</label>
                    <div class="col-md-3">
                      <form:input path="paramLabel" htmlEscape="false" maxlength="64" class="form-control"/>
                    </div>
                </div>

                <div class="form-group">
                    <div class="col-md-offset-2">
                        <shiro:hasPermission name="sys:params:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
                        <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
                    </div>
                </div>

            </form:form>
  </div>
</div>


</div>
</body>
</html>
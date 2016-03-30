<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
  <title>任务管理</title>
  <meta name="decorator" content="default"/>
  <script type="text/javascript">
    $(document).ready(function () {
      $("#value").workfocus();
      $("#inputForm").validate({
        submitHandler: function (form) {
          loading('正在提交，请稍等...');
          form.submit();
        },
        errorContainer: "#messageBox",
        errorPlacement: function (error, element) {
          $("#messageBox").text("输入有误，请先更正。");
          if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-append")) {
            error.appendTo(element.parent().parent());
          } else {
            error.insertAfter(element);
          }
        }
      });
    });
  </script>
</head>
<body>
<ul class="nav nav-tabs">
  <li><a href="${ctx}/sys/scheduleJob/">任务列表</a></li>
  <li class="active">
    <a href="${ctx}/sys/scheduleJob/form?name=${scheduleJob.name}&group=${scheduleJob.group}&cronExpression=${scheduleJob.cronExpression}&className=${scheduleJob.className}&description=${scheduleJob.description}">
      任务<shiro:hasPermission
            name="sys:scheduleJob:edit">${not empty scheduleJob.name and not empty scheduleJob.group?'修改':'添加'}</shiro:hasPermission>
    </a>
  </li>
</ul>
<br/>
<form:form id="inputForm" modelAttribute="scheduleJob" action="${ctx}/sys/scheduleJob/${actionUrl}" method="post"
           class="form-horizontal">
  <sys:message content="${message}"/>
  <div class="control-group">
    <label class="control-label">任务名:</label>

    <div class="controls">
      <form:input path="name" htmlEscape="false" maxlength="100" class="input-xlarge required"
                  readonly="${not empty scheduleJob.name and not empty scheduleJob.group?'true':'false'}"/>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">任务组:</label>

    <div class="controls">
      <form:input path="group" htmlEscape="false" maxlength="100" class="input-xlarge required"
                  readonly="${not empty scheduleJob.name and not empty scheduleJob.group?'true':'false'}"/>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label">表达式:</label>

    <div class="controls">
      <form:input path="cronExpression" htmlEscape="false" maxlength="100" class="input-xlarge required"/>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label">任务类:</label>

    <div class="controls">
      <form:input path="className" htmlEscape="false" maxlength="250" class="input-xlarge required"
                  readonly="${not empty scheduleJob.name and not empty scheduleJob.group?'true':'false'}"/>
    </div>
  </div>


  <div class="control-group">
    <label class="control-label">描述:</label>

    <div class="controls">
      <form:input path="description" htmlEscape="false" maxlength="100" class="input-xlarge"
                  readonly="${not empty scheduleJob.name and not empty scheduleJob.group?'true':'false'}"/>
    </div>
  </div>
  <div class="form-actions">
    <shiro:hasPermission name="sys:scheduleJob:edit"><input id="btnSubmit" class="btn btn-primary" type="submit"
                                                            value="保 存"/>&nbsp;</shiro:hasPermission>
    <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
  </div>
</form:form>
</body>
</html>
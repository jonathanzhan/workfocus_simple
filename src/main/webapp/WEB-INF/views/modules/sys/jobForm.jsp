<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
  <title>岗位管理</title>
  <meta name="decorator" content="default"/>
  <script type="text/javascript">
    $(document).ready(function() {
      $("#value").workfocus();
      $("#inputForm").validate({
        rules: {
          jobName: {remote: "${ctx}/sys/job/checkName?oldName=" + encodeURIComponent("${job.jobName}")}
        },
        messages: {
          jobName: {remote: "岗位名已存在"}
        },
        ignore:"",
        submitHandler: function(form){
          loading('正在提交，请稍等...');
          form.submit();
        },
        errorContainer: "#messageBox",
        errorPlacement: function(error, element) {
          $("#messageBox").text("输入有误，请先更正。");
          if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
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
<div class="panel" id="mainPanel">
  <div class="panel-heading">
    <ul class="nav nav-tabs">
      <li><a href="${ctx}/sys/job/">岗位列表</a></li>
      <li class="active"><a href="${ctx}/sys/job/form?id=${job.id}">岗位<shiro:hasPermission name="sys:job:edit">${not empty job.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="sys:job:edit">查看</shiro:lacksPermission></a></li>
    </ul><br/>
  </div>
  <div class="panel-body">
    <div class="tab-content col-md-12">
<form:form id="inputForm" modelAttribute="job" action="${ctx}/sys/job/save" method="post" class="form-horizontal">
  <form:hidden path="id"/>
  <sys:message content="${message}"/>
  <div class="form-group">
    <div class="row-group">
      <label class="col-md-1 control-label">角色:</label>
      <div class="col-md-3">
        <form:select path="role.id" class="form-control required layerBox">
          <form:option value="" label="请选择"/>
          <form:options items="${fns:getRoleList()}" itemLabel="roleName" itemValue="id" htmlEscape="false"/>
        </form:select>
      </div>
    </div>
    <div class="required-wrapper"></div>
  </div>

  <div class="form-group">
    <div class="row-group">
      <label class="col-md-1 control-label">岗位名称:</label>
      <div class="col-md-3">
        <input id="oldName" name="oldName" type="hidden" value="${job.jobName}" >
        <form:input path="jobName" htmlEscape="false" maxlength="50" class="form-control required layerBox"/>
      </div>
      </div>
    <div class="required-wrapper"></div>
  </div>

  <div class="form-group">
    <div class="row-group">
      <label class="col-md-1 control-label">岗位说明:</label>
      <div class="col-md-3">
        <form:input path="jobCommend" htmlEscape="false" maxlength="100" class="form-control required layerBox"/>
      </div>
    </div>
    <div class="required-wrapper"></div>
  </div>
  <div class="form-group">
    <div class="col-md-offset-2">
      <shiro:hasPermission name="sys:job:edit"><input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;</shiro:hasPermission>
      <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
    </div>
  </div>
  </div>
</form:form>
      </div>
    </div>
  </div>
</body>
</html>
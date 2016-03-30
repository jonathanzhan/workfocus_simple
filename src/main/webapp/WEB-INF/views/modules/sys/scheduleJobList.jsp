<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
  <title>任务管理</title>
  <meta name="decorator" content="default"/>
  <script type="text/javascript">

  </script>
</head>
<body>
<ul class="nav nav-tabs">
  <li class="active"><a href="${ctx}/sys/scheduleJob/">任务列表</a></li>
  <shiro:hasPermission name="sys:scheduleJob:edit"><li><a href="${ctx}/sys/scheduleJob/form">任务添加</a></li></shiro:hasPermission>
</ul>
<form:form id="searchForm" modelAttribute="scheduleJob" action="${ctx}/sys/scheduleJob/" method="post" class="breadcrumb form-search">
  <label>类型：</label>
  <form:select path="status" class="input-medium">
    <form:option value="" label=""/>
    <form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value"/>
  </form:select>&nbsp;&nbsp;
  <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
</form:form>
<sys:message content="${message}"/>
<table id="contentTable" class="table table-striped table-bordered table-condensed">
  <thead><tr><th>任务名称</th><th>任务组</th><th>cron表达式</th><th>状态</th><th>任务类</th><th>描述</th><shiro:hasPermission name="sys:scheduleJob:edit"><th>操作</th></shiro:hasPermission></tr></thead>
  <tbody>
  <c:forEach items="${list}" var="scheduleJob">
    <tr>
      <td>${scheduleJob.name}</td>
      <td>${scheduleJob.group}</td>
      <td>${scheduleJob.cronExpression}</td>
      <td>${scheduleJob.status}</td>
      <td>${scheduleJob.className}</td>
      <td>${scheduleJob.description}</td>
      <shiro:hasPermission name="sys:scheduleJob:edit"><td>
        <a href="${ctx}/sys/scheduleJob/form?name=${scheduleJob.name}&group=${scheduleJob.group}&cronExpression=${scheduleJob.cronExpression}&className=${scheduleJob.className}&description=${scheduleJob.description}">修改</a>
        <a href="${ctx}/sys/scheduleJob/${scheduleJob.name}/${scheduleJob.group}/stop" onclick="return confirmx('确认要暂停该任务吗？', this.href)">暂停</a>
        <a href="${ctx}/sys/scheduleJob/${scheduleJob.name}/${scheduleJob.group}/resume" onclick="return confirmx('确认要恢复该任务吗？', this.href)">恢复</a>
        <a href="${ctx}/sys/scheduleJob/${scheduleJob.name}/${scheduleJob.group}/startNow" onclick="return confirmx('确认要运行该任务吗？', this.href)">运行一次</a>
        <a href="${ctx}/sys/scheduleJob/${scheduleJob.name}/${scheduleJob.group}/delete" onclick="return confirmx('确认要删除该任务吗？', this.href)">删除</a>
      </td></shiro:hasPermission>
    </tr>
  </c:forEach>
  </tbody>
</table>
</body>
</html>
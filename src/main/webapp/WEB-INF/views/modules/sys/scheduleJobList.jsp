<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>任务管理</title>
    <%@include file="/WEB-INF/views/include/head.jsp" %>
</head>

<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="ibox m-b-sm border-bottom">
        <div class="ibox-title">
            <a href="${ctx}/sys/scheduleJob/"><h5>任务列表</h5></a></li>
            <shiro:hasPermission name="sys:scheduleJob:edit">
                <div class="ibox-tools">
                    <a href="${ctx}/sys/scheduleJob/form" class="btn btn-primary btn-xs">任务添加</a>
                </div>
            </shiro:hasPermission>
        </div>
        <%--<div class="ibox-content">--%>
            <%--<form:form id="searchForm" modelAttribute="scheduleJob" action="${ctx}/sys/scheduleJob/" method="post"--%>
                       <%--class="form-horizontal">--%>
                <%--<div class="form-group">--%>
                    <%--<label class="col-md-1 control-label">类型</label>--%>
                    <%--<div class="col-md-2">--%>
                        <%--<form:select path="status" class="form-control">--%>
                            <%--<form:option value="">请选择</form:option>--%>
                            <%--<form:options items="${fns:getDictList('yes_no')}" itemLabel="label" itemValue="value"/>--%>
                        <%--</form:select>--%>
                    <%--</div>--%>

                    <%--<div class="col-md-1">--%>
                        <%--<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</form:form>--%>
        <%--</div>--%>
    <%--</div>--%>
    <sys:message content="${message}"/>
    <%--<div class="ibox">--%>
        <div class="ibox-content">
            <table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTable">
                <thead>
                <tr>
                    <th>任务名称</th>
                    <th>任务组</th>
                    <th>cron表达式</th>
                    <th>状态</th>
                    <th>任务类</th>
                    <th>描述</th>
                    <shiro:hasPermission name="sys:scheduleJob:edit">
                        <th>操作</th>
                    </shiro:hasPermission>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${list}" var="scheduleJob">
                    <tr>
                        <td>${scheduleJob.name}</td>
                        <td>${scheduleJob.group}</td>
                        <td>${scheduleJob.cronExpression}</td>
                        <td>${scheduleJob.status}</td>
                        <td>${scheduleJob.className}</td>
                        <td>${scheduleJob.description}</td>
                        <shiro:hasPermission name="sys:scheduleJob:edit">
                            <td>
                                <a href="${ctx}/sys/scheduleJob/form?name=${scheduleJob.name}&group=${scheduleJob.group}&cronExpression=${scheduleJob.cronExpression}&className=${scheduleJob.className}&description=${scheduleJob.description}">修改</a>
                                <a href="${ctx}/sys/scheduleJob/${scheduleJob.name}/${scheduleJob.group}/stop"
                                   onclick="return confirmx('确认要暂停该任务吗？', this.href)">暂停</a>
                                <a href="${ctx}/sys/scheduleJob/${scheduleJob.name}/${scheduleJob.group}/resume"
                                   onclick="return confirmx('确认要恢复该任务吗？', this.href)">恢复</a>
                                <a href="${ctx}/sys/scheduleJob/${scheduleJob.name}/${scheduleJob.group}/startNow"
                                   onclick="return confirmx('确认要运行该任务吗？', this.href)">运行一次</a>
                                <a href="${ctx}/sys/scheduleJob/${scheduleJob.name}/${scheduleJob.group}/delete"
                                   onclick="return confirmx('确认要删除该任务吗？', this.href)">删除</a>
                            </td>
                        </shiro:hasPermission>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div>
                ${page.html}
            </div>
        </div>
    </div>
</div>
</body>
</html>
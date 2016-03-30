<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>岗位管理</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        $(document).ready(function () {

        });
        function page(n, s) {
            if (n) $("#pageNo").val(n);
            if (s) $("#pageSize").val(s);
            $("#searchForm").attr("action", "${ctx}/sys/job/list");
            $("#searchForm").submit();
            return false;
        }
    </script>
</head>
<body>
<div class="panel" id="mainPanel">
    <div class="panel-heading">
        <ul class="nav nav-tabs">
            <li class="active"><a href="${ctx}/sys/job/list">岗位列表</a></li>
            <shiro:hasPermission name="sys:job:edit">
                <li><a href="${ctx}/sys/job/form">岗位添加</a></li>
            </shiro:hasPermission>
        </ul>
    </div>
    <div class="panel-body">
        <form:form id="searchForm" modelAttribute="job" action="${ctx}/sys/job/list" method="post"
                   cssClass="form-horizontal">
            <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
            <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
            <sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>
            <div class="form-group">
                <label class="col-md-1 control-label">角色：</label>
                <div class="col-md-2">
                    <form:select path="role.id" class="form-control">
                        <form:option value="" label="请选择"/>
                        <form:options items="${fns:getRoleList()}" itemLabel="roleName" itemValue="id" htmlEscape="false"/>
                    </form:select>
                </div>
                <label class="col-md-1 control-label">岗位名称：</label>
                <div class="col-md-2">
                    <form:input path="jobName" htmlEscape="false" maxlength="50" class="form-control"/>
                </div>
                    <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询" onclick="return page();"/>
            </div>
        </form:form>
        <sys:message content="${message}"/>
        <table id="contentTable" class="table table-striped table-bordered table-condensed">
            <thead>
            <tr>
                <th style="text-align:center;vertical-align:middle;" >编号</th>
                <th style="text-align:center;vertical-align:middle;" >岗位名称</th>
                <th style="text-align:center;vertical-align:middle;" >角色</th>
                <th style="text-align:center;vertical-align:middle;" >说明</th>
                <shiro:hasPermission name="sys:job:edit">
                    <th style="text-align:center;vertical-align:middle;" >操作</th>
                </shiro:hasPermission>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${page.list}" var="job" varStatus="st">
                <tr>
                    <td>${st.count}</td>
                    <td><a href="${ctx}/sys/job/form?id=${job.id}">${job.jobName}</a></td>
                    <td>${job.role.roleName}</td>
                    <td>${job.jobCommend}</td>
                    <shiro:hasPermission name="sys:job:edit">
                        <td>
                            <a href="${ctx}/sys/job/form?id=${job.id}">修改</a>
                            <a href="${ctx}/sys/job/delete?id=${job.id}"
                               onclick="return confirmx('确认要删除该岗位吗？', this.href)">删除</a>
                        </td>
                    </shiro:hasPermission>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <div class="pagination">${page}</div>

    </div>

</body>
</html>
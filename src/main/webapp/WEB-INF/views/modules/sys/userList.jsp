<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>用户管理</title>
    <meta name="decorator" content="default"/>
    <script type="text/javascript">
        <%--$(document).ready(function() {--%>
        <%--$("#btnExport").click(function(){--%>
        <%--top.$.jBox.confirm("确认要导出用户数据吗？","系统提示",function(v,h,f){--%>
        <%--if(v=="ok"){--%>
        <%--$("#searchForm").attr("action","${ctx}/sys/user/export");--%>
        <%--$("#searchForm").submit();--%>
        <%--}--%>
        <%--},{buttonsFocus:1});--%>
        <%--top.$('.jbox-body .jbox-icon').css('top','55px');--%>
        <%--});--%>
        <%--$("#btnImport").click(function(){--%>
        <%--$.jBox($("#importBox").html(), {title:"导入数据", buttons:{"关闭":true}, --%>
        <%--bottomText:"导入文件不能超过5M，仅允许导入“xls”或“xlsx”格式文件！"});--%>
        <%--});--%>
        <%--});--%>
        function page(n, s) {
            if (n) $("#pageNo").val(n);
            if (s) $("#pageSize").val(s);
            $("#searchForm").attr("action", "${ctx}/sys/user/list");
            $("#searchForm").submit();
            return false;
        }
    </script>
</head>
<body>
<%--<div id="importBox" class="hide">--%>
    <%--<form id="importForm" action="${ctx}/sys/user/import" method="post" enctype="multipart/form-data"--%>
          <%--class="form-search" style="padding-left:20px;text-align:center;" onsubmit="loading('正在导入，请稍等...');"><br/>--%>
        <%--<input id="uploadFile" name="file" type="file" style="width:330px"/><br/><br/>　　--%>
        <%--<input id="btnImportSubmit" class="btn btn-primary" type="submit" value="   导    入   "/>--%>
        <%--<a href="${ctx}/sys/user/import/template">下载模板</a>--%>
    <%--</form>--%>
<%--</div>--%>
<div class="panel" id="mainPanel">
    <div class="panel-heading">
        <ul class="nav nav-tabs">
            <li class="active"><a href="${ctx}/sys/user/list">用户列表</a></li>
            <shiro:hasPermission name="sys:user:edit">
                <li><a href="${ctx}/sys/user/form">用户添加</a></li>
            </shiro:hasPermission>
        </ul>
    </div>
    <div class="panel-body">
        <div class="tab-content col-md-12">
            <form:form id="searchForm" modelAttribute="user" action="${ctx}/sys/user/list" method="post"
                       cssClass="form-horizontal">
                <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
                <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
                <sys:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="page();"/>
                  <div class="form-group">
                      <label class="col-md-1 control-label">登录名：</label>
                      <div class="col-md-2">
                        <form:input path="userName" class="form-control"/>
                      </div>

                      <label class="col-md-1 control-label">用户名称：</label>
                      <div class="col-md-2">
                        <form:input path="name" class="form-control"/>
                      </div>
                        <%--<li>--%>
                        <%--<label>用户类型：</label>--%>
                        <%--<form:select path="userType" class="input-large">--%>
                        <%--<form:option value="" label="请选择"/>--%>
                        <%--<form:options items="${fns:getDictList('sys_user_type')}" itemLabel="label" itemValue="value" htmlEscape="false"/>--%>
                        <%--</form:select>--%>
                        <%--</li>--%>
                    <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"
                                            onclick="return page();"/>
                            <%--<input id="btnExport" class="btn btn-primary" type="button" value="导出"/>--%>
                            <%--<input id="btnImport" class="btn btn-primary" type="button" value="导入"/></li>--%>
                  </div>
            </form:form>
            <table id="contentTable" class="table table-striped table-bordered table-condensed">
                <thead>
                <tr>
                    <th>编号</th>
                    <th class="sort-column user_name">登录名</th>
                    <th class="sort-column name">用户名称</th>
                    <%--<th>员工编号</th>--%>
                    <%--<th>中文名称</th>--%>
                    <%--<th>英文名称</th>--%>
                    <%--<th>部门</th>--%>
                    <%--<th>岗位</th>--%>
                    <th>用户类型</th>
                    <shiro:hasPermission name="sys:user:edit">
                        <th>操作</th>
                    </shiro:hasPermission></tr>
                </thead>
                <tbody>
                <c:forEach items="${page.list}" var="user" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td><a href="${ctx}/sys/user/form?id=${user.id}">${user.userName}</a></td>
                        <td>${user.name}</td>
                            <%--<td>${user.employee.employeeCd}</td>--%>
                            <%--<td>${user.employee.employeeCnm}</td>--%>
                            <%--<td>${user.employee.employeeEnm}</td>--%>
                            <%--<td>${user.employee.org.orgNm}</td>--%>
                            <%--<td>${user.employee.job.jobName}</td>--%>
                        <td>${fns:getDictLabel(user.userType,"sys_user_type" , "")} </td>
                        <shiro:hasPermission name="sys:user:edit">
                            <td>
                                <a href="${ctx}/sys/user/form?id=${user.id}">修改</a>
                                <a href="${ctx}/sys/user/delete?id=${user.id}"
                                   onclick="return confirmx('确认要删除该用户吗？', this.href)">删除</a>
                            </td>
                        </shiro:hasPermission>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="pagination">${page}</div>

        </div>
    </div>
</body>
</html>
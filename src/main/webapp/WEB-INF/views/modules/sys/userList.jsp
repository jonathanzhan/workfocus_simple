<%@ taglib prefix="select" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>用户管理</title>
    <%@include file="/WEB-INF/views/include/head.jsp" %>
    <script type="text/javascript">
        $(function () {
            $('#contentTable').DataTable({
                scrollY:"500px"
                ,scrollX:false//显示横向滚动
                ,scrollCollapse:true//当显示更少的记录时，是否允许表格减少高度
                ,searching: false//是否允许Datatables开启本地搜索
                ,ordering:  false//是否显示排序
                ,info:false//控制是否显示表格左下角的信息
                ,paging: false//是否开启本地分页
                ,fixedHeader: {//固定表头
                    header: true
                }
            } );
        });
    </script>
</head>

<body class="gray-bg">
<div class="wrapper wrapper-content">
    <div class="ibox">
        <div class="ibox-content">
            <form:form id="searchForm" modelAttribute="user" action="${ctx}/sys/user/list" method="post"
                       cssClass="form-horizontal">
                <div class="row">
                    <div class="col-sm-12">
                        <div class="form-group">
                            <common:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/>
                            <label class="col-sm-1 control-label">用户名</label>
                            <div class="col-sm-2">
                                <form:input path="name" class="form-control"/>
                            </div>

                            <label class="col-sm-1 control-label">员工编号</label>
                            <div class="col-sm-2">
                                <form:input path="employee.code" class="form-control"/>
                            </div>

                            <label class="col-sm-1 control-label">用户类型</label>
                            <div class="col-sm-2">
                                <form:select path="userType"  cssClass="form-control">
                                    <select:option value="" label="请选择"/>
                                    <form:options items="${fns:getDictList('sys_user_type')}" itemLabel="label" itemValue="value" />
                                </form:select>
                            </div>
                        </div>
                        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
                        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <%--<div class="pull-left">--%>
                            <%----%>
                            <%--<shiro:hasPermission name="sys:user:del">--%>
                                <%--<common:delBtn url="${ctx}/sys/user/deleteAll"></common:delBtn><!-- 删除按钮 -->--%>
                            <%--</shiro:hasPermission>--%>
                            <%--<button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()"  title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>--%>
                        <%--</div>--%>
                        <div class="pull-left">
                            <shiro:hasPermission name="sys:user:add">
                                <common:addBtn url="${ctx}/sys/user/form" title="用户" width="800px" height="620px" btnClass="btn-primary btn-rounded btn-outline btn-sm"></common:addBtn><!-- 增加按钮 -->
                            </shiro:hasPermission>
                            <button  class="btn btn-primary btn-rounded btn-outline btn-sm " type="submit" onclick="searchForm()"><i class="fa fa-search"></i> 查询</button>
                            <button  class="btn btn-primary btn-rounded btn-outline btn-sm " type="button" onclick="resetFrom()" ><i class="fa fa-refresh"></i> 重置</button>
                        </div>
                    </div>
                </div>
            </form:form>

            <sys:message content="${message}"/>
            <common:tableAllCheck checkBoxClass="i-checks" checkAllId="check-all"/>
            <input type="hidden" id="check-all" value="0">
            <table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTable">
                <thead>
                <tr>
                    <th class="check-all">选择</th>
                    <th>编号</th>
                    <th class="sort-column sorting" data-sort="login_name">登录名</th>
                    <th class="sort-column sorting" data-sort="name">用户名称</th>
                    <th class="sort-column sorting" data-sort="user_type">用户类型</th>
                    <th class="sort-column sorting" data-sort="b.code">员工编号</th>
                    <th class="sort-column sorting">员工姓名</th>
                    <th>所属机构</th>
                    <th>最近登录时间</th>
                    <shiro:hasPermission name="sys:user:edit">
                        <th>操作</th>
                    </shiro:hasPermission></tr>
                </thead>
                <tbody>
                <c:forEach items="${page.list}" var="user" varStatus="st">
                    <tr>
                        <td> <input type="checkbox" class="i-checks" id="${user.id}"></td>
                        <td>${st.count}</td>
                        <td><a href="${ctx}/sys/user/form?id=${user.id}">${user.loginName}</a></td>
                        <td>${user.name}</td>
                        <td>${fns:getDictLabel(user.userType,"sys_user_type" , "")} </td>
                        <td>${user.employee.code}</td>
                        <td>${user.employee.name}</td>
                        <td>${user.employee.org.name}</td>
                        <td><fmt:formatDate value="${user.thisLoginAt}" type="both"/></td>
                        <td>
                            <shiro:hasPermission name="sys:user:view">
                                <a href="#" onclick="openDialogView('查看用户', '${ctx}/sys/user/form?id=${user.id}','800px', '620px')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i> 查看</a>
                            </shiro:hasPermission>
                            <shiro:hasPermission name="sys:user:edit">
                                <a href="#" onclick="openDialog('修改用户', '${ctx}/sys/user/form?id=${user.id}','800px', '620px')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
                            </shiro:hasPermission>
                            <shiro:hasPermission name="sys:user:del">
                                <a href="${ctx}/sys/user/delete?id=${user.id}" onclick="return confirmx('要删除该员工吗？', this.href)" class="btn btn-danger btn-xs"><i class="fa fa-trash"></i> 删除</a>
                            </shiro:hasPermission>
                        </td>
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
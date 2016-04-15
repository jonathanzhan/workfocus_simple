<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <%@ include file="/WEB-INF/views/include/head.jsp" %>
    <title>角色管理</title>
    <script type="text/javascript">
        $(function () {

        })
    </script>
</head>


<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">

    <div class="ibox">
        <div class="ibox-title">
            <a href="${ctx}/sys/role"><h5>角色列表</h5></a>
            <shiro:hasPermission name="sys:role:edit">
                <div class="ibox-tools">
                    <a href="${ctx}/sys/role/form" class="btn btn-primary btn-xs">角色添加</a>
                </div>
            </shiro:hasPermission>
        </div>

        <div class="ibox-content">
            <sys:message content="${message}"/>
            <table class="table table-striped table-hover table-bordered table-condensed">
                <thead>
                <tr>
                    <th class="text-center">编号</th>
                    <th class="text-center">角色名称</th>
                    <th class="text-center">英文名称</th>
                    <th class="text-center">数据范围</th>
                    <shiro:hasPermission name="sys:role:edit">
                        <th class="text-center">操作</th>
                    </shiro:hasPermission>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${list}" var="role" varStatus="st">
                    <tr>
                        <td>${st.count}</td>
                        <td><a href="${ctx}/sys/role/form?id=${role.id}">${role.name}</a></td>
                        <td><a href="${ctx}/sys/role/form?id=${role.id}">${role.ename}</a></td>
                        <td>${fns:getDictLabel(role.dataScope,'sys_data_scope' ,'' )}</td>
                        <shiro:hasPermission name="sys:role:edit">
                            <td>

                                <a href="#" onclick="openDialogView('分配用户', '${ctx}/sys/role/assign?id=${role.id}','800px', '600px')"  class="btn  btn-warning btn-xs" ><i class="glyphicon glyphicon-plus"></i> 分配用户</a>

                                <a href="${ctx}/sys/role/form?id=${role.id}" title="修改">
                                    <span class="label label-primary">修改</span></a>
                                <a href="${ctx}/sys/role/delete?id=${role.id}" title="删除"
                                   onclick="return confirmx('确认要删除该角色吗？', this.href)">
                                    <span class="label label-danger">删除</span></a>
                            </td>
                        </shiro:hasPermission>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>
</body>

</html>
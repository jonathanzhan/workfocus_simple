<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <%@include file="/WEB-INF/views/include/head.jsp" %>
    <title>字典管理</title>
    <script type="text/javascript">
        function page(n, s) {
            $("#pageNo").val(n);
            $("#pageSize").val(s);
            $("#searchForm").submit();
            return false;
        }
        $(function () {

        })

    </script>

</head>

<body class="gray-bg">
<div class="wrapper wrapper-content">

    <!--查询表单开始-->
    <div class="ibox m-b-sm border-bottom">
        <div class="ibox-title">
            <a href="${ctx}/sys/dict"><h5>数据字典</h5></a>
            <shiro:hasPermission name="sys:dict:edit">
                <div class="ibox-tools">
                    <a href="${ctx}/sys/dict/form?sort=10" class="btn btn-primary btn-xs">字典添加</a>
                </div>
            </shiro:hasPermission>
        </div>

        <div class="ibox-content">
            <form:form id="searchForm" modelAttribute="dict" action="${ctx}/sys/dict/" method="post"
                       cssClass="form-horizontal">
                <div class="row">
                    <div class="col-md-10">
                        <label class="col-md-1 control-label">类型</label>

                        <div class="col-md-2">
                            <form:select path="type" class="form-control">
                                <form:option value="">请选择</form:option>
                                <form:options items="${typeList}" htmlEscape="false"/>
                            </form:select>
                        </div>

                        <label class="col-md-1 control-label">描述</label>

                        <div class="col-md-2">
                            <form:input path="description" htmlEscape="false" maxlength="50" class="form-control"/>
                        </div>

                        <div class="col-md-1">
                            <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
                        </div>
                        <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
                        <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
                    </div>
                </div>
            </form:form>
        </div>
    </div>
    <!--查询表单结束-->
    <sys:message content="${message}"/>
    <%--数据展示开始--%>
    <div class="ibox">
        <div class="ibox-content">
            <table data-toggle="table"
                   data-height="500"
                   data-sort-name="type"
                   data-sort-order="asc"
                   data-row-style="rowStyle">
                <thead>
                <tr>
                    <th data-field="value" data-sortable="true">键值</th>
                    <th data-field="label">标签</th>
                    <th data-field="type" data-sortable="true">类型</th>
                    <th class="text-center">描述</th>
                    <th class="text-center">排序</th>
                    <shiro:hasPermission name="sys:dict:edit">
                        <th class="text-center">操作</th>
                    </shiro:hasPermission>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${page.list}" var="dict">
                    <tr>
                        <td>${dict.value}</td>
                        <td><a href="${ctx}/sys/dict/form?id=${dict.id}">${dict.label}</a></td>
                        <td>
                            <a href="javascript:"
                               onclick="$('#type').val('${dict.type}');$('#searchForm').submit();return false;">${dict.type}</a>
                        </td>
                        <td>${dict.description}</td>
                        <td>${dict.seq}</td>
                        <shiro:hasPermission name="sys:dict:edit">
                            <td>
                                <a href="${ctx}/sys/dict/form?id=${dict.id}"><span class="label label-primary">修改</span></a>
                                <a href="${ctx}/sys/dict/delete?id=${dict.id}"
                                   onclick="return confirmx('确认要删除该字典吗？', this.href)"><span class="label label-danger">删除</span></a>
                                <a href="<c:url value='${fns:getAdminPath()}/sys/dict/form?type=${dict.type}&seq=${dict.seq+10}&description=${dict.description}'></c:url>">
                                    <span  class="label label-success">添加键值</span>
                                </a>
                            </td>
                        </shiro:hasPermission>
                    </tr>
                </c:forEach>
                </tbody>
                <tfoot>
                <tr>
                    <td colspan="6">
                        ${page.html}
                    </td>
                </tr>
                </tfoot>
            </table>
        </div>
    </div>
    <%--数据展示结束--%>

</div>


</body>


</html>
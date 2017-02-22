<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>系统参数</title>
    <%@include file="/WEB-INF/views/include/head.jsp" %>

</head>
<body class="gray-bg">
<div class="wrapper wrapper-content">
    <div class="ibox m-b-sm border-bottom">
        <div class="ibox-title">
            <a href="${ctx}/sys/param"><h5>系统参数列表</h5></a>
            <div class="ibox-tools">
                <a href="${ctx}/sys/param/form" class="btn btn-primary btn-xs">系统参数添加</a>
            </div>
        </div>

        <div class="ibox-content">
            <form:form id="searchForm" modelAttribute="param" action="${ctx}/sys/param/" method="post"
                       cssClass="form-horizontal">
                <div class="row">
                    <div class="col-md-10">
                        <label class="col-md-1 control-label">参数名：</label>
                        <div class="col-md-2">
                            <form:select path="name" class="form-control">
                                <form:option value="" label=""/>
                                <form:options items="${paramNameList}" htmlEscape="false"/>
                            </form:select>
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
            <table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTable">
                <thead>
                <tr>
                    <th>参数名</th>
                    <th>参数值</th>
                    <th>标签名</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${page.list}" var="param">
                    <tr>
                        <td><a href="${ctx}/sys/params/form?name=${param.name}">${param.name}</a></td>
                        <td>${param.value}</td>
                        <td>${param.label}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div>
                ${page.html}
            </div>
        </div>
    </div>
    <%--数据展示结束--%>


</div>
</body>


</html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
  <title>系统参数</title>
  <meta name="decorator" content="default"/>
  <script type="text/javascript">
    function page(n,s){
      $("#pageNo").val(n);
      $("#pageSize").val(s);
      $("#searchForm").submit();
      return false;
    }
    $(function(){
        $(".table").datatable({fixedHeader:true});
    })
  </script>
</head>
<body>
<%--<div class="panel" id="mainPanel">--%>
  <%--<div class="panel-heading">--%>
    <%--<ul class="nav nav-tabs">--%>
      <%--<li class="active"><a href="${ctx}/sys/params/">系统参数列表</a></li>--%>
      <%--<shiro:hasPermission name="sys:params:edit"><li><a href="${ctx}/sys/params/form">系统参数添加</a></li></shiro:hasPermission>--%>
    <%--</ul>--%>
  <%--</div>--%>

  <%--<div class="panel-body">--%>
    <%--<div class="tab-content col-md-12">--%>
      <%--<form:form id="searchForm" modelAttribute="params" action="${ctx}/sys/params/" method="post" cssClass="form-horizontal">--%>
        <%--<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>--%>
        <%--<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>--%>
        <%--<div class="form-group">--%>
          <%--<label class="col-md-1 control-label">参数名：</label>--%>
          <%--<div class="col-md-2">--%>
              <%--<form:select path="paramName" class="form-control">--%>
                <%--<form:option value="" label=""/>--%>
                <%--<form:options items="${paramNameList}" htmlEscape="false"/>--%>
              <%--</form:select>--%>
          <%--</div>--%>
          <%--<label class="col-md-1 control-label">用户名称：</label>--%>
          <%--<div class="col-md-2">--%>
            <%--<form:input path="paramName" class="form-control"/>--%>
          <%--</div>--%>

          <%--<div class="col-md-1 text-right">--%>
            <%--<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>--%>
          <%--</div>--%>
        <%--</div>--%>

      <%--</form:form>--%>
      <%--<sys:message content="${message}"/>--%>
      <%--<table id="contentTable" class="table table-striped table-bordered table-condensed">--%>
        <%--<thead><tr><th>参数名</th><th>参数值</th><th>标签名</th></tr></thead>--%>
        <%--<tbody>--%>
        <%--<c:forEach items="${page.list}" var="params">--%>
          <%--<tr>--%>
            <%--<td> <a href="${ctx}/sys/params/form?paramName=${params.paramName}">${params.paramName}</a></td>--%>
            <%--<td>${params.paramValue}</td>--%>
            <%--<td>${params.paramLabel}</td>--%>
          <%--</tr>--%>
        <%--</c:forEach>--%>
        <%--</tbody>--%>
      <%--</table>--%>
      <%--<div class="pagination">${page}</div>--%>
    <%--</div>--%>
  <%--</div>--%>
<%--</div>--%>



<%--=======--%>

<div class="panel" id="mainPanel">
    <div class="panel-heading">
        <ul class="nav nav-tabs">
          <li class="active"><a href="${ctx}/sys/params/">系统参数列表</a></li>
          <shiro:hasPermission name="sys:params:edit"><li><a href="${ctx}/sys/params/form">系统参数添加</a></li></shiro:hasPermission>
        </ul>
    </div>
    <div class="panel-body">
        <div class="tab-content col-md-12">
            <form:form id="searchForm" modelAttribute="params" action="${ctx}/sys/params/" method="post" cssClass="form-horizontal">
                <div class="form-group">
                    <label class="col-md-1 control-label">参数名：</label>
                    <div class="col-md-2">
                        <form:select path="paramName" class="form-control">
                            <form:option value="" label=""/>
                            <form:options items="${paramNameList}" htmlEscape="false"/>
                        </form:select>
                    </div>

                    <div class="col-md-2">
                        <input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
                    </div>
                    <input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
                    <input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
                </div>
            </form:form>
            <sys:message content="${message}"/>
            <table id="contentTable" class="table table-striped table-bordered table-condensed">
                <thead><tr><th>参数名</th><th>参数值</th><th>标签名</th></tr></thead>
                <tbody>
                <c:forEach items="${page.list}" var="params">
                    <tr>
                        <td> <a href="${ctx}/sys/params/form?paramName=${params.paramName}">${params.paramName}</a></td>
                        <td>${params.paramValue}</td>
                        <td>${params.paramLabel}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <div class="pagination">${page}</div>
        </div>
    </div>
</div>
</body>
</html>
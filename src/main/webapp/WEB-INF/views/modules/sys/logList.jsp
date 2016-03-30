<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<html>
<head>
	<title>日志管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		function page(n,s){
			$("#pageNo").val(n);
			$("#pageSize").val(s);
			$("#searchForm").submit();
	    	return false;
	    }
	</script>
</head>
<%--/WEB-INF/views/include/--%>
<body>
<div class="panel" id="mainPanel">
	<div class="panel-body">
		<div class="tab-content col-md-12">
			<form:form id="searchForm" action="${ctx}/sys/log/" method="post" cssClass="form-horizontal">
				<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
				<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
				<div class="form-group">
					<label class="col-md-1 control-label">操作菜单：</label>
					<div class="col-md-2">
						<input id="title" name="title" type="text" maxlength="50" class="form-control" value="${log.title}"/>
					</div>
					<label class="col-md-1 control-label">用户ID：</label>
					<div class="col-md-2">
						<input id="creator.id" name="creator.id" type="text" maxlength="50" class="form-control" value="${log.creator.id}"/>
					</div>
					<label class="col-md-1 control-label">URI：</label>
					<div class="col-md-2">
						<input id="requestUri" name="requestUri" type="text" maxlength="50" class="form-control" value="${log.requestUri}"/>
					</div>
				</div>
				<div class="form-group">
					<div class="row-group">
					<label class="col-md-1 control-label">日期范围：&nbsp;</label>
					<div class="col-md-2">
						<input id="beginDate" name="beginDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate"
														 value="<fmt:formatDate value="${log.beginDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>

					</div>
					<div class="col-md-2">
						<input id="endDate" name="endDate" type="text" readonly="readonly" maxlength="20" class="form-control Wdate"
							   value="<fmt:formatDate value="${log.endDate}" pattern="yyyy-MM-dd"/>" onclick="WdatePicker({dateFmt:'yyyy-MM-dd',isShowClear:false});"/>&nbsp;&nbsp;
					</div>
					</div>
					<div class="col-md-2">
						<label for="exception"><input id="exception" name="exception" type="checkbox"${log.exception eq '1'?' checked':''} value="1"/>只查询异常信息</label>
					</div>
					<div class="col-md-2">
						<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
					</div>

				</div>
			</div>
			</form:form>
			<sys:message content="${message}"/>
			<table id="contentTable" class="table table-striped table-bordered table-condensed">
				<thead>
				<tr>
					<th style="text-align:center;vertical-align:middle;" >操作菜单</th>
					<th style="text-align:center;vertical-align:middle;" >操作用户</th>
					<th style="text-align:center;vertical-align:middle;" >URI</th>
					<th style="text-align:center;vertical-align:middle;" >提交方式</th>
					<th style="text-align:center;vertical-align:middle;" >操作者IP</th>
					<th style="text-align:center;vertical-align:middle;" >操作时间</th>
				</tr>
				</thead>
				<tbody><%request.setAttribute("strEnter", "\n");request.setAttribute("strTab", "\t");%>
				<c:forEach items="${page.list}" var="log">
					<tr>
						<td>${log.title}</td>
						<td>${log.creator.userName}</td>
						<td><strong>${log.requestUri}</strong></td>
						<td>${log.method}</td>
						<td>${log.remoteAddr}</td>
						<td><fmt:formatDate value="${log.createAt}" type="both"/></td>
					</tr>
					<c:if test="${not empty log.exception}"><tr>
						<td colspan="8" style="word-wrap:break-word;word-break:break-all;">
								<%-- 					用户代理: ${log.userAgent}<br/> --%>
								<%-- 					提交参数: ${fns:escapeHtml(log.params)} <br/> --%>
							异常信息: <br/>
								${fn:replace(fn:replace(fns:escapeHtml(log.exception), strEnter, '<br/>'), strTab, '&nbsp; &nbsp; ')}</td>
					</tr></c:if>
				</c:forEach>
				</tbody>
			</table>
			<div class="pagination">${page}</div>
		</div>
	</div>
</div>
<!-- 	<ul class="nav nav-tabs"> -->
<%-- 		<li class="active"><a href="${ctx}/sys/log/">日志列表</a></li> --%>
<!-- 	</ul> -->

</body>
</html>
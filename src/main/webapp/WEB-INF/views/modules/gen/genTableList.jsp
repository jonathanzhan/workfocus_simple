<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
	<%@ include file="/WEB-INF/views/include/head.jsp" %>
	<title>业务表管理</title>
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
<div class="wrapper wrapper-content animated fadeInRight">

	<div class="ibox m-b-sm border-bottom">
		<div class="ibox-title">
			<a href="${ctx}/gen/genTable/"><h5>业务表列表</h5></a>
			<shiro:hasPermission name="gen:genTable:edit">
				<div class="ibox-tools">
					<a href="${ctx}/gen/genTable/form" class="btn btn-primary btn-xs">业务表添加</a>
				</div>
			</shiro:hasPermission>
		</div>

		<div class="ibox-content">
			<form:form id="searchForm" modelAttribute="genTable" action="${ctx}/gen/genTable/" method="post"
					   cssClass="form-horizontal">
				<div class="row">
					<div class="col-md-10">
						<label class="col-md-1 control-label">表名</label>
						<div class="col-md-2">
							<form:input path="nameLike" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>

						<label class="col-md-1 control-label">说明</label>
						<div class="col-md-2">
							<form:input path="comments" htmlEscape="false" maxlength="50" class="form-control"/>
						</div>

						<label class="col-md-1 control-label">父表名</label>
						<div class="col-md-2">
							<form:input path="parentTable" htmlEscape="false" maxlength="50" class="form-control"/>
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
	<sys:message content="${message}"/>

	<div class="ibox">
		<div class="ibox-content">
			<table data-toggle="table"
				   data-height="500"
				   data-sort-name="value"
				   data-sort-order="asc"
				   data-row-style="rowStyle">
				<thead>
				<tr>
					<th data-field="value" data-sortable="true">表名</th>
					<th data-field="label">说明</th>
					<th data-field="type" data-sortable="true">类名</th>
					<th class="text-center">父表</th>
					<shiro:hasPermission name="gen:genTable:edit">
						<th class="text-center">操作</th>
					</shiro:hasPermission>
				</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="genTable">
					<tr>
						<td><a href="${ctx}/gen/genTable/form?id=${genTable.id}">${genTable.name}</a></td>
						<td>${genTable.comments}</td>
						<td>${genTable.className}</td>
						<td title="点击查询子表"><a href="javascript:" onclick="$('#parentTable').val('${genTable.parentTable}');$('#searchForm').submit();">${genTable.parentTable}</a></td>
						<shiro:hasPermission name="gen:genTable:edit">
							<td>
								<a href="${ctx}/gen/genTable/form?id=${genTable.id}"><span class="label label-primary">修改</span></a>
								<a href="${ctx}/gen/genTable/delete?id=${genTable.id}" onclick="return confirmx('确认要删除该业务表吗？', this.href)"><span class="label label-danger">删除</span></a>
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

</div>
</body>

</html>

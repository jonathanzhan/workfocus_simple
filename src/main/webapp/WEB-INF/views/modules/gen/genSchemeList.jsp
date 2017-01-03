<%@ taglib prefix="select" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
	<title>生成方案管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			
		});
	</script>
</head>

<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="ibox">
		<div class="ibox-content">
			<form:form id="searchForm" modelAttribute="genScheme" action="${ctx}/gen/genScheme/" method="post"
					   cssClass="form-horizontal">
				<div class="row">
					<div class="col-sm-12">
						<div class="form-group">
							<common:tableSort id="orderBy" name="orderBy" value="${page.orderBy}" callback="sortOrRefresh();"/>
							<label class="col-sm-1 control-label">用户名</label>
							<div class="col-sm-2">
								<form:input path="name" class="form-control"/>
							</div>
						</div>
						<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
						<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
					</div>
				</div>
				<div class="row">
					<div class="col-sm-12">
						<div class="pull-left">
							<shiro:hasPermission name="gen:genScheme:edit">
								<common:addBtn url="${ctx}/gen/genScheme/form" title="生成方案" width="800px" height="620px" btnClass="btn-primary btn-rounded btn-outline btn-sm"></common:addBtn><!-- 增加按钮 -->
							</shiro:hasPermission>
							<button  class="btn btn-primary btn-rounded btn-outline btn-sm " type="submit" onclick="searchForm()"><i class="fa fa-search"></i> 查询</button>
							<button  class="btn btn-primary btn-rounded btn-outline btn-sm " type="button" onclick="resetFrom()" ><i class="fa fa-refresh"></i> 重置</button>
						</div>
					</div>
				</div>
			</form:form>

			<sys:message content="${message}"/>
			<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed">
				<thead>
				<tr>
					<th>方案名称</th>
					<th>生成模块</th>
					<th>模块名</th>
					<th>功能名</th>
					<th>功能作者</th>
					<shiro:hasPermission name="gen:genScheme:edit">
						<th>操作</th>
					</shiro:hasPermission>
				</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="genScheme">
					<tr>
						<td>${genScheme.name}</td>
						<td>${genScheme.packageName}</td>
						<td>${genScheme.moduleName}${not empty genScheme.subModuleName?'.':''}${genScheme.subModuleName}</td>
						<td>${genScheme.functionName}</td>
						<td>${genScheme.functionAuthor}</td>
						<shiro:hasPermission name="gen:genScheme:edit">
							<td>
								<a href="#" onclick="openDialogView('查看方案', '${ctx}/gen/genScheme/form?id=${genScheme.id}','800px', '620px')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i> 查看</a>
								<a href="#" onclick="openDialog('修改方案', '${ctx}/gen/genScheme/form?id=${genScheme.id}','800px', '620px')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
								<a href="${ctx}/gen/genScheme/delete?id=${genScheme.id}" onclick="return confirmx('确认要删除该生成方案吗？', this.href)" class="btn btn-danger btn-xs"><i class="fa fa-trash"></i> 删除</a>
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

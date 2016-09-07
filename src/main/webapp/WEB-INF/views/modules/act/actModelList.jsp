<%@ taglib prefix="select" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
	<title>模型管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(function () {

		});

		function updateCategory(id, category){
			$("#categoryBoxCategory").val(category);
			$("#categoryBoxId").val(id);
			layer.open({
				type: 1,
				skin: 'layui-layer-rim', //加上边框
				area: ['420px', '240px'], //宽高
				content: $("#layBox").html(),
				btn: ['确定', '关闭'],
				yes: function(index, layero){
					layer.load();
					var categoryForm =$("#categoryForm");
					var top_iframe = top.getActiveTab().attr("name");//获取当前active的tab的iframe
					categoryForm.attr("target",top_iframe);//表单提交成功后，从服务器返回的url在当前tab中展示

					$("#categoryForm").submit();
					layer.close(index);
				},
				cancel: function(index){
					layer.close(index);
				}
			});
		}

	</script>

</head>



<body class="gray-bg">

<div class="wrapper wrapper-content">

	<!--查询表单开始-->
	<div class="ibox m-b-sm border-bottom">
		<div class="ibox-title">
			<a href="${ctx}/act/model"><h5>模型列表</h5></a>
			<shiro:hasPermission name="act:model:edit">
				<div class="ibox-tools">
					<a href="${ctx}/act/model/create" class="btn btn-primary btn-xs">模型添加</a>
				</div>
			</shiro:hasPermission>
		</div>

		<div class="ibox-content">
			<div id="layBox" class="hide">
				<form id="categoryForm" action="${ctx}/act/model/updateCategory" method="post" enctype="multipart/form-data"
					  class="form-horizontal">
					<div class="col-md-10">
						<label class="col-md-3 control-label">分类</label>
						<div class="col-md-7">
							<input id="categoryBoxId" type="hidden" name="id" value="" />
							<select id="categoryBoxCategory" name="category" class="form-control">
								<c:forEach items="${fns:getDictList('act_category')}" var="dict">
									<option value="${dict.value}">${dict.label}</option>
								</c:forEach>
							</select>
						</div>
					</div>
				</form>
			</div>


			<form:form id="searchForm" modelAttribute="category" action="${ctx}/act/model/" method="post"
					   cssClass="form-horizontal">
				<div class="row">

					<div class="col-md-10">
						<label class="col-md-1 control-label">分类</label>

						<div class="col-md-2">
							<select id="category" name="category" class="form-control">
								<option value="">全部分类</option>
								<c:forEach items="${fns:getDictList('act_category')}" var="dict">
									<option value="${dict.value}" ${dict.value==category?'selected':''}>${dict.label}</option>
								</c:forEach>
							</select>
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
					<th data-field="category" data-sortable="true">流程分类</th>
					<th data-field="id">模型ID</th>
					<th data-field="key" data-sortable="true">模型标识</th>
					<th class="text-center">模型名称</th>
					<th class="text-center">版本号</th>
					<th class="text-center">创建时间</th>
					<th class="text-center">最后更新时间</th>
					<shiro:hasPermission name="act:model:edit">
						<th class="text-center">操作</th>
					</shiro:hasPermission>
				</tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="model">
					<tr>
						<td><a href="javascript:updateCategory('${model.id}', '${model.category}')" title="设置分类">${fns:getDictLabel(model.category,'act_category','无分类')}</a></td>
						<td>${model.id}</td>
						<td>${model.key}</td>
						<td>${model.name}</td>
						<td><b title='流程版本号'>V: ${model.version}</b></td>
						<td><fmt:formatDate value="${model.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td><fmt:formatDate value="${model.lastUpdateTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<shiro:hasPermission name="act:model:edit">
						<td>
							<a href="${pageContext.request.contextPath}/activiti/modeler.html?modelId=${model.id}" target="_blank">编辑</a>
							<a href="${ctx}/act/model/deploy?id=${model.id}" onclick="return confirmx('确认要部署该模型吗？', this.href)">部署</a>
							<a href="${ctx}/act/model/export?id=${model.id}" target="_blank">导出</a>
							<a href="${ctx}/act/model/delete?id=${model.id}" onclick="return confirmx('确认要删除该模型吗？', this.href)">删除</a>
						</td>
						</shiro:hasPermission>
					</tr>
				</c:forEach>
				</tbody>
				<tfoot>
				<tr>
					<td colspan="8">
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
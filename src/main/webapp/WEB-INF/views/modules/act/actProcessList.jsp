<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>流程管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function(){

		});

	</script>
	<script type="text/template" id="categoryBox">
		<form id="categoryForm" action="${ctx}/act/process/updateCategory" method="post" enctype="multipart/form-data"
			style="text-align:center;" class="form-search" onsubmit="loading('正在设置，请稍等...');"><br/>
			<input id="categoryBoxId" type="hidden" name="procDefId" value="" />
			<select id="categoryBoxCategory" name="category">
				<c:forEach items="${fns:getDictList('act_category')}" var="dict">
					<option value="${dict.value}">${dict.label}</option>
				</c:forEach>
			</select>
			<br/><br/>　　
			<input id="categorySubmit" class="btn btn-primary" type="submit" value="   保    存   "/>　　
		</form>
	</script>
</head>

<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeIn">

	<div class="tabs-container">
		<ul class="nav nav-tabs">
			<li class="active"><a href="${ctx}/act/process/">流程管理</a></li>
			<li><a href="${ctx}/act/process/deploy/">部署流程</a></li>
			<li><a href="${ctx}/act/process/running/">运行中的流程</a></li>
		</ul>
		<div class="tab-content">
			<!--查询表单开始-->
			<div class="ibox m-b-sm border-bottom">
				<div class="ibox-content">
					<form:form id="searchForm" modelAttribute="category" action="${ctx}/act/process/" method="post"
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



			<%--数据展示开始--%>
			<div class="ibox">
				<div class="ibox-content">
					<table class="table table-striped table-hover table-bordered table-condensed">
						<thead>
						<tr>
							<th>流程分类</th>
							<th>流程ID</th>
							<th>流程标识</th>
							<th>流程名称</th>
							<th>流程版本</th>
							<th>流程XML</th>
							<th>流程图片</th>
							<th>部署时间</th>
							<th>操作</th>
						</tr>
						</thead>
						<tbody>
						<c:forEach items="${page.list}" var="object">
							<c:set var="process" value="${object[0]}" />
							<c:set var="deployment" value="${object[1]}" />
							<tr>
								<td><a href="javascript:updateCategory('${process.id}', '${process.category}')" title="设置分类">${fns:getDictLabel(process.category,'act_category','无分类')}</a></td>
								<td>${process.id}</td>
								<td>${process.key}</td>
								<td>${process.name}</td>
								<td><b title='流程版本号'>V: ${process.version}</b></td>
								<td><a target="_blank" href="${ctx}/act/process/resource/read?procDefId=${process.id}&resType=xml">${process.resourceName}</a></td>
								<td><a target="_blank" href="${ctx}/act/process/resource/read?procDefId=${process.id}&resType=image">${process.diagramResourceName}</a></td>
								<td><fmt:formatDate value="${deployment.deploymentTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
								<td>
									<a href="${ctx}/act/dynamic/startForm?procDefId=${process.id}">动态表单</a>
									<c:if test="${process.suspended}">
										<a href="${ctx}/act/process/update/active?procDefId=${process.id}" onclick="return confirmx('确认要激活吗？', this.href)">激活</a>
									</c:if>
									<c:if test="${!process.suspended}">
										<a href="${ctx}/act/process/update/suspend?procDefId=${process.id}" onclick="return confirmx('确认挂起除吗？', this.href)">挂起</a>
									</c:if>
									<a href='${ctx}/act/process/delete?deploymentId=${process.deploymentId}' onclick="return confirmx('确认要删除该流程吗？', this.href)">删除</a>
									<a href='${ctx}/act/process/convert/toModel?procDefId=${process.id}' onclick="return confirmx('确认要转换为模型吗？', this.href)">转换为模型</a>
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
	</div>

</div>
</body>

</html>

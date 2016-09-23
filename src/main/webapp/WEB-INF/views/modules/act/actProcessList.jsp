<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>流程管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function(){
//			$("#categoryBoxCategory").val("demo");
		});

		function updateCategory(id, category){


			layer.open({
				type: 1,
				skin: 'layui-layer-rim', //加上边框
				area: ['420px', '240px'], //宽高
				maxmin: true, //开启最大化最小化按钮
				content: $("#categoryBox").html() ,
				btn: ['确定', '关闭'],
				yes: function(index, layero){
					layer.load();
					$("#categoryForm").submit();
				},
				cancel: function(index){
				},
				success:function(layero,index){
					$("#categoryBoxCategory").val(category);
					$("#categoryBoxId").val(id);
					if(category!=null && category!=''){
						$("#categoryBoxCategory").find("option[value="+category+"]").attr("selected",true);
					}
				}
			});

		}

	</script>
	<script type="text/template" id="categoryBox">
		<form id="categoryForm" action="${ctx}/act/process/updateCategory" class="form-horizontal" method="post">
			<div class="col-md-10">
				<label class="col-md-3 control-label">分类</label>
				<div class="col-md-7">
					<input id="categoryBoxId" type="hidden" name="procDefId" value="" />
					<select id="categoryBoxCategory" name="category" class="form-control">
						<c:forEach items="${fns:getDictList('act_category')}" var="dict">
							<option value="${dict.value}">${dict.label}</option>
						</c:forEach>
					</select>
				</div>
			</div>
		</form>
	</script>

</head>

<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeInRight">
	<!--查询表单开始-->
	<div class="ibox m-b-sm border-bottom">
		<div class="ibox-title">
			<a href="${ctx}/act/process"><h5>流程管理</h5></a>
		</div>

		<div class="ibox-content">

			<div id="layBox">

			</div>


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
	<sys:message content="${message}"/>
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
						<td><fmt:formatDate value="${deployment.deploymentTime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td>
							<%--<a href="#" onclick="openDialog('流程启动', '${ctx}/act/dynamic/startForm/${process.id}','800px', '620px')" class="btn btn-success btn-xs" ><i class="fa fa-toggle-right"></i>动态表单</a>--%>
							<a href="#" onclick="openDialog('流程启动', '${ctx}/act/process/startForm/${process.id}','800px', '620px')" class="btn btn-success btn-xs" ><i class="fa fa-toggle-right"></i>启动</a>

							<c:if test="${process.suspended}">
								<a href="${ctx}/act/process/update/active/${process.id}" onclick="return confirmx('确认要激活吗？', this.href)" class="btn btn-info btn-xs"><i class="fa fa-toggle-on"></i>激活</a>
							</c:if>
							<c:if test="${!process.suspended}">
								<a href="${ctx}/act/process/update/suspend/${process.id}" onclick="return confirmx('确认挂起吗？', this.href)" class="btn btn-warning btn-xs"><i class="fa fa-toggle-off"></i>挂起</a>
							</c:if>
							<a href='${ctx}/act/process/delete?deploymentId=${process.deploymentId}' onclick="return confirmx('确认要删除该流程吗？', this.href)" class="btn btn-danger btn-xs"><i class="fa fa-trash"></i>删除</a>
							<a href='${ctx}/act/process/convert/toModel?procDefId=${process.id}' onclick="return confirmx('确认要转换为模型吗？', this.href)" class="btn btn-info btn-xs"><i class="fa fa-check"></i>模型</a>
								<div class="btn-group">
									<button data-toggle="dropdown" class="btn btn-primary btn-xs dropdown-toggle"><i class="fa fa-search-plus"></i>查看<span class="caret"></span></button>
									<ul class="dropdown-menu">
										<li><a target="_blank" href="${ctx}/act/process/resource/read?procDefId=${process.id}&resType=xml" title="${process.resourceName}">XML</a></li>
										<li><a target="_blank" href="${ctx}/act/process/resource/read?procDefId=${process.id}&resType=image" title="${process.diagramResourceName}">图片</a></li>
									</ul>
								</div>
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

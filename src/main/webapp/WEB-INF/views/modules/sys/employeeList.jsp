<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
	<title>员工管理</title>
	<meta name="decorator" content="default"/>
	<script type="text/javascript">
		function page(n, s) {
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

<div class="panel" id="mainPanel">
	<div class="panel-heading">
		<ul class="nav nav-tabs">
			<li class="active"><a href="${ctx}/sys/employee/">员工列表1</a></li>
			<shiro:hasPermission name="sys:employee:edit">
				<li><a href="${ctx}/sys/employee/form">员工添加</a></li>
			</shiro:hasPermission>
		</ul>
	</div>

	<div class="panel-body">
		<div class="tab-content col-md-12">
			<form:form id="searchForm" modelAttribute="employee" action="${ctx}/sys/employee/" method="post" cssClass="form-horizontal" >
				<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
				<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
				<div class="form-group">
					<label class="col-md-1 control-label">员工编号</label>
					<div class="col-md-2">
						<form:input path="employeeCd" class="form-control"/>
					</div>

					<label class="col-md-1 control-label">中文名称</label>
					<div class="col-md-2">
						<form:input path="employeeCnm" class="form-control"/>
					</div>

					<label class="col-md-1 control-label">英文名称</label>
					<div class="col-md-2">
						<form:input path="employeeEnm" class="form-control"/>
					</div>
				</div>
				<div class="form-group">
					<label class="col-md-1 control-label">部门</label>
					<div class="col-md-2">
						<sys:treeselect id="parent" name="org.id" value="${employee.org.id}" labelName="org.orgNm" labelValue="${employee.org.orgNm}"
										title="部门" url="/sys/org/treeData" cssClass="form-control"  allowClear="true"/>
					</div>

					<%--<label class="col-md-1 control-label">岗位</label>--%>
					<%--<div class="col-md-2">--%>
						<%--<form:select path="job.id" class="form-control">--%>
							<%--<form:option value="">请选择</form:option>--%>
							<%--<form:options items="${fns:getJobList()}" itemLabel="jobName" itemValue="id" htmlEscape="false"/>--%>
						<%--</form:select>--%>
					<%--</div>--%>

					<div class="col-md-1 text-right">
						<input id="btnSubmit" class="btn btn-primary" type="submit" value="查询"/>
					</div>
				</div>
			</form:form>

			<sys:message content="${message}"/>
			<table class="table table-striped table-hover table-bordered table-condensed">
				<thead>
				<tr>
					<th class="text-center">编号</th>
					<th class="text-center">员工编号</th>
					<th class="text-center">中文名称</th>
					<th class="text-center">英文名称</th>
					<th class="text-center">性别</th>
					<th class="text-center">联系电话</th>
					<th class="text-center">联系地址</th>
					<shiro:hasPermission name="sys:employee:edit">
						<th class="text-center">操作</th>
					</shiro:hasPermission></tr>
				</thead>
				<tbody>
				<c:forEach items="${page.list}" var="employee" varStatus="st">
					<tr>
						<td>${st.count}</td>
						<td><a href="${ctx}/sys/employee/form?id=${employee.id}">${employee.employeeCd}</a></td>
						<td>${employee.employeeCnm}</td>
						<td>${employee.employeeEnm}</td>
						<td>${fns:getDictLabel(employee.sex,"sex" , "")} </td>
						<td>${employee.tel}</td>
						<td>${employee.address}</td>
						<shiro:hasPermission name="sys:employee:edit">
							<td>
								<a href="${ctx}/sys/employee/form?id=${employee.id}">修改</a>
								<a href="${ctx}/sys/employee/delete?id=${employee.id}"
								   onclick="return confirmx('确认要删除该员工吗？', this.href)">删除</a>
							</td>
						</shiro:hasPermission>
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
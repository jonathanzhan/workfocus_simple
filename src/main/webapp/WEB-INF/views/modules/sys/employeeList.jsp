<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
	<title>员工管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(function () {
			$('#contentTable').DataTable({
				scrollY:"500px"
				,scrollX:true//显示横向滚动
				,scrollCollapse:true//当显示更少的记录时，是否允许表格减少高度
				,searching: false//是否允许Datatables开启本地搜索
				,ordering:  true//是否显示排序
				,info:false//控制是否显示表格左下角的信息
				,paging: false//是否开启本地分页
				,fixedColumns:   {//固定列
					leftColumns: 1,//左边固定几行
					rightColumns:2 //右边固定几行
				}
				,fixedHeader: {//固定表头
					header: true
				}
			} );

		});

	</script>
</head>
<body>
	<form:form id="searchForm" modelAttribute="employee" action="${ctx}/sys/employee/list" method="post"
			   cssClass="form-horizontal">
	<div class="row">
		<div class="col-sm-12">
			<div class="form-group">
				<label class="col-sm-2 control-label">部门</label>
				<div class="col-sm-3">
					<sys:treeselect id="org" name="org.id" value="${employee.org.id}" labelName="org.name"
									labelValue="${employee.org.name}"
									title="机构" url="/sys/org/treeData" iframeId="employeeContent" cssClass="form-control"/>
				</div>

				<label class="col-sm-2 control-label">员工编号</label>
				<div class="col-sm-3">
					<form:input path="code" class="form-control"/>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">中文名称</label>
				<div class="col-sm-3">
					<form:input path="name" class="form-control"/>
				</div>

				<label class="col-sm-2 control-label">英文名称</label>
				<div class="col-sm-3">
					<form:input path="eName" class="form-control"/>
				</div>
			</div>
			<input id="pageNo" name="pageNo" type="hidden" value="${page.pageNo}"/>
			<input id="pageSize" name="pageSize" type="hidden" value="${page.pageSize}"/>
		</div>
	</div>
	<div class="row">
		<div class="col-sm-12">
			<div class="pull-left">
				<shiro:hasPermission name="sys:employee:add">
					<common:addBtn url="${ctx}/sys/employee/form" title="用户" width="800px" height="620px" target="employeeContent"></common:addBtn><!-- 增加按钮 -->
				</shiro:hasPermission>
				<shiro:hasPermission name="sys:employee:edit">
					<common:editBtn url="${ctx}/sys/employee/form" title="用户" width="800px" height="680px" target="employeeContent"></common:editBtn><!-- 编辑按钮 -->
				</shiro:hasPermission>
				<shiro:hasPermission name="sys:employee:del">
					<common:delBtn url="${ctx}/sys/employee/deleteAll"></common:delBtn><!-- 删除按钮 -->
				</shiro:hasPermission>
				<button class="btn btn-white btn-sm " data-toggle="tooltip" data-placement="left" onclick="sortOrRefresh()"  title="刷新"><i class="glyphicon glyphicon-repeat"></i> 刷新</button>
			</div>
			<div class="pull-right">
				<button  class="btn btn-primary btn-rounded btn-outline btn-sm " type="submit" onclick="searchForm()"><i class="fa fa-search"></i> 查询</button>
				<button  class="btn btn-primary btn-rounded btn-outline btn-sm " type="button" onclick="resetFrom()" ><i class="fa fa-refresh"></i> 重置</button>
			</div>
		</div>
	</div>
	</form:form>
	<!--查询表单结束-->
	<sys:message content="${message}"/>
	<common:tableAllCheck checkBoxClass="i-checks1" checkAllId="check-all" fixedColumn="true"/>
	<input type="hidden" id="check-all" value="0">
	<%--数据展示开始--%>
	<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTable">
		<thead>
		<tr>
			<th class="check-all">选择</th>
			<th>序号</th>
			<th>编码</th>
			<th>名称</th>
			<th>英文名</th>
			<th>性别</th>
			<th>电话</th>
			<th>email</th>
			<th>学历</th>
			<th>系统开通</th>
			<th>性别</th>
			<th>电话</th>
			<th>email</th>
			<th>学历</th>
			<th>系统开通</th>
			<th>性别</th>
			<th>电话</th>
			<th>email</th>
			<th>学历</th>
			<th>系统开通</th>
			<th class="text-center">操作</th>
		</tr>
		</thead>
		<tbody>
		<c:forEach items="${page.list}" var="employee" varStatus="st">
			<tr>
				<td> <input type="checkbox" class="i-checks1" id="${employee.id}"></td>
				<td>${st.count}</td>
				<td><a href="${ctx}/sys/employee/form?id=${employee.id}">${employee.code}</a></td>
				<td>${employee.name}</td>
				<td>${employee.eName}</td>
				<td>${fns:getDictLabel(employee.sex,"sex" , "")}</td>
				<td>${employee.tel}</td>
				<td>${employee.email}</td>
				<td>${fns:getDictLabel(employee.education,"education" , "")} </td>
				<td>${fns:getDictLabel(employee.isOpen,"yes_no" , "")} </td>
				<td>${fns:getDictLabel(employee.sex,"sex" , "")}</td>
				<td>${employee.tel}</td>
				<td>${employee.email}</td>
				<td>${fns:getDictLabel(employee.education,"education" , "")} </td>
				<td>${fns:getDictLabel(employee.isOpen,"yes_no" , "")} </td>
				<td>${fns:getDictLabel(employee.sex,"sex" , "")}</td>
				<td>${employee.tel}</td>
				<td>${employee.email}</td>
				<td>${fns:getDictLabel(employee.education,"education" , "")} </td>
				<td>${fns:getDictLabel(employee.isOpen,"yes_no" , "")} </td>
				<td>
					<shiro:hasPermission name="sys:employee:view">
						<a href="#" onclick="openDialogView('查看员工', '${ctx}/sys/employee/form?id=${employee.id}','800px', '620px')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i> 查看</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="sys:employee:edit">
						<a href="#" onclick="openDialog('修改员工', '${ctx}/sys/employee/form?id=${employee.id}','800px', '620px', 'employeeContent')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
					</shiro:hasPermission>
					<shiro:hasPermission name="sys:employee:del">
						<a href="${ctx}/sys/employee/delete?id=${employee.id}" onclick="return confirmx('要删除该员工吗？', this.href)" class="btn btn-danger btn-xs"><i class="fa fa-trash"></i> 删除</a>
					</shiro:hasPermission>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div>
		${page.html}
	</div>
	<%--数据展示结束--%>
</body>
</html>
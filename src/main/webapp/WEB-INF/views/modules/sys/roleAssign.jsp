<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<title>分配角色</title>
	<script>
	</script>
</head>

<body>
	<div class="wrapper wrapper-content">
		<form id="assignRoleForm" action="${ctx}/sys/role/assignrole" method="post"  class="form-horizontal">
			<input type="hidden" name="id" value="${role.id}"/>
			<div class="form-group">

				<label class="col-md-2 control-label">角色名称:<b>${role.name}</b></label>
				<label class="col-md-2 control-label">英文名称:<b>${role.ename}</b></label>
				<label class="col-md-2 control-label">角色类型:<b>${fns:getDictLabel(role.roleType,'role_type' , '')}</b></label>
				<label class="col-md-2 control-label">数据范围:<b>${fns:getDictLabel(role.dataScope, 'sys_data_scope', '')}</b></label>
			</div>
			<div class="form-group">
				<div class="col-md-2">
				<sys:treeselect id="roleUser" name="idsArr" value="${selectIds}" labelName="roleUserName"
								labelValue=""
								title="用户" url="/sys/org/treeData?type=6" checked="true" cssClass="form-control hidden"
								dataMsgRequired="请选择用户" notAllowSelectParent="true" btnClass="btn-outline" btnIcon="fa fa-plus" btnContent="添加用户" treeEvent="$('#assignRoleForm').submit()"/>
				</div>
			</div>
		</form>
		<sys:message content="${message}"/>

		<table id="contentTable" class="table table-striped table-bordered table-condensed">
			<thead>
			<tr>
				<th>编号</th>
				<th>用户名称</th>
				<th>用户类型</th>
				<th>员工编号</th>
				<th>员工姓名</th>
				<th>所属机构</th>
				<th>操作</th>
			</tr>
			</thead>
			<tbody>
			<c:forEach items="${userList}" var="user" varStatus="st">
				<tr>
					<td>${st.count}</td>
					<td>${user.name}</td>
					<td>${fns:getDictLabel(user.userType,"sys_user_type" , "")} </td>
					<td>${user.employee.code}</td>
					<td>${user.employee.name}</td>
					<td>${user.employee.org.name}</td>
					<td>
						<a href="${ctx}/sys/role/outrole?userId=${user.id}&roleId=${role.id}"
						   onclick="return confirmx('确认要将用户<b>[${user.name}]</b>从<b>[${role.name}]</b>角色中移除吗？', this.href)">移除</a>
					</td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>

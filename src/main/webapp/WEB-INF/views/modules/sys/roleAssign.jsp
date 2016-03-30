<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<%@ include file="/WEB-INF/views/include/head.jsp"%>
	<title>分配角色</title>
	<script>
		function addRoleUser(){
			top.layer.open({
				type: 2,
				area: ['800px', '600px'],
				title:"选择用户",
				maxmin: true, //开启最大化最小化按钮
				content: "${ctx}/sys/role/usertorole?id=${role.id}" ,
				btn: ['确定', '关闭'],
				yes: function(index, layero){
					var pre_ids = layero.find("iframe")[0].contentWindow.pre_ids;
					var ids = layero.find("iframe")[0].contentWindow.ids;
					if(ids[0]==''){
						ids.shift();
						pre_ids.shift();
					}
					if(pre_ids.sort().toString() == ids.sort().toString()){
						top.$.jBox.tip("未给角色【${role.name}】分配新成员！", 'info');
						return false;
					};
					// 执行保存
					loading('正在提交，请稍等...');
					var idsArr = "";
					for (var i = 0; i<ids.length; i++) {
						idsArr = (idsArr + ids[i]) + (((i + 1)== ids.length) ? '':',');
					}
					$('#idsArr').val(idsArr);
					$('#assignRoleForm').submit();
					top.layer.close(index);
				},
				cancel: function(index){
				}
			});
		}
	</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content">
		<div class="ibox">
			<div class="ibox-title">
				<a href="${ctx}/sys/role/assign?id=${role.id}"><h5>角色分配</h5></a>
				<div class="ibox-tools">
					<a href="${ctx}/sys/role" class="btn btn-primary btn-xs">返回角色列表</a>
				</div>
			</div>

			<div class="ibox-content">
				<form id="assignRoleForm" action="${ctx}/sys/role/assignrole" method="post"  class="form-horizontal">
					<input type="hidden" name="id" value="${role.id}"/>
					<input id="idsArr" type="hidden" name="idsArr" value=""/>
					<div class="form-group">
						<div class="col-md-1">
							<button class="btn btn-outline btn-primary" type="button" onclick="addRoleUser()"><i class="fa fa-plus"></i> 添加用户</button>
						</div>
						<label class="col-md-2 control-label">角色名称:<b>${role.name}</b></label>
						<label class="col-md-2 control-label">英文名称:<b>${role.ename}</b></label>
						<label class="col-md-2 control-label">角色类型:<b>${fns:getDictLabel(role.roleType,'role_type' , '')}</b></label>
						<label class="col-md-2 control-label">数据范围:<b>${fns:getDictLabel(role.dataScope, 'sys_data_scope', '')}</b></label>
					</div>
					<%--<div class="col-sm-12">--%>
						<%--<div class="pull-left">--%>
						<%--</div>--%>
						<%--<div class="pull-right">--%>
							<%--<button class="btn btn-primary btn-rounded btn-outline btn-sm " onclick="search()"><i class="fa fa-search"></i> 查询</button>--%>
						<%--</div>--%>
					<%--</div>--%>

				</form>
				<sys:message content="${message}"/>
				<table id="contentTable" class="table table-striped table-bordered table-condensed">
					<thead><tr><th>归属公司</th><th>归属部门</th><th>登录名</th><th>姓名</th><th>电话</th><th>手机</th><shiro:hasPermission name="sys:user:edit"><th>操作</th></shiro:hasPermission></tr></thead>
					<tbody>
					<c:forEach items="${userList}" var="user">
						<tr>
							<td>${user.userName}</td>
							<td>${user.userName}</td>
							<td><a href="${ctx}/sys/user/form?id=${user.id}">${user.userName}</a></td>
							<td>${user.userName}</td>
							<td>${user.userName}</td>
							<td>${user.userName}</td>
							<shiro:hasPermission name="sys:role:edit"><td>
								<a href="${ctx}/sys/role/outrole?userId=${user.id}&roleId=${role.id}"
								   onclick="return confirmx('确认要将用户<b>[${user.userName}]</b>从<b>[${role.name}]</b>角色中移除吗？', this.href)">移除</a>
							</td></shiro:hasPermission>
						</tr>
					</c:forEach>
					</tbody>
				</table>

			</div>
		</div>
	</div>
</body>
</html>

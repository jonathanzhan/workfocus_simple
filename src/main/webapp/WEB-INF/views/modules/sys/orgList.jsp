<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>机构管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<%@include file="/WEB-INF/views/include/treetable.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			var tpl = $("#treeTableTpl").html().replace(/(\/\/\<!\-\-)|(\/\/\-\->)/g,"");
			var data = ${fns:toJson(list)}, rootId = "${not empty org.parentId ? org.parentId : '0'}";
			addRow("#treeTableList", tpl, data, rootId, true);
			$("#treeTable").treeTable({expandLevel : 5});
		});
		function addRow(list, tpl, data, pid, root){
			for (var i=0; i<data.length; i++){
				var row = data[i];
				if ((${fns:jsGetVal('row.parentId')}) == pid){
					$(list).append(Mustache.render(tpl, {
						dict: {
							type: getDictLabel(${fns:toJson(fns:getDictList('org_type'))}, row.type)
						}, pid: (root?0:pid), row: row
					}));
					addRow(list, tpl, data, row.id);
				}
			}
		}
		function refresh(){//刷新或者排序，页码不清零
			window.location="${ctx}/sys/org/list?id=${org.id}";
		}
	</script>
</head>
<body>
	<div class="row m-b-xs">
		<div class="col-sm-12">
			<div class="pull-left">
				<shiro:hasPermission name="sys:org:add">
					<common:addBtn url="${ctx}/sys/org/form?parent.id=${org.id}" btnClass="btn-primary btn-outline btn-sm" title="机构" width="800px" height="620px" target="orgContent"></common:addBtn><!-- 增加按钮 -->
				</shiro:hasPermission>
				<button class="btn btn-primary btn-outline btn-sm " data-toggle="tooltip" data-placement="left" onclick="refresh()" title="刷新">
					<i class="glyphicon glyphicon-repeat"></i> 刷新
				</button>
			</div>
		</div>
	</div>
	<sys:message content="${message}"/>
	<table id="treeTable" class="table table-striped table-bordered table-hover table-condensed">
		<thead><tr><th>机构名称</th><th>机构编码</th><th>机构类型</th><th>联系人</th><shiro:hasPermission name="sys:org:edit"><th>操作</th></shiro:hasPermission></tr></thead>
		<tbody id="treeTableList"></tbody>
	</table>
	<script type="text/template" id="treeTableTpl">
		<tr id="{{row.id}}" pId="{{pid}}">
			<td>{{row.name}}</td>
			<td>{{row.code}}</td>
			<td>{{dict.type}}</td>
			<td>{{row.master}}</td>
			<td>
				<shiro:hasPermission name="sys:org:view">
					<a href="#" onclick="openDialogView('查看机构', '${ctx}/sys/org/form?id={{row.id}}','800px', '620px')" class="btn btn-info btn-xs" ><i class="fa fa-search-plus"></i> 查看</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="sys:org:edit">
					<a href="#" onclick="openDialog('修改机构', '${ctx}/sys/org/form?id={{row.id}}','800px', '620px', 'orgContent')" class="btn btn-success btn-xs" ><i class="fa fa-edit"></i> 修改</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="sys:org:del">
					<a href="${ctx}/sys/org/delete?id={{row.id}}" onclick="return confirmx('要删除该机构及所有子机构项吗？', this.href)" class="btn btn-danger btn-xs"><i class="fa fa-trash"></i> 删除</a>
				</shiro:hasPermission>
				<shiro:hasPermission name="sys:org:add">
					<a href="#" onclick="openDialog('添加下级机构', '${ctx}/sys/org/form?parent.id={{row.id}}','800px', '620px', 'orgContent')" class="btn  btn-primary btn-xs"><i class="fa fa-plus"></i> 添加下级机构</a>
				</shiro:hasPermission>
			</td>
		</tr>
	</script>
</body>
</html>
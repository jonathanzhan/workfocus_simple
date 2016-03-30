<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ include file="/WEB-INF/views/include/head.jsp" %>
<html>
<head>
	<title>分配角色</title>
	<meta name="decorator" content="blank"/>
	<%@include file="/WEB-INF/views/include/treeview.jsp" %>
	<script type="text/javascript">
	
		var orgTree;
		var selectedTree;//zTree已选择对象
		
		// 初始化
		$(document).ready(function(){
			orgTree = $.fn.zTree.init($("#orgTree"), setting, orgNodes);
			selectedTree = $.fn.zTree.init($("#selectedTree"), setting, selectedNodes);
		});

		var setting = {view: {selectedMulti:false,nameIsHTML:true,showTitle:false,dblClickExpand:false},
				data: {simpleData: {enable: true}},
				callback: {onClick: treeOnClick}};
		
		var orgNodes=[
	            <c:forEach items="${orgList}" var="org">
	            {id:"${org.id}",
	             pId:"${not empty org.parent?org.parent.id:0}",
	             name:"${org.orgNm}"},
	            </c:forEach>];
	
		var pre_selectedNodes =[
   		        <c:forEach items="${userList}" var="user">
   		        {id:"${user.id}",
   		         pId:"0",
   		         name:"<font color='red' style='font-weight:bold;'>${user.userName}</font>"},
   		        </c:forEach>];
		
		var selectedNodes =[
		        <c:forEach items="${userList}" var="user">
		        {id:"${user.id}",
		         pId:"0",
		         name:"<font color='red' style='font-weight:bold;'>${user.userName}</font>"},
		        </c:forEach>];
		
		var pre_ids = "${preids}".split(",");
		var ids = "${selectIds}".split(",");
		//点击选择项回调
		function treeOnClick(event, treeId, treeNode, clickFlag){
			$.fn.zTree.getZTreeObj(treeId).expandNode(treeNode);
			if("orgTree"==treeId){
				$.get("${ctx}/sys/role/users?orgId=" + treeNode.id, function(userNodes){
					$.fn.zTree.init($("#userTree"), setting, userNodes);
				});
			}
			if("userTree"==treeId){
				//alert(treeNode.id + " | " + ids);
				//alert(typeof ids[0] + " | " +  typeof treeNode.id);
				if($.inArray(String(treeNode.id), ids)<0){
					selectedTree.addNodes(null, treeNode);
					ids.push(String(treeNode.id));
				}
			};
			if("selectedTree"==treeId){
				if($.inArray(String(treeNode.id), pre_ids)<0){
					selectedTree.removeNode(treeNode);
					ids.splice($.inArray(String(treeNode.id), ids), 1);
				}else{
//					top.$.jBox.tip("角色原有成员不能清除！", 'info');
					layer.alert("角色原有成员不能清除！");
				}
			}
		};
		function clearAssign(){
			var submit = function (v, h, f) {
			    if (v == 'ok'){
					var tips="";
					if(pre_ids.sort().toString() == ids.sort().toString()){
						tips = "未给角色【${role.roleName}】分配新成员！";
					}else{
						tips = "已选人员清除成功！";
					}
					ids=pre_ids.slice(0);
					selectedNodes=pre_selectedNodes;
					$.fn.zTree.init($("#selectedTree"), setting, selectedNodes);
//			    	top.$.jBox.tip(tips, 'info');
					layer.alert(tips);
			    } else if (v == 'cancel'){
			    	// 取消
//			    	top.$.jBox.tip("取消清除操作！", 'info');
					layer.alert("取消清除操作！");
			    }
			    return true;
			};
			tips="确定清除角色【${role.roleName}】下的已选人员？";
//			top.$.jBox.confirm(tips, "清除确认", submit);
			layer.alert(tips);
		};


		var index = parent.layer.getFrameIndex(window.name);
		//保存
		$(document).on("click","#btnSubmit",function(){
			//调用父页面方法
			parent.closeTask(pre_ids,ids,index);

		});

		//关闭
		$(document).on("click","#btnCancel",function(){
			parent.layer.close(index);
		});

	</script>
</head>
<body>
	<div class="form-group">
		<div class="col-md-offset-2">
			<input id="btnSubmit" class="btn btn-info btn-sm" type="button" value="确认"/>
			<input id="btnCancel" class="btn btn-sm" type="button" value="取消"/>
		</div>
	</div>
	<div id="assignRole" class="row-fluid span12">
		<div class="span4" style="border-right: 1px solid #A8A8A8;">
			<p>所在部门：</p>
			<div id="orgTree" class="ztree"></div>
		</div>
		<div class="span3">
			<p>待选人员：</p>
			<div id="userTree" class="ztree"></div>
		</div>
		<div class="span3" style="padding-left:16px;border-left: 1px solid #A8A8A8;">
			<p>已选人员：</p>
			<div id="selectedTree" class="ztree"></div>
		</div>
	</div>
</body>
</html>

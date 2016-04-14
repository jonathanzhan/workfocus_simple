<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<title>数据选择</title>
	<%@include file="/WEB-INF/views/include/head.jsp"%>
	<%@include file="/WEB-INF/views/include/treeview.jsp"%>
	<script type="text/javascript">

		var index = parent.layer.getFrameIndex(window.name); //获取窗口索引
		var key, lastValue = "", nodeList = [], type = getQueryString("type", "${url}");

		var asyncEnabled = false,asyncUrl = "";
		if(type==5){
			asyncEnabled = true;
			asyncUrl = "${ctx}/sys/employee/treeData";
		}else if(type==6){
			asyncEnabled = true;
			asyncUrl = "${ctx}/sys/user/treeData";
		}else{
			asyncEnabled = false;
		}

		var tree, setting = {
			view:{selectedMulti:false,dblClickExpand:false},
			check:{enable:"${checked}",nocheckInherit:true},
			async:{enable:asyncEnabled,url:asyncUrl,autoParam:["id=orgId"]},//当url参数中type=5,则代表需要走异步程序，参数为orgId=节点ID
			data:{simpleData:{enable:true}},
			callback:{
				onClick:function(event, treeId, treeNode){
					tree.expandNode(treeNode);
				},
				onCheck: function(e, treeId, treeNode){
					var nodes = tree.getCheckedNodes(true);
					for (var i=0, l=nodes.length; i<l; i++) {
						tree.expandNode(nodes[i], true, false, false);
					}
					return false;
				},
				onAsyncSuccess: function(event, treeId, treeNode, msg){
					var nodes = tree.getNodesByParam("pId", treeNode.id, null);
					for (var i=0, l=nodes.length; i<l; i++) {
						try{tree.checkNode(nodes[i], treeNode.checked, true);}catch(e){}
					}
					selectCheckNode();
				},
				onDblClick: function(){
					if("${checked}" != "true"){
						var parentIndex = '${index}';
						if(parentIndex=='undefined'){
							if('${iframeId}'!=''){
								top.$(".J_iframe:visible")[0].contentWindow.$("#"+'${iframeId}')[0].contentWindow.doLayerChoose${treeId}(tree,index);
							}else{
								top.$(".J_iframe:visible")[0].contentWindow.doLayerChoose${treeId}(tree,index);
							}
						}else{
							var iframeId = "#layui-layer-iframe"+parentIndex;
							parent.$(iframeId)[0].contentWindow.doLayerChoose${treeId}(tree,index);
					}
					}
				}
			}
		};
		function expandNodes(nodes) {
			if (!nodes) return;
			for (var i=0, l=nodes.length; i<l; i++) {
				tree.expandNode(nodes[i], true, false, false);
				if (nodes[i].isParent && nodes[i].zAsync) {
					expandNodes(nodes[i].children);
				}
			}
		}
		$(document).ready(function(){
			$.get("${ctx}${url}${fn:indexOf(url,'?')==-1?'?':'&'}extId=${extId}&t="
					+ new Date().getTime(), function(zNodes){
				// 初始化树结构
				tree = $.fn.zTree.init($("#tree"), setting, zNodes);
				
				// 默认展开一级节点
				var nodes = tree.getNodesByParam("level", 0);
				for(var i=0; i<nodes.length; i++) {
					tree.expandNode(nodes[i], true, true, false);
				}
				//异步加载子节点（加载用户）
				var nodesOne = tree.getNodesByParam("isParent", true);
				for(var j=0; j<nodesOne.length; j++) {
					tree.reAsyncChildNodes(nodesOne[j],"!refresh",true);
				}
				selectCheckNode();
			});
			key = $("#key");
			key.bind("focus", focusKey).bind("blur", blurKey).bind("change cut input propertychange", searchNode);
			key.bind('keydown', function (e){if(e.which == 13){searchNode();}});
			$("#search").toggle();
		});

		// 默认选择节点
		function selectCheckNode(){
			var ids = "${selectIds}".split(",");
			for(var i=0; i<ids.length; i++) {
				var node = tree.getNodeByParam("id", (type>=5?"e_":"")+ids[i]);
				if("${checked}" == "true"){
					try{tree.checkNode(node, true, true);}catch(e){}
					tree.selectNode(node, false);
				}else{
					tree.selectNode(node, true);
				}
			}
		}

	  	function focusKey(e) {
			if (key.hasClass("empty")) {
				key.removeClass("empty");
			}
		}
		function blurKey(e) {
			if (key.get(0).value === "") {
				key.addClass("empty");
			}
			searchNode(e);
		}
		
		//搜索节点
		function searchNode() {
			// 取得输入的关键字的值
			var value = $.trim(key.get(0).value);
			
			// 按名字查询
			var keyType = "name";
			
			// 如果和上次一次，就退出不查了。
			if (lastValue === value) {
				return;
			}
			
			// 保存最后一次
			lastValue = value;
			
			var nodes = tree.getNodes();
			// 如果要查空字串，就退出不查了。
			if (value == "") {
				showAllNode(nodes);
				return;
			}
			hideAllNode(nodes);
			nodeList = tree.getNodesByParamFuzzy(keyType, value);
			updateNodes(nodeList);
		}
		
		//隐藏所有节点
		function hideAllNode(nodes){			
			nodes = tree.transformToArray(nodes);
			for(var i=nodes.length-1; i>=0; i--) {
				tree.hideNode(nodes[i]);
			}
		}
		
		//显示所有节点
		function showAllNode(nodes){			
			nodes = tree.transformToArray(nodes);
			for(var i=nodes.length-1; i>=0; i--) {
				if(nodes[i].getParentNode()!=null){
					tree.expandNode(nodes[i],false,false,false,false);
				}else{
					tree.expandNode(nodes[i],true,true,false,false);
				}
				tree.showNode(nodes[i]);
				showAllNode(nodes[i].children);
			}
		}
		
		//更新节点状态
		function updateNodes(nodeList) {
			tree.showNodes(nodeList);
			for(var i=0, l=nodeList.length; i<l; i++) {
				//展开当前节点的父节点
				tree.showNode(nodeList[i].getParentNode()); 
				//显示展开符合条件节点的父节点
				while(nodeList[i].getParentNode()!=null){
					tree.expandNode(nodeList[i].getParentNode(), true, false, false);
					nodeList[i] = nodeList[i].getParentNode();
					tree.showNode(nodeList[i].getParentNode());
				}
				//显示根节点
				tree.showNode(nodeList[i].getParentNode());
				//展开根节点
				tree.expandNode(nodeList[i].getParentNode(), true, false, false);
			}
		}
		
		// 开始搜索
		function search() {
			$("#search").slideToggle(200);
			$("#key").focus();
		}
		
	</script>

</head>
<body class="gray-bg">
<div class="wrapper-content" style="padding-top: 5px;">

	<div class="row">
		<div class="col-xs-9" >
			<div id="search">
				<div class="input-group" >
				<span class="input-group-btn">
					 <button type="button" id="btn" onclick="searchNode()" class="btn btn-sm btn-primary">搜索</button>
				</span>
					<input type="text" id="key" name="key" placeholder="关键字" class="form-control input-sm">
				</div>
			</div>

		</div>
		<div class="col-xs-3" onclick="search();" style="cursor:pointer;">
			<i class="fa fa-search"></i><label id="txt">搜索</label>
		</div>
	</div>
	<div class="row">
		<div class="col-xs-12" >
			<div id="tree" class="ztree"></div>
		</div>
	</div>

</div>
</body>
</html>
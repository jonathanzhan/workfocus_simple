<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>员工管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<%@include file="/WEB-INF/views/include/treeview.jsp" %>
	<style type="text/css">
		.ztree {overflow:auto;margin:0;_margin-top:10px;padding:10px 0 0 10px;}
	</style>
	<script type="text/javascript">
		function refresh(){//刷新
			window.location="${ctx}/sys/employee/";
		}
	</script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content animated bounce">
		<div class="ibox" id="main">
			<div class="ibox-content">
				<sys:message content="${message}"/>
				<div id="content" class="row">
					<div id="left" style="background-color:#e7eaec" class="animated swing">
						<a onclick="refresh()" class="pull-right">
							<i class="fa fa-refresh"></i>
						</a>
						<div id="ztree" class="ztree"></div>
					</div>
					<div id="openClose" class="close">&nbsp;</div>
					<div id="right" class="animated rubberBand">
						<iframe id="employeeContent" name="employeeContent" src="${ctx}/sys/employee/list" width="100%" height="91%" frameborder="0"></iframe>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script type="text/javascript">
		var setting = {data:{simpleData:{enable:true,idKey:"id",pIdKey:"pId",rootPId:'0'}},
			callback:{onClick:function(event, treeId, treeNode){
					var id = treeNode.id == '0' ? '1' :treeNode.id;
					var name = treeNode.name==''?'':treeNode.name;
					$('#employeeContent').attr("src","${ctx}/sys/employee/list?org.id="+id+"&org.name="+name);
				}
			}
		};
		
		function refreshTree(){
			$.getJSON("${ctx}/sys/org/treeData",function(data){
				$.fn.zTree.init($("#ztree"), setting, data).expandAll(true);
			});
		}
		refreshTree();
		 
		var leftWidth = 180; // 左侧窗口大小
		var htmlObj = $("html"), mainObj = $("#main");
		var frameObj = $("#left, #openClose, #right, #right iframe");
		function wSize(){
			var strs = getWindowSize().toString().split(",");
			htmlObj.css({"overflow-x":"hidden", "overflow-y":"hidden"});
			mainObj.css("width","auto");
			frameObj.height(strs[0] - 100);
			var leftWidth = ($("#left").width() < 0 ? 0 : $("#left").width());
			$("#right").width($("#content").width()- leftWidth - $("#openClose").width() -20);
			$(".ztree").width(leftWidth - 10).height(frameObj.height() - 46);
		}
	</script>
	<script src="${ctxStatic}/js/wsize.js" type="text/javascript"></script>
</body>
</html>
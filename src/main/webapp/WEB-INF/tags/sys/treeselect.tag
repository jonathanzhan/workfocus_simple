<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="编号"%>
<%@ attribute name="name" type="java.lang.String" required="true" description="隐藏域名称（ID）"%>
<%@ attribute name="value" type="java.lang.String" required="true" description="隐藏域值（ID）"%>
<%@ attribute name="labelName" type="java.lang.String" required="true" description="输入框名称（Name）"%>
<%@ attribute name="labelValue" type="java.lang.String" required="true" description="输入框值（Name）"%>
<%@ attribute name="title" type="java.lang.String" required="true" description="选择框标题"%>
<%@ attribute name="url" type="java.lang.String" required="true" description="树结构数据地址"%>
<%@ attribute name="checked" type="java.lang.Boolean" required="false" description="是否显示复选框，如果不需要返回父节点，请设置notAllowSelectParent为true"%>
<%@ attribute name="extId" type="java.lang.String" required="false" description="排除掉的编号（不能选择的编号）"%>
<%@ attribute name="notAllowSelectRoot" type="java.lang.Boolean" required="false" description="不允许选择根节点"%>
<%@ attribute name="notAllowSelectParent" type="java.lang.Boolean" required="false" description="不允许选择父节点"%>
<%@ attribute name="allowClear" type="java.lang.Boolean" required="false" description="是否允许清除"%>
<%@ attribute name="allowInput" type="java.lang.Boolean" required="false" description="文本框可填写"%>
<%@ attribute name="cssClass" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="cssStyle" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="hideBtn" type="java.lang.Boolean" required="false" description="是否显示按钮"%>
<%@ attribute name="disabled" type="java.lang.String" required="false" description="是否限制选择，如果限制，设置为disabled"%>
<%@ attribute name="dataMsgRequired" type="java.lang.String" required="false" description=""%>
<%@ attribute name="treeEvent" type="java.lang.String" required="false" description="选择树后执行事件"%>
<div class="input-group">
	<input id="${id}Id" name="${name}" class="${cssClass}" type="hidden" value="${value}"/>
	<input id="${id}Name" name="${labelName}" ${allowInput?'':'readonly="readonly"'} type="text" value="${labelValue}" data-msg-required="${dataMsgRequired}"
		class="${cssClass}" style="${cssStyle}"/>
	<span class="input-group-btn">
		<button id="${id}Button" href="javascript:" type="button" class="btn btn-primary ${disabled} ${hideBtn ? 'hide' : ''}">
			<i class="fa fa-search"></i>
		</button>
	</span>
</div>

<script type="text/javascript">
	$("#${id}Button, #${id}Name").click(function(){
		// 是否限制选择，如果限制，设置为disabled
		if ($("#${id}Button").hasClass("disabled")){
			return true;
		}

		//弹出layer层
		layer.open({
			type: 2
			,fix: false
			,title: '选择${title}'
			,maxmin: true
			,shade: [0.1, 'grey']
			,shadeClose: false
			,content : "${ctx}/tag/treeSelect?url="+encodeURIComponent("${url}")+"&checked=${checked}&extId=${extId}&selectIds="+$("#${id}Id").val()+"&treeId=${id}"
			,area: ['300px' , '450px']

		});
	});


	function doLayerChoose${id}(tree,index){
		var ids = [], names = [], nodes = [];
		if ("${checked}" == "true"){
			nodes = tree.getCheckedNodes(true);
		}else{
			nodes = tree.getSelectedNodes();
		}
		for(var i=0; i<nodes.length; i++) {
			<c:if test="${checked}">
			if (nodes[i].isParent){
				continue; // 如果为复选框选择，则过滤掉父节点
			}
			</c:if>
			<c:if test="${notAllowSelectRoot}">
			if (nodes[i].level == 0){
				layer.msg("不能选择根节点（"+nodes[i].name+"）请重新选择。",2,3)
				return false;
			}
			</c:if>
			<c:if test="${notAllowSelectParent}">
			if (nodes[i].isParent){
				layer.msg("不能选择父节点（"+nodes[i].name+"）请重新选择。",2,3)
				return false;
			}
			</c:if>
			ids.push(nodes[i].id);

			names.push(nodes[i].name);

			<c:if test="${!checked}">
			$("#level").val(nodes[i].level+1);
			break; // 如果为非复选框选择，则返回第一个选择
			</c:if>
		}
		$("#${id}Id").attr("value",ids);
		$("#${id}Name").attr("value",names);
		${treeEvent}
		layer.close(index);
	}

	function doReset${id}(index){
		$("#${id}Id").attr("value","");
		$("#${id}Name").attr("value","");
		${treeEvent}
		layer.close(index);
	}

</script>
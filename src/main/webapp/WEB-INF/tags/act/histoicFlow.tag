<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="procInsId" type="java.lang.String" required="true" description="流程实例ID"%>
<%@ attribute name="startAct" type="java.lang.String" required="false" description="开始活动节点名称"%>
<%@ attribute name="endAct" type="java.lang.String" required="false" description="结束活动节点名称"%>

<div class="ibox-content">
	<h4 class="text-navy">
		流程历史
	</h4>
	<div class="hr-line-dashed"></div>

	<div id="histoicFlowList">
		正在加载流转信息...
	</div>
</div>
<script type="text/javascript">
	$.get("${ctx}/act/task/histoicFlow?procInsId=${procInsId}&startAct=${startAct}&endAct=${endAct}&t="+new Date().getTime(), function(data){
		$("#histoicFlowList").html(data);
	});
</script>
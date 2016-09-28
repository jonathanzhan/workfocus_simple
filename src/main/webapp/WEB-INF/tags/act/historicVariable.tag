<%--
  author Jonathan
  Date: 2016/9/28 14:57
--%>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="procInsId" type="java.lang.String" required="true" description="流程实例ID"%>

<div class="ibox-content">
	<h4 class="text-navy">
		参数变量
	</h4>
	<div class="hr-line-dashed"></div>

	<div id="histoicVariableList">
		正在加载参数信息...
	</div>
</div>
<script type="text/javascript">
	$.get("${ctx}/act/process/historicVariable/${procInsId}?t="+new Date().getTime(), function(data){
		$("#histoicVariableList").html(data);
	});
</script>

<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="content" type="java.lang.String" required="true" description="消息内容"%>
<script type="text/javascript">
	function showMessageBox(content){
		var type = (content.indexOf('失败') ==-1 && content.indexOf('错误') ==-1)?'alert-success':'alert-danger';
		var icon = type.indexOf('danger') ==-1?'fa fa-check-circle-o':'fa fa-exclamation-circle';
		$("#messagesBox").removeClass();
		$("#messagesBox").addClass('alert alert-dismissable '+type);
		$("#messContent").text(content);
		$("#icon-mess").removeClass();
		$("#icon-mess").addClass('small-icon '+icon);

		showToastr('提示:',content,{
			"timeOut":"3000",
			"type":type.indexOf('danger') ==-1?'success':'error'
		});
	}

	function hideMessageBox(){
		$("#messagesBox").addClass('hidden');
	}

</script>

<div id="messagesBox" class="alert alert-dismissable hidden">
	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
	<i class="small-icon" id="icon-mess"></i>
	<span id="messContent"></span>
</div>


<c:if test="${not empty content}">

	<script type="text/javascript">
		showMessageBox("${content}");
	</script>
</c:if>



<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="编号"%>
<%@ attribute name="name" type="java.lang.String" required="true" description="输入框名称"%>
<%@ attribute name="value" type="java.lang.String" required="true" description="输入框值"%>
<i id="${id}Icon" class="${not empty value?value:' hide'}"></i>&nbsp;<label id="${id}IconLabel">${not empty value?value:'无'}</label>&nbsp;
<input id="${id}" name="${name}" type="hidden" value="${value}"/><a id="${id}Button" href="javascript:" class="btn">选择</a>&nbsp;&nbsp;
<script type="text/javascript">
	$("#${id}Button").click(function(){
		var layerHeight = $(top.document).height()-180;
		//弹出layer层
		layer.open({
			type: 2
			,fix: false
			,title: '选择图标'
			,maxmin: true
			,shade: [0.1, 'grey']
			,shadeClose: false
			,content:"${ctx}/tag/iconSelect?value="+$("#${id}").val()
			,area: ['600px' , ($(top.document).height()-180)+'px']
			,btn: ['确定', '清除']
			,btn1: function(index){
				//按钮【按钮一】的回调
				var body = layer.getChildFrame('body', index);
				var icon = body.find('#icon').val();
				$("#${id}Icon").attr("class", icon);
				$("#${id}IconLabel").text(icon);
				$("#${id}").val(icon);
				layer.close(index);

			},btn2: function(index){
				//按钮【按钮二】的回调
				$("#${id}Icon").attr("class", "hide");
				$("#${id}IconLabel").text("无");
				$("#${id}").val("");
				layer.close(index);
			}
		});

	});


	function chooseIcon(index,icon){
		$("#${id}Icon").attr("class", icon);
		$("#${id}IconLabel").text(icon);
		$("#${id}").val(icon);
		layer.close(index);
	}
</script>
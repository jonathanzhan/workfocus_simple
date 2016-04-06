<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="id" type="java.lang.String" required="true" description="上传后回写的数据的ID"%>
<%@ attribute name="path" type="java.lang.String" required="true" description="图片的路径"%>
<%@ attribute name="cssClass" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="cssStyle" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="imgCssClass" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="imgCssStyle" type="java.lang.String" required="false" description="css样式"%>
<%@ attribute name="treeEvent" type="java.lang.String" required="false" description="选择树后执行事件"%>

<input type="hidden" id="${id}" name="${id}" value="${path}">
<input type="file" id="id-input-file" class="input-large required"/>

<div class="progress progress-small progress-striped active" id="progress">
	<div class="progress-bar progress-bar-success"></div>
</div>
<div class="${cssClass} <c:if test="${empty path}">hidden</c:if>" style="${cssStyle}" id="imageShowDiv">
	<img <c:if test="${not empty path}">src="${ctxUpload}${path}"</c:if> id="imageShow" class="${imgCssClass}" style="${imgCssStyle}">
</div>




<script type="text/javascript">

	var whitelist_ext = ["jpeg", "jpg", "png","bmp"];
	var whitelist_mime = ["image/jpg", "image/jpeg", "image/png", "image/bmp"];

	$(function(){
		$('#id-input-file').ace_file_input({
			no_file:'请上传文件',
			btn_choose:'选择',
			btn_change:"选择",
			droppable:false,
			onchange:null,
			thumbnail:true,//| true | large
			allowExt: whitelist_ext,
			allowMime: whitelist_mime
		});

		$('#id-input-file').fileupload({
			autoUpload: true,//是否自动上传
			url: "${ctx}/bsc/upload",//上传地址
			dataType: 'json',
			done: function (e, data) {//设置文件上传完毕事件的回调函数
				if(data.result[0].status=="ok"){
					$("#imageShow").attr("src",'${ctxUpload}'+data.result[0].key);
					$("#imageShowDiv").removeClass("hidden");
					$("#${id}").attr("value",data.result[0].key);
				}

			},
			progressall: function (e, data) {//设置上传进度事件的回调函数
				var progress = parseInt(data.loaded / data.total * 100, 10);
				$('#progress .progress-bar').css(
						'width',
						progress + '%'
				);
			}
		});

	})
</script>
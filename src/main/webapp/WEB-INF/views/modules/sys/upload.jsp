<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
	<title>文件上传</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<!--引入CSS-->
	<script src="${ctxStatic}/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<link rel="stylesheet" type="text/css" href="${ctxStatic}/plugins/webuploader/webuploader.css">

	<!--引入JS-->
	<script type="text/javascript" src="${ctxStatic}/plugins/webuploader/webuploader.js"></script>
	<script>
		$(function(){
			var $list = $('#thelist'),
					$btn = $('#ctlBtn'),
					state = 'pending',
					uploader;

			uploader = WebUploader.create({
				auto:true,
				// swf文件路径
				swf: ctxStatic + '/plugins/webuploader/Uploader.swf',

				// 文件接收服务端。
				server: '${ctx}/sys/upload/test',

				// 选择文件的按钮。可选。
				// 内部根据当前运行是创建，可能是input元素，也可能是flash.
				pick: '#picker',

				// 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
				resize: false
			});



			// 当有文件被添加进队列的时候
			uploader.on( 'fileQueued', function( file ) {
				$list.append( '<div id="' + file.id + '" class="item">' +
						'<h4 class="info">' + file.name + '</h4>' +
						'<p class="state">等待上传...</p>' +
						'</div>' );
			});


			// 文件上传过程中创建进度条实时显示。
			uploader.on( 'uploadProgress', function( file, percentage ) {
				var $li = $( '#'+file.id ),
						$percent = $li.find('.progress .progress-bar');

				// 避免重复创建
				if ( !$percent.length ) {
					$percent = $('<div class="progress progress-striped active">' +
							'<div class="progress-bar" role="progressbar" style="width: 0%">' +
							'</div>' +
							'</div>').appendTo( $li ).find('.progress-bar');
				}

				$li.find('p.state').text('上传中');

				$percent.css( 'width', percentage * 100 + '%' );
			});

			uploader.on('error',function(type){
				console.log(type);
			})


			uploader.on('startUpload',function(){
				alert("sad");
			});

			uploader.on( 'uploadSuccess', function( file ,response) {
				console.log(response);
				alert(response.ok);
				console.log("uploadSuccess");
				$( '#'+file.id ).find('p.state').text('已上传');
			});

			uploader.on( 'uploadError', function( file ) {
				console.log("uploadError");
				$( '#'+file.id ).find('p.state').text('上传出错');
			});

			uploader.on( 'uploadComplete', function( file ) {
				console.log("uploadComplete");
				$( '#'+file.id ).find('.progress').fadeOut();
			});

			uploader.on( 'all', function( type ) {
				if ( type === 'startUpload' ) {
					state = 'uploading';
				} else if ( type === 'stopUpload' ) {
					state = 'paused';
				} else if ( type === 'uploadFinished' ) {
					state = 'done';
				}

				if ( state === 'uploading' ) {
					$btn.text('暂停上传');
				} else {
					$btn.text('开始上传');
				}
			});

			$btn.on( 'click', function() {
				if ( state === 'uploading' ) {
					uploader.stop();
				} else {
					uploader.upload();
				}
			});

		})


	</script>
</head>

<body class="gray-bg">
<div class="wrapper wrapper-content">

	<div class="ibox">
		<div class="ibox-title">
			<a href="${ctx}/demo/fileUpload"><h5>文件上传demo</h5></a>
		</div>

		<div class="ibox-content">
			<div class="row">
				<div class="col-md-9">
					<div id="uploader" class="wu-example">
						<!--用来存放文件信息-->
						<div id="thelist" class="uploader-list"></div>
						<div class="btns">
							<div id="picker">选择文件</div>
							<%--<button id="ctlBtn" class="btn btn-default">开始上传</button>--%>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</div>


</body>


</html>
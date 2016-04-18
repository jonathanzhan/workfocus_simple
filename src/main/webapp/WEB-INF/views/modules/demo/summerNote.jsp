<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<html>
<head>
    <title>summernote</title>
    <%@include file="/WEB-INF/views/include/head.jsp" %>
    <%@include file="/WEB-INF/views/include/summernote.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {

            $('.summernote').summernote({
                height: 200,
                lang: 'zh-CN'
            });


            $('form').on('submit', function (e) {
                $("#content").val($('.summernote').code());
            });
        });

        function sendLetter(){
            if($("#emailAddress").val()==''){
                top.layer.alert('收件人不能为空！', {icon: 0});
                return;
            }
            if($("#title").val()==''){
                top.layer.alert('标题不能为空！', {icon: 0});
                return;
            }
            if($('.summernote').code()==''){
                top.layer.alert('内容不能为空！', {icon: 0});
                return;
            }

            $("#content").val($('.summernote').code());
            var index = layer.load(1, {
                shade: [0.3,'#fff'] //0.1透明度的白色背景
            });
            $("#inputForm").submit();
        }
    </script>
</head>

<body class="gray-bg">
<div class="wrapper wrapper-content">
    <div class="mail-box-header">
        <div class="pull-right tooltip-demo">
            <a href="#" class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="存为草稿"><i class="fa fa-pencil"></i> 存为草稿</a>
            <a href="#" class="btn btn-danger btn-sm" data-toggle="tooltip" data-placement="top" title="放弃"><i class="fa fa-times"></i> 放弃</a>
        </div>
        <h2>
            写信
        </h2>
    </div>
    <div class="mail-box">

        <div class="mail-body">
            <sys:message content="${message}"/>
            <form class="form-horizontal" method="post" id="inputForm" action="${ctx}/demo/editor/summerNote/sent">
                <div class="form-group">
                    <label class="col-sm-2 control-label">发送到：</label>

                    <div class="col-sm-10">
                        <input type="text" class="form-control" value="" name="emailAddress" id="emailAddress">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col-sm-2 control-label">主题：</label>

                    <div class="col-sm-10">
                        <input type="text" class="form-control" value="" name="title" id="title">
                        <input type="hidden" id="content" name="content">
                    </div>
                </div>
            </form>

        </div>

        <div class="mail-text h-200">

            <div class="summernote">
                <h2>H+ 后台主题</h2>
                <p>H+是一个完全响应式，基于Bootstrap3最新版本开发的扁平化主题，她采用了主流的左右两栏式布局，使用了Html5+CSS3等现代技术，她提供了诸多的强大的可以重新组合的UI组件，并集成了最新的jQuery版本，当然，也集成了很多功能强大，用途广泛的国内外jQuery插件及其他组件，她可以用于所有的Web应用程序，如<b>网站管理后台</b>，<b>网站会员中心</b>，<b>CMS</b>，<b>CRM</b>，<b>OA</b>等等，当然，您也可以对她进行深度定制，以做出更强系统。</p>
                <p>
                    <b>当前版本：</b>v4.0.0
                </p>
                <p>
                    <b>定价：</b><span class="label label-warning">&yen;988（不开发票）</span>
                </p>

            </div>
            <div class="clearfix"></div>
        </div>
        <div class="mail-body text-right tooltip-demo">
            <a href="#" onclick="sendLetter()" class="btn btn-sm btn-primary" data-toggle="tooltip" data-placement="top" title="Send"><i class="fa fa-reply"></i> 发送</a>
            <a href="#" class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="Discard email"><i class="fa fa-times"></i> 放弃</a>
            <a href="#" class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="top" title="Move to draft folder"><i class="fa fa-pencil"></i> 存为草稿</a>
        </div>
        <div class="clearfix"></div>



    </div>
</div>


</body>


</html>
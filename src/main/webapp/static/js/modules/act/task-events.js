/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */


$(function(){

	//外部js调用
	laydate({
		elem: '#dueDate', //目标元素。由于laydate.js封装了一个轻量级的选择器引擎，因此elem还允许你传入class、tag但必须按照这种方式 '#id .class'
		event: 'focus', //响应事件。如果没有传入event，则按照默认的click
		format: 'YYYY-MM-DD hh:mm:ss',//日期格式
		istime:true,//是否开启时间选择
		istoday: true, //是否显示今天
		issure: true, //是否显示确认
		min: laydate.now(),//最小日期
		max: '2020-06-16 23:59:59',//最大日期
		festival: true, //是否显示节日
		choose: function(dates){ //选择好日期的回调
			$.post(ctx+"/act/task/changeTaskProperty/"+taskId,{
				propertyName:"dueDate",
				value:dates
			},function(data){
				console.log("dueDate change result is:"+data);
			})
		}
	});

	loadEvents();


	$("#btnAddComment").click(function(){
		saveComment();
	});

	/**
	 * 优先级的change事件
	 */
	$("#priority").change(function(){
		$.post(ctx+"/act/task/changeTaskProperty/"+taskId,{
			propertyName:"priority",
			value:$("#priority").val()
		},function(data){
			console.log("priority change result is:"+data);
		})
	})


})

/**
 * 添加意见
 * @returns {boolean}
 */
function saveComment(){
	var comment = $("#comment").val();
	if(!comment){
		top.layer.msg('请填写备注', {time: 3000, icon:2});
		return false;
	}
	$.post(ctx + '/act/task/comment/save', {
		taskId: taskId,
		proInsId: processInstanceId,
		comment:comment
	}, function (data) {
		if(data=='true'){
			loadEvents();
		}else{
			top.layer.msg('添加失败', {time: 3000, icon:2});
		}
	})
}

/*
 根据英文类型翻译为中文
 */
function translateType(event) {
	var types = {
		"1": "贡献人",
		"2": "项目经理",
		"3": "总经理",
		"4": "业务顾问",
		"5": "技术顾问",
		"6": "执行人",
		"owner": "拥有人",
		"candidate": "候选",
		"assignee":"办理人"
	};

	var type = (types[event.messageParts[1]] || '');
	if(type == '候选') {
		if(event.action.indexOf('User') != -1) {
			return '候选人';
		} else {
			return '候选组';
		}
	}
	return type;
}

/*
 事件处理器
 */
var eventHandler = {
	'DeleteAttachment': function(event, user, msg) {
		return user + '<span class="text-error">删除</span>了附件：' + msg;
	},
	'AddAttachment': function(event, user, msg) {
		return user + '添加了附件：' + msg;
	},
	'AddComment': function(event, user, msg) {
		return user + '发表了意见：' + msg;
	},
	'DeleteComment': function(event, user, msg) {
		return user + '<span class="text-error">删除</span>了意见：' + msg;
	},
	AddUserLink: function(event, user, msg) {
		return user + '邀请了<span class="text-info">' + event.messageParts[0] + '</span>作为任务的[<span class="text-info">' + translateType(event) + '</span>]';
	},
	DeleteUserLink: function(event, user, msg) {
		return user + '<span class="text-error">取消了</span><span class="text-info">' + event.messageParts[0] + '</span>的[<span class="text-info">' + translateType(event) + '</span>]角色';
	},
	AddGroupLink: function(event, user, msg) {
		return user + '添加了[<span class="text-info">' + translateType(event) + ']</span>' + event.messageParts[0];
	},
	DeleteGroupLink: function(event, user, msg) {
		return user + '从[<span class="text-info">' + translateType(event) + '</span>]中<span class="text-error">移除了</span><span class="text-info">' + event.messageParts[0] + '</span>';
	}
}

/**
 * 加载任务事件
 */
function loadEvents(){
	$("#eventList ul").html('');
	$.getJSON(ctx+'/act/task/taskEvents/'+taskId,function(datas) {
		console.log(datas);
		$.each(datas, function(i, v) {
			$('<li/>', {
				html: function() {
					var user = (v.userId || '');
					if(user) {
						user = "<span style='margin-right: 1em;'><b>" + user + "</b></span>"
					}
					var msg = v.message || v.fullMessage;
					var content = eventHandler[v.action](v, user, msg);
					// var taskName = datas.taskNames ? datas.taskNames[v.taskId] : '';
					content += "<span style='margin-left:1em;'></span>";

					// 名称不为空时才显示
					// if(taskName) {
					// 	content += "（<span class='text-info'>" + taskName + "</span>）";
					// }

					content += "<span class='text-muted'>" + new Date(v.time).toLocaleString() + "</span>";
					return content;
				}
			}).appendTo('#eventList ul');
		});
	})
}
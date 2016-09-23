/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.demo.controller;

import com.google.common.collect.Maps;
import com.mfnets.workfocus.common.persistence.ActEntity;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.act.entity.Act;
import com.mfnets.workfocus.modules.act.service.ActProcessService;
import com.mfnets.workfocus.modules.act.service.ActTaskService;
import com.mfnets.workfocus.modules.demo.entity.Leave;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;
import java.util.Map;

/**
 * 请假工作流的Controller层
 *
 * @author Jonathan
 * @version 2016/9/19 14:34
 * @since JDK 7.0+
 */
@Controller
@RequestMapping("${adminPath}/demo/leave")
public class LeaveController extends BaseController {

	@Autowired
	private ActTaskService actTaskService;


	@Autowired
	private ActProcessService actProcessService;

	@RequestMapping("startForm")
	public String startForm(Leave leave, Model model){
		model.addAttribute("leave",leave);
		return "modules/demo/leave/leaveApply";
	}

	@RequestMapping("start")
	public String start(Leave leave,
			RedirectAttributes redirectAttributes){
		String title = "请假["+leave.getReason()+"]";
		Map<String, Object> vars = Leave.getVars(leave);
		String proInsId = actTaskService.startProcess(leave.getAct().getProcDefKey(),null,title,vars);
		addMessage(redirectAttributes, "启动成功，流程ID："+ proInsId);
		return "redirect:" + adminPath + "/act/process";
	}



	@RequestMapping("completeForm")
	public String completeForm(Leave leave,Model model){
		//获取流程变量
		Map<String,Object> vars = actTaskService.getTaskIncludeVars(leave.getAct().getTaskId());
		leave.setVars(vars);
		model.addAttribute("leave",leave);
		return "modules/demo/leave/leaveComplete";
	}


	@RequestMapping("complete")
	public String complete(Leave leave, RedirectAttributes redirectAttributes){
		String comment = "";
		if(!"reportBack".equals(leave.getAct().getTaskDefKey())){
			comment = leave.getAct().getTaskName()+"【备注】";
		}
		Map<String, Object> vars = Leave.getVars(leave);
		actTaskService.complete(leave.getAct().getTaskId(),leave.getProcInsId(),comment,vars);
		addMessage(redirectAttributes, "任务完成，taskID：" + leave.getAct().getTaskId());
		return "redirect:" + adminPath + "/act/task/todo/list";
	}

}

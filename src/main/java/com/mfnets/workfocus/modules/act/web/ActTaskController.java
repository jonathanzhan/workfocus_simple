/*
 * Copyright  2014-2016 whatlookingfor@gmail.com(Jonathan)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.mfnets.workfocus.modules.act.web;

import com.mfnets.workfocus.common.persistence.Page;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.act.entity.Act;
import com.mfnets.workfocus.modules.act.entity.ActBusiness;
import com.mfnets.workfocus.modules.act.service.ActTaskService;
import com.mfnets.workfocus.modules.act.utils.ActUtils;
import com.mfnets.workfocus.modules.sys.utils.UserUtils;
import org.activiti.engine.task.Task;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.InputStream;
import java.util.List;
import java.util.Map;


/**
 * 流程任务的Controller
 * 
 * @author Jonathan
 * @version 2016/9/9 14:48
 * @since JDK 7.0+
 */
@Controller
@RequestMapping(value = "${adminPath}/act/task")
public class ActTaskController extends BaseController {

	@Autowired
	private ActTaskService actTaskService;


	/**
	 * 获取待认领列表(未签收)
	 * @param act 流程实例,封装查询条件
	 * @return
	 */
	@RequestMapping(value = "claim/list")
	public String claimList(Act act, Model model) throws Exception {
		List<Act> list = actTaskService.claimList(act);
		model.addAttribute("list", list);
		return "modules/act/actTaskClaimList";
	}


	
	/**
	 * 获取待办列表
	 * @param act 流程实例
	 * @return
	 */
	@RequestMapping(value = "todo/list")
	public String todoList(Act act, HttpServletResponse response, Model model) throws Exception {
		List<Act> list = actTaskService.todoList(act);
		model.addAttribute("list", list);
		return "modules/act/actTaskTodoList";
	}



	
	/**
	 *
	 * 获取已办任务
	 * @param act 流程实例
	 * @return
	 */
	@RequestMapping(value = "historic/list")
	public String historicList(Act act, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Page<Act> page = new Page<Act>(request, response);
		page = actTaskService.historicList(page, act);
		model.addAttribute("page", page);
		return "modules/act/actTaskHistoricList";
	}

	/**
	 * 获取流转历史列表
	 * @param act 流程实例
	 * @param startAct 开始活动节点名称
	 * @param endAct 结束活动节点名称
	 */
	@RequestMapping(value = "histoicFlow")
	public String histoicFlow(Act act, String startAct, String endAct, Model model){
		if (StringUtils.isNotBlank(act.getProcInsId())){
			List<Act> histoicFlowList = actTaskService.histoicFlowList(act.getProcInsId(), startAct, endAct);
			model.addAttribute("histoicFlowList", histoicFlowList);
		}
		return "modules/act/actTaskHistoricFlow";
	}


	/**
	 * 待办事项的处理页面表单
	 * @param taskId
	 * @return
	 */
	@RequestMapping(value = "form/{taskId}")
	public String form(@PathVariable("taskId") String taskId){
		//根据任务ID获取任务信息
		Task task = actTaskService.getTask(taskId);
		String formKey = task.getFormKey();
		if(StringUtils.isNotBlank(formKey)) {
			Act act = new Act();
			act.setProcInsId(task.getProcessInstanceId());
			act.setProcDefId(task.getProcessDefinitionId());
			act.setTask(task);
			act.setTaskId(taskId);
			act.setTaskDefKey(task.getTaskDefinitionKey());
			return "redirect:" + ActUtils.getFormUrl(formKey, act);
		} else {
			return "redirect:" + adminPath + "/act/dynamic/completeForm/"+taskId;
		}
	}
	
	/**
	 * 启动流程
	 * @param act 流程定义
	 * @param actBusiness 业务表相关字段或者SQL片段
	 */
	@RequestMapping(value = "start")
	@ResponseBody
	public String start(Act act, ActBusiness actBusiness, Model model) throws Exception {
		actTaskService.startProcess(act.getProcDefKey(), actBusiness, act.getTitle());
		return "true";
	}

	/**
	 * 签收任务
	 * @param act 任务ID
	 */
	@RequestMapping(value = "claim")
	@ResponseBody
	public String claim(Act act) {
		String userId = UserUtils.getUser().getLoginName();
		actTaskService.claim(act.getTaskId(), userId);
		return "true";
	}
	
	/**
	 * 完成任务
	 * @param act 流程实例
	 * 		vars.keys=flag,pass
	 * 		vars.values=1,true
	 * 		vars.types=S,B  @see com.thinkgem.jeesite.modules.act.utils.PropertyType
	 */
	@RequestMapping(value = "complete")
	@ResponseBody
	public String complete(Act act) {
		actTaskService.complete(act.getTaskId(), act.getProcInsId(), act.getComment(), act.getVars().getVariableMap());
		return "true";
	}

	/**
	 * 读取带跟踪的图片
	 */
	@RequestMapping(value = "trace/photo/{procDefId}/{execId}")
	public void tracePhoto(@PathVariable("procDefId") String procDefId, @PathVariable("execId") String execId, HttpServletResponse response) throws Exception {
		InputStream imageStream = actTaskService.tracePhoto(procDefId, execId);

		// 输出资源内容到相应对象
		byte[] b = new byte[1024];
		int len;
		while ((len = imageStream.read(b, 0, 1024)) != -1) {
			response.getOutputStream().write(b, 0, len);
		}
	}

	
	/**
	 * 输出跟踪流程信息
	 * 
	 * @param proInsId
	 * @return
	 * @throws Exception
	 */
	@ResponseBody
	@RequestMapping(value = "trace/info/{proInsId}")
	public List<Map<String, Object>> traceInfo(@PathVariable("proInsId") String proInsId) throws Exception {
		List<Map<String, Object>> activityInfos = actTaskService.traceProcess(proInsId);
		return activityInfos;
	}

	
	/**
	 * 删除任务
	 * @param taskId 流程实例ID
	 * @param reason 删除原因
	 */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = "deleteTask")
	public String deleteTask(String taskId, String reason, RedirectAttributes redirectAttributes) {
		if (StringUtils.isBlank(reason)){
			addMessage(redirectAttributes, "请填写删除原因");
		}else{
			actTaskService.deleteTask(taskId, reason);
			addMessage(redirectAttributes, "删除任务成功，任务ID=" + taskId);
		}
		return "redirect:" + adminPath + "/act/task";
	}
}

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

import com.google.common.collect.Maps;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.sys.entity.User;
import com.mfnets.workfocus.modules.sys.utils.UserUtils;
import org.activiti.engine.FormService;
import org.activiti.engine.IdentityService;
import org.activiti.engine.TaskService;
import org.activiti.engine.form.FormProperty;
import org.activiti.engine.form.StartFormData;
import org.activiti.engine.form.TaskFormData;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 动态表单的工作流demo
 *
 * @author Jonathan
 * @version 2016/1/7 14:52
 * @since JDK 7.0+
 */
@Controller
@RequestMapping(value = "${adminPath}/act/dynamic")
public class DynamicFormController extends BaseController {

	@Autowired
	private FormService formService;

	@Autowired
	private TaskService taskService;

	@Autowired
	private IdentityService identityService;


	/**
	 * 流程的启动页面
	 * @param procDefId 流程定义ID
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "startForm/{procDefId}")
	public String startForm(@PathVariable(value = "procDefId") String procDefId, Model model) {

		Map<String, Map<String, String>> result = Maps.newHashMap();
		Map<String,String> datePatterns = Maps.newHashMap();
		StartFormData startFormData = formService.getStartFormData(procDefId);
		List<FormProperty> formProperties = startFormData.getFormProperties();
		for (FormProperty formProperty : formProperties) {
			if("enum".equals(formProperty.getType().getName())){
				Map<String, String> values;
				values = (Map<String, String>) formProperty.getType().getInformation("values");
				if (values != null) {
					for (Map.Entry<String, String> enumEntry : values.entrySet())
						logger.debug("enum, key: {}, value: {}", enumEntry.getKey(), enumEntry.getValue());
					result.put("enum_" + formProperty.getId(), values);
				}

			}else if("date".equals(formProperty.getType().getName())){
				datePatterns.put("pattern_"+formProperty.getId(), (String)formProperty.getType().getInformation("datePattern"));
				logger.debug("date,key:{},pattern:{}",formProperty.getId(),formProperty.getType().getInformation("datePattern"));
			}

		}
		model.addAttribute("datePatterns",datePatterns);
		model.addAttribute("result", result);
		model.addAttribute("list", formProperties);
		model.addAttribute("formData", startFormData);

		return "modules/act/dynamicStartForm";
	}

	/**
	 * 动态表单任务办理界面的跳转
	 * @param taskId 任务ID
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "completeForm/{taskId}")
	public String completeForm(@PathVariable(value = "taskId") String taskId, Model model) {
		Map<String, Map<String, String>> result = Maps.newHashMap();
		Map<String,String> datePatterns = Maps.newHashMap();

		TaskFormData formData = formService.getTaskFormData(taskId);
		List<FormProperty> list = formData.getFormProperties();

		for (FormProperty formProperty : list) {
			if("enum".equals(formProperty.getType().getName())){
				Map<String, String> values = (Map<String, String>) formProperty.getType().getInformation("values");
				if (values != null) {
					for (Map.Entry<String, String> enumEntry : values.entrySet())
						logger.debug("enum, key: {}, value: {}", enumEntry.getKey(), enumEntry.getValue());
					result.put("enum_" + formProperty.getId(), values);
				}

			}else if("date".equals(formProperty.getType().getName())){
				datePatterns.put("pattern_"+formProperty.getId(), (String)formProperty.getType().getInformation("datePattern"));
				logger.debug("date,key:{},pattern:{}",formProperty.getId(),formProperty.getType().getInformation("datePattern"));
			}

		}

		Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
		model.addAttribute("datePatterns",datePatterns);
		model.addAttribute("result", result);
		model.addAttribute("list", list);
		model.addAttribute("task", task);

		return "modules/act/dynamicCompleteForm";
	}

	/**
	 * 动态表单的流程启动
	 * @param redirectAttributes
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "start")
	public String startProcess(
			RedirectAttributes redirectAttributes,
			HttpServletRequest request) {

		Map<String, String> formProperties = Maps.newHashMap();

		// 从request中读取参数然后转换
		Map<String, String[]> parameterMap = request.getParameterMap();
		Set<Map.Entry<String, String[]>> entrySet = parameterMap.entrySet();
		for (Map.Entry<String, String[]> entry : entrySet) {
			String key = entry.getKey();
			// fp_的意思是form parameter
			if (StringUtils.defaultString(key).startsWith("fp_")) {
				formProperties.put(key.split("_")[1], entry.getValue()[0]);
			}
		}
		String procDefId = request.getParameter("procDefId");
		logger.debug("start form parameters: {}", formProperties);

		User user = UserUtils.getUser();
		if (user != null && StringUtils.isNotBlank(user.getId())) {
			try {
				identityService.setAuthenticatedUserId(user.getLoginName());


				ProcessInstance processInstance = formService.submitStartFormData(procDefId, formProperties);
				logger.debug("start a processInstance: {}", processInstance);
				addMessage(redirectAttributes, "启动成功，流程ID：" + processInstance.getId());
				return "redirect:" + adminPath + "/act/process";
			} finally {
				identityService.setAuthenticatedUserId(null);
			}

		} else {
			return "redirect:" + adminPath + "/login";
		}

	}

	/**
	 * 动态表单的任务的办理
	 * @param redirectAttributes
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "complete")
	public String completeTask(
			RedirectAttributes redirectAttributes,
			HttpServletRequest request) {

		Map<String, String> formProperties = Maps.newHashMap();

		// 从request中读取参数然后转换
		Map<String, String[]> parameterMap = request.getParameterMap();
		Set<Map.Entry<String, String[]>> entrySet = parameterMap.entrySet();
		for (Map.Entry<String, String[]> entry : entrySet) {
			String key = entry.getKey();
			// fp_的意思是form parameter
			if (StringUtils.defaultString(key).startsWith("fp_")) {
				formProperties.put(key.split("_")[1], entry.getValue()[0]);
			}
		}
		String taskId = request.getParameter("taskId");
		logger.debug("task form parameters: {}", formProperties);
//		Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
		User user = UserUtils.getUser();
		if (user != null && StringUtils.isNotBlank(user.getId())) {
			try {
				identityService.setAuthenticatedUserId(user.getLoginName());
//				taskService.addComment(taskId, task.getProcessInstanceId(), "231231");
				formService.submitTaskFormData(taskId, formProperties);
				addMessage(redirectAttributes, "任务完成，taskID：" + taskId);
				return "redirect:" + adminPath + "/act/task/todo/list";
			} finally {
				identityService.setAuthenticatedUserId(null);
			}

		} else {
			return "redirect:" + adminPath + "/login";
		}

	}


}

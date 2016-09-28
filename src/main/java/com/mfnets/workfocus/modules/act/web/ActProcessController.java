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
import com.mfnets.workfocus.common.utils.StringUtils;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.act.entity.Act;
import com.mfnets.workfocus.modules.act.service.ActProcessService;
import com.mfnets.workfocus.modules.act.service.ActTaskService;
import com.mfnets.workfocus.modules.act.utils.ActUtils;
import org.activiti.engine.history.HistoricDetail;
import org.activiti.engine.history.HistoricFormProperty;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricVariableInstance;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.runtime.ProcessInstance;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.stream.XMLStreamException;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.List;


/**
 * 流程实例的controller
 *
 * @author Jonathan
 * @version 2016/9/14 15:19
 * @since JDK 7.0+
 */
@Controller
@RequestMapping(value = "${adminPath}/act/process")
public class ActProcessController extends BaseController {

	@Autowired
	private ActProcessService actProcessService;

	/**
	 * 流程定义列表
	 */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = {"list", ""})
	public String processList(String category, HttpServletRequest request, HttpServletResponse response, Model model) {
		/*
		 * 保存两个对象，一个是ProcessDefinition（流程定义），一个是Deployment（流程部署）
		 */
	    Page<Object[]> page = actProcessService.processList(new Page<Object[]>(request, response), category);
		model.addAttribute("page", page);
		model.addAttribute("category", category);
		return "modules/act/actProcessList";
	}
	
	/**
	 * 运行中的实例列表
	 */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = "running")
	public String runningList(String procInsId, String procDefKey, HttpServletRequest request, HttpServletResponse response, Model model) {
	    Page<ProcessInstance> page = actProcessService.runningList(new Page<ProcessInstance>(request, response), procInsId, procDefKey);
		model.addAttribute("page", page);
		model.addAttribute("procInsId", procInsId);
		model.addAttribute("procDefKey", procDefKey);
		return "modules/act/actProcessRunningList";
	}

	/**
	 * 已结束的流程列表
	 * @param act 查询条件
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "finish/list")
	public String finishList(Act act, HttpServletRequest request, HttpServletResponse response,Model model){
		Page<HistoricProcessInstance> page = actProcessService.finishList(new Page<HistoricProcessInstance>(request,response),act);
		model.addAttribute("page", page);
		return "modules/act/actProcessFinishList";
	}

	/**
	 * 查看流程的具体信息
	 * @param proInsId
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "view/{proInsId}", method = RequestMethod.GET)
	public String historicView(@PathVariable("proInsId") String proInsId,Model model) {
		List<HistoricVariableInstance> variableInstanceList = actProcessService.getHistoricVariable(proInsId);
		model.addAttribute("varList",variableInstanceList);
		model.addAttribute("proInsId",proInsId);
		return "modules/act/processView";
	}



	/**
	 * 读取资源，通过部署ID
	 * @param procDefId  流程定义ID
	 * @param proInsId 流程实例ID
	 * @param resType 资源类型(xml|image)
	 * @param response
	 * @throws Exception
	 */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = "resource/read", method = RequestMethod.GET)
	public void resourceRead(String procDefId, String proInsId, String resType, HttpServletResponse response) throws Exception {
		InputStream resourceAsStream = actProcessService.resourceRead(procDefId, proInsId, resType);
		byte[] b = new byte[1024];
		int len = -1;
		while ((len = resourceAsStream.read(b, 0, 1024)) != -1) {
			response.getOutputStream().write(b, 0, len);
		}
	}

	/**
	 * 部署流程
	 */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = "/deploy", method=RequestMethod.GET)
	public String deploy(Model model) {
		return "modules/act/actProcessDeploy";
	}
	
	/**
	 * 部署流程 - 保存
	 * @param file
	 * @return
	 */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = "/deploy", method=RequestMethod.POST)
	public String deploy(@Value("#{APP_PROP['activiti.export.diagram.path']}") String exportDir, 
			String category, MultipartFile file, RedirectAttributes redirectAttributes) {

		String fileName = file.getOriginalFilename();
		
		if (StringUtils.isBlank(fileName)){
			redirectAttributes.addFlashAttribute("message", "请选择要部署的流程文件");
		}else{
			String message = actProcessService.deploy(exportDir, category, file);
			redirectAttributes.addFlashAttribute("message", message);
		}

		return "redirect:" + adminPath + "/act/process";
	}
	
	/**
	 * 设置流程分类
	 */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = "updateCategory",method = RequestMethod.POST)
	public String updateCategory(String procDefId, String category, RedirectAttributes redirectAttributes) {
		actProcessService.updateCategory(procDefId, category);
		return "redirect:" + adminPath + "/act/process";
	}


	/**
	 * 挂起,激活流程定义
	 * @param state
	 * @param procDefId
	 * @param redirectAttributes
     * @return
     */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = "update/{state}/{procDefId}",method = RequestMethod.GET)
	public String updateState(@PathVariable("state") String state,@PathVariable("procDefId") String procDefId, RedirectAttributes redirectAttributes) {
		String message = actProcessService.updateState(state, procDefId);
		redirectAttributes.addFlashAttribute("message", message);
		return "redirect:" + adminPath + "/act/process";
	}


	/**
	 * 挂起,激活流程实例
	 * @param state
	 * @param processInstanceId
	 * @param redirectAttributes
     * @return
     */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = "processInstance/update/{state}/{processInstanceId}",method = RequestMethod.GET)
	public String updateProcessInstanceState(@PathVariable("state") String state, @PathVariable("processInstanceId") String processInstanceId,
							  RedirectAttributes redirectAttributes) {
		String message = actProcessService.updateProcessInstanceState(state, processInstanceId);

		redirectAttributes.addFlashAttribute("message", message);
		return "redirect:" + adminPath + "/act/process/running";
	}


	/**
	 * 将部署的流程转换为模型
	 * @param procDefId
	 * @param redirectAttributes
	 * @return
	 * @throws UnsupportedEncodingException
	 * @throws XMLStreamException
	 */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = "convert/toModel",method = RequestMethod.GET)
	public String convertToModel(String procDefId, RedirectAttributes redirectAttributes) throws UnsupportedEncodingException, XMLStreamException {
		org.activiti.engine.repository.Model modelData = actProcessService.convertToModel(procDefId);
		redirectAttributes.addFlashAttribute("message", "转换模型成功，模型ID="+modelData.getId());
		return "redirect:" + adminPath + "/act/process";
	}


	/**
	 * 删除部署的流程，级联删除流程实例
	 * @param deploymentId 流程部署ID
	 */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = "delete")
	public String delete(String deploymentId) {
		actProcessService.deleteDeployment(deploymentId);
		return "redirect:" + adminPath + "/act/process";
	}
	
	/**
	 * 删除流程实例
	 * @param procInsId 流程实例ID
	 * @param reason 删除原因
	 */
	@RequiresPermissions("act:process:edit")
	@RequestMapping(value = "deleteProcIns")
	public String deleteProcIns(String procInsId, String reason, RedirectAttributes redirectAttributes) {
		if (StringUtils.isBlank(reason)){
			addMessage(redirectAttributes, "请填写删除原因");
		}else{
			actProcessService.deleteProcIns(procInsId, reason);
			addMessage(redirectAttributes, "删除流程实例成功，实例ID=" + procInsId);
		}
		return "redirect:" + adminPath + "/act/process/running/";
	}


	/**
	 * 流程的启动页面跳转(定制表单或者动态表单都可以,根据判断是否定义formKey来区分)
	 * @param procDefId
	 * @param redirectAttributes
	 * @return
	 */
	@RequestMapping(value = "startForm/{procDefId}",method = RequestMethod.GET)
	public String run(@PathVariable("procDefId") String procDefId,RedirectAttributes redirectAttributes){
		// 获取流程XML上的流程启动表单KEY
		String formKey = actProcessService.getStartFormKey(procDefId);
		//根据formKey是否在模型中定义来判断是走动态表单还是自定义表单
		if(StringUtils.isNotBlank(formKey)) {
			Act act = new Act();
			ProcessDefinition processDefinition = ActUtils.getProcessDefinition(procDefId);
			act.setProcDefKey(processDefinition.getKey());
			act.setProcDefId(procDefId);
			redirectAttributes.addAttribute("act.procDefId",procDefId);
			redirectAttributes.addAttribute("act.procDefKey",processDefinition.getKey());
			return "redirect:" + ActUtils.getFormUrl(formKey);
		} else {
			return "redirect:" + adminPath + "/act/dynamic/startForm/"+procDefId;
		}
	}
	
}

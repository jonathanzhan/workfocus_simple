/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.act.web;

import com.google.common.collect.Maps;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.sys.entity.User;
import com.mfnets.workfocus.modules.sys.utils.UserUtils;
import org.activiti.engine.*;
import org.activiti.engine.form.FormProperty;
import org.activiti.engine.form.StartFormData;
import org.activiti.engine.form.TaskFormData;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.Task;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
public class DynamicFormController extends BaseController{

    @Autowired
    private FormService formService;

    @Autowired
    private RepositoryService repositoryService;

    @Autowired
    private TaskService taskService;

    @Autowired
    private IdentityService identityService;

    @Autowired
    private HistoryService historyService;

    @Autowired
    private RuntimeService runtimeService;

    @RequestMapping(value = "startForm")
    public String startForm(String procDefId,Model model){

            Map<String,Map<String, String>> result = Maps.newHashMap();
            StartFormData startFormData = formService.getStartFormData(procDefId);
            List<FormProperty> list = startFormData.getFormProperties();

            for (FormProperty formProperty : list) {
                Map<String, String> values = (Map<String, String>) formProperty.getType().getInformation("values");
                if (values != null) {
                    for (Map.Entry<String, String> enumEntry : values.entrySet()) {
                        logger.debug("enum, key: {}, value: {}", enumEntry.getKey(), enumEntry.getValue());
                    }
                    result.put("enum_" + formProperty.getId(), values);
                }
            }

            model.addAttribute("result",result);
            model.addAttribute("list",list);
            model.addAttribute("formData",startFormData);

            return "modules/act/dynamicStartForm";
    }


    @RequestMapping(value = "completeForm")
    public String completeForm(String taskId,Model model) {
        Map<String,Map<String, String>> result = Maps.newHashMap();
        TaskFormData formData = formService.getTaskFormData(taskId);
        List<FormProperty> list = formData.getFormProperties();

        for (FormProperty formProperty : list) {
            Map<String, String> values = (Map<String, String>) formProperty.getType().getInformation("values");
            if (values != null) {
                for (Map.Entry<String, String> enumEntry : values.entrySet()) {
                    logger.debug("enum, key: {}, value: {}", enumEntry.getKey(), enumEntry.getValue());
                }
                result.put("enum_" + formProperty.getId(), values);
            }
        }
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        System.out.println(formData.getTask().getId());
        System.out.println(formData.getTask().getName());
        System.out.println(formData.getTask().getAssignee());


        model.addAttribute("result",result);
        model.addAttribute("list",list);
        model.addAttribute("task",task);

        return "modules/act/dynamicCompleteForm";
    }



    @RequestMapping(value = "start")
    public String startProcess(
                               RedirectAttributes redirectAttributes,
                               HttpServletRequest request){

        Map<String, String> formProperties = Maps.newHashMap();

        // 从request中读取参数然后转换
        Map<String, String[]> parameterMap = request.getParameterMap();
        Set<Map.Entry<String, String[]>> entrySet = parameterMap.entrySet();
        for (Map.Entry<String, String[]> entry : entrySet) {
            String key = entry.getKey();
            // fp_的意思是form paremeter
            if (StringUtils.defaultString(key).startsWith("fp_")) {
                formProperties.put(key.split("_")[1], entry.getValue()[0]);
            }
        }
        String procDefId = request.getParameter("procDefId");
        logger.debug("start form parameters: {}", formProperties);

        User user = UserUtils.getUser();
        if(user!=null && StringUtils.isNotBlank(user.getId())){
            try{
                identityService.setAuthenticatedUserId(user.getLoginName());

                ProcessInstance processInstance = formService.submitStartFormData(procDefId, formProperties);
                logger.debug("start a processinstance: {}", processInstance);
                addMessage(redirectAttributes, "启动成功，流程ID：" + processInstance.getId());
                return "redirect:" + adminPath + "/act/process";
            } finally {
                identityService.setAuthenticatedUserId(null);
            }

        }else{
            return "redirect:" + adminPath + "/login";
        }

    }


    @RequestMapping(value = "complete")
    public String completeTask(
            RedirectAttributes redirectAttributes,
            HttpServletRequest request){

        Map<String, String> formProperties = Maps.newHashMap();

        // 从request中读取参数然后转换
        Map<String, String[]> parameterMap = request.getParameterMap();
        Set<Map.Entry<String, String[]>> entrySet = parameterMap.entrySet();
        for (Map.Entry<String, String[]> entry : entrySet) {
            String key = entry.getKey();
            // fp_的意思是form paremeter
            if (StringUtils.defaultString(key).startsWith("fp_")) {
                formProperties.put(key.split("_")[1], entry.getValue()[0]);
            }
        }
        String taskId = request.getParameter("taskId");
        logger.debug("task form parameters: {}", formProperties);
        Task task = taskService.createTaskQuery().taskId(taskId).singleResult();
        User user = UserUtils.getUser();
        if(user!=null && StringUtils.isNotBlank(user.getId())){
            try{
                identityService.setAuthenticatedUserId(user.getLoginName());
                taskService.addComment(taskId,task.getProcessInstanceId(),"231231");
                formService.submitTaskFormData(taskId,formProperties);
                addMessage(redirectAttributes, "任务完成，taskID：" + taskId);
                return "redirect:" + adminPath + "/act/task/todo";
            } finally {
                identityService.setAuthenticatedUserId(null);
            }

        }else{
            return "redirect:" + adminPath + "/login";
        }

    }




}

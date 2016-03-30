/**
 * Copyright &copy; 2012-2015 <a href="http://git.oschina.net/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.web;

import com.mfnets.workfocus.common.persistence.Page;
import com.mfnets.workfocus.common.utils.StringUtils;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.sys.entity.Job;
import com.mfnets.workfocus.modules.sys.service.JobService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 岗位Controller
 * @author jiangwei
 * @version 2014-08-29
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/job")
public class JobController extends BaseController {
    @Autowired
    private JobService jobService;

    @ModelAttribute
    public Job get(@RequestParam(required=false) String id){
        if (StringUtils.isNotBlank(id)){
            return jobService.get(id);
        }else{
            return new Job();
        }
    }

    @RequiresPermissions("sys:job:view")
    @RequestMapping(value = {"list",""})
    public String List(Job job,HttpServletRequest request, HttpServletResponse response, Model model){
        Page<Job> page = jobService.findPage(new Page<Job>(request, response),job);
        model.addAttribute("page", page);
        return "modules/sys/jobList";
    }

    @RequiresPermissions("sys:job:view")
    @RequestMapping(value = "form")
    public String form(Job job, Model model){
        model.addAttribute("job",job);
        return "modules/sys/jobForm";
    }

    @RequiresPermissions("sys:job:edit")
    @RequestMapping(value = "save")
    public String save(Job job, Model model, RedirectAttributes redirectAttributes){
        jobService.save(job);
        addMessage(redirectAttributes, "保存岗位'" + job.getJobName() + "'成功");
        return "redirect:" + adminPath + "/sys/job";
    }

    @RequiresPermissions("sys:job:edit")
    @RequestMapping(value = "delete")
    public String delete(Job job,RedirectAttributes redirectAttributes){
        jobService.delete(job);
        addMessage(redirectAttributes, "删除岗位成功");
        return "redirect:" + adminPath + "/sys/job/";
    }

}

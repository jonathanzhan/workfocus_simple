package com.mfnets.workfocus.modules.sys.web;

import com.google.common.collect.Lists;
import com.mfnets.workfocus.common.config.Global;
import com.mfnets.workfocus.common.task.ScheduleJobService;
import com.mfnets.workfocus.common.utils.StringUtils;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.sys.entity.ScheduleJob;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.quartz.CronExpression;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * 定时任务 controller
 * @author whatlookingfor
 * @date 2015年9月1日
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/scheduleJob")
public class ScheduleJobController extends BaseController{

    @Autowired
    private ScheduleJobService scheduleJobService;

    /**
     * 获取任务列表
     *
     * @return
     */
    @RequiresPermissions("sys:scheduleJob:view")
    @RequestMapping(value = {"list", ""})
    public String list(ScheduleJob scheduleJob,Model model) {
        List<ScheduleJob> scheduleJobs = Lists.newArrayList();
        if(StringUtils.isNotBlank(scheduleJob.getStatus()) && "0".equals(scheduleJob.getStatus())){//计划中的
            scheduleJobs = scheduleJobService.getAllScheduleJob();
        }else if(StringUtils.isNotBlank(scheduleJob.getStatus()) && "1".equals(scheduleJob.getStatus())){
            scheduleJobs = scheduleJobService.getAllRuningScheduleJob();
        }else{
            scheduleJobs = scheduleJobService.getAllScheduleJob();
        }
        model.addAttribute("list",scheduleJobs);
        return "modules/sys/scheduleJobList";
    }


    @RequiresPermissions("sys:scheduleJob:edit")
    @RequestMapping(value = "form")
    public String form(ScheduleJob scheduleJob, Model model) {
        model.addAttribute("scheduleJob", scheduleJob);
        String actionUrl = "";
        if(StringUtils.isNotBlank(scheduleJob.getName()) && StringUtils.isNotBlank(scheduleJob.getGroup())){
            actionUrl = scheduleJob.getName()+"/"+scheduleJob.getGroup()+"/update";
        }else{
            actionUrl = "save";
        }
        model.addAttribute("actionUrl",actionUrl);
        return "modules/sys/scheduleJobForm";
    }

    @RequiresPermissions("sys:scheduleJob:edit")
    @RequestMapping(value = "save")
    public String save(ScheduleJob scheduleJob, Model model, RedirectAttributes redirectAttributes) {
        if(Global.isDemoMode()){
            addMessage(redirectAttributes, "演示模式，不允许操作！");
            return "redirect:" + adminPath + "/sys/scheduleJob";
        }
        if (!beanValidator(model, scheduleJob)){
            return form(scheduleJob, model);
        }
        scheduleJob.setStatus("1");
        scheduleJobService.add(scheduleJob);
        addMessage(redirectAttributes, "保存任务'" + scheduleJob.getName() + "'成功");
        return "redirect:" + adminPath + "/sys/scheduleJob/";
    }



    /**
     * 暂停任务
     */
    @RequiresPermissions("sys:scheduleJob:edit")
    @RequestMapping("/{name}/{group}/stop")
    public String stop(@PathVariable String name, @PathVariable String group,RedirectAttributes redirectAttributes) {
        scheduleJobService.stopJob(name, group);
        addMessage(redirectAttributes, "任务'" + name + "'已暂停");
        return "redirect:" + adminPath + "/sys/scheduleJob/";
    }



    /**
     * 删除任务
     */
    @RequiresPermissions("sys:scheduleJob:edit")
    @RequestMapping("/{name}/{group}/delete")
    public String delete(@PathVariable String name, @PathVariable String group,RedirectAttributes redirectAttributes) {
        scheduleJobService.delJob(name, group);
        addMessage(redirectAttributes, "任务'" + name + "'已删除");
        return "redirect:" + adminPath + "/sys/scheduleJob/";
    }

    /**
     * 修改表达式
     */
    @RequiresPermissions("sys:scheduleJob:edit")
    @RequestMapping("/{name}/{group}/update")
    public String update(@PathVariable String name, @PathVariable String group,@RequestParam String cronExpression,RedirectAttributes redirectAttributes) {
        //验证cron表达式
        if(CronExpression.isValidExpression(cronExpression)){
            scheduleJobService.modifyTrigger(name, group, cronExpression);
            addMessage(redirectAttributes, "任务'" + name + "'表达式修改成功");
        }else{
            addMessage(redirectAttributes, "任务'" + name + "'表达式不正确");
        }
        return "redirect:" + adminPath + "/sys/scheduleJob/";
    }

    /**
     * 立即运行一次
     */
    @RequiresPermissions("sys:scheduleJob:edit")
    @RequestMapping("/{name}/{group}/startNow")
    public String startNow(@PathVariable String name, @PathVariable String group,RedirectAttributes redirectAttributes) {
        scheduleJobService.startNowJob(name, group);
        addMessage(redirectAttributes, "任务'" + name + "'已运行一次");
        return "redirect:" + adminPath + "/sys/scheduleJob/";
    }

    /**
     * 恢复
     */
    @RequiresPermissions("sys:scheduleJob:edit")
    @RequestMapping("/{name}/{group}/resume")
    public String resume(@PathVariable String name, @PathVariable String group,RedirectAttributes redirectAttributes) {
        scheduleJobService.restartJob(name, group);
        addMessage(redirectAttributes, "任务'" + name + "'已恢复");
        return "redirect:" + adminPath + "/sys/scheduleJob/";
    }

    /**
     * 获取所有trigger
     */
    public void getTriggers(HttpServletRequest request) {
        List<ScheduleJob> scheduleJobs = scheduleJobService.getTriggersInfo();
        System.out.println(scheduleJobs.size());
        request.setAttribute("triggers", scheduleJobs);
    }

    /**
     * cron表达式生成页
     */
    @RequestMapping("quartzCron")
    public String quartzCronCreate(){
        return "system/quartzCron";
    }
}

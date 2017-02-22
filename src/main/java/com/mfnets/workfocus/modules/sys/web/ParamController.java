/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.web;

import com.mfnets.workfocus.common.config.Global;
import com.mfnets.workfocus.common.persistence.Page;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.sys.entity.Param;
import com.mfnets.workfocus.modules.sys.service.ParamService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 系统参数controller
 *
 * @author Jonathan
 * @version 2016/5/9 17:35
 * @since JDK 7.0+
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/param")
public class ParamController extends BaseController {
    @Autowired
    private ParamService paramService;

    @RequiresPermissions("sys:param:view")
    @RequestMapping(value = {"list", ""})
    public String list(Param param, HttpServletRequest request, HttpServletResponse response, Model model) {
        List<String> paramNameList = paramService.findParamNameList();
        model.addAttribute("paramNameList", paramNameList);
        Page<Param> page = paramService.findPage(new Page<Param>(request, response), param);
        model.addAttribute("page", page);
        return "modules/sys/paramList";
    }
    @RequiresPermissions("sys:param:view")
    @RequestMapping(value = "form")
    public String form(Param param, Model model) {
        param = paramService.getParamByName(param.getName());
        if(param==null){
            param = new Param();
            model.addAttribute("param", param);
            return "modules/sys/paramForm";
        }
        model.addAttribute("param", param);
        return "modules/sys/paramForm";
    }

    @RequiresPermissions("sys:param:edit")
    @RequestMapping(value = "save")
    public String save(Param param, RedirectAttributes redirectAttributes) {
        Param param1 = paramService.getParamByName(param.getName());
        if(param1==null) {
            paramService.save(param);
            addMessage(redirectAttributes, "保存系统参数成功");
        } else{
            paramService.update(param);
            addMessage(redirectAttributes, "修改系统参数成功");
        }
        return "redirect:"+ Global.getAdminPath()+"/sys/param/?repage";
    }

   /**
     * 参数名是否重复检查
     * @param oldName
     * @param name
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "checkParamName")
    public String checkParamName(String oldName, String name) {
        if (name!=null && name.equals(oldName)) {
            return "true";
        } else if (name!=null && paramService.getParamByName(name) == null) {
            return "true";
        }
        return "false";
    }
}

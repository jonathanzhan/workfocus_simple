/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.web;

import com.mfnets.workfocus.common.config.Global;
import com.mfnets.workfocus.common.persistence.Page;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.sys.entity.Params;
import com.mfnets.workfocus.modules.sys.service.ParamsService;
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
@RequestMapping(value = "${adminPath}/sys/params")
public class ParamsController extends BaseController {
    @Autowired
    private ParamsService paramsService;

    @RequiresPermissions("sys:params:view")
    @RequestMapping(value = {"list", ""})
    public String list(Params params, HttpServletRequest request, HttpServletResponse response, Model model) {
        List<String> paramNameList = paramsService.findParamNameList();
        model.addAttribute("paramNameList", paramNameList);
        Page<Params> page = paramsService.findPage(new Page<Params>(request, response), params);
        model.addAttribute("page", page);
        return "modules/sys/paramsList";
    }
    @RequiresPermissions("sys:params:view")
    @RequestMapping(value = "form")
    public String form(Params params, Model model) {
        params = paramsService.getParamById(params.getParamName());
        if(params==null){
            params = new Params();
            model.addAttribute("params", params);
            return "modules/sys/paramsForm";
        }
        model.addAttribute("params", params);
        return "modules/sys/paramsForm";
    }

    @RequiresPermissions("sys:params:edit")
    @RequestMapping(value = "save")
    public String save(Params params, RedirectAttributes redirectAttributes) {
        Params params1 = paramsService.getParamById(params.getParamName());
        if(params1==null) {
            paramsService.save(params);
            addMessage(redirectAttributes, "保存系统参数成功");
        } else{
            paramsService.update(params);
            addMessage(redirectAttributes, "修改系统参数成功");
        }
        return "redirect:"+ Global.getAdminPath()+"/sys/params/?repage";
    }

   /**
     * 参数名是否重复检查
     * @param oldParamName
     * @param paramName
     * @return
     */
    @ResponseBody
    @RequestMapping(value = "checkParamName")
    public String checkParamName(String oldParamName, String paramName) {
        if (paramName!=null && paramName.equals(oldParamName)) {
            return "true";
        } else if (paramName!=null && paramsService.getParamById(paramName) == null) {
            return "true";
        }
        return "false";
    }
}

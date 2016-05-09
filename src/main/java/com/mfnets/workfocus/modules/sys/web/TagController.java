/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.web;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.mfnets.workfocus.common.web.BaseController;

/**
 * 标签Controller
 * @author Jonathan
 * @version 2016-3-23
 */
@Controller
@RequestMapping(value = "${adminPath}/tag")
public class TagController extends BaseController {
	
	/**
	 * 树结构选择标签（treeSelect.tag）
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "treeSelect")
	public String treeSelect(HttpServletRequest request, Model model) {
		model.addAttribute("url", request.getParameter("url")); 	// 树结构数据URL
		model.addAttribute("extId", request.getParameter("extId")); // 排除的编号ID
		model.addAttribute("checked", request.getParameter("checked")); // 是否可复选
		model.addAttribute("selectIds", request.getParameter("selectIds")); // 指定默认选中的ID
		model.addAttribute("isAll", request.getParameter("isAll")); 	// 是否读取全部数据，不进行权限过滤
		model.addAttribute("treeId",request.getParameter("treeId"));//标签的ID
		model.addAttribute("index",request.getParameter("index"));//父弹出层的index(用于弹出层中弹出树选择控件)
		model.addAttribute("iframeId",request.getParameter("iframeId"));//弹出层所在的iframe的Id(用于当前页面包含子iframe，并且弹出层在子iframe中)

		return "modules/sys/tagTreeSelect";
	}
	
	/**
	 * 图标选择标签（iconSelect.tag）
	 */
	@RequiresPermissions("user")
	@RequestMapping(value = "iconSelect")
	public String iconSelect(HttpServletRequest request, Model model) {
		model.addAttribute("value", request.getParameter("value"));
		return "modules/sys/tagIconSelect";
	}



}

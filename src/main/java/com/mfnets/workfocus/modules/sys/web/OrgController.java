/**
 * Copyright &copy; 2012-2014 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.web;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.mfnets.workfocus.common.config.Global;
import com.mfnets.workfocus.common.utils.StringUtils;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.sys.entity.Org;
import com.mfnets.workfocus.modules.sys.entity.User;
import com.mfnets.workfocus.modules.sys.service.OrgService;
import com.mfnets.workfocus.modules.sys.utils.UserUtils;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.Map;

/**
 * 机构Controller
 * @author ThinkGem
 * @version 2013-5-15
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/org")
public class OrgController extends BaseController {

	@Autowired
	private OrgService orgService;
	
	@ModelAttribute("org")
	public Org get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return orgService.get(id);
		}else{
			return new Org();
		}
	}

	@RequiresPermissions("sys:org:view")
	@RequestMapping(value = {""})
	public String index() {
		return "modules/sys/orgIndex";
	}

	@RequiresPermissions("sys:org:view")
	@RequestMapping(value = {"list"})
	public String list(Org org, Model model) {
        model.addAttribute("list", orgService.findList(org));
		return "modules/sys/orgList";
	}
	
	@RequiresPermissions("sys:org:view")
	@RequestMapping(value = "form")
	public String form(Org org, Model model) {
		User user = UserUtils.getUser();
		if (org.getParent()==null || org.getParent().getId()==null){
			org.setParent(new Org(Org.getRootId()));
		}
		org.setParent(orgService.get(org.getParent().getId()));

		// 自动获取排序号
		if (StringUtils.isBlank(org.getId())&&org.getParent()!=null){
			int size = 0;
			List<Org> list = orgService.findAll();
			for (int i=0; i<list.size(); i++){
				Org e = list.get(i);
				if (e.getParent()!=null && e.getParent().getId()!=null
						&& e.getParent().getId().equals(org.getParent().getId())){
					size++;
				}
			}
			org.setCode(org.getParent().getCode() + StringUtils.leftPad(String.valueOf(size > 0 ? size+1 : 1), 3, "0"));
		}
		model.addAttribute("org", org);
		return "modules/sys/orgForm";
	}
	
	@RequiresPermissions("sys:org:edit")
	@RequestMapping(value = "save")
	public String save(Org org, Model model, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/org/";
		}
		if (!beanValidator(model, org)){
			return form(org, model);
		}
		orgService.save(org);
		addMessage(redirectAttributes, "保存机构'" + org.getName() + "'成功");
		String id = "0".equals(org.getParentId()) ? "" : org.getParentId();
		return "redirect:" + adminPath + "/sys/org/list?id="+id+"&parentIds="+org.getParentIds();
	}
	
	@RequiresPermissions("sys:org:edit")
	@RequestMapping(value = "delete")
	public String delete(Org org, RedirectAttributes redirectAttributes) {
		if(Global.isDemoMode()){
			addMessage(redirectAttributes, "演示模式，不允许操作！");
			return "redirect:" + adminPath + "/sys/org/list";
		}
		if (Org.isRoot(org.getId())){
			addMessage(redirectAttributes, "删除机构失败, 不允许删除顶级机构或编号空");
		}else{
			orgService.delete(org);
			addMessage(redirectAttributes, "删除机构成功");
		}
		return "redirect:" + adminPath + "/sys/org/list?id="+org.getParentId()+"&parentIds="+org.getParentIds();
	}

	/**
	 * 获取机构JSON数据。
	 * @param extId 排除的ID
	 * @param type	类型（1：公司；2：部门/小组/其它：3：用户）
	 * @param response
	 * @return
	 */
	@RequiresPermissions("user")
	@ResponseBody
	@RequestMapping(value = "treeData")
	public List<Map<String, Object>> treeData(
			@RequestParam(required = false) String extId,
			@RequestParam(required = false) String type,
			@RequestParam(required = false) Boolean isAll,
			HttpServletResponse response) {
		List<Map<String, Object>> mapList = Lists.newArrayList();
		List<Org> list = orgService.findList(isAll);
		for (int i = 0; i < list.size(); i++) {
			Org e = list.get(i);
			if ((StringUtils.isBlank(extId) || (extId != null && !extId.equals(e.getId()) && e.getParentIds().indexOf("," + extId + ",") == -1))
					&& (type == null || (type != null && (type.equals("1") ? type.equals(e.getType()) : true)))){
				Map<String, Object> map = Maps.newHashMap();
				map.put("id", e.getId());
				map.put("pId", e.getParentId());
				map.put("pIds", e.getParentIds());
				map.put("name", e.getName());
				if (type != null && "3".equals(type)) {
					map.put("isParent", true);
				}
				mapList.add(map);
			}
		}
		return mapList;
	}
}

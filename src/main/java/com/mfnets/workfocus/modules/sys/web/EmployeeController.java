/**
 * Copyright &copy; 2012-2015 <a href="http://git.oschina.net/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.web;

import com.mfnets.workfocus.common.persistence.Page;
import com.mfnets.workfocus.common.utils.StringUtils;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.sys.entity.Employee;
import com.mfnets.workfocus.modules.sys.service.EmployeeService;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 员工Controller
 * @author ThinkGem
 * @version 2014-05-16
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/employee")
public class EmployeeController extends BaseController {

	@Autowired
	private EmployeeService employeeService;

	@ModelAttribute
	public Employee get(@RequestParam(required=false) String id) {
		if (StringUtils.isNotBlank(id)){
			return employeeService.get(id);
		}else{
			return new Employee();
		}
	}

	/**
	 * 员工管理分页
	 * @param employee
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys:employee:view")
	@RequestMapping(value = {"list", ""})
	public String list(Employee employee, HttpServletRequest request, HttpServletResponse response, Model model) {
        Page<Employee> page = employeeService.findPage(new Page<Employee>(request, response), employee);
        model.addAttribute("page", page);
		return "modules/sys/employeeList";
	}

	/**
	 * 员工管理from
	 * @param employee
	 * @param model
	 * @return
	 */
	@RequiresPermissions("sys:employee:view")
	@RequestMapping(value = "form")
	public String form(Employee employee, Model model) {
		if(employee.getSex()==null){
			employee.setSex(1);
		}
		if(employee.getIsOpenSys()==null){
			employee.setIsOpenSys(1);
		}
		model.addAttribute("employee", employee);
		return "modules/sys/employeeForm";
	}

	/**
	 * 员工信息保存
	 * @param employee
	 * @param model
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:employee:edit")
	@RequestMapping(value = "save")//@Valid 
	public String save(Employee employee, Model model, RedirectAttributes redirectAttributes) {
		if (!beanValidator(model, employee)){
			return form(employee, model);
		}
		employeeService.save(employee);
		addMessage(redirectAttributes, "保存员工'" + employee.getEmployeeCnm() + "'成功");
		return "redirect:" + adminPath + "/sys/employee/?repage";
	}

	/**
	 * 员工信息删除
	 * @param employee
	 * @param redirectAttributes
	 * @return
	 */
	@RequiresPermissions("sys:dict:edit")
	@RequestMapping(value = "delete")
	public String delete(Employee employee, RedirectAttributes redirectAttributes) {
		employeeService.delete(employee);
		addMessage(redirectAttributes, "删除员工成功");
		return "redirect:" + adminPath + "/sys/employee/?repage";
	}


	/**
	 * 员工编号是否重复检查
	 * @param oldEmployeeCd
	 * @param employeeCd
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "checkEmployeeCd")
	public String checkEmployeeCd(String oldEmployeeCd, String employeeCd) {
		if (employeeCd!=null && employeeCd.equals(oldEmployeeCd)) {
			return "true";
		} else if (employeeCd!=null && employeeService.getEmployeeByCd(employeeCd) == null) {
			return "true";
		}
		return "false";
	}

}

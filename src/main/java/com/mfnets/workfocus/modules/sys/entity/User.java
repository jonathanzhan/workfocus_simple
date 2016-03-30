/**
 * Copyright &copy; 2012-2015 <a href="http://git.oschina.net/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.entity;

import java.util.Date;
import java.util.List;

import javax.validation.constraints.NotNull;

import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.Length;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.google.common.collect.Lists;
import com.mfnets.workfocus.common.config.Global;
import com.mfnets.workfocus.common.persistence.DataEntity;
import com.mfnets.workfocus.common.utils.Collections3;
import com.mfnets.workfocus.common.utils.excel.annotation.ExcelField;
import com.mfnets.workfocus.common.utils.excel.fieldtype.RoleListType;

/**
 * 用户Entity
 * @author ThinkGem
 * @version 2013-12-05
 */
public class User extends DataEntity<User> {

	private static final long serialVersionUID = 1L;
	private String userName;// 登录名
	private String password;// 密码
	private Integer userType;// 用户类型
	private String name;//用户名称

	private String img;	// 头像
	private String oldLoginName;// 原登录名
	private String newPassword;	// 新密码

	private String thisLoginIp;	// 最后登陆IP
	private Date thisLoginAt;	// 最后登陆日期



	private String lastLoginIp;	// 上次登陆IP
	private Date lastLoginAt;	// 上次登陆日期
	
	private Role role;	// 根据角色查询用户条件

	private Employee employee;// 员工信息
	
	private List<Role> roleList = Lists.newArrayList(); // 拥有角色列表

	public User() {
		super();
	}
	
	public User(String id){
		super(id);
	}

	public User(String id, String userName){
		super(id);
		this.userName = userName;
	}

	public User(Role role){
		super();
		this.role = role;
	}


	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}


	public String getId() {
		return id;
	}

	@Length(min=1, max=50, message="登录名长度必须介于 1 和 50 之间")
	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}




	@JsonIgnore
	@Length(min=1, max=100, message="密码长度必须介于 1 和 100 之间")
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}



//	@Email(message="邮箱格式不正确")
//	@Length(min=0, max=200, message="邮箱长度必须介于 1 和 200 之间")
//	@ExcelField(title="邮箱", align=1, sort=50)
//	public String getEmail() {
//		return email;
//	}
//
//	public void setEmail(String email) {
//		this.email = email;
//	}
//
//	@Length(min=0, max=200, message="电话长度必须介于 1 和 200 之间")
//	@ExcelField(title="电话", align=2, sort=60)
//	public String getPhone() {
//		return phone;
//	}
//
//	public void setPhone(String phone) {
//		this.phone = phone;
//	}
//
//	@Length(min=0, max=200, message="手机长度必须介于 1 和 200 之间")
//	@ExcelField(title="手机", align=2, sort=70)
//	public String getMobile() {
//		return mobile;
//	}
//
//	public void setMobile(String mobile) {
//		this.mobile = mobile;
//	}



	public Integer getUserType() {
		return userType;
	}

	public void setUserType(Integer userType) {
		this.userType = userType;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@JsonIgnore
	public String getThisLoginIp() {
		return thisLoginIp;
	}

	public void setThisLoginIp(String thisLoginIp) {
		this.thisLoginIp = thisLoginIp;
	}

	@JsonIgnore
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getThisLoginAt() {
		return thisLoginAt;
	}

	public void setThisLoginAt(Date thisLoginAt) {
		this.thisLoginAt = thisLoginAt;
	}

	@JsonIgnore
	public String getLastLoginIp() {
		return lastLoginIp;
	}

	public void setLastLoginIp(String lastLoginIp) {
		this.lastLoginIp = lastLoginIp;
	}

	@JsonIgnore
	@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date getLastLoginAt() {
		return lastLoginAt;
	}

	public void setLastLoginAt(Date lastLoginAt) {
		this.lastLoginAt = lastLoginAt;
	}


	public String getOldLoginName() {
		return oldLoginName;
	}

	public void setOldLoginName(String oldLoginName) {
		this.oldLoginName = oldLoginName;
	}

	public String getNewPassword() {
		return newPassword;
	}

	public void setNewPassword(String newPassword) {
		this.newPassword = newPassword;
	}


	public Role getRole() {
		return role;
	}

	public void setRole(Role role) {
		this.role = role;
	}

	@JsonIgnore
	public List<Role> getRoleList() {
		return roleList;
	}
	
	public void setRoleList(List<Role> roleList) {
		this.roleList = roleList;
	}

	@JsonIgnore
	public List<String> getRoleIdList() {
		List<String> roleIdList = Lists.newArrayList();
		for (Role role : roleList) {
			roleIdList.add(role.getId());
		}
		return roleIdList;
	}

	public void setRoleIdList(List<String> roleIdList) {
		roleList = Lists.newArrayList();
		for (String roleId : roleIdList) {
			Role role = new Role();
			role.setId(roleId);
			roleList.add(role);
		}
	}
	
	/**
	 * 用户拥有的角色名称字符串, 多个角色名称用','分隔.
	 */
	public String getRoleNames() {
		return Collections3.extractToString(roleList, "name", ",");
	}
	
	public boolean isAdmin(){
		return isAdmin(this.id);
	}
	
	public static boolean isAdmin(String id){
		return id != null && "1".equals(id);
	}
	
	@Override
	public String toString() {
		return id;
	}

	public Employee getEmployee() {
		return employee;
	}

	public void setEmployee(Employee employee) {
		this.employee = employee;
	}
}
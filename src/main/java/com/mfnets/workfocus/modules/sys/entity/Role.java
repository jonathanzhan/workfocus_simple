/**
 * Copyright &copy; 2012-2015 <a href="http://git.oschina.net/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.entity;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.validator.constraints.Length;

import com.google.common.collect.Lists;
import com.mfnets.workfocus.common.config.Global;
import com.mfnets.workfocus.common.persistence.DataEntity;

import javax.validation.constraints.NotNull;

/**
 * 角色Entity
 * @author ThinkGem
 * @version 2013-12-05
 */
public class Role extends DataEntity<Role> {
	
	private static final long serialVersionUID = 1L;
	private String name; 	// 角色名称
	private String ename;	// 英文名称
	private int isSys; //是否系统设置

	private String roleType;//角色类型

	private int dataScope;//数据范围


	private String oldName; 	// 原角色名称（判断重复使用）
	private String oldEname;	// 原英文名称（判断重复使用）

	
	private User user;		// 根据用户ID查询角色列表

	private List<Menu> menuList = Lists.newArrayList(); // 拥有菜单列表

//	// 数据范围（1：所有数据；2：所在公司及以下数据；3：所在公司数据；4：所在部门及以下数据；5：所在部门数据；8：仅本人数据；9：按明细设置）
//	public static final String DATA_SCOPE_ALL = "1";
//	public static final String DATA_SCOPE_COMPANY_AND_CHILD = "2";
//	public static final String DATA_SCOPE_COMPANY = "3";
//	public static final String DATA_SCOPE_OFFICE_AND_CHILD = "4";
//	public static final String DATA_SCOPE_OFFICE = "5";
//	public static final String DATA_SCOPE_SELF = "8";
//	public static final String DATA_SCOPE_CUSTOM = "9";
	
	public Role() {
		super();
	}
	
	public Role(String id){
		super(id);
	}
	
	public Role(User user) {
		this();
		this.user = user;
	}


	public String getRoleType() {
		return roleType;
	}

	public void setRoleType(String roleType) {
		this.roleType = roleType;
	}
	@Length(min=1, max=20)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Length(min=1, max=20)
	public String getEname() {
		return ename;
	}

	public void setEname(String ename) {
		this.ename = ename;
	}


	@NotNull
	public int getIsSys() {
		return isSys;
	}

	public void setIsSys(int isSys) {
		this.isSys = isSys;
	}


	@NotNull
	public int getDataScope() {
		return dataScope;
	}

	public void setDataScope(int dataScope) {
		this.dataScope = dataScope;
	}

	public String getOldEname() {
		return oldEname;
	}

	public void setOldEname(String oldEname) {
		this.oldEname = oldEname;
	}

	public String getOldName() {
		return oldName;
	}

	public void setOldName(String oldName) {
		this.oldName = oldName;
	}



	public List<Menu> getMenuList() {
		return menuList;
	}

	public void setMenuList(List<Menu> menuList) {
		this.menuList = menuList;
	}

	public List<String> getMenuIdList() {
		List<String> menuIdList = Lists.newArrayList();
		for (Menu menu : menuList) {
			menuIdList.add(menu.getId());
		}
		return menuIdList;
	}

	public void setMenuIdList(List<String> menuIdList) {
		menuList = Lists.newArrayList();
		for (String menuId : menuIdList) {
			Menu menu = new Menu();
			menu.setId(menuId);
			menuList.add(menu);
		}
	}


	public String getMenuIds() {
		return StringUtils.join(getMenuIdList(), ",");
	}


	public void setMenuIds(String menuIds) {
		menuList = Lists.newArrayList();
		if (menuIds != null){
			String[] ids = StringUtils.split(menuIds, ",");
			setMenuIdList(Lists.newArrayList(ids));
		}
	}

	


	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}


}

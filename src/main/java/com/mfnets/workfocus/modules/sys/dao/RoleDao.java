/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.dao;

import com.mfnets.workfocus.common.persistence.CrudDao;
import com.mfnets.workfocus.common.persistence.annotation.MyBatisDao;
import com.mfnets.workfocus.modules.sys.entity.Role;

import java.util.List;

/**
 * 角色DAO接口
 * @author Jonathan
 * @version 2013-12-05
 */
@MyBatisDao
public interface RoleDao extends CrudDao<Role> {

	@Override
	Role get(String id);

	@Override
	List<Role> findList(Role role);

	@Override
	List<Role> findAllList(Role role);

	@Override
	int insert(Role role);

	@Override
	int update(Role role);

	@Override
	int delete(Role role);


	Role getByName(Role role);
	
	Role getByEname(Role role);

	/**
	 * 维护角色与菜单权限关系
	 * @param role
	 * @return
	 */
	int deleteRoleMenu(Role role);

	int insertRoleMenu(Role role);


	/**
	 * 维护角色与公司部门关系
	 * @param role
	 * @return
	 */
	public int deleteRoleOrg(Role role);

	public int insertRoleOrg(Role role);

}

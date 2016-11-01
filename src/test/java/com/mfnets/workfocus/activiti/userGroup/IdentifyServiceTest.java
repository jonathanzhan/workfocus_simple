/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.activiti.userGroup;

import org.activiti.engine.IdentityService;
import org.activiti.engine.identity.Group;
import org.activiti.engine.identity.User;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

/**
 * 用户 用户组
 *
 * @author Jonathan
 * @version 2016/10/28 11:36
 * @since JDK 7.0+
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext-test.xml")
public class IdentifyServiceTest {

	@Autowired
	private IdentityService identityService;

	/**
	 * 用户管理
	 */
	@Test
	public void testUser(){
		User user = identityService.newUser("Jonathan");
		user.setFirstName("Jonathan");
		user.setLastName("chang");
		user.setEmail("whatlookingfor@gmail.com");
		user.setPassword("123");
		//保存用户到数据库
		identityService.saveUser(user);
		//用户的查询
		User userInDb = identityService.createUserQuery().userId("Jonathan").singleResult();
		Assert.notNull(userInDb);
		//验证用户名和密码
		Assert.isTrue(identityService.checkPassword("Jonathan","123"));

		//删除用户
		identityService.deleteUser("Jonathan");

		//验证是否删除成功
		userInDb = identityService.createUserQuery().userId("Jonathan").singleResult();
		Assert.isNull(userInDb);
	}

	/**
	 * 用户组管理
	 */
	@Test
	public void testGroup(){
		//创建用户组对象
		Group group = identityService.newGroup("hr");
		group.setName("hr用户组");
		group.setType("assignment");
		//保存用户组
		identityService.saveGroup(group);
		//验证是否保存成功
		Group groupInDb = identityService.createGroupQuery().groupId("hr").singleResult();
		Assert.notNull(groupInDb);
		//删除用户组
		identityService.deleteGroup("hr");
		//验证是否删除成功
		groupInDb = identityService.createGroupQuery().groupId("hr").singleResult();
		Assert.isNull(groupInDb);
	}


	/**
	 * 用户 用户组管理
	 */
	@Test
	public void testUserAndGroupMemership(){
		//创建并保存用户组
		Group group = identityService.newGroup("hr");
		group.setName("hr用户组");
		group.setType("assignment");
		//保存用户组
		identityService.saveGroup(group);

		User user = identityService.newUser("Jonathan");
		user.setFirstName("Jonathan");
		user.setLastName("chang");
		user.setEmail("whatlookingfor@gmail.com");
		user.setPassword("123");
		//保存用户到数据库
		identityService.saveUser(user);

		//将用户Jonathan加入到用户组hr中
		identityService.createMembership("Jonathan","hr");

		//查询属于HR用户组的用户
		User userInGroup = identityService.createUserQuery().memberOfGroup("hr").singleResult();
		Assert.notNull(userInGroup);
		Assert.isTrue(userInGroup.getId().equals("Jonathan"));
		//查询用户所属组
		Group groupContainsUser = identityService.createGroupQuery().groupMember("Jonathan").singleResult();
		Assert.notNull(groupContainsUser);
		Assert.isTrue(groupContainsUser.getId().equals("hr"));
	}




}

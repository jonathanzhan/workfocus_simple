/*
 * Copyright  2014-2016 whatlookingfor@gmail.com(Jonathan)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.mfnets.workfocus.modules.act.service.ext;

import com.google.common.collect.Lists;
import com.mfnets.workfocus.common.utils.SpringContextHolder;
import com.mfnets.workfocus.modules.act.utils.ActUtils;
import com.mfnets.workfocus.modules.sys.entity.Role;
import com.mfnets.workfocus.modules.sys.service.SystemService;
import org.activiti.engine.identity.Group;
import org.activiti.engine.identity.User;
import org.activiti.engine.identity.UserQuery;
import org.activiti.engine.impl.Page;
import org.activiti.engine.impl.UserQueryImpl;
import org.activiti.engine.impl.persistence.entity.IdentityInfoEntity;
import org.activiti.engine.impl.persistence.entity.UserEntity;
import org.activiti.engine.impl.persistence.entity.UserEntityManager;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * activiti的user和group与业务数据的同步
 * 主要有两种方式:
 * 1、调用IdentifyService接口完成同步
 * 2、自定义sessionFactory
 * 本系统用的是第二种方式
 * 用户的统一接口访问
 * @author Jonathan
 * @version 2016/9/14 16:51
 * @since JDK 7.0+
 */
@Service
public class ActUserEntityService extends UserEntityManager {

	private SystemService systemService;

	public SystemService getSystemService() {
		if (systemService == null){
			systemService = SpringContextHolder.getBean(SystemService.class);
		}
		return systemService;
	}

	public User createNewUser(String userId) {
		return new UserEntity(userId);
	}

	public void insertUser(User user) {
		throw new RuntimeException("not implement method.");
	}

	public void updateUser(UserEntity updatedUser) {
		throw new RuntimeException("not implement method.");
	}


	public UserEntity findUserById(String userId) {
		return ActUtils.toActivitiUser(getSystemService().getUserByLoginName(userId));
	}

	public void deleteUser(String userId) {
		User user = findUserById(userId);
		if (user != null) {
			getSystemService().deleteUser(new com.mfnets.workfocus.modules.sys.entity.User(user.getId()));
		}
	}

	public List<User> findUserByQueryCriteria(UserQueryImpl query, Page page) {
		throw new RuntimeException("not implement method.");
	}

	public long findUserCountByQueryCriteria(UserQueryImpl query) {
		throw new RuntimeException("not implement method.");
	}

	public List<Group> findGroupsByUser(String userId) {
		List<Group> list = Lists.newArrayList();
		for (Role role : getSystemService().findRole(new Role(new com.mfnets.workfocus.modules.sys.entity.User(null, userId)))){
			list.add(ActUtils.toActivitiGroup(role));
		}
		return list;
	}

	public UserQuery createNewUserQuery() {
		throw new RuntimeException("not implement method.");
	}

	public IdentityInfoEntity findUserInfoByUserIdAndKey(String userId, String key) {
		throw new RuntimeException("not implement method.");
	}

	public List<String> findUserInfoKeysByUserIdAndType(String userId, String type) {
		throw new RuntimeException("not implement method.");
	}

	public Boolean checkPassword(String userId, String password) {
		throw new RuntimeException("not implement method.");
	}

	public List<User> findPotentialStarterUsers(String proceDefId) {
		throw new RuntimeException("not implement method.");

	}

	public List<User> findUsersByNativeQuery(Map<String, Object> parameterMap, int firstResult, int maxResults) {
		throw new RuntimeException("not implement method.");
	}

	public long findUserCountByNativeQuery(Map<String, Object> parameterMap) {
		throw new RuntimeException("not implement method.");
	}
	
}

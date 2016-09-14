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

import org.activiti.engine.impl.interceptor.Session;
import org.activiti.engine.impl.interceptor.SessionFactory;
import org.activiti.engine.impl.persistence.entity.GroupIdentityManager;
import org.springframework.beans.factory.annotation.Autowired;

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
public class ActGroupEntityServiceFactory implements SessionFactory {
	
	@Autowired
	private ActGroupEntityService actGroupEntityService;
	
	public Class<?> getSessionType() {
		// 返回原始的GroupIdentityManager类型
		return GroupIdentityManager.class;
	}

	public Session openSession() {
		// 返回自定义的GroupEntityManager实例
		return actGroupEntityService;
	}

}

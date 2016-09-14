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
package com.mfnets.workfocus.modules.act.utils;

import com.mfnets.workfocus.common.config.Global;
import com.mfnets.workfocus.common.utils.CacheUtils;
import com.mfnets.workfocus.common.utils.Encodes;
import com.mfnets.workfocus.common.utils.SpringContextHolder;
import com.mfnets.workfocus.common.utils.StringUtils;
import com.mfnets.workfocus.modules.act.entity.Act;
import com.mfnets.workfocus.modules.sys.entity.Role;
import com.mfnets.workfocus.modules.sys.entity.User;
import org.activiti.engine.RepositoryService;
import org.activiti.engine.impl.persistence.entity.GroupEntity;
import org.activiti.engine.impl.persistence.entity.ProcessDefinitionEntity;
import org.activiti.engine.impl.persistence.entity.UserEntity;
import org.activiti.engine.impl.pvm.process.ActivityImpl;
import org.activiti.engine.repository.ProcessDefinition;
import org.apache.commons.lang3.ObjectUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.List;
import java.util.Map;


/**
 * 流程的工具类
 * 包含获取流程表单的formKey,获取流程定义对象,系统用户角色转换为流程的用户,用户组对象等方法
 *
 * @author Jonathan
 * @version 2016/9/14 10:47
 * @since JDK 7.0+
 */
public class ActUtils {

	private static final Logger logger = LoggerFactory.getLogger(ActUtils.class);



	private static final String ACT_CACHE = "actCache";
	private static final String ACT_CACHE_PD_ID_ = "pd_id_";


	/**
	 * 获得流程定义对象
	 * @param procDefId
	 * @return
	 */
	public static ProcessDefinition getProcessDefinition(String procDefId) {
		ProcessDefinition pd = (ProcessDefinition) CacheUtils.get(ACT_CACHE, ACT_CACHE_PD_ID_ + procDefId);
		if (pd == null) {
			RepositoryService repositoryService = SpringContextHolder.getBean(RepositoryService.class);
			pd = repositoryService.createProcessDefinitionQuery().processDefinitionId(procDefId).singleResult();
			if (pd != null) {
				CacheUtils.put(ACT_CACHE, ACT_CACHE_PD_ID_ + procDefId, pd);
			}
		}
		return pd;
	}


	/**
	 * 获得流程定义的所有活动节点
	 * @param procDefId
	 * @return
	 */
	public static List<ActivityImpl> getActivities(String procDefId) {
		ProcessDefinition pd = getProcessDefinition(procDefId);
		if (pd != null) {
			return ((ProcessDefinitionEntity) pd).getActivities();
		}
		return null;
	}

	/**
	 * 获取流程定义活动节点名称
	 * @param procDefId
	 * @param activityId
	 * @return
	 */
	@SuppressWarnings("deprecation")
	public static String getActivityName(String procDefId, String activityId) {
		ActivityImpl activity = getActivity(procDefId, activityId);
		if (activity != null) {
			return ObjectUtils.toString(activity.getProperty("name"));
		}
		return null;
	}

	/**
	 * 获得流程定义活动节点
	 * @param procDefId
	 * @param activityId
	 * @return
	 */
	public static ActivityImpl getActivity(String procDefId, String activityId) {
		ProcessDefinition pd = getProcessDefinition(procDefId);
		if (pd != null) {
			List<ActivityImpl> list = getActivities(procDefId);
			if (list != null){
				for (ActivityImpl activityImpl : list) {
					if (activityId.equals(activityImpl.getId())){
						return activityImpl;
					}
				}
			}
		}
		return null;
	}


	/**
	 * 获取流程表单URL
	 * @param formKey
	 * @param act 表单传递参数
	 * @return
	 */
	public static String getFormUrl(String formKey, Act act){
		
		StringBuilder formUrl = new StringBuilder();
		
		String formServerUrl = Global.getConfig("activiti.form.server.url");
		if (StringUtils.isBlank(formServerUrl)){
			formUrl.append(Global.getAdminPath());
		}else{
			formUrl.append(formServerUrl);
		}
		
		formUrl.append(formKey).append(formUrl.indexOf("?") == -1 ? "?" : "&");
		formUrl.append("act.taskId=").append(act.getTaskId() != null ? act.getTaskId() : "");
		formUrl.append("&act.taskName=").append(act.getTaskName() != null ? Encodes.urlEncode(act.getTaskName()) : "");
		formUrl.append("&act.taskDefKey=").append(act.getTaskDefKey() != null ? act.getTaskDefKey() : "");
		formUrl.append("&act.procInsId=").append(act.getProcInsId() != null ? act.getProcInsId() : "");
		formUrl.append("&act.procDefId=").append(act.getProcDefId() != null ? act.getProcDefId() : "");
		formUrl.append("&act.status=").append(act.getStatus() != null ? act.getStatus() : "");
		formUrl.append("&id=").append(act.getBusinessId() != null ? act.getBusinessId() : "");
		logger.debug("formUrl:{}",formUrl.toString());
		return formUrl.toString();
	}
	
	/**
	 * 转换流程节点类型为中文说明
	 * @param type 英文名称
	 * @return 翻译后的中文名称
	 */
	public static String parseToZhType(String type) {
		Map<String, String> types = new HashMap<String, String>();
		types.put("userTask", "用户任务");
		types.put("serviceTask", "系统任务");
		types.put("startEvent", "开始节点");
		types.put("endEvent", "结束节点");
		types.put("exclusiveGateway", "条件判断节点(系统自动根据条件处理)");
		types.put("inclusiveGateway", "并行处理任务");
		types.put("callActivity", "子流程");
		return types.get(type) == null ? type : types.get(type);
	}

	/**
	 * 将用户信息转换为工作流的用户信息
	 * @param user
	 * @return
	 */
	public static UserEntity toActivitiUser(User user){
		if (user == null){
			return null;
		}
		UserEntity userEntity = new UserEntity();
		userEntity.setId(user.getLoginName());
		userEntity.setFirstName(user.getName());
		userEntity.setLastName(StringUtils.EMPTY);
		userEntity.setPassword(user.getPassword());
		userEntity.setEmail(StringUtils.EMPTY);
		userEntity.setRevision(1);
		return userEntity;
	}

	/**
	 * 将角色信息转换为工作流的用户组
	 * @param role
	 * @return
	 */
	public static GroupEntity toActivitiGroup(Role role){
		if (role == null){
			return null;
		}
		GroupEntity groupEntity = new GroupEntity();
		groupEntity.setId(role.getEname());
		groupEntity.setName(role.getName());
		groupEntity.setType(role.getRoleType());
		groupEntity.setRevision(1);
		return groupEntity;
	}
	
}

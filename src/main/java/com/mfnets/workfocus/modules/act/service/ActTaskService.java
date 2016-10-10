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
package com.mfnets.workfocus.modules.act.service;

import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import com.mfnets.workfocus.common.mapper.JsonMapper;
import com.mfnets.workfocus.common.persistence.Page;
import com.mfnets.workfocus.common.service.BaseService;
import com.mfnets.workfocus.common.utils.DateUtils;
import com.mfnets.workfocus.common.utils.StringUtils;
import com.mfnets.workfocus.modules.act.dao.ActDao;
import com.mfnets.workfocus.modules.act.entity.Act;
import com.mfnets.workfocus.modules.act.entity.ActBusiness;
import com.mfnets.workfocus.modules.act.utils.ActUtils;
import com.mfnets.workfocus.modules.sys.entity.User;
import com.mfnets.workfocus.modules.sys.utils.UserUtils;
import org.activiti.bpmn.model.BpmnModel;
import org.activiti.engine.*;
import org.activiti.engine.history.HistoricActivityInstance;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricTaskInstance;
import org.activiti.engine.history.HistoricTaskInstanceQuery;
import org.activiti.engine.impl.context.Context;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.task.*;
import org.activiti.image.ProcessDiagramGenerator;
import org.activiti.spring.ProcessEngineFactoryBean;
import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;


/**
 * 流程的任务的事物层
 *
 * @author Jonathan
 * @version 2016/9/14 16:45
 * @since JDK 7.0+
 */
@Service
@Transactional(readOnly = true)
public class ActTaskService extends BaseService {

	@Autowired
	private ActDao actDao;
	
	@Autowired
	private ProcessEngineFactoryBean processEngine;


	@Autowired
	private RuntimeService runtimeService;
	@Autowired
	private TaskService taskService;
	@Autowired
	private FormService formService;
	@Autowired
	private HistoryService historyService;
	@Autowired
	private RepositoryService repositoryService;
	@Autowired
	private IdentityService identityService;
	@Autowired
	private ProcessEngineConfiguration processEngineConfiguration;

	/**
	 * 获取待签收的任务列表
	 * @param act 流程定义标识
	 * @return 待签收的任务列表
	 */
	public List<Act> claimList(Act act){
		String userId = UserUtils.getUser().getLoginName();//ObjectUtils.toString(UserUtils.getUser().getId());

		List<Act> result = new ArrayList<Act>();


		// =============== 等待签收的任务  ===============
		TaskQuery toClaimQuery = taskService.createTaskQuery().taskCandidateUser(userId)
				.includeProcessVariables().active().orderByTaskCreateTime().desc();

		// 设置查询条件
		if (StringUtils.isNotBlank(act.getProcDefKey())){
			toClaimQuery.processDefinitionKey(act.getProcDefKey());
		}
		if (act.getBeginDate() != null){
			toClaimQuery.taskCreatedAfter(act.getBeginDate());
		}
		if (act.getEndDate() != null){
			toClaimQuery.taskCreatedBefore(act.getEndDate());
		}

		// 查询列表
		List<Task> toClaimList = toClaimQuery.list();
		for (Task task : toClaimList) {
			Act e = new Act();
			e.setTask(task);
			e.setVars(task.getProcessVariables());
//			e.setTaskVars(task.getTaskLocalVariables());
			e.setProcDef(ActUtils.getProcessDefinition(task.getProcessDefinitionId()));
			e.setStatus("claim");
			result.add(e);
		}
		return result;
	}

	public List<Task> todoList(){
		String userId = UserUtils.getUser().getLoginName();
		// 读取直接分配给当前人或者已经签收的任务
		List<Task> doingTasks = taskService.createTaskQuery().taskAssignee(userId).list();

		// 等待签收的任务--废弃，用taskInvolvedUser代替
		// List<Task> waitingClaimTasks =
		// taskService.createTaskQuery().taskCandidateUser(user.getId()).list();

//		// 受邀任务
//		List<Task> involvedTasks = taskService.createTaskQuery().taskInvolvedUser(userId).list();

		// 合并两种任务
		List<Task> allTasks = new ArrayList<Task>();
		allTasks.addAll(doingTasks);
		// allTasks.addAll(waitingClaimTasks);
//		allTasks.addAll(involvedTasks);
		return allTasks;
	}

	/**
	 * 获取待办列表
	 * @param act 流程定义标识
	 * @return
	 */
	public List<Act> todoList(Act act){
		String userId = UserUtils.getUser().getLoginName();//ObjectUtils.toString(UserUtils.getUser().getId());

		List<Act> result = new ArrayList<Act>();

		// =============== 已经签收的任务  ===============
		TaskQuery todoTaskQuery = taskService.createTaskQuery().taskAssignee(userId).active()
				.includeProcessVariables().orderByTaskCreateTime().desc();


		// 设置查询条件
		if (StringUtils.isNotBlank(act.getProcDefKey())){
			todoTaskQuery.processDefinitionKey(act.getProcDefKey());
		}
		if (act.getBeginDate() != null){
			todoTaskQuery.taskCreatedAfter(act.getBeginDate());
		}
		if (act.getEndDate() != null){
			todoTaskQuery.taskCreatedBefore(act.getEndDate());
		}

		// 查询列表
		List<Task> todoList = todoTaskQuery.list();
		for (Task task : todoList) {
			Act e = new Act();
			e.setTask(task);

			e.setVars(task.getProcessVariables());

		 	ProcessInstance processInstance = runtimeService.createProcessInstanceQuery().processInstanceId(task.getProcessInstanceId()).singleResult();
			e.setProcIns(processInstance);
			logger.debug(task.getId()+"  =  "+task.getProcessVariables() + "  ========== " + task.getTaskLocalVariables());
			e.setProcDef(ActUtils.getProcessDefinition(task.getProcessDefinitionId()));
			e.setStatus("todo");
			result.add(e);
		}

		return result;
	}

	/**
	 * 获取已办任务
	 * @param page
	 * @param act 流程定义标识
	 * @return
	 */
	public Page<Act> historicList(Page<Act> page, Act act){
		String userId = UserUtils.getUser().getLoginName();

		HistoricTaskInstanceQuery histTaskQuery = historyService.createHistoricTaskInstanceQuery().taskAssignee(userId).finished()
				.includeProcessVariables().orderByHistoricTaskInstanceEndTime().desc();

		// 设置查询条件
		if (StringUtils.isNotBlank(act.getProcDefKey())){
			histTaskQuery.processDefinitionKey(act.getProcDefKey());
		}
		if (act.getBeginDate() != null){
			histTaskQuery.taskCompletedAfter(act.getBeginDate());
		}
		if (act.getEndDate() != null){
			histTaskQuery.taskCompletedBefore(act.getEndDate());
		}

		// 查询总数
		page.setCount(histTaskQuery.count());

		// 查询列表
		List<HistoricTaskInstance> histList = histTaskQuery.listPage(page.getFirstResult(), page.getMaxResults());
		for (HistoricTaskInstance histTask : histList) {
			Act e = new Act();
			e.setHistTask(histTask);
			e.setVars(histTask.getProcessVariables());
			e.setProcDef(ActUtils.getProcessDefinition(histTask.getProcessDefinitionId()));
//			e.setProcIns(runtimeService.createProcessInstanceQuery().processInstanceId(task.getProcessInstanceId()).singleResult());
			e.setStatus("finish");
			page.getList().add(e);
		}
		return page;
	}

	/**
	 * 获取流转历史列表
	 * @param procInsId 流程实例
	 * @param startAct 开始活动节点名称
	 * @param endAct 结束活动节点名称
	 */
	public List<Act> histoicFlowList(String procInsId, String startAct, String endAct){
		List<Act> actList = Lists.newArrayList();
		List<HistoricActivityInstance> list = historyService.createHistoricActivityInstanceQuery().processInstanceId(procInsId)
				.orderByHistoricActivityInstanceStartTime().asc().orderByHistoricActivityInstanceEndTime().asc().list();
		
		boolean start = false;
		Map<String, Integer> actMap = Maps.newHashMap();
		
		for (int i=0; i<list.size(); i++){
			
			HistoricActivityInstance histIns = list.get(i);
			
			// 过滤开始节点前的节点
			if (StringUtils.isNotBlank(startAct) && startAct.equals(histIns.getActivityId())){
				start = true;
			}
			if (StringUtils.isNotBlank(startAct) && !start){
				continue;
			}
			
			// 只显示开始节点和结束节点，并且执行人不为空的任务
			if (StringUtils.isNotBlank(histIns.getAssignee())
					 || "startEvent".equals(histIns.getActivityType())
					 || "endEvent".equals(histIns.getActivityType())){
				
				// 给节点增加一个序号
				Integer actNum = actMap.get(histIns.getActivityId());
				if (actNum == null){
					actMap.put(histIns.getActivityId(), actMap.size());
				}
				
				Act e = new Act();
				e.setHistIns(histIns);
				// 获取流程发起人名称
				if ("startEvent".equals(histIns.getActivityType())){
					List<HistoricProcessInstance> il = historyService.createHistoricProcessInstanceQuery().processInstanceId(procInsId).orderByProcessInstanceStartTime().asc().list();
//					List<HistoricIdentityLink> il = historyService.getHistoricIdentityLinksForProcessInstance(procInsId);
					if (il.size() > 0){
						if (StringUtils.isNotBlank(il.get(0).getStartUserId())){
							User user = UserUtils.getByLoginName(il.get(0).getStartUserId());
							if (user != null){
								e.setAssignee(histIns.getAssignee());
								e.setAssigneeName(user.getName());
							}
						}
					}
				}
				// 获取任务执行人名称
				if (StringUtils.isNotEmpty(histIns.getAssignee())){
					User user = UserUtils.getByLoginName(histIns.getAssignee());
					if (user != null){
						e.setAssignee(histIns.getAssignee());
						e.setAssigneeName(user.getName());
					}
				}
				// 获取意见评论内容
				if (StringUtils.isNotBlank(histIns.getTaskId())){
					List<Comment> commentList = taskService.getTaskComments(histIns.getTaskId());
					if (commentList.size()>0){
						e.setComment(commentList.get(0).getFullMessage());
					}
				}
				actList.add(e);
			}
			
			// 过滤结束节点后的节点
			if (StringUtils.isNotBlank(endAct) && endAct.equals(histIns.getActivityId())){
				boolean bl = false;
				Integer actNum = actMap.get(histIns.getActivityId());
				// 该活动节点，后续节点是否在结束节点之前，在后续节点中是否存在
				for (int j=i+1; j<list.size(); j++){
					HistoricActivityInstance hi = list.get(j);
					Integer actNumA = actMap.get(hi.getActivityId());
					if ((actNumA != null && actNumA < actNum) || StringUtils.equals(hi.getActivityId(), histIns.getActivityId())){
						bl = true;
					}
				}
				if (!bl){
					break;
				}
			}
		}
		return actList;
	}

	
	/**
	 * 获取流程实例对象
	 * @param procInsId
	 * @return
	 */
	@Transactional(readOnly = false)
	public ProcessInstance getProcIns(String procInsId) {
		return runtimeService.createProcessInstanceQuery().processInstanceId(procInsId).singleResult();
	}

	/**
	 * 启动流程
	 * @param procDefKey 流程定义KEY
	 * @return 流程实例ID
	 */
	@Transactional(readOnly = false)
	public String startProcess(String procDefKey) {
		return startProcess(procDefKey, null);
	}


	/**
	 * 启动流程
	 * @param procDefKey 流程定义KEY
	 * @param actBusiness 业务表相关字段或者SQL片段
	 * @return 流程实例ID
	 */
	@Transactional(readOnly = false)
	public String startProcess(String procDefKey, ActBusiness actBusiness) {
		return startProcess(procDefKey, actBusiness, "");
	}
	
	/**
	 * 启动流程
	 * @param procDefKey 流程定义KEY
	 * @param actBusiness 业务表相关字段或者SQL片段
	 * @param title			流程标题，显示在待办任务标题
	 * @return 流程实例ID
	 */
	@Transactional(readOnly = false)
	public String startProcess(String procDefKey, ActBusiness actBusiness, String title) {
		Map<String, Object> vars = Maps.newHashMap();
		return startProcess(procDefKey, actBusiness, title, vars);
	}
	
	/**
	 * 启动流程
	 * @param procDefKey 流程定义KEY
	 * @param actBusiness 业务表相关字段或者SQL片段
	 * @param title			流程标题，显示在待办任务标题
	 * @param vars			流程变量
	 * @return 流程实例ID
	 */
	@Transactional(readOnly = false)
	public String startProcess(String procDefKey, ActBusiness actBusiness, String title, Map<String, Object> vars) {
		String userId = UserUtils.getUser().getLoginName();//ObjectUtils.toString(UserUtils.getUser().getId())
		
		// 用来设置启动流程的人员ID，引擎会自动把用户ID保存到activiti:initiator中
		identityService.setAuthenticatedUserId(userId);
		
		// 设置流程变量
		if (vars == null){
			vars = Maps.newHashMap();
		}
		
		// 设置流程标题
		if (StringUtils.isNotBlank(title)){
			vars.put("title", title);
		}

		// 启动流程
		ProcessInstance procIns = runtimeService.startProcessInstanceByKey(procDefKey, vars);
		// 更新业务表流程实例ID
		if(actBusiness!=null){
			if(
					StringUtils.isNotBlank(actBusiness.getTableName())
					&& StringUtils.isNotBlank(actBusiness.getUpdateKeyName())
					&& (
					(StringUtils.isNotBlank(actBusiness.getWhereKeyName()) && StringUtils.isNotBlank(actBusiness.getWhereKeyValue()) )
					|| StringUtils.isNotBlank(actBusiness.getWhereSql())
			        )
			){
				actBusiness.setProcInsId(procIns.getId());
				actDao.updateProcInsIdByBusinessInfo(actBusiness);
			}
		}
		return procIns.getId();
	}

	/**
	 * 获取任务
	 * @param taskId 任务ID
	 */
	public Task getTask(String taskId){
		return taskService.createTaskQuery().taskId(taskId).singleResult();
	}

	public Map<String, Object> getTaskIncludeVars(String taskId) {
		return taskService.getVariables(taskId);
	}



	/**
	 * 删除任务
	 * @param taskId 任务ID
	 * @param deleteReason 删除原因
	 */
	public void deleteTask(String taskId, String deleteReason){
		taskService.deleteTask(taskId, deleteReason);
	}
	
	/**
	 * 签收任务
	 * @param taskId 任务ID
	 * @param userId 签收用户ID（用户登录名）
	 */
	@Transactional(readOnly = false)
	public void claim(String taskId, String userId){
		taskService.claim(taskId, userId);
	}
	
	/**
	 * 提交任务, 并保存意见
	 * @param taskId 任务ID
	 * @param procInsId 流程实例ID，如果为空，则不保存任务提交意见
	 * @param comment 任务提交意见的内容
	 * @param vars 任务变量
	 */
	@Transactional(readOnly = false)
	public void complete(String taskId, String procInsId, String comment, Map<String, Object> vars){
		complete(taskId, procInsId, comment, "", vars);
	}
	
	/**
	 * 提交任务, 并保存意见
	 * @param taskId 任务ID
	 * @param procInsId 流程实例ID，如果为空，则不保存任务提交意见
	 * @param comment 任务提交意见的内容
	 * @param title			流程标题，显示在待办任务标题
	 * @param vars 任务变量
	 */
	@Transactional(readOnly = false)
	public void complete(String taskId, String procInsId, String comment, String title, Map<String, Object> vars){
		// 添加意见
		if (StringUtils.isNotBlank(procInsId) && StringUtils.isNotBlank(comment)){
			taskService.addComment(taskId, procInsId, comment);
		}
		// 设置流程变量
		if (vars == null){
			vars = Maps.newHashMap();
		}
		
		// 设置流程标题
		if (StringUtils.isNotBlank(title)){
			vars.put("title", title);
		}
		
		// 提交任务
		taskService.complete(taskId, vars);
	}

	/**
	 * 完成第一个任务
	 * @param procInsId
	 */
	public void completeFirstTask(String procInsId){
		completeFirstTask(procInsId, null, null, null);
	}
	
	/**
	 * 完成第一个任务
	 * @param procInsId
	 * @param comment
	 * @param title
	 * @param vars
	 */
	public void completeFirstTask(String procInsId, String comment, String title, Map<String, Object> vars){
		String userId = UserUtils.getUser().getLoginName();
		Task task = taskService.createTaskQuery().taskAssignee(userId).processInstanceId(procInsId).active().singleResult();
		if (task != null){
			complete(task.getId(), procInsId, comment, title, vars);
		}
	}

	/**
	 * 读取带跟踪的图片
	 * @param executionId	环节ID
	 * @return	封装了各种节点信息
	 */
	public InputStream tracePhoto(String processDefinitionId, String executionId) {
		// ProcessInstance processInstance = runtimeService.createProcessInstanceQuery().processInstanceId(executionId).singleResult();
		BpmnModel bpmnModel = repositoryService.getBpmnModel(processDefinitionId);

		List<String> activeActivityIds = Lists.newArrayList();
		if (runtimeService.createExecutionQuery().executionId(executionId).count() > 0){
			activeActivityIds = runtimeService.getActiveActivityIds(executionId);
		}

		// 不使用spring请使用下面的两行代码
		// ProcessEngineImpl defaultProcessEngine = (ProcessEngineImpl)ProcessEngines.getDefaultProcessEngine();
		// Context.setProcessEngineConfiguration(defaultProcessEngine.getProcessEngineConfiguration());

		// 使用spring注入引擎请使用下面的这行代码
		Context.setProcessEngineConfiguration(processEngine.getProcessEngineConfiguration());

		ProcessDiagramGenerator diagramGenerator = processEngineConfiguration.getProcessDiagramGenerator();
		return diagramGenerator.generateDiagram(bpmnModel, "png", activeActivityIds);
	}


	/**
	 * 获取当前节点信息
	 * @param processInstance
	 * @return
	 */
	private Task getCurrentTaskInfo(ProcessInstance processInstance) {
		Task currentTask = null;
		try {
			String activitiId = (String) PropertyUtils.getProperty(processInstance, "activityId");
			logger.debug("current activity id: {}", activitiId);

			currentTask = taskService.createTaskQuery().processInstanceId(processInstance.getId()).taskDefinitionKey(activitiId)
					.singleResult();
			logger.debug("current task for processInstance: {}", ToStringBuilder.reflectionToString(currentTask));

		} catch (Exception e) {
			logger.error("can not get property activityId from processInstance: {}", processInstance);
		}
		return currentTask;
	}


	@Transactional(readOnly = false)
	public void addSubTask(String parentTaskId, String taskName) {
		Task subTask = taskService.newTask();
		subTask.setName(taskName);
		subTask.setAssignee(UserUtils.getUser().getLoginName());
		subTask.setOwner(UserUtils.getUser().getLoginName());
		subTask.setDescription("子任务");
		subTask.setParentTaskId(parentTaskId);
		taskService.saveTask(subTask);
	}

	/**
	 * 流程备注的保存
	 * @param taskId
	 * @param proInsId
	 * @param comment
	 */
	@Transactional(readOnly = false)
	public void commentSave(String taskId, String proInsId, String comment) {
		identityService.setAuthenticatedUserId(UserUtils.getUser().getLoginName());
		taskService.addComment(taskId,proInsId,comment);
	}

	/**
	 * 任务的事件列表
	 * @param taskId
	 * @return 整个任务的所有事件列表,按照事件倒序
	 */
	public List<Event> getTaskEvents(String taskId) {
		List<Event> taskEvents = taskService.getTaskEvents(taskId);
		return taskEvents;


//		Map<String,Object> result = Maps.newHashMap();
//		Map<String,Object> commentAndEventsMap = Maps.newHashMap();
//		//todo 集合是无序的,因此页面显示未按照时间显示
////		if(StringUtils.isNotBlank(processInstanceId)) {
////			List<Comment> processInstanceComments = taskService.getProcessInstanceComments(processInstanceId);
////			for (Comment comment : processInstanceComments) {
////				String commentId = (String) PropertyUtils.getProperty(comment,"id");
////				commentAndEventsMap.put(commentId,comment);
////			}
////			//提取任务名称
////			List<HistoricTaskInstance> list = historyService.createHistoricTaskInstanceQuery().processInstanceId(processInstanceId).list();
////
////			Map<String,String> taskNames = Maps.newHashMap();
////			for (HistoricTaskInstance historicTaskInstance : list) {
////				taskNames.put(historicTaskInstance.getId(),historicTaskInstance.getName());
////			}
////			result.put("taskNames" , taskNames);
////		}
//
//		//查询所有类型的事件
//		if(StringUtils.isNotBlank(taskId)) {
//			List<Event> taskEvents = taskService.getTaskEvents(taskId);
//			for(Event event : taskEvents) {
//				String eventId = (String) PropertyUtils.getProperty(event,"id");
//				commentAndEventsMap.put(eventId,event);
//			}
//		}
//		result.put("events",commentAndEventsMap.values());
//		return result;
	}

	/**
	 * 修改任务的参数属性
	 * @param taskId
	 * @param propertyName
	 * @param value
	 * @return
	 */
	@Transactional(readOnly = false)
	public String changeTaskProperty(String taskId, String propertyName, String value) {
		try{
			identityService.setAuthenticatedUserId(UserUtils.getUser().getLoginName());
			if(StringUtils.equals(propertyName,"dueDate")){
				Date dueDate = DateUtils.parseDate(value);
				taskService.setDueDate(taskId,dueDate);
			}else if(StringUtils.equals(propertyName,"priority")) {
				taskService.setPriority(taskId,Integer.parseInt(value));
			}else if(StringUtils.equals(propertyName,"owner")) {
				taskService.addUserIdentityLink(taskId,value,IdentityLinkType.OWNER);
			}else if(StringUtils.equals(propertyName,"assignee")) {
				taskService.setAssignee(taskId,value);
			}else{
				logger.warn("there is no propertyName:{} to set",propertyName);
			}
			return "true";
		}catch (Exception e){
			e.printStackTrace();
			throw new RuntimeException("操作失败");
		}

	}

	public List<HistoricTaskInstance> getSubTasks(String parentTaskId) {
		List<HistoricTaskInstance> historicTaskInstanceList = historyService.createHistoricTaskInstanceQuery().taskParentTaskId(parentTaskId).orderByTaskPriority().desc().list();
		List<Task> taskList = taskService.getSubTasks(parentTaskId);

		String str = JsonMapper.toJsonString(taskList);
		logger.debug(str);
		return historicTaskInstanceList;
	}
}

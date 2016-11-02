/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.activiti.runtimeServiceTest;

import org.activiti.engine.RuntimeService;
import org.activiti.engine.runtime.Execution;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.runtime.ProcessInstanceQuery;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * RuntimeService测试案例
 *
 * @author Jonathan
 * @version 2016/11/1 11:17
 * @since JDK 7.0+
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext-test.xml")
public class RuntimeServiceTest {

	@Autowired
	private RuntimeService runtimeService;

	private static final String processDefinitionKey = "act-demo";


	/**
	 * 启动流程的测试
	 */
	@Test
	public void startProcessTest(){
		//系统已经提前部署了一个processDefinitionKey='timer-serviceTask'的流程

		//启动流程
		Map<String,Object> vars = new HashMap<String, Object>();
		vars.put("title","启动流程");
		ProcessInstance processInstance = runtimeService.startProcessInstanceByKey(processDefinitionKey,vars);
		//验证是否启动成功
		Assert.assertNotNull(processInstance);
		//通过查询正在运行的流程实例来判断
		ProcessInstanceQuery processInstanceQuery = runtimeService.createProcessInstanceQuery();
		//
		List<ProcessInstance> runningList = processInstanceQuery.processInstanceId(processInstance.getProcessInstanceId()).list();
		Assert.assertTrue(runningList.size()>0);
	}


	/**
	 * 流程的挂起和激活
	 */
	@Test
	public void suspendAndActivateTest(){
		ProcessInstance processInstance = runtimeService.createProcessInstanceQuery().processDefinitionKey(processDefinitionKey).variableValueEquals("title","启动流程").singleResult();
		String processInstanceId = processInstance.getProcessInstanceId();

		System.out.println(processInstance.isSuspended());
		//挂起流程实例
		runtimeService.suspendProcessInstanceById(processInstanceId);
		//验证是否挂起
		Assert.assertTrue(runtimeService.createProcessInstanceQuery().processInstanceId(processInstanceId).singleResult().isSuspended());

		//激活流程实例
		runtimeService.activateProcessInstanceById(processInstanceId);
		//验证是否激活
		Assert.assertTrue(!runtimeService.createProcessInstanceQuery().processInstanceId(processInstanceId).singleResult().isSuspended());
	}


	/**
	 * 流程实例的查询
	 */
	@Test
	public void processInstanceQueryTest(){
		//根据流程定义Key值查询正在运行的流程实例
		List<ProcessInstance> processInstanceList = runtimeService.createProcessInstanceQuery().processDefinitionKey(processDefinitionKey).list();
		Assert.assertTrue(processInstanceList.size()>0);

		//查询激活的流程实例
		List<ProcessInstance> activateList = runtimeService.createProcessInstanceQuery().processDefinitionKey(processDefinitionKey).active().list();
		Assert.assertTrue(activateList.size()>0);

		//相反 查询挂起的流程则是
		List<ProcessInstance> suspendList = runtimeService.createProcessInstanceQuery().processDefinitionKey(processDefinitionKey).suspended().list();
		Assert.assertTrue(suspendList.size()==0);

		//根据变量来查询
		// 根据title='启动流程',以及processDefinitionKey来作为查询条件进行查询
		List<ProcessInstance> varList = runtimeService.createProcessInstanceQuery().variableValueEquals("title","启动流程").list();
		Assert.assertTrue(varList.size()>0);
	}

	/**
	 * 执行流的查询
	 */
	@Test
	public void executionQueryTest(){
		List<Execution> executionList = runtimeService.createExecutionQuery().processDefinitionKey(processDefinitionKey).list();
		Assert.assertTrue(executionList.size()>0);
	}


	/**
	 * 流程实例的删除
	 */
	@Test
	public void deleteProcessInstanceTest(){
		ProcessInstance processInstance = runtimeService.createProcessInstanceQuery().processDefinitionKey(processDefinitionKey).variableValueEquals("title","启动流程").singleResult();
		String processInstanceId = processInstance.getProcessInstanceId();
		runtimeService.deleteProcessInstance(processInstanceId,"删除测试");
	}





}

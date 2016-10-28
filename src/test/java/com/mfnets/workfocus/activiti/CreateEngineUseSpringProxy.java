/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.activiti;

import com.mfnets.workfocus.activiti.interceptor.MyProcessEngineConfiguration;
import org.activiti.engine.ProcessEngine;
import org.activiti.engine.ProcessEngineConfiguration;
import org.activiti.engine.RuntimeService;
import org.activiti.spring.ProcessEngineFactoryBean;
import org.junit.Assert;
import org.junit.Test;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.assertNotNull;

/**
 * 基于传统的单元测试,测试Spring配置是否可以创建引擎对象
 *
 * @author Jonathan
 * @version 2016/10/11 12:07
 * @since JDK 7.0+
 */
public class CreateEngineUseSpringProxy {


	@Test
	public void createEngineUseSpring() {
		ClassPathXmlApplicationContext context = new ClassPathXmlApplicationContext("applicationContext-test.xml");
		ProcessEngineFactoryBean factoryBean = context.getBean(ProcessEngineFactoryBean.class);
		assertNotNull(factoryBean);

		RuntimeService bean = context.getBean(RuntimeService.class);
		assertNotNull(bean);
	}




	@Test
	public void createMyEngine(){
		//创建配置对象
		MyProcessEngineConfiguration configuration = (MyProcessEngineConfiguration) ProcessEngineConfiguration.createProcessEngineConfigurationFromResource("my-config.xml");
		//初始化流程引擎
		ProcessEngine engine = configuration.buildProcessEngine();
		Assert.assertTrue("Jonathan".equals(configuration.getUserName()));
		//部署一个简单的流程
//		engine.getRepositoryService().createDeployment().addClasspathResource("bpmn/leave-normal-from.bpmn20.xml").deploy();

		//开始流程
		Map<String, Object> vars = new HashMap<String, Object>();
		vars.put("title", "12312");
		engine.getRuntimeService().startProcessInstanceByKey("leave-normal-from",vars);

	}
}

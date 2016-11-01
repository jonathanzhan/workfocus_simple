/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.activiti;

import org.activiti.engine.ProcessEngine;
import org.activiti.engine.RuntimeService;
import org.activiti.spring.ProcessEngineFactoryBean;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.assertNotNull;

/**
 * 基于注解的单元测试,测试Spring配置是否可以创建引擎对象
 *
 * @author Jonathan
 * @version 2016/10/11 14:33
 * @since JDK 7.0+
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext-test.xml")
public class CreateEngineUseSpringProxyAnnotation {

	@Autowired
	RuntimeService runtimeService;

	@Autowired
	ProcessEngineFactoryBean processEngineFactoryBean;


	@Test
	public void testService() throws Exception {
		assertNotNull(runtimeService);
		ProcessEngine processEngine = processEngineFactoryBean.getObject();
		assertNotNull(processEngine.getRuntimeService());
	}
}

/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.activiti.interceptor;

import com.mfnets.workfocus.activiti.interceptor.MyInterceptorA;
import com.mfnets.workfocus.activiti.interceptor.MyInterceptorB;
import org.activiti.engine.impl.cfg.ProcessEngineConfigurationImpl;
import org.activiti.engine.impl.interceptor.CommandContextInterceptor;
import org.activiti.engine.impl.interceptor.CommandInterceptor;
import org.activiti.engine.impl.interceptor.LogInterceptor;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * 自定义流程引擎配置对象
 *
 * @author Jonathan
 * @version 2016/10/11 15:25
 * @since JDK 7.0+
 */
public class MyProcessEngineConfiguration extends ProcessEngineConfigurationImpl {


	public MyProcessEngineConfiguration() {
		// 做自定义设置
	}

	//测试属性，需要在processEngineConfiguration注入
	private String userName;

	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserName() {
		return this.userName;
	}

	@Override
	protected CommandInterceptor createTransactionInterceptor() {
		return new MyInterceptorA();
	}


	@Override
	protected Collection<? extends CommandInterceptor> getDefaultCommandInterceptors() {
		List<CommandInterceptor> interceptors = new ArrayList<CommandInterceptor>();
		interceptors.add(new LogInterceptor());
		CommandInterceptor transactionInterceptor = createTransactionInterceptor();
		if(transactionInterceptor!=null) {
			interceptors.add(transactionInterceptor);
		}
		interceptors.add(new MyInterceptorB());
		interceptors.add(new CommandContextInterceptor(commandContextFactory,this));
		return interceptors;
	}
}

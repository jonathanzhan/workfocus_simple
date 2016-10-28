/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.activiti.interceptor;

import org.activiti.engine.impl.interceptor.Command;
import org.activiti.engine.impl.interceptor.CommandConfig;
import org.activiti.engine.impl.interceptor.CommandContextInterceptor;

/**
 * 继承CommandContextInterceptor,实现execute方法--使用的是责任链设计模式
 *
 * @author Jonathan
 * @version 2016/10/11 15:47
 * @since JDK 7.0+
 */
public class MyInterceptorB extends CommandContextInterceptor {
	@Override
	public <T> T execute(CommandConfig config, Command<T> command) {
		System.out.println("this is interceptor B "+command.getClass().getName());
		return next.execute(config, command);
	}
}


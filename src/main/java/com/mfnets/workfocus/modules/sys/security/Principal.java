/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.sys.security;

import com.mfnets.workfocus.modules.sys.entity.User;

import java.io.Serializable;

/**
 * Shiro的身份实体类
 *
 * @author Jonathan
 * @version 2016/12/7 14:52
 * @since JDK 7.0+
 */
public class Principal implements Serializable {

	private static final long serialVersionUID = 1L;
	/**
	 * 编号,唯一约束
	 */
	private String id;

	/**
	 * 登录名
	 */
	private String loginName;

	/**
	 * 用户姓名
	 */
	private String name;

	/**
	 * token
	 */
	private String token;

	public Principal(User user) {
		this.id = user.getId();
		this.loginName = user.getLoginName();
		this.name = user.getName();
	}

	public Principal(String token) {
		this.token = token;
	}

	public String getId() {
		return id;
	}

	public String getLoginName() {
		return loginName;
	}

	public String getName() {
		return name;
	}

	public String getToken() {
		return token;
	}

	@Override
	public String toString() {
		return "Principal{" +
				"id='" + id + '\'' +
				", loginName='" + loginName + '\'' +
				", name='" + name + '\'' +
				", token='" + token + '\'' +
				'}';
	}
}

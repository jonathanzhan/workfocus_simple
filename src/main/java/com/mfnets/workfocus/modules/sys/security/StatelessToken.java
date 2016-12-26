/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.sys.security;

import org.apache.shiro.authc.AuthenticationToken;

import java.util.Map;

/**
 * 无状态token令牌类
 *
 * @author Jonathan
 * @version 2016/11/29 15:51
 * @since JDK 7.0+
 */
public class StatelessToken implements AuthenticationToken {

	private static final long serialVersionUID = 1L;
	private String username;  //用户名
	private String token;  //摘要

	public StatelessToken(String token) {
		super();
		this.token = token;
	}

	//省略部分代码
	public StatelessToken(String username,
						  String token) {
		super();
		this.username = username;
		this.token = token;
	}

	public Object getPrincipal() {
		return username;
	}

	public Object getCredentials() {
		return token;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}
}

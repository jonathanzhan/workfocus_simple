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
	private Map<String, ?> params;  //请求参数
	private String clientDigest;  //摘要

	//省略部分代码
	public StatelessToken(String username, Map<String, ?> params,
						  String clientDigest) {
		super();
		this.username = username;
		this.params = params;
		this.clientDigest = clientDigest;
	}

	public Object getPrincipal() {
		return username;
	}

	public Object getCredentials() {
		return clientDigest;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public Map<String, ?> getParams() {
		return params;
	}

	public void setParams(Map<String, ?> params) {
		this.params = params;
	}

	public String getClientDigest() {
		return clientDigest;
	}

	public void setClientDigest(String clientDigest) {
		this.clientDigest = clientDigest;
	}
}

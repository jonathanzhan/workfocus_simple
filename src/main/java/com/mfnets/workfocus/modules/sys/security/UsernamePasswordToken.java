/**
 * Copyright &copy; 2012-2014 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.security;

/**
 * 用户和密码（包含验证码）令牌类
 * @author ThinkGem
 * @version 2013-5-19
 */
public class UsernamePasswordToken extends org.apache.shiro.authc.UsernamePasswordToken {

	private static final long serialVersionUID = 1L;

	private String captcha;

	private boolean needValidateCode = true;
	public UsernamePasswordToken() {
		super();
	}

	public UsernamePasswordToken(String username, String password, boolean needValidateCode) {
		super(username, password);
		this.needValidateCode = needValidateCode;
	}

	public UsernamePasswordToken(String username, char[] password,
								 boolean rememberMe, String host, String captcha) {
		super(username, password, rememberMe, host);
		this.captcha = captcha;
		this.needValidateCode = true;
	}

	public String getCaptcha() {
		return captcha;
	}

	public void setCaptcha(String captcha) {
		this.captcha = captcha;
	}

	public boolean isNeedValidateCode() {
		return needValidateCode;
	}

	public void setNeedValidateCode(boolean needValidateCode) {
		this.needValidateCode = needValidateCode;
	}
}
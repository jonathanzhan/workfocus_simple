/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.sys.security;

import com.alibaba.fastjson.JSONObject;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.UnauthorizedException;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.AccessControlFilter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 无状态验证过滤类
 * 根据当前请求上下文信息每次请求时都要登录的认证过滤器
 * @author Jonathan
 * @version 2016/11/29 15:48
 * @since JDK 7.0+
 */
public class StatelessAuthcFilter extends AccessControlFilter {

	private static final Logger logger = LoggerFactory.getLogger(StatelessAuthcFilter.class);

	@Override
	protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) throws Exception {
		return false;
	}

	@Override
	protected boolean onAccessDenied(ServletRequest request, ServletResponse response) throws Exception {
		//1、客户端生成的消息摘要
		String clientDigest = request.getParameter("digest");
		//2、客户端传入的用户身份
		String username = request.getParameter("username");
		//3、客户端请求的参数列表
		Map<String, String[]> params = new HashMap<String, String[]>(request.getParameterMap());
		params.remove("digest");
		//4、生成无状态Token

		StatelessToken token = new StatelessToken(username, params, clientDigest);
		logger.debug("before login");
		try {
			//5、委托给Realm进行登录
			Subject subject = getSubject(request, response);
			logger.debug("subject getted");
			subject.login(token);

		} catch ( UnknownAccountException uae ) {
			onLoginFail(response,"No Account");
			return false;
		} catch ( IncorrectCredentialsException ice ) {
			onLoginFail(response,"Key incorrect");
			return false;
		} catch (LockedAccountException lae ) {
			onLoginFail(response,"Account Locked");
			return false;
		} catch (ExcessiveAttemptsException eae ) {
			onLoginFail(response,"Excessive Attempts");
			return false;
		}catch (AuthenticationException e) {
			onLoginFail(response,"Authentication Error");
			return false;
		}catch (UnauthorizedException e) {
			onLoginFail(response,"Unauthorized Error");
			return false;
		}catch (Exception e) {
			e.printStackTrace();
			onLoginFail(response,"Login Error"); //6、登录失败
			return false;
		}
		return true;
	}

	//登录失败时默认返回401状态码
	private void onLoginFail(ServletResponse response,String errorString) throws IOException {
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		httpResponse.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
		JSONObject errorJsonObject = new JSONObject();
		errorJsonObject.put("status", HttpServletResponse.SC_UNAUTHORIZED+"");
		errorJsonObject.put("error", errorString);
		httpResponse.getWriter().write(errorJsonObject.toJSONString());
	}
}

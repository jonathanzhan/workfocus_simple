/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.sys.security;

import org.apache.shiro.mgt.SessionStorageEvaluator;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.util.WebUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

/**
 * 在shiro中,设置哪些会话需要走sessionManager,哪些不需要
 *
 * @author Jonathan
 * @version 2016/11/29 16:27
 * @since JDK 7.0+
 */
public class MultiSessionStorageEvaluator implements SessionStorageEvaluator {

	private static final Logger logger = LoggerFactory.getLogger(MultiSessionStorageEvaluator.class);
	@Override
	public boolean isSessionStorageEnabled(Subject subject) {
		boolean enabled = false;
		if(WebUtils.isWeb(subject)) {
			HttpServletRequest request = WebUtils.getHttpRequest(subject);
			//具体判断规则根据项目的具体情况
			if (request.getHeader("accept").indexOf("application/json")<0) {
				enabled = true;
			} else {
				enabled = false;
			}

		} else {
			//not a web request - maybe a RMI or daemon invocation?
			//set 'enabled' another way …
			return enabled;
		}

		logger.debug("isSessionStorageEnabled = {} ",enabled);
		return enabled;
	}
}

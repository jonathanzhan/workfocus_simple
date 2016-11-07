/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.common.web;


import javax.servlet.http.HttpServletRequest;

/**
 * 重写CommonsMultipartResolver,增加针对某些路径不做过滤的情况
 *
 * @author Jonathan
 * @version 2016/11/4 15:47
 * @since JDK 7.0+
 */
public class CommonsMultipartResolver extends org.springframework.web.multipart.commons.CommonsMultipartResolver {

	private String excludeUrls;

	@Override
	public boolean isMultipart(HttpServletRequest request) {
		String[] excludeUrl = excludeUrls.split(",");
		for (int i = 0; i < excludeUrl.length; i++) {
			if(request.getRequestURI().contains(excludeUrl[i])){
				return false;
			}
		}
		return super.isMultipart(request);
	}


	public String getExcludeUrls() {
		return excludeUrls;
	}

	public void setExcludeUrls(String excludeUrls) {
		this.excludeUrls = excludeUrls;
	}
}

/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.common.web;

import com.google.common.collect.Maps;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authz.AuthorizationException;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;

import javax.servlet.http.HttpServletResponse;
import javax.validation.ConstraintViolationException;
import javax.validation.ValidationException;
import java.util.Map;

/**
 * 系统异常处理类
 *
 * @author Jonathan
 * @version 2016/12/23 16:22
 * @since JDK 7.0+
 */
@ControllerAdvice
public class GlobalExceptionHandlerController {


	/**
	 * 参数绑定异常
	 *
	 * @return 400页面
	 */
	@ExceptionHandler({BindException.class, ConstraintViolationException.class, ValidationException.class})
	@ResponseStatus(value = HttpStatus.BAD_REQUEST)
	public ModelAndView bindException(Exception ex) {
		Map<String, Object> map = Maps.newHashMap();
		map.put("status", 400);
		map.put("msg", ex.getMessage());
		map.put("timestamp", System.currentTimeMillis());
		return new ModelAndView("error/400").addAllObjects(map);
	}

	@ExceptionHandler(NoHandlerFoundException.class)
	@ResponseStatus(value = HttpStatus.NOT_FOUND)
	public ModelAndView handleException(HttpServletResponse response) {
		Map<String, Object> map = Maps.newHashMap();
		map.put("status", 404);
		map.put("msg", "请求地址不存在");
		map.put("timestamp", System.currentTimeMillis());
		response.setStatus(HttpServletResponse.SC_NOT_FOUND);
		return new ModelAndView("error/404").addAllObjects(map);
	}

	/**
	 * 授权登录异常
	 *
	 * @return 401页面
	 */
	@ExceptionHandler({AuthenticationException.class})
	@ResponseStatus(HttpStatus.UNAUTHORIZED)
	public ModelAndView authenticationException(Exception ex) {
		Map<String, Object> map = Maps.newHashMap();
		map.put("status", 401);
		map.put("msg", ex.getMessage());
		map.put("timestamp", System.currentTimeMillis());
		return new ModelAndView("/error/403").addAllObjects(map);
	}

	/**
	 * 无权限异常403
	 * @param ex
	 * @return
	 */
	@ExceptionHandler({AuthorizationException.class})
	@ResponseStatus(HttpStatus.FORBIDDEN)
	public ModelAndView authorizationException(Exception ex) {
		Map<String, Object> map = Maps.newHashMap();
		map.put("status", 403);
		map.put("msg", ex.getMessage());
		map.put("timestamp", System.currentTimeMillis());
		return new ModelAndView("/error/403").addAllObjects(map);
	}

	/**
	 * 异常控制，可以根据不同的异常类型 在此定义不同的错误消息和操作
	 */
	@ExceptionHandler(Exception.class)
	@ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
	public ModelAndView handleException(Exception ex) {
		Map<String, Object> map = Maps.newHashMap();
		map.put("status", 500);
		map.put("msg", ex.toString());
		map.put("timestamp", System.currentTimeMillis());
		return new ModelAndView("error/500").addAllObjects(map);
	}
}

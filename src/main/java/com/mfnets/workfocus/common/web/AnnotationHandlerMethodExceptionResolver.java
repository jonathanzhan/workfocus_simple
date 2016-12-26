/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.common.web;

import org.springframework.core.MethodParameter;
import org.springframework.core.annotation.AnnotationUtils;
import org.springframework.http.HttpInputMessage;
import org.springframework.http.HttpOutputMessage;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.http.server.ServletServerHttpResponse;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.method.annotation.ExceptionHandlerExceptionResolver;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * 不必在Controller中对异常进行处理，抛出即可，由此异常解析器统一控制。<br>
 * ajax请求（有@ResponseBody的Controller）发生错误，输出JSON。<br>
 * 页面请求（无@ResponseBody的Controller）发生错误，输出错误页面。<br>
 * 需要与AnnotationMethodHandlerAdapter使用同一个messageConverters<br>
 *
 * @author Jonathan
 * @version 2016/12/7 18:14
 * @since JDK 7.0+
 */
public class AnnotationHandlerMethodExceptionResolver extends ExceptionHandlerExceptionResolver {

	private String defaultErrorView;

	public String getDefaultErrorView() {
		return defaultErrorView;
	}

	public void setDefaultErrorView(String defaultErrorView) {
		this.defaultErrorView = defaultErrorView;
	}

	protected ModelAndView doResolveHandlerMethodException(HttpServletRequest request, HttpServletResponse response, HandlerMethod handlerMethod, Exception exception) {



		ModelAndView modelAndView = super.doResolveHandlerMethodException(request, response, handlerMethod, exception);
		//首先处理404异常,因为404异常没有handleMethod
		if(modelAndView!=null && modelAndView.getViewName().equals("error/404")){
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			if(Servlets.isAjaxRequest(request)){
				try {
					return handleResponseBody(modelAndView, request, response);
				} catch (Exception e){
					e.printStackTrace();
				}
			}

			return modelAndView;
		}
		//其次处理其他异常
		if (handlerMethod == null) {
			return null;
		}

		Method method = handlerMethod.getMethod();
		MethodParameter handlerMethodReturnType= handlerMethod.getReturnType();


		if (method == null) {
			return null;
		}
		//判断handlerMethod是否有@responseBody注解。或者Controller类上是否有@responseBody注解
		if(AnnotationUtils.findAnnotation(handlerMethodReturnType.getContainingClass(), ResponseBody.class) != null ||
				handlerMethodReturnType.getMethodAnnotation(ResponseBody.class) != null){

			try {
				ResponseStatus responseStatusAnn = AnnotationUtils.findAnnotation(method, ResponseStatus.class);
				if (responseStatusAnn != null) {
					HttpStatus responseStatus = responseStatusAnn.value();
					String reason = responseStatusAnn.reason();
					if (!StringUtils.hasText(reason)) {
						response.setStatus(responseStatus.value());
					} else {
						try {
							response.sendError(responseStatus.value(), reason);
						} catch (IOException e) { }
					}
				}

				return handleResponseBody(modelAndView, request, response);
			} catch (Exception e) {
				return null;
			}
		}

		if(modelAndView.getViewName() == null){
			modelAndView.setViewName(defaultErrorView);
		}
		return modelAndView;
	}


	@SuppressWarnings({ "unchecked", "rawtypes" })
	private ModelAndView handleResponseBody(ModelAndView modelAndView, HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Map value = modelAndView.getModelMap();
		HttpInputMessage inputMessage = new ServletServerHttpRequest(request);
		List<MediaType> acceptedMediaTypes = inputMessage.getHeaders().getAccept();
		if (acceptedMediaTypes.isEmpty()) {
			acceptedMediaTypes = Collections.singletonList(MediaType.ALL);
		}
		MediaType.sortByQualityValue(acceptedMediaTypes);
		HttpOutputMessage outputMessage = new ServletServerHttpResponse(response);
		Class<?> returnValueType = value.getClass();
		List<HttpMessageConverter<?>> messageConverters = super.getMessageConverters();
		if (messageConverters != null) {
			for (MediaType acceptedMediaType : acceptedMediaTypes) {
				for (HttpMessageConverter messageConverter : messageConverters) {
					if (messageConverter.canWrite(returnValueType, acceptedMediaType)) {
						messageConverter.write(value, acceptedMediaType, outputMessage);
						return new ModelAndView();
					}
				}
			}
		}
		if (logger.isWarnEnabled()) {
			logger.warn("Could not find HttpMessageConverter that supports return type [" + returnValueType + "] and " + acceptedMediaTypes);
		}
		return null;
	}
}

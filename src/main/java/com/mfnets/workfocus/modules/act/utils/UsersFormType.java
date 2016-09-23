/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.act.utils;

import org.activiti.engine.form.AbstractFormType;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;

/**
 * 多用户的表单类型,loginName中间以','隔开
 *
 * @author Jonathan
 * @version 2016/9/22 17:00
 * @since JDK 7.0+
 */
public class UsersFormType extends AbstractFormType {

	/**
	 * 把字符串的值转换为集合对象
	 * @param propertyValue
	 * @return
	 */
	@Override
	public Object convertFormValueToModelValue(String propertyValue) {
		String[] split = StringUtils.split(propertyValue, ",");
		return Arrays.asList(split);
	}

	/**
	 * 把集合对象的值转换为字符串
	 * @param modelValue
	 * @return
	 */
	@Override
	public String convertModelValueToFormValue(Object modelValue) {
		if(modelValue==null){
			return null;
		}
		return modelValue.toString();
	}

	@Override
	public String getName() {
		return "users";
	}
}

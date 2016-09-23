/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.act.utils;

import org.activiti.engine.form.AbstractFormType;
import org.apache.commons.lang3.ObjectUtils;
import org.apache.commons.lang3.StringUtils;

import java.util.Arrays;

/**
 * TODO
 *
 * @author Jonathan
 * @version 2016/9/22 17:00
 * @since JDK 7.0+
 */
public class UsersFormType extends AbstractFormType {
	@Override
	public Object convertFormValueToModelValue(String propertyValue) {
		String[] split = StringUtils.split(propertyValue, ",");
		return Arrays.asList(split);
	}

	@Override
	public String convertModelValueToFormValue(Object modelValue) {
		return modelValue.toString();
	}

	@Override
	public String getName() {
		return "users";
	}
}

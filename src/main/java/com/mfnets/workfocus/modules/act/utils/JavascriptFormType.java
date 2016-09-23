/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.act.utils;

import org.activiti.engine.form.AbstractFormType;

/**
 * TODO
 *
 * @author Jonathan
 * @version 2016/9/22 17:09
 * @since JDK 7.0+
 */
public class JavascriptFormType extends AbstractFormType {

	@Override
	public String getName() {
		return "javascript";
	}

	@Override
	public Object convertFormValueToModelValue(String propertyValue) {
		return propertyValue;
	}

	@Override
	public String convertModelValueToFormValue(Object modelValue) {
		return (String) modelValue;
	}
}

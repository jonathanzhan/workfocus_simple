/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.utils;

import org.junit.Test;

/**
 * StringFormats的测试类
 *
 * @author Jonathan
 * @version 2016/9/28 17:23
 * @since JDK 7.0+
 */

public class StringFormatUtils {



	@Test
	public void test1(){

		//s  字符串类型。
		//-  在最小宽度内左对齐，右边用空格补上。
		//c 字符类型，实参必须为char或int、short等可转换为char类型的数据类型，否则抛IllegalFormatConversionException异常
		//b  boolean

		String str = String.format("aada%sasdas%s","1111","1222");
		System.out.println(str);


		String str1 = "hello";
		System.out.println(String.format("%1$7s", "hello"));
	}
}

/**
 * Copyright &copy; 2012-2014 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.mfnets.workfocus.common.utils;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

import org.apache.commons.lang3.time.DateFormatUtils;

/**
 * 日期工具类, 继承org.apache.commons.lang.time.DateUtils类
 * @author ThinkGem
 * @version 2014-4-15
 */
public class DateUtils extends org.apache.commons.lang3.time.DateUtils {
	
	private static String[] parsePatterns = {
		"yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "yyyy-MM", 
		"yyyy/MM/dd", "yyyy/MM/dd HH:mm:ss", "yyyy/MM/dd HH:mm", "yyyy/MM",
		"yyyy.MM.dd", "yyyy.MM.dd HH:mm:ss", "yyyy.MM.dd HH:mm", "yyyy.MM"};

	/**
	 * 得到当前日期字符串 格式（yyyy-MM-dd）
	 */
	public static String getDate() {
		return getDate("yyyy-MM-dd");
	}
	
	/**
	 * 得到当前日期字符串 格式（yyyy-MM-dd） pattern可以为："yyyy-MM-dd" "HH:mm:ss" "E"
	 */
	public static String getDate(String pattern) {
		return DateFormatUtils.format(new Date(), pattern);
	}
	
	/**
	 * 得到日期字符串 默认格式（yyyy-MM-dd） pattern可以为："yyyy-MM-dd" "HH:mm:ss" "E"
	 */
	public static String formatDate(Date date, Object... pattern) {
		String formatDate = null;
		if (pattern != null && pattern.length > 0) {
			formatDate = DateFormatUtils.format(date, pattern[0].toString());
		} else {
			formatDate = DateFormatUtils.format(date, "yyyy-MM-dd");
		}
		return formatDate;
	}
	
	/**
	 * 得到日期时间字符串，转换格式（yyyy-MM-dd HH:mm:ss）
	 */
	public static String formatDateTime(Date date) {
		return formatDate(date, "yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 得到当前时间字符串 格式（HH:mm:ss）
	 */
	public static String getTime() {
		return formatDate(new Date(), "HH:mm:ss");
	}

	/**
	 * 得到当前日期和时间字符串 格式（yyyy-MM-dd HH:mm:ss）
	 */
	public static String getDateTime() {
		return formatDate(new Date(), "yyyy-MM-dd HH:mm:ss");
	}

	/**
	 * 得到当前年份字符串 格式（yyyy）
	 */
	public static String getYear() {
		return formatDate(new Date(), "yyyy");
	}

	/**
	 * 得到当前月份字符串 格式（MM）
	 */
	public static String getMonth() {
		return formatDate(new Date(), "MM");
	}

	/**
	 * 得到当天字符串 格式（dd）
	 */
	public static String getDay() {
		return formatDate(new Date(), "dd");
	}

	/**
	 * 得到当前星期字符串 格式（E）星期几
	 */
	public static String getWeek() {
		return formatDate(new Date(), "E");
	}
	
	/**
	 * 日期型字符串转化为日期 格式
	 * { "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", 
	 *   "yyyy/MM/dd", "yyyy/MM/dd HH:mm:ss", "yyyy/MM/dd HH:mm",
	 *   "yyyy.MM.dd", "yyyy.MM.dd HH:mm:ss", "yyyy.MM.dd HH:mm" }
	 */
	public static Date parseDate(Object str) {
		if (str == null){
			return null;
		}
		try {
			return parseDate(str.toString(), parsePatterns);
		} catch (ParseException e) {
			return null;
		}
	}

	/**
	 * 获取过去的天数
	 * @param date
	 * @return
	 */
	public static long pastDays(Date date) {
		long t = new Date().getTime()-date.getTime();
		return t/(24*60*60*1000);
	}

	/**
	 * 获取过去的小时
	 * @param date
	 * @return
	 */
	public static long pastHour(Date date) {
		long t = new Date().getTime()-date.getTime();
		return t/(60*60*1000);
	}
	
	/**
	 * 获取过去的分钟
	 * @param date
	 * @return
	 */
	public static long pastMinutes(Date date) {
		long t = new Date().getTime()-date.getTime();
		return t/(60*1000);
	}
	
	/**
	 * 转换为时间（天,时:分:秒.毫秒）
	 * @param timeMillis
	 * @return
	 */
    public static String formatDateTime(long timeMillis){
		long day = timeMillis/(24*60*60*1000);
		long hour = (timeMillis/(60*60*1000)-day*24);
		long min = ((timeMillis/(60*1000))-day*24*60-hour*60);
		long s = (timeMillis/1000-day*24*60*60-hour*60*60-min*60);
		long sss = (timeMillis-day*24*60*60*1000-hour*60*60*1000-min*60*1000-s*1000);
		return (day>0?day+",":"")+hour+":"+min+":"+s+"."+sss;
    }

	/**
	 * 将巴西时间 转成北京时间(巴西时间 格式yyyy-MM-dd'T'HH:mm:ss.SSS  北京时间格式  yyyy-MM-dd HH:mm:ss)
	 * @param bxDate
	 * @return
	 */
	public static String timeZoneBX2BJ(String bxDate){
		return timeZoneBX2BJ(bxDate, "yyyy-MM-dd'T'HH:mm:ss.SSS", "yyyy-MM-dd HH:mm:ss");
	}


	/**
	 * 巴西时间转巴西时间 去掉时区 格式 2015-11-27T09:59:44.000-02:00
	 * @param bxDate
	 * @return
	 */
	public static String timeZoneBx2Bx(String bxDate){
		return StringUtils.substring(bxDate, 0, bxDate.length() - 6);
	}


	/**
	 * 巴西时间转巴西时间 去掉时区 格式 2015-11-27T09:59:44.000-0200
	 * @param bxDate
	 * @return
	 */
	public static String timeZoneBx2Bx1(String bxDate){
		return StringUtils.substring(bxDate, 0, bxDate.length() - 5);
	}

	/**
	 * 将巴西时间转换为北京时间（yyyy-MM-dd HH:mm:ss）
	 * @param bxDate
	 * @param inFormat
	 * @param outFormat
	 * @return
	 */
	public static String timeZoneBX2BJ(String bxDate,String inFormat,String outFormat){

		TimeZone timeZoneCQ = TimeZone.getTimeZone("Asia/Shanghai");
		TimeZone timeZoneBX = TimeZone.getTimeZone("America/Sao_Paulo");
		SimpleDateFormat inputFormat = new SimpleDateFormat(inFormat);
		inputFormat.setTimeZone(timeZoneBX);
		Date date = null;
		try
		{
			date = inputFormat.parse(timeZoneBx2Bx(bxDate));
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		SimpleDateFormat outputFormat = new SimpleDateFormat(outFormat);
		outputFormat.setTimeZone(timeZoneCQ);
		return outputFormat.format(date);

	}

	/**
	 * 巴西时间转换为北京时间
	 * @param bxDate
	 * @param inFormat
	 * @param outFormat
	 * @return
	 */
	public static String timeZoneBX2BJ1(String bxDate,String inFormat,String outFormat){

		TimeZone timeZoneCQ = TimeZone.getTimeZone("Asia/Shanghai");
		TimeZone timeZoneBX = TimeZone.getTimeZone("America/Sao_Paulo");
		SimpleDateFormat inputFormat = new SimpleDateFormat(inFormat);
		inputFormat.setTimeZone(timeZoneBX);
		Date date = null;
		try
		{
			date = inputFormat.parse(bxDate);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}

		SimpleDateFormat outputFormat = new SimpleDateFormat(outFormat);
		outputFormat.setTimeZone(timeZoneCQ);
		return outputFormat.format(date);

	}


	/**
	 * 将北京时间转成巴西时间
	 * @param bjDate
	 * @return
	 */
	public static String timeZoneBJ2BX(String bjDate){
		return timeZoneBJ2BX(bjDate, "yyyy-MM-dd HH:mm:ss");
	}


	/**
	 * 将北京时间转成巴西时间
	 * @param bjDate  inFormat 北京时间的格式
	 * @return
	 */
	public static String timeZoneBJ2BX(String bjDate,String inFormat){
		TimeZone timeZoneCQ = TimeZone.getTimeZone("Asia/Shanghai");
		TimeZone timeZoneBX = TimeZone.getTimeZone("America/Sao_Paulo");
		SimpleDateFormat inputFormat = new SimpleDateFormat(inFormat);
		inputFormat.setTimeZone(timeZoneCQ);
		Date date = null;
		try
		{
			date = inputFormat.parse(bjDate);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
		outputFormat.setTimeZone(timeZoneBX);
		String result = outputFormat.format(date);
		String begin = StringUtils.substring(result,0,result.length()-2);
		String end = StringUtils.substring(result,result.length()-2,result.length());
		return begin + ":" + end;

	}

	/**
	 * 将北京时间 转换成巴西时间
	 * @param bjDate
	 * @param inFormat 待转换的日期格式
	 * @param outFormat 转换后的日期格式
	 * @return
	 */
	public static String timeZoneBJ2BX(String bjDate,String inFormat,String outFormat){
		TimeZone timeZoneCQ = TimeZone.getTimeZone("Asia/Shanghai");
		TimeZone timeZoneBX = TimeZone.getTimeZone("America/Sao_Paulo");
		SimpleDateFormat inputFormat = new SimpleDateFormat(inFormat);
		inputFormat.setTimeZone(timeZoneCQ);
		Date date = null;
		try
		{
			date = inputFormat.parse(bjDate);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		SimpleDateFormat outputFormat = new SimpleDateFormat(outFormat);
		outputFormat.setTimeZone(timeZoneBX);
		String result = outputFormat.format(date);
		return result;

	}


	/**
	 * 将北京时间 转换成巴西时间
	 * @param bjDate
	 * @param inFormat  待转换的日期格式
	 * @param outFormat  转换后的日期格式
	 * @return
	 */
	public static String timeZoneBJ2BX(Date bjDate,String inFormat,String outFormat){
		String str = formatDate(bjDate,inFormat);
		return timeZoneBJ2BX(str,inFormat,outFormat);
	}



	/**
	 * 获取两个日期之间的天数
	 * 
	 * @param before
	 * @param after
	 * @return
	 */
	public static double getDistanceOfTwoDate(Date before, Date after) {
		long beforeTime = before.getTime();
		long afterTime = after.getTime();
		return (afterTime - beforeTime) / (1000 * 60 * 60 * 24);
	}
	
	/**
	 * @param args
	 * @throws ParseException
	 */
	public static void main(String[] args) throws ParseException {
		System.out.println(timeZoneBx2Bx("2015-11-27T09:59:44.000-0200"));
	}
}

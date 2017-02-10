/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.demo.controller;

import com.google.common.collect.Maps;
import com.mfnets.workfocus.common.web.BaseController;
import com.mfnets.workfocus.modules.sys.entity.User;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.List;
import java.util.Map;


/**
 * restful的请求demo,context-type accept=application/json
 *
 * @author Jonathan
 * @version 2016/11/24 15:23
 * @since JDK 7.0+
 */
@RestController
@RequestMapping(value = "/api")
public class RestfulController extends BaseController{



	@RequiresPermissions("user")
	@RequestMapping(value = "get/{id}",method = RequestMethod.GET)
	public Map<String,String> getById(@PathVariable("id")String id){
		Map<String,String> result = Maps.newHashMap();
		result.put("id",id);
		result.put("name","Jonathan");
		return result;
	}

	//Accept: image/png
	/**
	 * 文件上传
	 * @return
	 */
	@RequestMapping(value = "upload",consumes = "multipart/form-data",method = RequestMethod.POST)
	public Map<String,String> upload(@RequestParam("fileUpload") CommonsMultipartFile file){

		Map<String,String> result = Maps.newHashMap();
		result.put("id","1");
		// 判断文件是否存在
		if (!file.isEmpty()) {
			result.put("name","上传成功");
			return result;
		}
		result.put("name","上传失败");
		return result;
	}

	@RequestMapping(value = "/upload1", consumes = "multipart/form-data", method = RequestMethod.POST)
	public void picture(HttpServletRequest request) {

		String uploadPicturePath = "/Users/whatlookingfor/Pictures";
		String pathname = uploadPicturePath + "/";
		File file = new File(pathname);
		if (!file.exists()) {
			file.mkdirs();
		}
		MultipartHttpServletRequest muti = (MultipartHttpServletRequest) request;
		System.out.println(muti.getMultiFileMap().size());

		MultiValueMap<String, MultipartFile> map = muti.getMultiFileMap();
		for (Map.Entry<String, List<MultipartFile>> entry : map.entrySet()) {

			List<MultipartFile> list = entry.getValue();
			for (MultipartFile multipartFile : list) {

				try {
					multipartFile.transferTo(new File(pathname
							+ multipartFile.getOriginalFilename()));
				} catch (IOException e) {
					e.printStackTrace();
				}

			}
		}
	}






	@RequiresPermissions("ussda")
	@RequestMapping(value = "error/403",method = RequestMethod.GET)
	public String getError403(){
		return "12312";
	}


	@RequestMapping(value = "error/500",method = RequestMethod.GET)
	public Map<String,String> getError500(){
		int i = Integer.parseInt("sfsd");
		Map<String,String> result = Maps.newHashMap();
		result.put("2312","1231");
		result.put("value",i+"");
		return result;
	}


	@RequestMapping(value = "error/400",method = RequestMethod.GET)
	public User getError400(User user){
		return user;
	}



	@RequestMapping(value = "getFile",method = RequestMethod.GET,produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public void getMyFile(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String basePath = request.getSession().getServletContext().getRealPath("/");
		//读取路径
		String templateFile = "template" + File.separator +  "1.xlsx";
		FileInputStream fs = new FileInputStream(basePath + File.separator + templateFile);
		XSSFWorkbook wb = new XSSFWorkbook(fs);

		OutputStream os = response.getOutputStream();
		response.reset();
		response.setContentType("application/octet-stream; charset=utf-8");
		response.setHeader("Content-Disposition", "attachment; filename=1.xlsx");
		wb.write(os);
		os.close();
	}


	@RequestMapping(value = "getFile1",method = RequestMethod.GET,produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	public void getMyFile1(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String basePath = request.getSession().getServletContext().getRealPath("/");
		//读取路径
		String templateFile = "template" + File.separator +  "1.xlsx";
		FileInputStream fs = new FileInputStream(basePath + File.separator + templateFile);

		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
		int i = Integer.parseInt("12312sadsad");
		response.reset();
		response.setContentType("application/octet-stream; charset=utf-8");
		response.setHeader("Content-Disposition", "attachment; filename=1.xlsx");
		bis = new BufferedInputStream(fs);
		bos = new BufferedOutputStream(response.getOutputStream());
		byte[] buff = new byte[2048];
		int bytesRead;
		while (-1 != (bytesRead = bis.read(buff, 0, buff.length))) {
			bos.write(buff, 0, bytesRead);
		}

		bis.close();
		bos.close();
	}



}

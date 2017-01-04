/*
 * Copyright  2014-2016 whatlookingfor@gmail.com(Jonathan)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.mfnets.workfocus.modules.sys.web;

import com.alibaba.fastjson.JSONException;
import com.google.common.collect.Maps;
import com.mfnets.workfocus.common.web.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.Map;

/**
 * 上传控件的Controller
 *
 * @author Jonathan
 * @version 2016/11/4 15:52
 * @since JDK 7.0+
 */
@Controller
@RequestMapping(value = "${adminPath}/sys/upload")
public class UploadController extends BaseController {


	@RequestMapping(value = {"index",""})
	public String index(){
		return "modules/sys/upload";
	}


	@ResponseBody
	@RequestMapping(value = "test")
	public Map<String,String> test(HttpServletRequest request, HttpServletResponse response) throws IOException, JSONException {
		request.setCharacterEncoding("utf-8");
		response.setHeader("Content-Type", "text/html");
		String contentPath = request.getContextPath();

		String realPath = request.getSession().getServletContext()
				.getRealPath(contentPath);
		String path="static/upload/";

		String rootPath =  new File(realPath).getParent() +"/" +path;
		System.out.println(rootPath);
		Map<String,String> result = upload(request);
		return result;
	}

	public static Map<String,String> upload(HttpServletRequest request){
		Map<String,String> result = Maps.newHashMap();
		MultipartFile file = null;
		boolean isAjaxUpload = request.getHeader( "X_Requested_With" ) != null;
		ServletContext servletContext = request.getSession().getServletContext();
		CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver(servletContext);

		if(!multipartResolver.isMultipart(request)) { //判断request是否有文件上传
			result.put("error","文件不存在");
			return result;
		}

		if ( isAjaxUpload ) {
			multipartResolver.setDefaultEncoding("UTF-8");
		}

		try {
			MultipartHttpServletRequest multiRequest = multipartResolver.resolveMultipart(request);
			Iterator<String> iterator = multiRequest.getFileNames();


			while (iterator.hasNext()) {
				file = multiRequest.getFile(iterator.next());
				System.out.println(file.getOriginalFilename());
				if (file == null) {
					result.put("error","文件不存在");
					continue;
				}
				String originFileName = file.getOriginalFilename();



				InputStream is = file.getInputStream();
				is.close();
				result.put("ok","文件上传成功");

			}

		}catch (IOException e) {

		}

		return result;


	}

}

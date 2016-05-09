/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.demo.controller;

import com.mfnets.workfocus.common.utils.StringUtils;
import com.mfnets.workfocus.modules.demo.entity.FileUpload;
import com.mfnets.workfocus.modules.demo.service.FileUploadService;
import com.mfnets.workfocus.modules.sys.entity.Menu;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;

/**
 * 文件表单上传的demo
 * @author Jonathan
 * @version 2016/4/6 11:15
 * @since JDK 7.0+
 */
@Controller
@RequestMapping(value = "${adminPath}/demo/fileUpload")
public class FileUploadController {

    @Autowired
    private FileUploadService fileUploadService;

    @ModelAttribute("fileUpload")
    public FileUpload get(@RequestParam(required = false) String id) {
        if (StringUtils.isNotBlank(id)) {
            return fileUploadService.get(id);
        } else {
            return new FileUpload();
        }
    }

    @RequestMapping(value = {"index", ""})
    public String index(Model model){
        return "modules/demo/fileUpload";
    }


    @RequestMapping(value = "save")
    public String save(FileUpload fileUpload,HttpServletRequest request){
        String targetFiles = request.getSession().getServletContext().getRealPath("/");
        String path = fileUploadService.saveFile(fileUpload.getFile(),targetFiles);
        fileUpload.setName(path);
        return "modules/demo/fileUpload";
    }

}

package com.mfnets.workfocus.modules.demo.controller;

import com.mfnets.workfocus.common.utils.mail.MailSendUtils;
import com.mfnets.workfocus.common.web.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author Jonathan
 * @date 2016/4/18 16:27
 * @since V1.0
 */
@Controller
@RequestMapping(value = "${adminPath}/demo/editor")
public class EditorController extends BaseController{


    @RequestMapping(value = "summerNote")
    public String summerNote(HttpServletRequest request, HttpServletResponse response, Model model){
        return "modules/demo/summerNote";
    }



    @RequestMapping(value = "summerNote/sent")
    public String summerNoteSave(String emailAddress,  HttpServletResponse response, String title, String content, Model model){
        System.out.println(content);
        System.out.println(title);
        System.out.println(emailAddress);
        String[]addresses = emailAddress.split(";");
        String result = "";
        for(String address: addresses){
            boolean isSuccess = MailSendUtils.sendEmail("smtp.mxhichina.com", "25", "zhangzhan@mfnets.com", "qwewqewqeqw", address, title, content, "0");
            if(isSuccess){
                result += address+":<font color='green'>发送成功!</font><br/>";
            }else{
                result += address+":<font color='red'>发送失败!</font><br/>";
            }
        }
        addMessage(model,result);
        return "modules/demo/summerNote";
    }
}

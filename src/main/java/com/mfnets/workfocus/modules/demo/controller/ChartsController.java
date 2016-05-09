package com.mfnets.workfocus.modules.demo.controller;

import com.mfnets.workfocus.common.web.BaseController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * 甘特图 demo
 * @author Jonathan
 * @version 2016/3/28 18:47
 * @since JDK 7.0+
 */
@Controller
@RequestMapping(value = "${adminPath}/demo/charts")
public class ChartsController extends BaseController {


    /**
     *
     * 甘特图+点击事件
     *
     * @return
     */
    @RequestMapping(value = "chart1")
    public String chart1(){
        return "modules/demo/charts/chart1";
    }
}

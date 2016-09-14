/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.demo.service;

import com.mfnets.workfocus.common.service.BaseService;
import org.springframework.stereotype.Service;

/**
 * TODO
 *
 * @author Jonathan
 * @version 2016/9/1 15:59
 * @since JDK 7.0+
 */
@Service
public class DemoService extends BaseService {

    public void print(String times){
        System.out.println(times);
        System.out.println("123213213123132");
    }
}

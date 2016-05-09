/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.listener;

import com.mfnets.workfocus.common.config.Global;
import com.mfnets.workfocus.common.utils.CacheUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Service;

/**
 * 系统启动前的监听处理
 *
 * @author Jonathan
 * @version 2016/5/9 17:31
 * @since JDK 7.0+
 */
@Service
public class StartUpListener implements ApplicationListener<ContextRefreshedEvent> {

    protected Logger logger = LoggerFactory.getLogger(getClass());
    @Override
    public void onApplicationEvent(ContextRefreshedEvent evt) {
        if (evt.getApplicationContext().getParent() == null) {
            init();
        }
    }

    private void init() {
        StringBuilder sb = new StringBuilder();
        sb.append("\r\n======================================================================\r\n");
        sb.append("\r\n    欢迎使用 "+Global.getConfig("productName")+"  - Powered By whatlookingfor@gmail.com\r\n");
        sb.append("\r\n======================================================================\r\n");
        System.out.println(sb.toString());
        //判断是否清除缓存
        logger.info("启动时先清除缓存");
        CacheUtils.getCacheManager().clearAll();


    }


}

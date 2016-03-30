package com.mfnets.workfocus.common.task;

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.ApplicationContext;

/**
 * Created by whatlookingfor on 15/9/1.
 */
public class BaseJob {
    protected Logger logger = LoggerFactory.getLogger(getClass());

    private static final String APPLICATION_CONTEXT_KEY = "applicationContextKey";

    public ApplicationContext getApplicationContext(JobExecutionContext context) throws Exception {
        ApplicationContext appCtx = null;
        appCtx = (ApplicationContext) context.getScheduler().getContext().get(APPLICATION_CONTEXT_KEY);
        if (appCtx == null) {
            throw new JobExecutionException("No application context available in scheduler context for key \"" + APPLICATION_CONTEXT_KEY + "\"");
        }
        return appCtx;
    }
}

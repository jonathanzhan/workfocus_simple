/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.demo.listener;

import org.activiti.engine.delegate.DelegateTask;
import org.activiti.engine.delegate.TaskListener;
import org.springframework.stereotype.Service;

/**
 * 请假会签任务监听器,当会签任务完成时统计同意的数量
 *
 * @author Jonathan
 * @version 2016/9/23 14:40
 * @since JDK 7.0+
 */
@Service
public class LeaveCounterSignCompleteListener implements TaskListener {
	@Override
	public void notify(DelegateTask delegateTask) {
		String approved = (String) delegateTask.getVariable("approved");
		if("true".equals(approved)) {
			Long agreeCounter = (Long) delegateTask.getVariable("approvedCounter");
			delegateTask.setVariable("approvedCounter",agreeCounter+1);
		}
	}
}

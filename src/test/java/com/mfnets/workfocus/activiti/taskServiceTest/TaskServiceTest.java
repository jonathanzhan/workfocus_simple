/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.activiti.taskServiceTest;

import org.activiti.engine.TaskService;
import org.activiti.engine.task.Task;
import org.activiti.engine.task.TaskQuery;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.List;

/**
 * 任务的创建
 * 任务属性的修改
 * 任务的查询
 * 任务的签收
 * 任务的处理
 *
 *
 * @author Jonathan
 * @version 2016/11/2 10:03
 * @since JDK 7.0+
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext-test.xml")
public class TaskServiceTest {

	@Autowired
	private TaskService taskService;


	@Test
	public void addTaskTest(){
		Task task = taskService.newTask();
		task.setName("手动任务");
		task.setAssignee("admin");
		task.setDescription("手动创建任务,与流程无关");
		task.setOwner("admin");
		task.setPriority(1);
		taskService.saveTask(task);

		TaskQuery taskQuery = taskService.createTaskQuery();
		List<Task> taskList = taskQuery.taskNameLike("手动任务").taskAssignee("admin").list();
		Assert.assertTrue(taskList.size()>0);


	}
}

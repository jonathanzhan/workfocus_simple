/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.activiti.repositoryServiceTest;

import org.activiti.engine.RepositoryService;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.DeploymentBuilder;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.repository.ProcessDefinitionQuery;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.util.Assert;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.List;
import java.util.zip.ZipInputStream;

/**
 * 部署流程资源的测试类
 *
 * @author Jonathan
 * @version 2016/10/31 15:34
 * @since JDK 7.0+
 */
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("classpath:applicationContext-test.xml")
public class DeploymentTest {

	@Autowired
	private RepositoryService repositoryService;


	/**
	 * 用classPath方式部署
	 */
	@Test
	public void classPathDeploymentTest(){

		//定义资源文件的classPath
		String bpmnClassPath = "/bpmn/leave-dynamic-form.bpmn20.xml";
		String pngClassPath = "/bpmn/leave-dynamic-form.png";
		//创建部署构建器
		DeploymentBuilder deploymentBuilder = repositoryService.createDeployment();

		//添加资源
		deploymentBuilder.addClasspathResource(bpmnClassPath);
		deploymentBuilder.addClasspathResource(pngClassPath);
		//执行部署
		deploymentBuilder.deploy();
		//验证部署是否成功
		ProcessDefinitionQuery processDefinitionQuery = repositoryService.createProcessDefinitionQuery();
		long count = processDefinitionQuery.processDefinitionKey("leave-dynamic-from").count();
		Assert.isTrue(count == 1);
		//读取图片文件
		ProcessDefinition processDefinition = processDefinitionQuery.singleResult();
		String diagramResourceName = processDefinition.getDiagramResourceName();
		System.out.println(diagramResourceName);

	}


	/**
	 * 用inputStream方式部署
	 * @throws Exception
	 */
	@Test
	public void inputStreamFromAbsolutePathTest() throws Exception{
		String filePath = "/Users/whatlookingfor/code/workfocus/src/test/resources/bpmn/leave-dynamic-form.bpmn20.xml";
		//读取filePath文件作为一个输入流
		FileInputStream fileInputStream = new FileInputStream(filePath);
		repositoryService.createDeployment().addInputStream("leave-dynamic-form.bpmn20.xml",fileInputStream).deploy();
		//验证部署是否成功
		ProcessDefinitionQuery processDefinitionQuery = repositoryService.createProcessDefinitionQuery();
		long count = processDefinitionQuery.processDefinitionKey("leave-dynamic-form").count();
		Assert.isTrue(count == 1);
	}


	/**
	 * 用字符串方式部署
	 */
	@Test
	public void stringDeploymentTest(){
		String text = "xml内容";
		repositoryService.createDeployment().addString("leave-dynamic-form.bpmn20.xml",text);
		//验证是否部署成功
		ProcessDefinitionQuery processDefinitionQuery = repositoryService.createProcessDefinitionQuery();
		long count = processDefinitionQuery.processDefinitionKey("leave-dynamic-form").count();
		Assert.isTrue(count == 1);
	}


	/**
	 * zip/bar压缩包格式部署
	 */
	@Test
	public void zipStreamDeploymentTest(){
		//读取资源
		InputStream zipStream = getClass().getClassLoader().getResourceAsStream("bpmn/leave.zip");
		repositoryService.createDeployment().addZipInputStream(new ZipInputStream(zipStream)).deploy();
		//统计已部署流程定义的数量
		long count = repositoryService.createProcessDefinitionQuery().count();
		Assert.isTrue(count == 1);
		//查询部署记录
		Deployment deployment = repositoryService.createDeploymentQuery().singleResult();
		Assert.notNull(deployment);
		String deploymentId = deployment.getId();
		//验证资源文件是否都部署成功
		Assert.notNull(repositoryService.getResourceAsStream(deploymentId,"leave-dynamic-form.bpmn"));
		Assert.notNull(repositoryService.getResourceAsStream(deploymentId,"leave-dynamic-form.png"));
	}

	/**
	 * 根据部署ID删除部署
	 */
	@Test
	public void deleteDeployment(){
		String deploymentId = "leave-dynamic-form:1:5004";
		repositoryService.deleteDeployment(deploymentId,true);
	}


	@Test
	public void findDefinitionTest(){
		ProcessDefinitionQuery processDefinitionQuery = repositoryService.createProcessDefinitionQuery();
		List<ProcessDefinition> processDefinitionList = processDefinitionQuery.listPage(0,10);
	}




}

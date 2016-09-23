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
package com.mfnets.workfocus.modules.act.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.mfnets.workfocus.common.persistence.Page;
import com.mfnets.workfocus.common.service.BaseService;
import com.mfnets.workfocus.common.utils.StringUtils;
import com.mfnets.workfocus.modules.act.entity.Act;
import org.activiti.bpmn.converter.BpmnXMLConverter;
import org.activiti.bpmn.model.BpmnModel;
import org.activiti.editor.constants.ModelDataJsonConstants;
import org.activiti.editor.language.json.converter.BpmnJsonConverter;
import org.activiti.engine.*;
import org.activiti.engine.history.HistoricActivityInstanceQuery;
import org.activiti.engine.history.HistoricProcessInstance;
import org.activiti.engine.history.HistoricProcessInstanceQuery;
import org.activiti.engine.history.HistoricVariableInstance;
import org.activiti.engine.repository.Deployment;
import org.activiti.engine.repository.ProcessDefinition;
import org.activiti.engine.repository.ProcessDefinitionQuery;
import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.runtime.ProcessInstanceQuery;
import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import java.io.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.zip.ZipInputStream;

/**
 * 流程定义事物层处理
 * 
 * @author Jonathan
 * @version 2016/9/12 13:46
 * @since JDK 7.0+
 */

@Service
@Transactional(readOnly = true)
public class ActProcessService extends BaseService {

	@Autowired
	private RepositoryService repositoryService;
	@Autowired
	private RuntimeService runtimeService;

	@Autowired
	private FormService formService;

	@Autowired
	private HistoryService historyService;

	/**
	 * 流程定义列表
	 */
	public Page<Object[]> processList(Page<Object[]> page, String category) {

	    ProcessDefinitionQuery processDefinitionQuery = repositoryService.createProcessDefinitionQuery()
	    		.latestVersion().orderByProcessDefinitionKey().asc();
	    
	    if (StringUtils.isNotEmpty(category)){
	    	processDefinitionQuery.processDefinitionCategory(category);
		}
	    
	    page.setCount(processDefinitionQuery.count());
	    
	    List<ProcessDefinition> processDefinitionList = processDefinitionQuery.listPage(page.getFirstResult(), page.getMaxResults());
	    for (ProcessDefinition processDefinition : processDefinitionList) {
	      String deploymentId = processDefinition.getDeploymentId();
	      Deployment deployment = repositoryService.createDeploymentQuery().deploymentId(deploymentId).singleResult();
	      page.getList().add(new Object[]{processDefinition, deployment});
	    }

		return page;
	}

	/**
	 * 流程定义列表
	 */
	public Page<ProcessInstance> runningList(Page<ProcessInstance> page, String procInsId, String procDefKey) {

	    ProcessInstanceQuery processInstanceQuery = runtimeService.createProcessInstanceQuery();

	    if (StringUtils.isNotBlank(procInsId)){
		    processInstanceQuery.processInstanceId(procInsId);
	    }
	    
	    if (StringUtils.isNotBlank(procDefKey)){
		    processInstanceQuery.processDefinitionKey(procDefKey);
	    }
	    
	    page.setCount(processInstanceQuery.count());
	    page.setList(processInstanceQuery.listPage(page.getFirstResult(), page.getMaxResults()));
		return page;
	}

	/**
	 * 已经完成的流程列表查询
	 * @param page 分页信息实体类
	 * @param act 流程查询实体类(procDefKey,beginDate,endDate)
	 * @return
	 */
	public Page<HistoricProcessInstance> finishList(Page<HistoricProcessInstance> page, Act act) {

		HistoricProcessInstanceQuery historicProcessInstanceQuery = historyService.createHistoricProcessInstanceQuery().finished();
		// 设置查询条件
		if (StringUtils.isNotBlank(act.getProcDefKey())){
			historicProcessInstanceQuery.processDefinitionKey(act.getProcDefKey());
		}
		if (act.getBeginDate() != null){
			historicProcessInstanceQuery.finishedAfter(act.getBeginDate());
		}
		if (act.getEndDate() != null){
			historicProcessInstanceQuery.finishedBefore(act.getEndDate());
		}

		page.setCount(historicProcessInstanceQuery.count());
		page.setList(historicProcessInstanceQuery.listPage(page.getFirstResult(), page.getMaxResults()));
		return page;
	}



	
	/**
	 * 读取资源，通过部署ID
	 * @param procDefId  流程定义ID
	 * @param proInsId 流程实例ID
	 * @param resType 资源类型(xml|image)
	 */
	public InputStream resourceRead(String procDefId, String proInsId, String resType) throws Exception {
		
		if (StringUtils.isBlank(procDefId)){
			ProcessInstance processInstance = runtimeService.createProcessInstanceQuery().processInstanceId(proInsId).singleResult();
			procDefId = processInstance.getProcessDefinitionId();
		}
		ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery().processDefinitionId(procDefId).singleResult();
		
		String resourceName = "";
		if (resType.equals("image")) {
			resourceName = processDefinition.getDiagramResourceName();
		} else if (resType.equals("xml")) {
			resourceName = processDefinition.getResourceName();
		}
		
		InputStream resourceAsStream = repositoryService.getResourceAsStream(processDefinition.getDeploymentId(), resourceName);
		return resourceAsStream;
	}
	
	/**
	 * 部署流程 - 保存
	 * @param file
	 * @return
	 */
	@Transactional(readOnly = false)
	public String deploy(String exportDir, String category, MultipartFile file) {

		String message = "";
		
		String fileName = file.getOriginalFilename();
		
		try {
			InputStream fileInputStream = file.getInputStream();
			Deployment deployment = null;
			String extension = FilenameUtils.getExtension(fileName);
			if (extension.equals("zip") || extension.equals("bar")) {
				ZipInputStream zip = new ZipInputStream(fileInputStream);
				deployment = repositoryService.createDeployment().addZipInputStream(zip).deploy();
			} else if (extension.equals("png")) {
				deployment = repositoryService.createDeployment().addInputStream(fileName, fileInputStream).deploy();
			} else if (fileName.indexOf("bpmn20.xml") != -1) {
				deployment = repositoryService.createDeployment().addInputStream(fileName, fileInputStream).deploy();
			} else if (extension.equals("bpmn")) { // bpmn扩展名特殊处理，转换为bpmn20.xml
				String baseName = FilenameUtils.getBaseName(fileName); 
				deployment = repositoryService.createDeployment().addInputStream(baseName + ".bpmn20.xml", fileInputStream).deploy();
			} else {
				message = "不支持的文件类型：" + extension;
			}
			
			List<ProcessDefinition> list = repositoryService.createProcessDefinitionQuery().deploymentId(deployment.getId()).list();

			// 设置流程分类
			for (ProcessDefinition processDefinition : list) {
//					ActUtils.exportDiagramToFile(repositoryService, processDefinition, exportDir);
				repositoryService.setProcessDefinitionCategory(processDefinition.getId(), category);
				message += "部署成功，流程ID=" + processDefinition.getId() + "<br/>";
			}
			
			if (list.size() == 0){
				message = "部署失败，没有流程。";
			}
			
		} catch (Exception e) {
			throw new ActivitiException("部署失败！", e);
		}
		return message;
	}
	
	/**
	 * 设置流程分类
	 */
	@Transactional(readOnly = false)
	public void updateCategory(String procDefId, String category) {
		repositoryService.setProcessDefinitionCategory(procDefId, category);
	}

	/**
	 * 挂起,激活流程定义
	 * @param state
	 * @param procDefId
     * @return
     */
	@Transactional(readOnly = false)
	public String updateState(String state, String procDefId) {
		if (state.equals("active")) {
			repositoryService.activateProcessDefinitionById(procDefId, true, null);
			return "已激活ID为[" + procDefId + "]的流程定义。";
		} else if (state.equals("suspend")) {
			repositoryService.suspendProcessDefinitionById(procDefId, true, null);
			return "已挂起ID为[" + procDefId + "]的流程定义。";
		}
		return "无操作";
	}

	/**
	 * 挂起,激活流程实例(正在运行的流程)
	 * @param state
	 * @param processInstanceId
     * @return
     */
	@Transactional(readOnly = false)
	public String updateProcessInstanceState(String state, String processInstanceId) {
		if (state.equals("active")) {
			runtimeService.activateProcessInstanceById(processInstanceId);
			return "已激活ID为[" + processInstanceId + "]的流程实例。";
		} else if (state.equals("suspend")) {
			runtimeService.suspendProcessInstanceById(processInstanceId);
			return "已挂起ID为[" + processInstanceId + "]的流程实例。";
		}
		return "无操作";
	}

	
	/**
	 * 将部署的流程转换为模型
	 * @param procDefId
	 * @throws UnsupportedEncodingException
	 * @throws XMLStreamException
	 */
	@Transactional(readOnly = false)
	public org.activiti.engine.repository.Model convertToModel(String procDefId) throws UnsupportedEncodingException, XMLStreamException {
		
		ProcessDefinition processDefinition = repositoryService.createProcessDefinitionQuery().processDefinitionId(procDefId).singleResult();
		InputStream bpmnStream = repositoryService.getResourceAsStream(processDefinition.getDeploymentId(),
		processDefinition.getResourceName());
		XMLInputFactory xif = XMLInputFactory.newInstance();
		InputStreamReader in = new InputStreamReader(bpmnStream, "UTF-8");
		XMLStreamReader xtr = xif.createXMLStreamReader(in);
		BpmnModel bpmnModel = new BpmnXMLConverter().convertToBpmnModel(xtr);
	
		BpmnJsonConverter converter = new BpmnJsonConverter();
		ObjectNode modelNode = converter.convertToJson(bpmnModel);
		org.activiti.engine.repository.Model modelData = repositoryService.newModel();
		modelData.setKey(processDefinition.getKey());
		modelData.setName(processDefinition.getResourceName());
		modelData.setCategory(processDefinition.getCategory());//.getDeploymentId());
		modelData.setDeploymentId(processDefinition.getDeploymentId());
		modelData.setVersion(Integer.parseInt(String.valueOf(repositoryService.createModelQuery().modelKey(modelData.getKey()).count()+1)));
	
		ObjectNode modelObjectNode = new ObjectMapper().createObjectNode();
		modelObjectNode.put(ModelDataJsonConstants.MODEL_NAME, processDefinition.getName());
		modelObjectNode.put(ModelDataJsonConstants.MODEL_REVISION, modelData.getVersion());
		modelObjectNode.put(ModelDataJsonConstants.MODEL_DESCRIPTION, processDefinition.getDescription());
		modelData.setMetaInfo(modelObjectNode.toString());
	
		repositoryService.saveModel(modelData);
	
		repositoryService.addModelEditorSource(modelData.getId(), modelNode.toString().getBytes("utf-8"));
	
		return modelData;
	}
	
	/**
	 * 导出图片文件到硬盘
	 */
	public List<String> exportDiagrams(String exportDir) throws IOException {
		List<String> files = new ArrayList<String>();
		List<ProcessDefinition> list = repositoryService.createProcessDefinitionQuery().list();
		
		for (ProcessDefinition processDefinition : list) {
			String diagramResourceName = processDefinition.getDiagramResourceName();
			String key = processDefinition.getKey();
			int version = processDefinition.getVersion();
			String diagramPath = "";

			InputStream resourceAsStream = repositoryService.getResourceAsStream(
					processDefinition.getDeploymentId(), diagramResourceName);
			byte[] b = new byte[resourceAsStream.available()];

			@SuppressWarnings("unused")
			int len = -1;
			resourceAsStream.read(b, 0, b.length);

			// create file if not exist
			String diagramDir = exportDir + "/" + key + "/" + version;
			File diagramDirFile = new File(diagramDir);
			if (!diagramDirFile.exists()) {
				diagramDirFile.mkdirs();
			}
			diagramPath = diagramDir + "/" + diagramResourceName;
			File file = new File(diagramPath);

			// 文件存在退出
			if (file.exists()) {
				// 文件大小相同时直接返回否则重新创建文件(可能损坏)
				logger.debug("diagram exist, ignore... : {}", diagramPath);
				
				files.add(diagramPath);
			} else {
				file.createNewFile();
				logger.debug("export diagram to : {}", diagramPath);

				// wirte bytes to file
				FileUtils.writeByteArrayToFile(file, b, true);
				
				files.add(diagramPath);
			}
			
		}
		
		return files;
	}

	/**
	 * 删除部署的流程，级联删除流程实例
	 * @param deploymentId 流程部署ID
	 */
	@Transactional(readOnly = false)
	public void deleteDeployment(String deploymentId) {
		repositoryService.deleteDeployment(deploymentId, true);
	}
	
	/**
	 * 删除部署的流程实例
	 * @param procInsId 流程实例ID
	 * @param deleteReason 删除原因，可为空
	 */
	@Transactional(readOnly = false)
	public void deleteProcIns(String procInsId, String deleteReason) {
		runtimeService.deleteProcessInstance(procInsId, deleteReason);
	}


	/**
	 * 根据流程定义ID获取流程启动的formKey值
	 * @param procDefId
	 * @return
	 */
	public String getStartFormKey(String procDefId) {
		String formKey = "";
		if(StringUtils.isNotBlank(procDefId)){
			try{
				formKey = formService.getStartFormKey(procDefId);
			}catch (Exception e){
				formKey = "";
			}
		}
		logger.debug("流程定义ID:{},对应的流程开始表单key为{}",procDefId,formKey);
		return formKey;
	}

	/**
	 * 根据流程实例ID,查询已经完成的流程的变量信息
	 * @param proInsId
	 * @return
	 */
	public List<HistoricVariableInstance> getHistoricVariable(String proInsId) {
		return historyService.createHistoricVariableInstanceQuery().processInstanceId(proInsId).orderByVariableName().desc().list();
	}
}

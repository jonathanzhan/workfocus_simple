<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
	<title>业务表管理</title>
	<%@include file="/WEB-INF/views/include/head.jsp" %>
	<script type="text/javascript">
		$(document).ready(function() {
			$("#comments").focus();

//			$('#contentTable').DataTable({
//				scrollY:"500px"
//				,scrollX:true//显示横向滚动
//				,scrollCollapse:true//当显示更少的记录时，是否允许表格减少高度
//				,searching: false//是否允许Datatables开启本地搜索
//				,ordering:  false//是否显示排序
//				,info:false//控制是否显示表格左下角的信息
//				,paging: false//是否开启本地分页
//				,fixedColumns:   {//固定列
//					leftColumns: 5,//左边固定几行
//					rightColumns:0 //右边固定几行
//				}
//				,fixedHeader: {//固定表头
//					header: true
//				}
//				,columnDefs:[{
//					orderable:false,//禁用排序
//					targets:[0,1]   //指定的列
//				}]
//			} );


			$("#inputForm").validate({
				submitHandler: function(form){
					loading('正在提交，请稍等...');
					$("input[type=checkbox]").each(function(){
						$(this).after("<input type=\"hidden\" name=\""+$(this).attr("name")+"\" value=\""
								+($(this).attr("checked")?"1":"0")+"\"/>");
						$(this).attr("name", "_"+$(this).attr("name"));
					});
					form.submit();
				},
				errorContainer: "#messageBox",
				errorPlacement: function(error, element) {
					$("#messageBox").text("输入有误，请先更正。");
					if (element.is(":checkbox")||element.is(":radio")||element.parent().is(".input-append")){
						error.appendTo(element.parent().parent());
					} else {
						error.insertAfter(element);
					}
				}
			});
		});
	</script>
</head>

<body class="gray-bg">
<div class="wrapper wrapper-content">

	<div class="ibox">
		<div class="ibox-title">
			<a href="${ctx}/gen/genTable/form?id=${genTable.id}&name=${genTable.name}"><h5>业务表<shiro:hasPermission name="gen:genTable:edit">${not empty genTable.id?'修改':'添加'}</shiro:hasPermission><shiro:lacksPermission name="gen:genTable:edit">查看</shiro:lacksPermission></h5></a>

			<div class="ibox-tools">
				<a href="${ctx}/gen/genTable/" class="btn btn-primary btn-xs">返回业务表列表</a>
			</div>
		</div>

		<div class="ibox-content">
		<c:choose>
			<c:when test="${empty genTable.name}">
				<form:form id="inputForm" modelAttribute="genTable" action="${ctx}/gen/genTable/form" method="post" class="form-horizontal">
					<form:hidden path="id"/>
					<sys:message content="${message}"/>

					<div class="form-group">
						<label class="col-md-2 control-label">表名</label>

						<div class="col-md-3">
							<form:select path="name" class="form-control">
								<form:options items="${tableList}" itemLabel="nameAndComments" itemValue="name" htmlEscape="false"/>
							</form:select>
						</div>
					</div>
					<div class="form-group">
						<div class="col-md-offset-2">
							<input id="btnSubmit" class="btn btn-primary" type="submit" value="下一步"/>&nbsp;
							<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
						</div>

					</div>
				</form:form>
			</c:when>
			<c:otherwise>
				<form:form id="inputForm" modelAttribute="genTable" action="${ctx}/gen/genTable/save" method="post" class="form-horizontal">
					<form:hidden path="id"/>
					<sys:message content="${message}"/>
					<fieldset>
						<legend>基本信息</legend>
						<div class="form-group">
							<label class="col-md-2 control-label">表名</label>
							<div class="col-md-3">
								<form:input path="name" htmlEscape="false" maxlength="200" class="form-control required" readonly="true"/>
							</div>
						</div>

						<div class="form-group">
							<label class="col-md-2 control-label">说明</label>
							<div class="col-md-3">
								<form:input path="comments" htmlEscape="false" maxlength="200" class="form-control required"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">类名:</label>
							<div class="col-md-3">
								<form:input path="className" htmlEscape="false" maxlength="200" class="form-control required"/>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">父表表名:</label>
							<div class="col-md-3">
								<form:select path="parentTable" cssClass="form-control">
									<form:option value="">无</form:option>
									<form:options items="${tableList}" itemLabel="nameAndComments" itemValue="name" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">当前表外键:</label>
							<div class="col-md-3">
								<form:select path="parentTableFk" cssClass="form-control">
									<form:option value="">无</form:option>
									<form:options items="${genTable.columnList}" itemLabel="nameAndComments" itemValue="name" htmlEscape="false"/>
								</form:select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-md-2 control-label">备注:</label>
							<div class="col-md-3">
								<form:textarea path="remarks" htmlEscape="false" rows="4" maxlength="200" class="form-control"/>
							</div>
						</div>
						<legend>字段列表</legend>
						<div class="control-group">
							<table data-toggle="table"
								   data-height="500"
								   data-row-style="rowStyle">
							<%--<table id="contentTable" class="table table-striped table-bordered table-hover table-condensed dataTable">--%>
							<thead>
								<tr>
									<th title="数据库字段名">列名</th>
									<th title="默认读取数据库字段备注">说明</th>
									<th title="数据库中设置的字段类型及长度">物理类型</th>
									<th title="实体对象的属性字段类型">Java类型</th>
									<th title="实体对象的属性字段（对象名.属性名|属性名2|属性名3，例如：用户user.id|name|loginName，属性名2和属性名3为Join时关联查询的字段）">Java属性名称 <i class="icon-question-sign"></i></th>
									<th title="是否是数据库主键">主键</th>
									<th title="字段是否可为空值，不可为空字段自动进行空值验证">可空</th>
									<th title="选中后该字段被加入到insert语句里">插入</th>
									<th title="选中后该字段被加入到update语句里">编辑</th>
									<th title="选中后该字段被加入到查询列表里">列表</th>
									<th title="选中后该字段被加入到查询条件里">查询</th>
									<th title="该字段为查询字段时的查询匹配放松">查询方式</th>
									<th title="字段在表单中显示的类型">表单类型</th>
									<th title="显示表单类型设置为“下拉框、复选框、点选框”时，需设置字典的类型">字典类型</th>
									<th>排序</th>
								</tr>
								</thead>
								<tbody>
								<c:forEach items="${genTable.columnList}" var="column" varStatus="vs">
									<tr${column.delFlag ==1?' class="error" title="已删除的列，保存之后消失！"':''}>
										<td nowrap>
											<input type="hidden" name="columnList[${vs.index}].id" value="${column.id}"/>
											<input type="hidden" name="columnList[${vs.index}].delFlag" value="${column.delFlag}"/>
											<input type="hidden" name="columnList[${vs.index}].genTable.id" value="${column.genTable.id}"/>
											<input type="hidden" name="columnList[${vs.index}].name" value="${column.name}"/>${column.name}
										</td>
										<td>
											<input type="text" name="columnList[${vs.index}].comments" value="${column.comments}" maxlength="200" class="required form-control" style="width:90px;"/>
										</td>
										<td nowrap>
											<input type="hidden" name="columnList[${vs.index}].jdbcType" value="${column.jdbcType}"/>${column.jdbcType}
										</td>
										<td>
											<select name="columnList[${vs.index}].javaType" class="required form-control" style="width:85px;">
												<c:forEach items="${config.javaTypeList}" var="dict">
													<option value="${dict.value}" ${dict.value==column.javaType?'selected':''} title="${dict.label}">${dict.label}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="text" name="columnList[${vs.index}].javaField" value="${column.javaField}" maxlength="200" class="required form-control" style="width:90px;"/>
										</td>
										<td>
											<input type="checkbox" name="columnList[${vs.index}].isPk" value="1" ${column.isPk eq '1' ? 'checked' : ''}/>
										</td>
										<td>
											<input type="checkbox" name="columnList[${vs.index}].isNull" value="1" ${column.isNull eq '1' ? 'checked' : ''}/>
										</td>
										<td>
											<input type="checkbox" name="columnList[${vs.index}].isInsert" value="1" ${column.isInsert eq '1' ? 'checked' : ''}/>
										</td>
										<td>
											<input type="checkbox" name="columnList[${vs.index}].isEdit" value="1" ${column.isEdit eq '1' ? 'checked' : ''}/>
										</td>
										<td>
											<input type="checkbox" name="columnList[${vs.index}].isList" value="1" ${column.isList eq '1' ? 'checked' : ''}/>
										</td>
										<td>
											<input type="checkbox" name="columnList[${vs.index}].isQuery" value="1" ${column.isQuery eq '1' ? 'checked' : ''}/>
										</td>
										<td>
											<select name="columnList[${vs.index}].queryType" class="required form-control" style="width:85px;">
												<c:forEach items="${config.queryTypeList}" var="dict">
													<option value="${fns:escapeHtml(dict.value)}" ${fns:escapeHtml(dict.value)==column.queryType?'selected':''} title="${dict.label}">${fns:escapeHtml(dict.label)}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<select name="columnList[${vs.index}].showType" class="required form-control" style="width:90px;">
												<c:forEach items="${config.showTypeList}" var="dict">
													<option value="${dict.value}" ${dict.value==column.showType?'selected':''} title="${dict.label}">${dict.label}</option>
												</c:forEach>
											</select>
										</td>
										<td>
											<input type="text" name="columnList[${vs.index}].dictType" value="${column.dictType}" maxlength="200" class="form-control" style="width:85px;"/>
										</td>
										<td>
											<input type="text" name="columnList[${vs.index}].sort" value="${column.sort}" maxlength="200" class="required form-control digits" style="width:75px;"/>
										</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
						</div>
					</fieldset>
					<div class="form-group">
						<div class="col-md-offset-2">
							<shiro:hasPermission name="gen:genTable:edit">
								<input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>
							</shiro:hasPermission>
							<input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
						</div>

					</div>
				</form:form>
			</c:otherwise>
		</c:choose>

		</div>
	</div>
</div>
</body>
</html>




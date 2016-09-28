<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<table class="table table-striped table-bordered table-condensed">
	<thead>
	<tr>
		<th>变量名</th><th>类型</th><th>值</th><th>创建时间</th><th>最后一次修改</th>
	</tr>
	</thead>
	<tbody>
	<c:forEach items="${varList}" var="var">
		<tr>
			<td>${var.variableName}</td>
			<td>${var.variableTypeName}</td>
			<td>${var.value}</td>
			<td><fmt:formatDate value="${var.createTime}" type="both"/></td>
			<td><fmt:formatDate value="${var.lastUpdatedTime}" type="both"/></td>
		</tr>
	</c:forEach>
	</tbody>
</table>
<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="id" type="java.lang.String" required="true"%>
<%@ attribute name="name" type="java.lang.String" required="true"%>
<%@ attribute name="value" type="java.lang.String" required="true"%>
<%@ attribute name="callback" type="java.lang.String" required="true"%>
<input id="${id}" name="${name}" type="hidden" value="${value}"/>
<%-- 使用方法： 1.将本tag写在查询的from里；2.在需要排序th列class上添加：sort-column sorting+ 排序字段名；3.后台sql添加排序引用page.orderBy；实例文件：userList.jsp、UserDao.xml --%>
<script type="text/javascript">
	$(document).ready(function() {
		var orderBy = $("#${id}").val().split(" ");
		$(".sort-column").each(function(){
			if ($(this).data('sort')==orderBy[0]){
				orderBy[1] = orderBy[1]&&orderBy[1].toUpperCase()=="DESC"?"sorting_desc":"sorting_asc";
				$(this).removeClass('sorting');
				$(this).addClass(orderBy[1]);
			}
		});
		$(".sort-column").click(function(){
			if($(this).hasClass('sorting_asc')){
				$("#${id}").val($(this).data('sort')+" DESC");
			}else{
				$("#${id}").val($(this).data('sort')+" ASC");
			}
			${callback}
		});
	});
</script>
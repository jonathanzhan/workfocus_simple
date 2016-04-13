<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ attribute name="url" type="java.lang.String" required="true" %>
<%@ attribute name="title" type="java.lang.String" required="true" %>
<%@ attribute name="width" type="java.lang.String" required="false" %>
<%@ attribute name="height" type="java.lang.String" required="false" %>
<%@ attribute name="target" type="java.lang.String" required="false" %>
<%@ attribute name="label" type="java.lang.String" required="false" %>
<%@ attribute name="paramName" type="java.lang.String" required="false" description="后台传值的参数名称" %>
<button class="btn btn-white btn-sm" data-toggle="tooltip" data-placement="left" type="button"
        onclick="edit()" title="${label==null?'修改':label}">
    <i class="fa fa-file-text-o"></i> ${label==null?'修改':label}
</button>
<%-- 使用方法： 必须结合tableAllCheck.tag(table权限标签使用) --%>
<%--注意:删除方法的默认参数是id--%>
<script type="text/javascript">
    function edit() {
        var size = getCheckNum();
        if (size == 0) {
            top.layer.alert('请至少选择一条数据!', {icon: 0, title: '警告'});
            return;
        }

        if (size > 1) {
            top.layer.alert('只能选择一条数据!', {icon: 0, title: '警告'});
            return;
        }
        var param = '${paramName==null?'id':paramName}';
        openDialog("修改" + '${title}', "${url}?"+param+"=" + getCheckIds(), "${width==null?'800px':width}", "${height==null?'500px':height}", "${target}");
    }
</script>
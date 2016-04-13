<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<%@ attribute name="url" type="java.lang.String" required="true" description="删除方法的地址" %>
<%@ attribute name="label" type="java.lang.String" required="false" description="删除按钮的内容" %>
<%@ attribute name="paramName" type="java.lang.String" required="false" description="后台传值的参数名称" %>
<button class="btn btn-white btn-sm" type="button" onclick="deleteAll()" data-toggle="tooltip" data-placement="top">
    <i class="fa fa-trash-o"> ${label==null?'删除':label}</i>
</button>
<%-- 使用方法： 必须结合tableAllCheck.tag(table权限标签使用) --%>
<%--注意:删除方法的默认参数是ids--%>
<script type="text/javascript">
    function deleteAll() {
        var ids = getCheckIds();//tableAllCheck.tag获取选中的id,','隔开
        if (ids == "") {
            top.layer.alert('请至少选择一条数据!', {icon: 0, title: '警告'});
            return;
        }
        var param = '${paramName==null?'ids':paramName}';
        top.layer.confirm('确认要彻底删除数据吗?', {icon: 3, title: '系统提示'}, function (index) {
            window.location = "${url}?"+param+"=" + ids;
            top.layer.close(index);
        });
    }
</script>
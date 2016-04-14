<%@ tag language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<%@ attribute name="checkBoxClass" type="java.lang.String" required="true" description="table内容行上的复选框的样式" %>
<%@ attribute name="checkAllId" type="java.lang.String" required="true" description="全选的样式名称,包括隐藏hidden的id值,两者一致,默认值为check-all,有默认样式,如果check-all被占用,建议权限的样式中增加check-all,比如class=check-all asd  hidden id = asd"  %>
<%@ attribute name="fixedColumn" type="java.lang.Boolean" required="false" description="是否固定列" %>
<%@ attribute name="tableSelector" type="java.lang.String" required="false" description="如果不是固定列的话,table的选择器,如果只有一个table,可以不写" %>
<script type="text/javascript">
	$(function(){
		//复选框的样式 (必须在datatable初始化之后，否则不能选中)
		$('.'+'${checkBoxClass}').iCheck({
			checkboxClass: 'icheckbox_flat-green',
			radioClass: 'iradio_flat-green'
		});

		$('table thead tr th.'+'${checkAllId}').removeClass("sorting_asc");
		//表头全选的点击事件
		$('table thead tr th.'+'${checkAllId}').click(function(){
			if($("#"+'${checkAllId}').val()==0){
				$('${tableSelector}'+' tbody tr td input.'+'${checkBoxClass}').iCheck('check');
				$("#"+'${checkAllId}').val(1);
			}else{
				$('${tableSelector}'+' tbody tr td input.'+'${checkBoxClass}').iCheck('uncheck');
				$("#"+'${checkAllId}').val(0);
			}
		});
	})

	/**
	*获取选中的id，以逗号隔开，最后一位没有逗号
	 */
	function getCheckIds(){
		var tableSelector = '';

		if ("${fixedColumn}" == "true"){//固定列的真实table的样式包含DTFC_Cloned
			tableSelector = ".DTFC_Cloned";
		}else{
			tableSelector = '${tableSelector}';//普通table的样式或者id
		}
		var str="";
		var ids="";
		$(tableSelector+" tbody tr td input."+'${checkBoxClass}'+":checkbox").each(function(){
			if(true == $(this).is(':checked')){
				str+=$(this).attr("id")+",";
			}
		});
		if(str.substr(str.length-1)== ','){
			ids = str.substr(0,str.length-1);
		}
		return ids;
	}

	/**
	* 获取选中的个数
	* @returns checkNum
	 */
	function getCheckNum(){
		var tableSelector = '';

		if ("${fixedColumn}" == "true"){//固定列的真实table的样式包含DTFC_Cloned
			tableSelector = ".DTFC_Cloned";
		}else{
			tableSelector = '${tableSelector}';//普通table的样式或者id
		}
		return $(tableSelector+" tbody tr td input."+'${checkBoxClass}'+":checked").size();
	}
</script>

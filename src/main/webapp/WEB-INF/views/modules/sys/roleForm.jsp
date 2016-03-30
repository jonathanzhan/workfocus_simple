<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE HTML>
<html>
<head>
    <title>角色管理</title>
    <%@include file="/WEB-INF/views/include/head.jsp" %>
    <%@include file="/WEB-INF/views/include/treeview.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            $("#name").focus();
            $("#inputForm").validate({
                rules: {
                    roleName: {remote: "${ctx}/sys/role/checkName?oldName=" + encodeURIComponent("${role.name}")},
                    roleEname: {remote: "${ctx}/sys/role/checkEname?oldEname=" + encodeURIComponent("${role.ename}")}
                },
                messages: {
                    roleName: {remote: "角色名已存在"},
                    roleEname: {remote: "英文名已存在"}
                },
                submitHandler: function (form) {
                    var ids = [], nodes = tree.getCheckedNodes(true);
                    for (var i = 0; i < nodes.length; i++) {
                        ids.push(nodes[i].id);
                    }
                    $("#menuIds").val(ids);
                    layer.load();
                    form.submit();
                },
                highlight: function (e) {
                    $(e).closest('.row-group').removeClass('has-success').addClass('has-error');
                },
                unhighlight: function (e) {
                    $(e).closest('.row-group').removeClass('has-error').addClass('has-success');

                },
                invalidHandler: function (form, validator) {
                    var errors = validator.numberOfInvalids();
                    if (errors) {
                        showMessageBox('保存失败,信息填写不完整!');
                    } else {
                        hideMessageBox();
                    }

                },
                errorPlacement: function (error, element) {
                    if (element.is(":checkbox") || element.is(":radio") || element.parent().is(".input-group")) {
                        error.appendTo(element.parent().parent().parent());
                    } else {
                        error.appendTo(element.parent().parent());
                    }
                }

            });

            var setting = {
                check: {enable: true, nocheckInherit: true}, view: {selectedMulti: false},
                data: {simpleData: {enable: true}}, callback: {
                    beforeClick: function (id, node) {
                        tree.checkNode(node, !node.checked, true, true);
                        return false;
                    }
                }
            };

            // 用户-菜单
            var zNodes = [
                    <c:forEach items="${menuList}" var="menu">{
                    id: "${menu.id}",
                    pId: "${not empty menu.parent.id?menu.parent.id:0}",
                    name: "${not empty menu.parent.id?menu.name:'权限列表'}"
                },
                </c:forEach>];
            // 初始化树结构
            var tree = $.fn.zTree.init($("#menuTree"), setting, zNodes);
            // 不选择父节点
            tree.setting.check.chkboxType = {"Y": "ps", "N": "s"};
            // 默认选择节点
            var ids = "${role.menuIds}".split(",");
            for (var i = 0; i < ids.length; i++) {
                var node = tree.getNodeByParam("id", ids[i]);
                try {
                    tree.checkNode(node, true, false);
                } catch (e) {
                }
            }
            // 默认展开全部节点
            tree.expandAll(true);
        });

    </script>
</head>
<body class="gray-bg">
<div class="wrapper wrapper-content">
    <div class="ibox">
        <div class="ibox-title">
            <a href="${ctx}/sys/role/form?id=${role.id}">角色管理</a>

            <div class="ibox-tools">
                <a href="${ctx}/sys/role" class="btn btn-primary btn-xs">返回角色列表</a>
            </div>
        </div>
        <div class="ibox-content">
            <form:form id="inputForm" modelAttribute="role" action="${ctx}/sys/role/save" method="post"
                       class="form-horizontal">
                <form:hidden path="id"/>
                <sys:message content="${message}"/>
                <div class="row">
                    <div class="col-md-5 col-xs-12">
                        <div class="form-group">
                            <label class="col-md-3 control-label">角色名称</label>

                            <div class="col-md-5">
                                <input id="oldName" name="oldName" type="hidden" value="${role.name}">
                                <form:input path="name" htmlEscape="false" maxlength="20"
                                            class="form-control inline required"/>
                                <div class="required-wrapper">*</div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">英文名称</label>

                            <div class="col-md-5">
                                <input id="oldEname" name="oldEname" type="hidden" value="${role.ename}">
                                <form:input path="ename" htmlEscape="false" maxlength="20"
                                            class="form-control inline required"/>
                                <div class="required-wrapper">*</div>
                                <span class="help-block m-b-none">工作流用户组标识</span>
                            </div>

                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">角色类型</label>

                            <div class="col-md-5">
                                <form:select path="roleType" class="form-control">
                                    <form:options items="${fns:getDictList('role_type')}" itemLabel="label"
                                                  itemValue="value" htmlEscape="false"/>
                                </form:select>
								<span class="help-block m-b-none"
                                      title="activiti有3种预定义的组类型：security-role、assignment、user 如果使用Activiti Explorer，需要security-role才能看到manage页签，需要assignment才能claim任务">
									工作流组用户组类型（任务分配：assignment、管理角色：security-role、普通角色：user）
								</span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-md-3 control-label">是否系统数据:</label>

                            <div class="col-md-5">
                                <form:select path="isSys" class="form-control required">
                                    <form:options items="${fns:getDictList('yes_no')}" itemLabel="label"
                                                  itemValue="value" htmlEscape="false"/>
                                </form:select>
                                <span class="help-block m-b-none">“是”代表只有超级管理员能进行修改，“否”则表示拥有角色修改人员的权限都能进行修改</span>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="col-md-offset-2">
                                <shiro:hasAnyPermissions name="sys:role:add,sys:role:edit">
                                    <input id="btnSubmit" class="btn btn-primary" type="submit" value="保 存"/>&nbsp;
                                </shiro:hasAnyPermissions>
                                <input id="btnCancel" class="btn" type="button" value="返 回" onclick="history.go(-1)"/>
                            </div>

                        </div>
                    </div>
                    <div class="col-md-4 col-xs-12">
                        <label class="col-md-2 control-label">角色授权:</label>

                        <div class="col-md-5">
                            <div id="menuTree" class="ztree" style="margin-top:3px;float:left;"></div>
                            <form:hidden path="menuIds"/>
                                <%--<div id="officeTree" class="ztree" style="margin-left:100px;margin-top:3px;float:left;"></div>--%>
                                <%--<form:hidden path="officeIds"/>--%>
                        </div>
                    </div>
                </div>


            </form:form>
        </div>
    </div>
</div>

</body>
</html>
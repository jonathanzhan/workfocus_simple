package com.mfnets.workfocus.modules.act.entity;

import java.io.Serializable;

/**
 * 流程启动后更改业务表的流程ID
 * Created by whatlookingfor on 15/9/7.
 */
public class ActBusiness implements Serializable{

    private static final long serialVersionUID = -6491886603784476334L;

    private String tableName;//业务表的表名

    private String updateKeyName;//修改的业务表的字段（流程实例ID）

    private String procInsId;//流程实例ID

    private String whereKeyName;//业务表的修改条件的字段名

    private String whereKeyValue;//业务表的修改条件的值

    private String whereSql;//where条件SQL片段

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getUpdateKeyName() {
        return updateKeyName;
    }

    public void setUpdateKeyName(String updateKeyName) {
        this.updateKeyName = updateKeyName;
    }

    public String getProcInsId() {
        return procInsId;
    }

    public void setProcInsId(String procInsId) {
        this.procInsId = procInsId;
    }

    public String getWhereKeyName() {
        return whereKeyName;
    }

    public void setWhereKeyName(String whereKeyName) {
        this.whereKeyName = whereKeyName;
    }

    public String getWhereKeyValue() {
        return whereKeyValue;
    }

    public void setWhereKeyValue(String whereKeyValue) {
        this.whereKeyValue = whereKeyValue;
    }

    public String getWhereSql() {
        return whereSql;
    }

    public void setWhereSql(String whereSql) {
        this.whereSql = whereSql;
    }
}

/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.entity;

import com.mfnets.workfocus.common.persistence.DataEntity;

/**
 * 系统参数的实体类
 *
 * @author Jonathan
 * @version 2016/5/9 17:30
 * @since JDK 7.0+
 */
public class Param extends DataEntity<Param> {

    private static final long serialVersionUID = 1L;
    /**
     * 参数名
     */
    private String name;

    /**
     * 参数值
     */
    private String value;

    /**
     * 参数说明
     */
    private String label;

    /**
     * 参数名,用于判断参数是否存在
     */
    private String name1;


    public Param() {
        super();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getName1() {
        return name1;
    }

    public void setName1(String name1) {
        this.name1 = name1;
    }
}

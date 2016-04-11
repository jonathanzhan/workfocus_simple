package com.mfnets.workfocus.modules.sys.entity;

import com.mfnets.workfocus.common.persistence.DataEntity;

/**
 * Created by yud on 2015/9/6.
 */
public class Params extends DataEntity<Params> {

    private static final long serialVersionUID = 1L;
    private String paramName;
    private String paramValue;
    private String paramLabel;

    private String paramName1;//判断参数名是否存在


    public String getParamName1() {
        return paramName1;
    }

    public void setParamName1(String paramName1) {
        this.paramName1 = paramName1;
    }

    public Params() {
        super();
    }

    public Params(String paramName){
        super(paramName);
    }

    public String getParamName() {
        return paramName;
    }

    public void setParamName(String paramName) {
        this.paramName = paramName;
    }

    public String getParamValue() {
        return paramValue;
    }

    public void setParamValue(String paramValue) {
        this.paramValue = paramValue;
    }

    public String getParamLabel() {
        return paramLabel;
    }

    public void setParamLabel(String paramLabel) {
        this.paramLabel = paramLabel;
    }
}
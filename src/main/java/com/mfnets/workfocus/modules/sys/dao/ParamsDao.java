/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.dao;

import com.mfnets.workfocus.common.persistence.CrudDao;
import com.mfnets.workfocus.common.persistence.annotation.MyBatisDao;
import com.mfnets.workfocus.modules.sys.entity.Params;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 系统参数的dao层
 * 
 * @author Jonathan
 * @version 2016/5/9 17:28
 * @since JDK 7.0+
 */
@MyBatisDao
public interface ParamsDao extends CrudDao<Params> {

    public void save(Params params);

    public Params getParamById(@Param(value = "paramName")String paramName);

    public List<String> findParamNameList(Params params);

    void updateValueByName(Params params);
}

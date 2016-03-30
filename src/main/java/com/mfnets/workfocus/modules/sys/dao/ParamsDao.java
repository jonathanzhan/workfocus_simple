package com.mfnets.workfocus.modules.sys.dao;

import com.mfnets.workfocus.common.persistence.CrudDao;
import com.mfnets.workfocus.common.persistence.annotation.MyBatisDao;
import com.mfnets.workfocus.modules.sys.entity.Params;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * Created by yud on 2015/9/6.
 */
@MyBatisDao
public interface ParamsDao extends CrudDao<Params> {

    public void save(Params params);

    public Params getParamById(@Param(value = "paramName")String paramName);

    public List<String> findParamNameList(Params params);

    void updateValueByName(Params params);
}

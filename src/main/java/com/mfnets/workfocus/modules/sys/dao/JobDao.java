package com.mfnets.workfocus.modules.sys.dao;

import com.mfnets.workfocus.common.persistence.CrudDao;
import com.mfnets.workfocus.common.persistence.annotation.MyBatisDao;
import com.mfnets.workfocus.modules.sys.entity.Job;

/**
 * 岗位DAO接口
 * @author jiangwei
 * @version 2014-08-29
 */
@MyBatisDao
public interface JobDao extends CrudDao<Job> {

}

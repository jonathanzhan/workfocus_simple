/**
 * Copyright &copy; 2012-2014 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.act.dao;

import com.mfnets.workfocus.common.persistence.CrudDao;
import com.mfnets.workfocus.common.persistence.annotation.MyBatisDao;
import com.mfnets.workfocus.modules.act.entity.Act;
import com.mfnets.workfocus.modules.act.entity.ActBusiness;

/**
 * 审批DAO接口
 * @author thinkgem
 * @version 2014-05-16
 */
@MyBatisDao
public interface ActDao extends CrudDao<Act> {

	public int updateProcInsIdByBusinessInfo(ActBusiness actBusiness);
}

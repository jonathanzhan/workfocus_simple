/**
 * Copyright &copy; 2012-2014 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.dao;

import com.mfnets.workfocus.common.persistence.TreeDao;
import com.mfnets.workfocus.common.persistence.annotation.MyBatisDao;
import com.mfnets.workfocus.modules.sys.entity.Org;

import java.util.List;

/**
 * 机构DAO接口
 * @author thinkgem
 * @version 2014-05-16
 */
@MyBatisDao
public interface OrgDao extends TreeDao<Org> {
    @Override
    Org get(String id);

    @Override
    List<Org> findList(Org org);

    @Override
    List<Org> findAllList(Org org);

    @Override
    int insert(Org org);

    @Override
    int update(Org org);

    @Override
    int delete(Org org);

    @Override
    List<Org> findByParentIdsLike(Org entity);

    @Override
    int updateParentIds(Org entity);
}

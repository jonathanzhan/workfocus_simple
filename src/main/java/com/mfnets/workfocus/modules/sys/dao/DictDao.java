/**
 * Copyright &copy; 2012-2015 <a href="http://git.oschina.net/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.dao;

import com.mfnets.workfocus.common.persistence.CrudDao;
import com.mfnets.workfocus.common.persistence.annotation.MyBatisDao;
import com.mfnets.workfocus.modules.sys.entity.Dict;

import java.util.List;

/**
 * 数据字典DAO接口
 *
 * @author Jonathan
 * @version 2016-03-21
 */
@MyBatisDao
public interface DictDao extends CrudDao<Dict> {

    @Override
    Dict get(String id);

    @Override
    List<Dict> findList(Dict dict);

    @Override
    List<Dict> findAllList(Dict dict);

    @Override
    List<Dict> findAllList();

    @Override
    int insert(Dict dict);

    @Override
    int update(Dict dict);

    @Override
    int delete(String id);


    List<String> findTypeList(Dict dict);


}

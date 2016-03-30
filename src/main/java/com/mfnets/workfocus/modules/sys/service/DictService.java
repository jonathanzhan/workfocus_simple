/**
 * Copyright &copy; 2012-2015 <a href="http://git.oschina.net/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.service;

import com.mfnets.workfocus.common.service.CrudService;
import com.mfnets.workfocus.common.utils.CacheUtils;
import com.mfnets.workfocus.modules.sys.dao.DictDao;
import com.mfnets.workfocus.modules.sys.entity.Dict;
import com.mfnets.workfocus.modules.sys.utils.DictUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 数据字典Service
 *
 * @author Jonathan
 * @version 2016-03-21
 */
@Service
@Transactional(readOnly = true)
public class DictService extends CrudService<DictDao, Dict> {

    @Override
    public Dict get(String id) {
        return dao.get(id);
    }


    /**
     * 查询字段类型列表
     *
     * @return
     */
    public List<String> findTypeList() {
        return dao.findTypeList(new Dict());
    }

    @Override
    @Transactional(readOnly = false)
    public void save(Dict dict) {
        super.save(dict);
        CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
    }

    @Override
    @Transactional(readOnly = false)
    public void delete(Dict dict) {
        super.delete(dict);
        CacheUtils.remove(DictUtils.CACHE_DICT_MAP);
    }

}

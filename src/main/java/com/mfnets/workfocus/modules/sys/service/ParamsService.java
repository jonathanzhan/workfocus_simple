/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.service;


import com.mfnets.workfocus.common.persistence.Page;
import com.mfnets.workfocus.common.service.CrudService;
import com.mfnets.workfocus.common.utils.CacheUtils;
import com.mfnets.workfocus.modules.sys.dao.ParamsDao;
import com.mfnets.workfocus.modules.sys.entity.Params;
import com.mfnets.workfocus.modules.sys.utils.DictUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
/**
 * 系统参数的service
 *
 * @author Jonathan
 * @version 2016/5/9 17:33
 * @since JDK 7.0+
 */
@Service
@Transactional(readOnly = true)
public class ParamsService extends CrudService<ParamsDao, Params> {

    /**
     * 根据参数名查询系统参数信息
     * @param paramName
     * @return
     */
    public Params getParamById(String paramName) {
        return dao.getParamById(paramName);
    }

    public List<Params> findList(Params params) {
        return super.findList(params);
    }

    public Page<Params> findPage(Page<Params> page, Params params) {
        return super.findPage(page, params);
    }

    public List<String> findParamNameList(){
        return dao.findParamNameList(new Params());
    }


    @Transactional(readOnly = false)
    public void save(Params params) {
        params.preInsert();
        super.dao.save(params);
        CacheUtils.remove(DictUtils.CACHE_PARAM_MAP);
    }


    @Transactional(readOnly = false)
    public void update(Params params) {
        params.preUpdate();
        super.dao.update(params);
        CacheUtils.remove(DictUtils.CACHE_PARAM_MAP);
    }

    @Transactional(readOnly = false)
    public void delete(Params params) {
        super.delete(params);
        CacheUtils.remove(DictUtils.CACHE_PARAM_MAP);
    }

}

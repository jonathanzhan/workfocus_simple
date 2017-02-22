/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.service;


import com.mfnets.workfocus.common.persistence.Page;
import com.mfnets.workfocus.common.service.CrudService;
import com.mfnets.workfocus.common.utils.CacheUtils;
import com.mfnets.workfocus.modules.sys.dao.ParamDao;
import com.mfnets.workfocus.modules.sys.entity.Param;
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
public class ParamService extends CrudService<ParamDao, Param> {

    /**
     * 根据参数名查询系统参数信息
     * @param name
     * @return
     */
    public Param getParamByName(String name) {
        return dao.getParamByName(name);
    }

    public List<Param> findList(Param param) {
        return super.findList(param);
    }

    public Page<Param> findPage(Page<Param> page, Param param) {
        return super.findPage(page, param);
    }

    public List<String> findParamNameList(){
        return dao.findParamNameList();
    }


    @Transactional(readOnly = false)
    public void save(Param param) {
        param.preInsert();
        super.dao.save(param);
        CacheUtils.remove(DictUtils.CACHE_PARAM_MAP);
    }


    @Transactional(readOnly = false)
    public void update(Param param) {
        param.preUpdate();
        super.dao.update(param);
        CacheUtils.remove(DictUtils.CACHE_PARAM_MAP);
    }

    @Transactional(readOnly = false)
    public void delete(Param param) {
        super.delete(param);
        CacheUtils.remove(DictUtils.CACHE_PARAM_MAP);
    }

}

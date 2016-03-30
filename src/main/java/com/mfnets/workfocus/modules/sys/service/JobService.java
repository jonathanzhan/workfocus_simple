package com.mfnets.workfocus.modules.sys.service;

import com.mfnets.workfocus.common.service.CrudService;
import com.mfnets.workfocus.modules.sys.dao.JobDao;
import com.mfnets.workfocus.modules.sys.entity.Job;
import com.mfnets.workfocus.modules.sys.utils.UserUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 岗位Service
 * @author jiangwei
 * @version 2014-08-31
 */
@Service
@Transactional(readOnly = true)
public class JobService extends CrudService<JobDao, Job> {


    /**
     * 保存数据（插入或更新）
     * @param entity
     */
    @Transactional(readOnly = false)
    public void save(Job entity) {
        if (entity.getIsNewRecord()){
            entity.preInsert();
            dao.insert(entity);
        }else{
            entity.preUpdate();
            dao.update(entity);
        }
        UserUtils.clearCache();
    }

    /**
     * 删除数据
     * @param entity
     */
    @Transactional(readOnly = false)
    public void delete(Job entity) {
        dao.delete(entity);
        UserUtils.clearCache();
    }
}

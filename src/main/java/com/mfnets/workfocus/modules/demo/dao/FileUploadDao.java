package com.mfnets.workfocus.modules.demo.dao;

import com.mfnets.workfocus.common.persistence.CrudDao;
import com.mfnets.workfocus.common.persistence.annotation.MyBatisDao;
import com.mfnets.workfocus.modules.demo.entity.FileUpload;

/**
 * @author Jonathan(whatlookingfor@gmail.com)
 * @date 2016/4/6 11:51
 * @since V1.0
 */
@MyBatisDao
public interface FileUploadDao extends CrudDao<FileUpload> {

    @Override
    FileUpload get(String id);
}

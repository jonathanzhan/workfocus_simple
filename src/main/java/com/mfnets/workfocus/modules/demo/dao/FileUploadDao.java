/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.demo.dao;

import com.mfnets.workfocus.common.persistence.CrudDao;
import com.mfnets.workfocus.common.persistence.annotation.MyBatisDao;
import com.mfnets.workfocus.modules.demo.entity.FileUpload;

/**
 * 文件上传的dao层处理
 * @author Jonathan
 * @version 2016/4/6 11:51
 * @since JDK 7.0+
 */
@MyBatisDao
public interface FileUploadDao extends CrudDao<FileUpload> {

    @Override
    FileUpload get(String id);
}

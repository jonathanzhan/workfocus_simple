package com.mfnets.workfocus.modules.demo.entity;

import com.mfnets.workfocus.common.persistence.DataEntity;
import org.springframework.web.multipart.MultipartFile;

/**
 * 文件上传的demo
 * @author Jonathan(whatlookingfor@gmail.com)
 * @date 2016/4/6 11:44
 * @since V1.0
 */
public class FileUpload extends DataEntity<FileUpload>{
    private String name;

    private MultipartFile file;

    private String path;

    public MultipartFile getFile() {
        return file;
    }

    public void setFile(MultipartFile file) {
        this.file = file;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public FileUpload() {
        super();
    }

    public FileUpload(String id) {
        super(id);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}

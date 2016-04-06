package com.mfnets.workfocus.modules.demo.service;

import com.mfnets.workfocus.common.service.CrudService;
import com.mfnets.workfocus.common.utils.DateUtils;
import com.mfnets.workfocus.common.utils.FileUtils;
import com.mfnets.workfocus.modules.demo.dao.FileUploadDao;
import com.mfnets.workfocus.modules.demo.entity.FileUpload;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.*;
import java.util.UUID;

/**
 * @author Jonathan(whatlookingfor@gmail.com)
 * @date 2016/4/6 11:51
 * @since V1.0
 */
@Service
@Transactional(readOnly = true)
public class FileUploadService extends CrudService<FileUploadDao,FileUpload>{

    /**
     *
     * @param file
     * @param targetFiles 文件即将需要存放路径
     * @return
     */
    public String saveFile(MultipartFile file,String targetFiles) {
        //定义商品文件的根目录
        String firstFolder = "uploadFile";

        String now = DateUtils.getDate("yyyyMMdd");

        //获取文件原始名称
        String originalFullName = file.getOriginalFilename();

        //获取文件名，不带后缀
        String originalName = originalFullName.substring(0,originalFullName.lastIndexOf("."));
        //获取文件后缀
        String fileExt = originalFullName.substring(originalFullName.lastIndexOf(".") + 1);

        //获取保存文件的相对路径，不包含文件后缀
        String apachePath = firstFolder+ File.separator+now+File.separator+originalName;

        //获取保存文件的完整路径，包含后缀
        String resultPath = apachePath+"."+fileExt;


        String descFileName = targetFiles+resultPath;
        File descFile = new File(descFileName);
        int repeat = 0;
        while (descFile.exists()){
            repeat++;
            resultPath = apachePath+"("+repeat+")."+fileExt;

            descFileName = targetFiles+resultPath;
            descFile = new File(descFileName);
        }
        // 判断目标文件是否存在
        if (descFile.exists()) {
            // 如果目标文件存在，并且允许覆盖
            logger.info("目标文件已存在，准备删除!");
            if (!FileUtils.delFile(descFileName)) {
                resultPath="";
                logger.info("删除目标文件 " + descFileName + " 失败!");
            }
        } else {
            if (!descFile.getParentFile().exists()) {
                // 如果目标文件所在的目录不存在，则创建目录
                logger.info("目标文件所在的目录不存在，创建目录{}"+descFileName);
                // 创建目标文件所在的目录
                if (!descFile.getParentFile().mkdirs()) {
                    resultPath="";
                    logger.info("创建目标文件所在的目录失败!");
                }
            }
        }

        // 准备复制文件
        // 读取的位数
        int readByte = 0;
        InputStream ins = null;
        OutputStream outs = null;
        try {
            // 打开源文件
            ins = file.getInputStream();
            // 打开目标文件的输出流
            outs = new FileOutputStream(descFile);
            byte[] buf = new byte[1024];
            // 一次读取1024个字节，当readByte为-1时表示文件已经读取完毕
            while ((readByte = ins.read(buf)) != -1) {
                // 将读取的字节流写入到输出流
                outs.write(buf, 0, readByte);
            }
            logger.debug("复制文件 " + descFileName + " 到" + descFileName
                    + "成功!");
        } catch (Exception e) {
            resultPath="";
            logger.debug("复制文件失败：" + e.getMessage());
        } finally {
            // 关闭输入输出流，首先关闭输出流，然后再关闭输入流
            if (outs != null) {
                try {
                    outs.close();
                } catch (IOException oute) {
                    oute.printStackTrace();
                }
            }
            if (ins != null) {
                try {
                    ins.close();
                } catch (IOException ine) {
                    ine.printStackTrace();
                }
            }
        }

        return resultPath;
    }
}

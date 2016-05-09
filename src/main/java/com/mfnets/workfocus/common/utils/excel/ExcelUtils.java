/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.common.utils.excel;

import com.google.common.collect.Lists;
import com.mfnets.workfocus.common.utils.Encodes;
import com.mfnets.workfocus.common.utils.Exceptions;
import com.mfnets.workfocus.common.utils.Reflections;
import com.mfnets.workfocus.common.utils.excel.annotation.ExcelField;
import com.mfnets.workfocus.modules.sys.utils.DictUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.*;

/**
 * excel的工具类,主要是负责根据模板导出数据
 *
 * @author Jonathan
 * @version 2015/4/24 16:56
 * @since JDK 7.0+
 */
public class ExcelUtils {

    private static Logger log = LoggerFactory.getLogger(ExcelUtils.class);

    /**
     * 工作薄对象
     * 读取模板时使用
     */
    private XSSFWorkbook wb;

    /**
     * 工作表对象
     */
    private Sheet sheet;

    /**
     * 样式列表
     */
    private Map<String, CellStyle> styles;


    /**
     * 注解列表（Object[]{ ExcelField, Field/Method }）
     */
    List<Object[]> annotationList = Lists.newArrayList();


    /**
     * 读取模板，创建工作薄
     * @param request HttpServletRequest
     * @param path 模板路径(基于项目的发布项目下的绝对路径)
     */
    public void getXssfWorkBook(HttpServletRequest request,String path) {
        String basePath = request.getSession().getServletContext().getRealPath("/");
        FileInputStream fs = null;
        try {
            fs = new FileInputStream(basePath+File.separator+path);
            this.wb = new XSSFWorkbook(fs);
            this.sheet = this.wb.getSheetAt(0);
            this.styles = createStyles(wb);
        } catch (Exception e) {
            throw Exceptions.unchecked(e);
        } finally {
            try {
                if (fs != null) fs.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 初始化类注释
     * @param cls 类的对象
     * @param type 导出类型（1:导出数据；2：导出模板）
     * @param sortSeq sort对应的下标
     */
    public  ExcelUtils(Class<?> cls, int type, final int sortSeq){
        // Get annotation field
        Field[] fs = cls.getDeclaredFields();
        for (Field f : fs){
            ExcelField ef = f.getAnnotation(ExcelField.class);
            if (ef != null && (ef.type()==0 || ef.type()==type)&& ef.sort()[sortSeq]>=0){
                annotationList.add(new Object[]{ef, f});
            }
        }

        // Field sorting
        Collections.sort(annotationList, new Comparator<Object[]>() {
            public int compare(Object[] o1, Object[] o2) {
                return new Integer(((ExcelField) o1[0]).sort()[sortSeq]).compareTo(
                        new Integer(((ExcelField) o2[0]).sort()[sortSeq]));
            };
        });
    }

    /**
     * 添加一行
     * @param rowNum 行号
     * @return 行对象
     */
    public Row addRow(int rowNum){
        Row row = null;
        if (sheet.getLastRowNum() < rowNum) {
            row = sheet.createRow(rowNum);
        } else {
            row = sheet.getRow(rowNum);
        }
        return row;
    }


    public Cell addCell(Row row, int column, Object val, int align,int hasStyle,int styleType,String numberFormat){
        return this.addCell(row, column, val, align,hasStyle,styleType,numberFormat, Class.class);
    }


    /**
     * 添加一个单元格
     * @param row 添加的行
     * @param column 添加列号
     * @param val 添加值
     * @param align 对齐方式（1：靠左；2：居中；3：靠右）
     * @return 单元格对象
     */
    public Cell addCell(Row row, int column, Object val, int align,int hasStyle,int styleType,String numberFormat, Class<?> fieldType){
        CellStyle style = wb.createCellStyle();
        Cell cell = row.getCell(column);
        if(cell==null){
            cell = row.createCell(column);
        }

        try {
            if (val == null){
                cell.setCellValue("");
            } else if (val instanceof String) {
                cell.setCellValue((String) val);
            } else if (val instanceof Integer) {
                cell.setCellValue((Integer) val);
            } else if (val instanceof Long) {
                cell.setCellValue((Long) val);
            } else if (val instanceof Double) {
                cell.setCellValue((Double) val);
            } else if (val instanceof Float) {
                cell.setCellValue((Float) val);
            } else if (val instanceof Date) {
//                DataFormat format = wb.createDataFormat();
//                style.setDataFormat(format.getFormat("yyyy-MM-dd"));
                cell.setCellValue((Date) val);
            } else {
                if (fieldType != Class.class){
                    cell.setCellValue((String)fieldType.getMethod("setValue", Object.class).invoke(null, val));
                }else{
                    cell.setCellValue((String)Class.forName(this.getClass().getName().replaceAll(this.getClass().getSimpleName(),
                            "fieldtype."+val.getClass().getSimpleName()+"Type")).getMethod("setValue", Object.class).invoke(null, val));
                }
            }
        } catch (Exception ex) {
            log.info("Set cell value ["+row.getRowNum()+","+column+"] error: " + ex.toString());
            cell.setCellValue(val.toString());
        }
        if(hasStyle!=0){
            if(styleType==1){
                cell.setCellStyle(styles.get("input_%"));
            }else if(styleType==2){
                cell.setCellStyle(styles.get("input_d"));
            }else if(styleType==3){
                cell.setCellStyle(styles.get("input_i"));
            }else{
                cell.setCellStyle(styles.get("item"+(align>=1&&align<=3?align:"")));
            }
        }

        return cell;
    }


    public static Map<String, CellStyle> createStyles(Workbook wb){
        Map<String, CellStyle> styles = new HashMap<String, CellStyle>();

        CellStyle style;
        Font titleFont = wb.createFont();
        titleFont.setFontHeightInPoints((short)14);
        titleFont.setFontName("宋体");
        style = wb.createCellStyle();
        style.setWrapText(true);
        style.setFont(titleFont);
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        styles.put("title", style);

        Font itemFont = wb.createFont();
        itemFont.setFontHeightInPoints((short) 11);
        itemFont.setFontName("宋体");
        style = wb.createCellStyle();
        style.setWrapText(true);
        style.setAlignment(CellStyle.ALIGN_LEFT);
        style.setFont(itemFont);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        styles.put("item1", style);

        style = wb.createCellStyle();
        style.setWrapText(true);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style.setAlignment(CellStyle.ALIGN_CENTER);
        style.setFont(itemFont);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        styles.put("item2", style);

        style = wb.createCellStyle();
        style.setWrapText(true);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style.setAlignment(CellStyle.ALIGN_CENTER);
        style.setFont(itemFont);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        styles.put("item", style);

        style = wb.createCellStyle();
        style.setWrapText(true);
        style.setAlignment(CellStyle.ALIGN_RIGHT);
        style.setFont(itemFont);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        styles.put("item3", style);

        style = wb.createCellStyle();
        style.setWrapText(true);
        style.setAlignment(CellStyle.ALIGN_RIGHT);
        style.setFont(itemFont);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setDataFormat(wb.createDataFormat().getFormat("_($* #,##0.00_);_($* (#,##0.00);_($* \"-\"??_);_(@_)"));
        styles.put("input_$", style);

        style = wb.createCellStyle();
        style.setWrapText(true);
        style.setAlignment(CellStyle.ALIGN_RIGHT);
        style.setFont(itemFont);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setDataFormat(wb.createDataFormat().getFormat("0.00%"));
        styles.put("input_%", style);

        style = wb.createCellStyle();
        style.setWrapText(true);
        style.setAlignment(CellStyle.ALIGN_RIGHT);
        style.setFont(itemFont);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setDataFormat(wb.createDataFormat().getFormat("0"));
        styles.put("input_i", style);

        style = wb.createCellStyle();
        style.setWrapText(true);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style.setAlignment(CellStyle.ALIGN_CENTER);
        style.setFont(itemFont);
        style.setDataFormat(wb.createDataFormat().getFormat("yyyy-mm-dd"));
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        styles.put("input_d", style);

        style = wb.createCellStyle();
        style.setWrapText(true);
        style.setAlignment(CellStyle.ALIGN_RIGHT);
        style.setFont(itemFont);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setDataFormat(wb.createDataFormat().getFormat("$##,##0.00"));
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(CellStyle.SOLID_FOREGROUND);
        styles.put("formula_$", style);

        style = wb.createCellStyle();
        style.setWrapText(true);
        style.setAlignment(CellStyle.ALIGN_RIGHT);
        style.setFont(itemFont);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setDataFormat(wb.createDataFormat().getFormat("0"));
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(CellStyle.SOLID_FOREGROUND);
        styles.put("formula_i", style);

        return styles;
    }




    public <E> void setDataList(List<E> list,int startRow,int startColumn){
        for (E e : list){
            int column = startColumn;
            Row row = this.addRow(startRow++);
            StringBuilder sb = new StringBuilder();
            for (Object[] os : annotationList){
                ExcelField ef = (ExcelField)os[0];
                Object val = null;
                // Get entity value
                try{
                    if (StringUtils.isNotBlank(ef.value())){
                        val = Reflections.invokeGetter(e, ef.value());
                    }else{
                        if (os[1] instanceof Field){
                            val = Reflections.invokeGetter(e, ((Field)os[1]).getName());
                        }else if (os[1] instanceof Method){
                            val = Reflections.invokeMethod(e, ((Method)os[1]).getName(), new Class[] {}, new Object[] {});
                        }
                    }
                    // If is dict, get dict label
                    if (StringUtils.isNotBlank(ef.dictType())){
                        val = val == null ? "" : DictUtils.getDictLabel(val.toString(), ef.dictType(), "");
                    }
                }catch(Exception ex) {
                    // Failure to ignore
                    log.info(ex.toString());
                    val = "";
                }
                this.addCell(row, column++, val, ef.align(),ef.style(),ef.styleType(), ef.numberStyle(),ef.fieldType());
                sb.append(val + ", ");
            }
            log.debug("Write success: ["+row.getRowNum()+"] "+sb.toString());
        }
    }
    /**
     * 创建表格样式
     * @param wb 工作薄对象
     * @return 样式列表
     */
//    private Map<String, CellStyle> createStyles(Workbook wb) {
//        Map<String, CellStyle> styles = new HashMap<String, CellStyle>();
//
//        CellStyle style = wb.createCellStyle();
//        style.setAlignment(CellStyle.ALIGN_CENTER);
//        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
//        Font titleFont = wb.createFont();
//        titleFont.setFontName("Arial");
//        titleFont.setFontHeightInPoints((short) 16);
//        titleFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
//        style.setFont(titleFont);
//        styles.put("title", style);
//
//        style = wb.createCellStyle();
//        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
//        style.setBorderRight(CellStyle.BORDER_THIN);
//        style.setRightBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
//        style.setBorderLeft(CellStyle.BORDER_THIN);
//        style.setLeftBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
//        style.setBorderTop(CellStyle.BORDER_THIN);
//        style.setTopBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
//        style.setBorderBottom(CellStyle.BORDER_THIN);
//        style.setBottomBorderColor(IndexedColors.GREY_50_PERCENT.getIndex());
//        Font dataFont = wb.createFont();
//        dataFont.setFontName("Arial");
//        dataFont.setFontHeightInPoints((short) 10);
//        style.setFont(dataFont);
//        styles.put("data", style);
//
//        style = wb.createCellStyle();
//        style.cloneStyleFrom(styles.get("data"));
//        style.setAlignment(CellStyle.ALIGN_LEFT);
//        styles.put("data1", style);
//
//        style = wb.createCellStyle();
//        style.cloneStyleFrom(styles.get("data"));
//        style.setAlignment(CellStyle.ALIGN_CENTER);
//        styles.put("data2", style);
//
//        style = wb.createCellStyle();
//        style.cloneStyleFrom(styles.get("data"));
//        style.setAlignment(CellStyle.ALIGN_RIGHT);
//        styles.put("data3", style);
//
//        style = wb.createCellStyle();
//        style.cloneStyleFrom(styles.get("data"));
////		style.setWrapText(true);
//        style.setAlignment(CellStyle.ALIGN_CENTER);
//        style.setFillForegroundColor(IndexedColors.GREY_50_PERCENT.getIndex());
//        style.setFillPattern(CellStyle.SOLID_FOREGROUND);
//        Font headerFont = wb.createFont();
//        headerFont.setFontName("Arial");
//        headerFont.setFontHeightInPoints((short) 10);
//        headerFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
//        headerFont.setColor(IndexedColors.WHITE.getIndex());
//        style.setFont(headerFont);
//        styles.put("header", style);
//
//        return styles;
//    }


    /**
     * 输出数据流
     * @param os 输出数据流
     */
    public ExcelUtils write(OutputStream os) throws IOException {
        wb.write(os);
        os.close();
        return this;
    }

    /**
     * 输出到客户端
     * @param fileName 输出文件名
     */
    public ExcelUtils write(HttpServletResponse response, String fileName) throws IOException{
        response.reset();
        response.setContentType("application/octet-stream; charset=utf-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + Encodes.urlEncode(fileName));
        write(response.getOutputStream());
        return this;
    }



}


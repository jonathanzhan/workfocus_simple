package com.mfnets.workfocus.modules.sys.entity;

import com.mfnets.workfocus.common.persistence.DataEntity;
import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.Length;

import java.util.Date;

/**
 *
 * 员工实体类
 * @author Jonathan(whatlookingfor@gmail.com)
 * @date   2016/4/11 17:00
 * @since  V1.0
 *
 */
public class Employee extends DataEntity<Employee>{

    private Org org;//员工所属机构

    private String code;//员工编码(生成user的loginName)

    private String name;//员工中文姓名

    private String eName;//员工英文姓名

    private Integer sex;//性别

    private Date birthday;//出生年月

    private String address;//联系地址

    private String tel;// 联系电话

    private String idCode;//身份证

    private Integer education;//学历

    private String qq; //qq

    private String email;// 电子邮箱

    private Integer isOpen;// 是否开通系统帐号

    private String photo;//照片


    public Employee(Org org){
        super();
        this.org = org;
    }


    public Employee() {
        super();
        this.isOpen = 0;
        this.sex = 1;
    }


    @Length(min = 1,max = 12,message = "员工编号长度必须介于 1 和 12 之间")
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Length(min = 1,max = 15,message = "中文名称长度必须介于 1 和 15 之间")
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Length(min = 1,max = 15,message = "英文文名称长度必须介于 1 和 15 之间")
    public String geteName() {
        return eName;
    }

    public void seteName(String eName) {
        this.eName = eName;
    }

    public Integer getIsOpen() {
        return isOpen;
    }

    public void setIsOpen(Integer isOpen) {
        this.isOpen = isOpen;
    }


    public Integer getSex() {
        return sex;
    }

    public void setSex(Integer sex) {
        this.sex = sex;
    }

    public Date getBirthday() {
        return birthday;
    }

    public void setBirthday(Date birthday) {
        this.birthday = birthday;
    }

    @Length(min = 0,max = 200,message = "联系地址长度最大长度为200")
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    @Length(min = 0,max = 20,message = "联系电话长度最大长度为20")
    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    @Length(min = 18,max = 18,message = "身份证长度为18位")
    public String getIdCode() {
        return idCode;
    }

    public void setIdCode(String idCode) {
        this.idCode = idCode;
    }

    public Integer getEducation() {
        return education;
    }

    public void setEducation(Integer education) {
        this.education = education;
    }


    public String getQq() {
        return qq;
    }

    public void setQq(String qq) {
        this.qq = qq;
    }

    @Email(message = "email格式不正确")
    @Length(min = 0,max = 20,message = "email的最大长度为20")
    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }


    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public Org getOrg() {
        return org;
    }

    public void setOrg(Org org) {
        this.org = org;
    }


}

package com.mfnets.workfocus.modules.sys.entity;

import com.mfnets.workfocus.common.persistence.DataEntity;
import org.hibernate.validator.constraints.Length;

import java.util.Date;

/**
 * Created by whatlookingfor on 15/8/29.
 */
@SuppressWarnings("ALL")
public class Employee extends DataEntity<Employee>{
    private String employeeCd;

    private String employeeCnm;//员工中文姓名

    private String employeeEnm;//员工英文姓名

    private Integer sex;//性别

    private Date birthday;//出生年月

    private String address;//联系地址

    private String tel;// 联系电话

    private String idCode;//身份证

    private Integer education;//学历

    private String hobbies;//爱好

    private String qq; //qq

    private String email;// 电子邮箱

    private Integer isOpenSys;// 是否开通系统帐号

    private String photo;//照片

    private User user;

    private Org org;

    private Job job;


    @Length(min = 1,max = 8,message = "员工编号长度必须介于 1 和 8 之间")
    public String getEmployeeCd() {
        return employeeCd;
    }

    public void setEmployeeCd(String employeeCd) {
        this.employeeCd = employeeCd;
    }

    @Length(min = 1,max = 50,message = "中文名称长度必须介于 1 和 50 之间")
    public String getEmployeeCnm() {
        return employeeCnm;
    }

    public void setEmployeeCnm(String employeeCnm) {
        this.employeeCnm = employeeCnm;
    }

    @Length(min = 1,max = 50,message = "英文名称长度必须介于 1 和 50 之间")
    public String getEmployeeEnm() {
        return employeeEnm;
    }

    public void setEmployeeEnm(String employeeEnm) {
        this.employeeEnm = employeeEnm;
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

//    @Length(min = 1,max = 512,message = "联系地址长度必须介于 1 和 512 之间")
    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

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

    public String getHobbies() {
        return hobbies;
    }

    public void setHobbies(String hobbies) {
        this.hobbies = hobbies;
    }

    public String getQq() {
        return qq;
    }

    public void setQq(String qq) {
        this.qq = qq;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Integer getIsOpenSys() {
        return isOpenSys;
    }

    @SuppressWarnings("SameParameterValue")
    public void setIsOpenSys(@SuppressWarnings("SameParameterValue") Integer isOpenSys) {
        this.isOpenSys = isOpenSys;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Job getJob() {
        return job;
    }

    public void setJob(Job job) {
        this.job = job;
    }

    public Org getOrg() {
        return org;
    }

    public void setOrg(Org org) {
        this.org = org;
    }
}

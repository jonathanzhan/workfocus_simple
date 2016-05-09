/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.dao;

import com.mfnets.workfocus.common.persistence.CrudDao;
import com.mfnets.workfocus.common.persistence.annotation.MyBatisDao;
import com.mfnets.workfocus.modules.sys.entity.Employee;

import java.util.List;

/**
 * 员工DAO接口
 * @author Jonathan
 * @version 2014-05-16
 */
@MyBatisDao
public interface EmployeeDao extends CrudDao<Employee> {

    @Override
    Employee get(String id);

    @Override
    List<Employee> findAllList(Employee entity);

    @Override
    List<Employee> findList(Employee entity);

    @Override
    int insert(Employee entity);

    @Override
    int update(Employee entity);

    @Override
    int delete(Employee entity);

    /**
     * 根据员工编号查询员工信息
     * @param employee
     * @return
     */
    public Employee getEmployeeByCd(Employee employee);

    /**
     * 更新员工信息(个人信息保存时调用)
     * @param employee
     */
    public void updateEmployeeInfo(Employee employee);
}

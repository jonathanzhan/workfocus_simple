/**
 * Copyright &copy; 2012-2014 <a href="https://github.com/thinkgem/jeesite">JeeSite</a> All rights reserved.
 */
package com.mfnets.workfocus.modules.sys.entity;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.mfnets.workfocus.common.persistence.TreeEntity;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * 机构Entity
 * @author ThinkGem
 * @version 2013-05-15
 */
public class Org extends TreeEntity<Org> {

	private static final long serialVersionUID = 1L;
	private String code; 	// 机构编码
	private String type; 	// 机构类型
	private String address; // 联系地址
	private String master; 	// 负责人
	private String phone; 	// 电话

	
	public Org(){
		super();
		this.type = "2";
	}

	public Org(String id){
		super(id);
	}


	@JsonBackReference
	@NotNull
	public Org getParent() {
		return parent;
	}

	public void setParent(Org parent) {
		this.parent = parent;
	}




	
	@Length(min=1, max=1)
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}


	@Length(min=0, max=255)
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}



	@Length(min=0, max=100)
	public String getMaster() {
		return master;
	}

	public void setMaster(String master) {
		this.master = master;
	}

	@Length(min=0, max=200)
	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}





	@Length(min=0, max=100)
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	@JsonIgnore
	public static String getRootId(){
		return "1";
	}

	@JsonIgnore
	public static boolean isRoot(String id){
		return id != null && getRootId().equals(id);
	}

	@Override
	public String toString() {
		return name;
	}
}
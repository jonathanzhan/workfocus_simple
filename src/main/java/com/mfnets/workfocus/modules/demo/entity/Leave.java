/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.demo.entity;

import com.google.common.collect.Maps;
import com.mfnets.workfocus.common.persistence.ActEntity;
import com.mfnets.workfocus.common.utils.StringUtils;

import java.util.Date;
import java.util.Map;

/**
 * 请假的实体类
 *
 * @author Jonathan
 * @version 2016/9/20 16:17
 * @since JDK 7.0+
 */
public class Leave extends ActEntity<Leave> {

	/**
	 * 请假开始时间
	 */
	private Date beginDate;

	/**
	 * 请假截止时间
	 */
	private Date endDate;

	/**
	 * 请假原因
	 */
	private String reason;

	/**
	 * 部门经理审批结果
	 */
	private String leaderAudit;

	/**
	 * HR审批结果
	 */
	private String hrAudit;

	/**
	 * 重新申请的结果
	 */
	private String reApply;

	/**
	 * 销假日期
	 */
	private Date backDate;

	public Leave() {
		super();
	}


	public Date getBeginDate() {
		return beginDate != null ? new Date(beginDate.getTime()) : null;
	}

	public void setBeginDate(Date beginDate) {
		this.beginDate = beginDate != null ? new Date(beginDate.getTime()) : null;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}

	public String getReason() {
		return reason;
	}

	public void setReason(String reason) {
		this.reason = reason;
	}

	public String getLeaderAudit() {
		return leaderAudit;
	}

	public void setLeaderAudit(String leaderAudit) {
		this.leaderAudit = leaderAudit;
	}

	public String getHrAudit() {
		return hrAudit;
	}

	public void setHrAudit(String hrAudit) {
		this.hrAudit = hrAudit;
	}

	public String getReApply() {
		return reApply;
	}

	public void setReApply(String reApply) {
		this.reApply = reApply;
	}

	public Date getBackDate() {
		return backDate;
	}

	public void setBackDate(Date backDate) {
		this.backDate = backDate;
	}



	public static Map<String, Object> getVars(Leave leave) {
		Map<String, Object> vars = Maps.newHashMap();
		if(leave.getBeginDate()!=null){
			vars.put("beginDate",leave.getBeginDate());
		}
		if(leave.getEndDate()!=null){
			vars.put("endDate",leave.getEndDate());
		}
		if(leave.getBackDate()!=null){
			vars.put("backDate",leave.getBackDate());
		}
		if(StringUtils.isNotBlank(leave.getReason())){
			vars.put("reason",leave.getReason());
		}
		if(StringUtils.isNotBlank(leave.getLeaderAudit())){
			vars.put("leaderAudit",leave.getLeaderAudit());
		}
		if(StringUtils.isNotBlank(leave.getHrAudit())){
			vars.put("hrAudit",leave.getHrAudit());
		}
		if(StringUtils.isNotBlank(leave.getReApply())){
			vars.put("reApply",leave.getReApply());
		}

		return vars;
	}

	public void setVars(Map<String, Object> vars) {
		this.setBeginDate(new Date(((Date) vars.get("endDate")).getTime()));
		this.setEndDate((Date) vars.get("endDate"));
		this.setReason((String)vars.get("reason"));

	}
}


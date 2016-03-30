package com.mfnets.workfocus.modules.sys.entity;

import com.mfnets.workfocus.common.persistence.DataEntity;

/**
 * Created by yud on 2015/8/29 0029.
 */
public class Job extends DataEntity<Job> {
    private static final long serialVersionUID = 1L;
    private Role role;
    private String jobName;
    private String jobCommend;

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public String getJobName() {
        return jobName;
    }

    public void setJobName(String jobName) {
        this.jobName = jobName;
    }

    public String getJobCommend() {
        return jobCommend;
    }

    public void setJobCommend(String jobCommend) {
        this.jobCommend = jobCommend;
    }
}

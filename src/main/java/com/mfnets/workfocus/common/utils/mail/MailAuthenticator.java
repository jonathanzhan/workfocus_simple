/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */
package com.mfnets.workfocus.common.utils.mail;

import javax.mail.*;

/**
 * 邮件的权限实体类
 *
 * @author Jonathan
 * @version 2016/5/9 16:59
 * @since JDK 7.0+
 */
public class MailAuthenticator extends Authenticator {
    String userName = null;
    String password = null;

    public MailAuthenticator() {
    }

    public MailAuthenticator(String username, String password) {
        this.userName = username;
        this.password = password;
    }

    protected PasswordAuthentication getPasswordAuthentication() {
        return new PasswordAuthentication(userName, password);
    }
}   

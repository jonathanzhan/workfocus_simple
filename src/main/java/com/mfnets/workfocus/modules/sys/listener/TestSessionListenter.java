/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.sys.listener;

import org.apache.shiro.session.Session;
import org.apache.shiro.session.SessionListener;

/**
 * TODO
 *
 * @author Jonathan
 * @version 2016/11/29 16:56
 * @since JDK 7.0+
 */
public class TestSessionListenter  implements SessionListener {
	@Override
	public void onStart(Session session) {
		System.out.println(session.getClass().getName());
		System.out.println("会话创建：" + session.getId());
	}

	@Override
	public void onStop(Session session) {
		System.out.println("会话停止：" + session.getId());
	}

	@Override
	public void onExpiration(Session session) {
		System.out.println("会话过期：" + session.getId());
	}
}

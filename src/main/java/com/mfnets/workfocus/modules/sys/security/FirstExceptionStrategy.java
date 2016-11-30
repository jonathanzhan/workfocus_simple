/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.sys.security;

import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.pam.FirstSuccessfulStrategy;
import org.apache.shiro.realm.Realm;

/**
 * {@link org.apache.shiro.authc.pam.AuthenticationStrategy} implementation that throws the first exception it gets
 * and ignores all subsequent realms. If there is no exceptions it works as the {@link FirstSuccessfulStrategy}
 * WARN: This approach works fine as long as there is ONLY ONE Realm per Token type.
 *	对于有多个realm的情况,设定规则为:FirstSuccessfulStrategy
 *	只有第一个成功地验证的 Realm 返回的信息将被 使用。
 *	所有进一步的 Realm 将被忽略。
 *	如果没有 一个验证成功，则整体尝试失败。
 * 	ModularRealmAuthenticator 默认为AtLeastOneSuccessfulStrategy,
 * 	如果一个(或更多)Realm 验证成功，则整体的 尝试被认为是成功的。如果没有一个验证成功，
 则整体尝试失败。
 * @author Jonathan
 * @version 2016/11/29 16:24
 * @since JDK 7.0+
 */
public class FirstExceptionStrategy extends FirstSuccessfulStrategy {

	@Override
	public AuthenticationInfo afterAttempt(Realm realm, AuthenticationToken token, AuthenticationInfo singleRealmInfo, AuthenticationInfo aggregateInfo, Throwable t) throws AuthenticationException {
		if ((t != null) && (t instanceof AuthenticationException)) throw (AuthenticationException) t;
		return super.afterAttempt(realm, token, singleRealmInfo, aggregateInfo, t);
	}
}

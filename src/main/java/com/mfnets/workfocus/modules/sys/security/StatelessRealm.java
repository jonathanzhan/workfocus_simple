/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.modules.sys.security;

import com.mfnets.workfocus.common.utils.JwtUtils;
import com.mfnets.workfocus.common.utils.SpringContextHolder;
import com.mfnets.workfocus.common.web.Servlets;
import com.mfnets.workfocus.modules.sys.entity.Menu;
import com.mfnets.workfocus.modules.sys.entity.Role;
import com.mfnets.workfocus.modules.sys.entity.User;
import com.mfnets.workfocus.modules.sys.service.SystemService;
import com.mfnets.workfocus.modules.sys.utils.LogUtils;
import com.mfnets.workfocus.modules.sys.utils.UserUtils;
import io.jsonwebtoken.Claims;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 无状态的Realm处理
 *
 * @author Jonathan
 * @version 2016/11/29 16:01
 * @since JDK 7.0+
 */
@Service
public class StatelessRealm extends AuthorizingRealm {
	private Logger logger = LoggerFactory.getLogger(getClass());

	private SystemService systemService;

	public boolean supports(AuthenticationToken token) {
		//仅支持StatelessToken类型的Token
		return token instanceof StatelessToken;
	}

	/**
	 * 认证回调函数, 登录时调用
	 */
	@Override
	protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
		StatelessToken statelessToken = (StatelessToken) token;
		Claims claims = JwtUtils.parseToken(statelessToken.getToken());
		String username = claims.getSubject();
		User user = getSystemService().getUserByLoginName(username);
		Principal principal = new Principal(user);
		if (user != null && user.getId().equals(claims.getId())) {
			return new SimpleAuthenticationInfo(principal, statelessToken.getToken(), getName());
		} else {
			return null;
		}
	}

	/**
	 * 授权查询回调函数, 进行鉴权但缓存中无用户的授权信息时调用
	 */
	@Override
	protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
		//根据用户名查找角色，请根据需求实现
		Principal principal = (Principal) getAvailablePrincipal(principals);
		User user = getSystemService().getUserByLoginName(principal.getLoginName());
		if (user != null) {
			SimpleAuthorizationInfo info = new SimpleAuthorizationInfo();
			List<Menu> list = UserUtils.getMenuList();
			for (Menu menu : list){
				if (StringUtils.isNotBlank(menu.getPermission())){
					// 添加基于Permission的权限信息
					for (String permission : StringUtils.split(menu.getPermission(),",")){
						info.addStringPermission(permission);
					}
				}
			}
			// 添加用户权限
			info.addStringPermission("user");
			// 添加用户角色信息
			for (Role role : user.getRoleList()){
				info.addRole(role.getEname());
			}
			// 更新登录IP和时间
			getSystemService().updateUserLoginInfo(user);
			// 记录登录日志
			LogUtils.saveLog(Servlets.getRequest(), "系统登录");
			return info;
		} else {
			return null;
		}
	}

	/**
	 * 获取系统业务对象
	 */
	public SystemService getSystemService() {
		if (systemService == null){
			systemService = SpringContextHolder.getBean(SystemService.class);
		}
		return systemService;
	}

	/**
	 * {@inheritDoc}
	 * 重写函数，如果不是web app登录，则用无状态授权
	 */
	@Override
	public boolean isPermitted(PrincipalCollection principals, String permission) {
		System.out.println(principals.fromRealm(getName()));
		if (principals.fromRealm(getName()).isEmpty()) {
			return false;
		}
		else {
			return super.isPermitted(principals, permission);
		}
	}


	/**
	 * {@inheritDoc}
	 * 重写函数，如果不是web app登录，则用无状态授权
	 */
	@Override
	public boolean hasRole(PrincipalCollection principals, String roleIdentifier) {
		if (principals.fromRealm(getName()).isEmpty()) {
			logger.debug("not stateless auth");
			return false;
		}
		else {
			return super.hasRole(principals, roleIdentifier);
		}
	}

}

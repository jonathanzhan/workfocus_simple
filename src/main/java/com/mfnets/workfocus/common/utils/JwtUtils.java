/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.common.utils;


import com.mfnets.workfocus.common.config.Global;
import io.jsonwebtoken.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Date;

/**
 * Json web token 工具类
 *
 * @author Jonathan
 * @version 2016/12/7 16:05
 * @since JDK 7.0+
 */
public class JwtUtils {
	private static final Logger logger = LoggerFactory.getLogger(JwtUtils.class);
	/**
	 * 发行者
	 */
	private static final String issure = Global.getConfig("jwt.issuer");
	/**
	 * token生命时长,单位分钟。0表示永久
	 */
	private static final int addExp = Integer.parseInt(Global.getConfig("jwt.exp"));

	private static final String key = Global.getConfig("jwt.key");

	/**
	 * 根据id 和loginName生成json web token
	 * @param id
	 * @param loginName
	 * @return
	 */
	public static String createToken(String id,String loginName){
		JwtBuilder jwtBuilder = Jwts.builder();
		jwtBuilder.setId(id);
		jwtBuilder.setIssuer(issure);
		jwtBuilder.setIssuedAt(new Date());
		if(addExp>0){
			jwtBuilder.setExpiration(DateUtils.addMinutes(new Date(),addExp));
		}
		jwtBuilder.setSubject(loginName);
		return jwtBuilder.compressWith(CompressionCodecs.DEFLATE)
				.signWith(SignatureAlgorithm.HS512, key)
				.compact();
	}

	/**
	 * 解析token
	 * @param token
	 * @return
	 */
	public static Claims parseToken(String token){
		try {
			Jws<Claims> claimsJws = Jwts.parser().setSigningKey(key).parseClaimsJws(token);
			Claims claims = claimsJws.getBody();
			logger.debug("token parse subject:{},id:{}",claims.getSubject(),claims.getId());
			return claims;
		}catch (io.jsonwebtoken.ExpiredJwtException e){
			throw new RuntimeException("token已过期");
		}catch (io.jsonwebtoken.SignatureException si){
			throw new SignatureException("验证错误");
		}
	}
}

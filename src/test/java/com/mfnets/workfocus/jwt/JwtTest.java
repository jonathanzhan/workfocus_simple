/**
 * Copyright &copy; 2012-2016 <a href="https://github.com/whatlookingfor">whatlookingfor</a> All rights reserved.
 */

package com.mfnets.workfocus.jwt;

import com.mfnets.workfocus.common.utils.DateUtils;
import io.jsonwebtoken.*;
import io.jsonwebtoken.impl.crypto.MacProvider;
import org.junit.Test;

import java.security.Key;
import java.util.Date;

/**
 * TODO
 *
 * @author Jonathan
 * @version 2016/12/7 15:22
 * @since JDK 7.0+
 */
public class JwtTest {

//	private static final Key key = MacProvider.generateKey();
	String key = "whatlookingfor";
	@Test
	public void getCompactJws(){
		String compactJws = Jwts.builder()
				.setSubject("Joe")
				.setIssuedAt(new Date())
				.setExpiration(DateUtils.addMinutes(new Date(),1))
				.setIssuer("Jonathan")
				.setId("22222")
				.compressWith(CompressionCodecs.DEFLATE)
				.signWith(SignatureAlgorithm.HS512, key)
				.compact();

		System.out.println(compactJws);
	}
	@Test
	public void test1(){

		String compactJws = "eyJhbGciOiJIUzUxMiIsInppcCI6IkRFRiJ9.eNqqV1iouTVKyUvLKT1XSUcpMLFGyMjSxMDSwNDc1M9FRSq0ogAuYGQEFMouLwarzEksyEvOAWrJKMoECRiCgVAsAAAD__w.Ft5FW8aeRGSysfiNbFlk58mkbsJCDbSzdaA_jYBzFqYxqq7u1Fk8rG8hA0-rIc0m3FlZ_eLVdUKaRPvgm1fCbw";

//		assert Jwts.parser().setSigningKey(key).parseClaimsJws(compactJws).getBody().getSubject().equals("Joe");
		try{
			Jws<Claims> claimsJws = Jwts.parser().setSigningKey(key).parseClaimsJws(compactJws);
			System.out.println(claimsJws.getBody().getSubject());
			Claims claims = claimsJws.getBody();
			System.out.println(claims.getSubject());
			System.out.println(claims.getId());
			System.out.println(claims.getIssuedAt());
			System.out.println(claims.getIssuer());
		}catch (io.jsonwebtoken.ExpiredJwtException e){
			throw new RuntimeException("token已过期");
		}catch (io.jsonwebtoken.SignatureException si){
			throw new SignatureException("验证错误");
		}

	}
}

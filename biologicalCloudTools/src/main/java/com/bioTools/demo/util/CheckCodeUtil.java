package com.bioTools.demo.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.stereotype.Service;

@Service
public class CheckCodeUtil {
	
	@Autowired
	private static JavaMailSenderImpl mailSender;

	
	private static String emailServiceCode;
	
	public static String sendCheckCode(String email){
		emailServiceCode = GetRandomStringUtil.getRandomString(6);
		SimpleMailMessage message = new SimpleMailMessage();
		message.setSubject("注册验证码");
		message.setText("注册验证码是：" + emailServiceCode);
		message.setFrom("1245929757@qq.com");
		message.setTo(email);
		mailSender.send(message);
		return emailServiceCode;
	}
	
	


}

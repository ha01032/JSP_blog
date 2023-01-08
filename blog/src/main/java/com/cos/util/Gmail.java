package com.cos.util;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;


// 메일을 접근(사용)할 때 사용 : 구글 아이디, 구글 비밀번호
public class Gmail extends Authenticator {
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return new PasswordAuthentication("hha01032@gmail.com", Password.GOOGLEPASSWORD);
	}
}

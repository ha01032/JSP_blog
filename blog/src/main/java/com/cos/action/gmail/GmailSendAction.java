package com.cos.action.gmail;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cos.action.Action;
import com.cos.dao.UserDao;
import com.cos.model.User;
import com.cos.util.Gmail;
import com.cos.util.SHA256;

public class GmailSendAction implements Action {
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String username = request.getParameter("username"); // (1)이메일 받기
		UserDao dao = new UserDao();
		User user = dao.findByUsername(username);
		String to = user.getEmail(); // (1)이메일 받기
		String from = "hha01032@gmail.com";
		String code = SHA256.getEncrypt(to, user.getId() + ""); // (2)code값을 SHA256 해시

		// (3)사용자에게 보낼 메시지
		String subject = "블로그 회원 가입을 위한 이메일 인증 메일입니다.";
		StringBuffer sb = new StringBuffer();
		sb.append("다음 링크에 접속하여 이메일 인증을 진행해주세요. ");
		sb.append("<a href='http://localhost:8000/blog/gmail?cmd=check&username=" + username + "&code=" + code
				+ "'>");
		sb.append("이메일 인증하기</a>");
		String content = sb.toString();

		// 설정 값
		Properties p = new Properties();
		p.put("mail.smtp.user", from);
		p.put("mail.smtp.host", "smtp.googlemail.com");
		p.put("mail.smtp.port", "465"); // TLS 587, SSL 465
		p.put("mail.smtp.starttls.enable", "true");
		p.put("mail.smtp.auth", "true");
		p.put("mail.smtp.debug", "true");
		p.put("mail.smtp.socketFactory.port", "465");
		p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		p.put("mail.smtp.sockerFactory.fallback", "false");

		// 이메일 전송
		try {
			Authenticator auth = new Gmail();
			Session ses = Session.getInstance(p, auth);
			ses.setDebug(true);
			MimeMessage msg = new MimeMessage(ses);
			msg.setSubject(subject);
			Address fromAddr = new InternetAddress(from);
			msg.setFrom(fromAddr);
			Address toAddr = new InternetAddress(to);
			msg.addRecipient(Message.RecipientType.TO, toAddr);
			msg.setContent(content, "text/html; charset=UTF8");
			Transport.send(msg);
			response.sendRedirect("/blog/user/login.jsp");
		} catch (Exception e) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이메일 인증 오류')");
			script.println("history.back();");
			script.println("</script>");
		}
	}
}

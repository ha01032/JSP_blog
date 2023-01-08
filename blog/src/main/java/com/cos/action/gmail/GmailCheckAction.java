package com.cos.action.gmail;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cos.action.Action;
import com.cos.dao.UserDao;
import com.cos.model.User;
import com.cos.util.SHA256;

public class GmailCheckAction implements Action{
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String code = request.getParameter("code");
		String username = request.getParameter("username");
		
		//DB에서 id값으로 email값 salt 가져오기
		UserDao dao = new UserDao();
		User user = dao.findByUsername(username);
		int  id = user.getId();
		String email = user.getEmail();

		// return code 값이랑 send code 값을 비교해서 동일하면
		boolean rightCode = SHA256.getEncrypt(email, id+"").equals(code);
		System.out.println("dsgfsdgdsg");
		
		PrintWriter script = response.getWriter();
		if(rightCode == true){
			dao.updateEmailCheck(id);
			script.println("<script>");
			script.println("alert('sucsess!')");
			script.println("location.href='/blog/user/login.jsp'");
			script.println("</script>");
		} else{
			script.println("<script>");
			script.println("alert('fail.')");
			script.println("location.href='errortest.jsp'");
			script.println("</script>");
		}
	}
}

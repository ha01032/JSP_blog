package com.cos.action.user;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cos.action.Action;
import com.cos.dao.UserDao;
import com.cos.model.User;
import com.cos.util.Script;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
// import com.sun.glass.ui.Application;

public class UserProfileAction implements Action{

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		

		
		String path = request.getServletContext().getRealPath("media");
		
	 	try {
	 		MultipartRequest multi = new MultipartRequest(
					request,
					path,
					1024*1024*2, //2MB
					"UTF-8",
					new DefaultFileRenamePolicy() //동일한 파일명이 들어오면 뒤에 숫자 붙임
					);
	 		
	 		String filename = multi.getFilesystemName("userProfile");
			String filepath = "/blog/media/" + filename;
			
			
			User user = (User)request.getSession().getAttribute("user");
			if(user == null)return;
			
					
			//DAO 연결하기
			UserDao dao = new UserDao();
			int result = dao.updateUserProfile(user, filepath);
			
			if(result == 1) {
				user.setUserProfile(filepath);
				HttpSession session = request.getSession();
				session.setAttribute("user", user);
				response.sendRedirect("/blog/index.jsp");
			}else {
				Script.back(response);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		//(리퀘스트, 저장경로, 허용파일크기, 인코딩타입, 파일명중복정책)
		

		
	}
}









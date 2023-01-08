package com.cos.action.board;

import java.io.IOException;
import java.util.List;

//import javax.jws.soap.SOAPBinding.Use;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cos.action.Action;
import com.cos.dao.BoardDao;
import com.cos.dao.CommentDao;
import com.cos.model.Board;
import com.cos.model.Comment;
import com.cos.model.User;
import com.cos.util.Script;
import com.cos.util.Utils;

public class BoardDetailAction implements Action {
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		if (request.getParameter("id") == null || request.getParameter("id").equals(""))
			return;

		int id = Integer.parseInt(request.getParameter("id"));

		BoardDao dao = new BoardDao();
		Board board = dao.findById(id);
		

		CommentDao commentDao = new CommentDao();

		List<Comment> comments = commentDao.findByBoardId(id);

		if (board != null) {
			
			//보드 카운트 쿠키

			String boardReadCheck = "";

			Cookie[] cookies = request.getCookies();
			for (int i = 0; i < cookies.length; i++) {
				if (cookies[i].getName().equals("boardReadCheck")) {
					boardReadCheck = cookies[i].getValue();
				}
			}

			if (boardReadCheck.equals("")) {
				Cookie c = new Cookie("boardReadCheck", "&" + id + "_" + (System.currentTimeMillis() / 1000));
				response.addCookie(c);
				dao.increaseReadCount(id);
			}else {
				
				if(!(boardReadCheck.contains("&"+id))) {
					boardReadCheck = boardReadCheck + "&" + id + "_" + (System.currentTimeMillis()/1000);
					Cookie coo = new Cookie("boardReadCheck",boardReadCheck);
					response.addCookie(coo);
					dao.increaseReadCount(id);
				}
				
				String tem[] = boardReadCheck.split("&");
				for (int i = 0; i < tem.length; i++) {
					if (!(tem[i].equals(""))) {
						String tem2[] = tem[i].split("_");
						if (tem2[0].equals(id + "")) {
							long timeUser = Long.parseLong(tem2[1]);
							long timeNow = System.currentTimeMillis() / 1000;
							if(timeUser+1800 < timeNow) {
								dao.increaseReadCount(id);
								boardReadCheck = boardReadCheck.replace("&" + id +"_"+ timeUser, "&" + id+ "_" + timeNow);
								Cookie coo = new Cookie("boardReadCheck",boardReadCheck);
								response.addCookie(coo);
							}
						}
					}
				}				
			}
			
			
			
			//보드 카운트 쿠키 끝
			
			int result = 1;
			if (result == 1) {
				// 유튜브 주소 파싱
				Utils.setPreviewYoutube(board);

				request.setAttribute("board", board);
				request.setAttribute("comments", comments);
				RequestDispatcher dis = request.getRequestDispatcher("board/detail.jsp");
				dis.forward(request, response);
			} else {
				Script.back(response);
			}
//널체크
		} else {
			Script.back(response);
		}
	}
}

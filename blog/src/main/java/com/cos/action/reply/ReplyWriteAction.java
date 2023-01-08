package com.cos.action.reply;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cos.action.Action;
import com.cos.dao.ReplyDao;
import com.cos.model.Reply;
import com.cos.util.Script;
import com.google.gson.Gson;

public class ReplyWriteAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// null 처리 직접
		int userId = Integer.parseInt(request.getParameter("userId"));
		int commentId = Integer.parseInt(request.getParameter("commentId"));
		String content = request.getParameter("content");

		System.out.println("userId : " + userId);
		System.out.println("commentId : " + commentId);
		System.out.println("content : " + content);

		Reply replyForm = new Reply();
		replyForm.setUserId(userId);
		replyForm.setCommentId(commentId);;
		replyForm.setContent(content);

		ReplyDao dao = new ReplyDao();
		// form으로 받은 데이터를 Comment 객체로 변환
		int result = dao.save(replyForm);

		if (result == 1) {
			// Comment 테이블에 가장 마지막에 만들어진 Comment의 튜플이 필요
			Reply reply = dao.findByMaxId();
			reply.getResponseData().setStatusCode(1);
			reply.getResponseData().setStatus("ok");
			reply.getResponseData().setStatusMessage("Write was completed");

			// Gson을 이용해서 Json으로 변환
			Gson gson = new Gson();
			String replyJson = gson.toJson(reply);

			System.out.println("(1) replyJson : "+replyJson);
			// 데이터 응답
			response.setContentType("application/json; charset=UTF-8");
			PrintWriter out = response.getWriter();
			out.print(replyJson);
			out.flush();
		} else {
			Script.back(response);
		}
	}
}

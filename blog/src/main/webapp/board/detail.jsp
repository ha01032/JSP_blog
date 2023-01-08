<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<%@ include file="/include/nav.jsp"%>

<!--================Blog Area =================-->
<section class="blog_area single-post-area">
	<div class="container">
		<div class="row">
			<div class="col-lg-2"></div>
			<div class="col-lg-8">
				<div class="main_blog_details">
					<a href="#"><h4>${board.title}</h4></a>
					<div class="user_details">
						<div class="float-left">
							<c:if test="${board.userId eq sessionScope.user.id}">
								<a href="/blog/board?cmd=updateForm&id=${board.id}">update</a>
								<a href="/blog/board?cmd=delete&id=${board.id}">delete</a>
							</c:if>
						</div>
						<div class="float-right">
							<div class="media">
								<div class="media-body">
									<h5>${board.user.username}</h5>
									<p>${board.createDate}</p>
								</div>
								<div class="d-flex">
									<img src="${board.user.userProfile }" alt="" width="60px;" style="border-radius: 50px;">
								</div>
							</div>
						</div>
					</div>
					<!-- 본문 시작 -->
					<p>${board.content}</p>
					<!-- 본문 끝 -->
					<hr />
				</div>

				<!-- 댓글 시작 -->
				<!-- before -->
				<div class="comments-area" id="comments-area">
					<!-- prepend -->
					<c:forEach var="comment" items="${comments}">


						<!-- 댓글 아이템 시작 -->
						<div class="comment-list" id="comment-id-${comment.id}">
							<!-- id 동적으로 만들기 -->

							<div class="single-comment justify-content-between d-flex">
								<div class="user justify-content-between d-flex">
									<div class="thumb">
										<img src="${comment.user.userProfile}" alt="" width="60px;" style="border-radius: 50px;">
									</div>
									<div class="desc">
										<h5>
											<a href="#">${comment.user.username}</a>
										</h5>
										<p class="date">${comment.createDate}</p>
										<p class="comment">${comment.content}</p>
									</div>
								</div>

								<div class="reply-btn">
								<c:if test="${comment.userId eq sessionScope.user.id}">
										<button onClick="commentDelete(${comment.id})"
										class="btn-reply text-uppercase" id="btn-del-${comment.id}"
										style="display: inline-block; float: left; margin-right: 10px;">삭제</button>
								</c:if>
									<button onClick="replyListShow(${comment.id})"
										class="btn-reply text-uppercase" id="btn-show-${comment.id}"
										style="display: inline-block; float: left; margin-right: 10px;">보기</button>
									<button onClick="replyForm(${comment.id})" id="btn-write-${comment.id}"
										class="btn-reply text-uppercase">쓰기</button>
								</div>
							</div>
						</div>
						<!-- 댓글 아이템 끝 -->


					</c:forEach>
					<!-- append -->



				</div>
				<!-- after -->
				<!-- 댓글 끝 -->

				<!-- 댓글 쓰기 시작 -->
				<div class="comment-form" style="margin-top: 0px;">
					<h4 style="margin-bottom: 20px">Leave a Comment</h4>
					<form id="comment-submit">
						<input type="hidden" name="userId" value="${sessionScope.user.id}" />
						<input type="hidden" name="boardId" value="${board.id}" />
						<div class="form-group">
							<textarea id="content" style="height: 60px"
								class="form-control mb-10" rows="2" name="content"
								placeholder="Messege" onfocus="this.placeholder = ''"
								onblur="this.placeholder = 'Messege'" required=""></textarea>
						</div>
						<button type="button" onClick="commentWrite()"
							class="primary-btn submit_btn">Post Comment</button>
					</form>
				</div>
				<!-- 댓글 쓰기 끝 -->
			</div>

			<div class="col-lg-2"></div>
		</div>
	</div>
</section>

<!--================Blog Area =================-->

<%@ include file="/include/footer.jsp"%>

<!--================Comment Script =================-->
<script>
   
   function commentWriteForm(id, username, content, createDate,comment_id, userProfile){
       var comment_list = "<div class='comment-list' id='comment-id-"+id+"'> ";
       comment_list += "<div class='single-comment justify-content-between d-flex'> ";
       comment_list += "<div class='user justify-content-between d-flex'> ";
       comment_list += "<div class='thumb'> <img src='"+userProfile+"' width='60px;' style='border-radius: 50px;'> </div> ";
       comment_list += "<div class='desc'><h5><a href='#'>"+username+"</a></h5> ";
       comment_list += "<p class='date'>"+createDate+"</p><p class='comment'>"+content+"</p></div></div> ";
       comment_list += "<div class='reply-btn'>";       
       comment_list += "<button onClick='commentDelete("+id+")' class='btn-reply text-uppercase' style='display:inline-block; float:left; margin-right:10px;'>삭제</button>";       
       comment_list += "<button onClick='replyListShow("+id+")' class='btn-reply text-uppercase'  style='display:inline-block; float:left; margin-right:10px;' id='btn-show-"+id+"'>보기</button>";
       comment_list += "<button onClick='replyForm("+id+")' class='btn-reply text-uppercase' id='btn-write-"+id+"''>쓰기</button></div></div></div>";
       console.log(comment_list);
       return comment_list;
   }
   
   //comment 쓰기
   function commentWrite(){

    var comment_submit_string = $("#comment-submit").serialize();
      console.log(comment_submit_string);
      $.ajax({
         method: "POST",
         url: "/blog/api/comment?cmd=write",
         data: comment_submit_string,
         contentType: "application/x-www-form-urlencoded; charset=utf-8",
         dataType:"json",
         success: function(comment){
            console.log(comment);
            //화면에 적용

               var comment_et = commentWriteForm(comment.id,comment.user.username,comment.content,comment.createDate,comment.id,comment.user.userProfile);
               $("#comments-area").append(comment_et);
               $("#content").val("");
               
         },
         error: function(xhr){
            console.log(xhr.status);
            
         }
         
      }); 
      
   }
   
   
   //comment 삭제
   function commentDelete(comment_id){ //자바스크립트는 하이픈 사용 불가
      $.ajax({
         method: "POST",
         url: "/blog/api/comment?cmd=delete",
         data: comment_id+"",
         contentType: "text/plain; charset=utf-8", //MIME 타입
         success: function(result){
            console.log(result);
            //해당 엘레멘트(DOM)을 찾아서 remove() 해주면 됨.
            if(result === "ok"){
               $("#comment-id-"+comment_id).remove();
            }
            
         },
         error: function(xhr){
            console.log(xhr.status);
         }
      });
   }

   function replyItemForm(id, username, content, createDate, ssusername,comment_id,userProfile){
         var replyItem = "<div class='comment-list left-padding' id ='reply-id-"+id+"'>";
         replyItem+= "<div class='single-comment justify-content-between d-flex'>";
         replyItem+= "<div class='user justify-content-between d-flex'>";
         replyItem+= "<div class='thumb'><img src='"+userProfile+"' alt='' style='border-radius:50px;' width='60px'></div>";
         replyItem+= "<div class='desc'><h5><a href='#'>"+username+"</a></h5>";
         replyItem+= "<p class='date'>"+createDate+"</p>";
         replyItem+= "<p class='comment'>"+content+"</p>";   
         replyItem+= "</div></div>";
         if(ssusername == username){
        	 replyItem+= "<div class='reply-btn'><button onClick='replyDelete("+id+","+comment_id+")' class='btn-reply text-uppercase'>삭제</button></div>";
         }         
         replyItem+= "</div></div>";
         
         return replyItem;
      }
   //reply 보기 - ajax
   function replyListShow(commentId) {
	   var tem = document.querySelector('#comment-id-'+commentId);
	   var tem2 = document.querySelector("#btn-show-" + commentId).innerHTML;
	   if(tem.querySelector(".comment-list")){
		  while(tem.querySelector(".comment-list")){
			  tem.querySelector(".comment-list").remove();
		  }
		  document.querySelector('#btn-show-' + commentId).innerText = '보기';
		  return;
	   }
	   
	   if(!(document.querySelector("#comment-id-"+commentId).querySelector(".comment-list"))&&tem2=="접기"){
		   document.querySelector('#btn-show-' + commentId).innerText = '보기'
		   return;
       }
	   
	   

	   document.querySelector('#btn-show-' + commentId).innerText = '접기';
	   
   //commentId 로 reply 전부다 select해서 가져오기
   $.ajax({
      method:"POST",
      url:"/blog/api/reply?cmd=list",
      data:commentId+"",
      contentType:"text/plain; charset=utf-8",
      dataType:"json",
      success:function(replys){ //js object
         console.log(replys);
         for(reply of replys){
            var reply_et= replyItemForm(reply.id,reply.user.username,reply.content,reply.createDate,"${sessionScope.user.username}",commentId,reply.user.userProfile);
            console.log(reply_et);
            $("#comment-id-"+reply.commentId).append(reply_et);
         }
      },
      error:function(xhr){
         console.log(xhr)
      }
   })      
      
   }
   
   //reply 삭제
   
   function replyDelete(replyId,commentId){
      $.ajax({
         method:"POST",
         url:"/blog/api/reply?cmd=delete",
      data:replyId+"",
      contentType:"text/plain; charset=utf-8",
      success:function(result){
         if(result==="ok"){
            //해당 엘레멘트 삭제
            $("#reply-id-"+replyId).remove();
            if(!(document.querySelector("#comment-id-"+commentId).querySelector(".comment-list"))){
            	document.querySelector('#btn-show-'+commentId).innerText = "보기";
            }            
         }
      },
      error:function(xhr){
         console.log(xhr);
      }
      });
   }

   //reply Form 만들기  - 화면에 로딩!!

   function replyForm(comment_id) {
         if(document.querySelector('#reply-form-'+comment_id)){
            document.querySelector('#btn-write-'+comment_id).innerText = "쓰기";
            document.querySelector('#reply-form-'+comment_id).remove();
            return;
         }
         
         document.querySelector('#btn-write-'+comment_id).innerText = '접기';
         
      var tem = "notLoginUser";
	<c:if test="${!empty sessionScope.user.id}">
		tem =${sessionScope.user.id};
	</c:if>
      var comment_form_inner = "<h4 style='margin-bottom:20px'>Leave a Reply</h4><form id='reply-submit'><input type='hidden' name='userId' value='"+tem+"' /><input type='hidden' name='commentId' value='"+comment_id+"' <div class='form-group'><textarea style='height:60px' class='form-control mb-10' rows='2'  name='content' placeholder='Messege' required=''></textarea></div><button type='button' onClick='replyWrite(" +  comment_id + ")' class='primary-btn submit_btn' >Post Comment</button></form>";
	
      //<div class="comment-form" style="margin-top:0px;"></div>
      var comment_form = document.createElement("div"); //div 빈 박스 생성
      comment_form.className = "comment-form"; //div에 클래스 이름을 주고
      comment_form.style = "margin-top:0px"; //div에 style을 준다.
      comment_form.id = "reply-form-" + comment_id;

      comment_form.innerHTML = comment_form_inner;
      console.log(comment_form);

      var comment_list = document.querySelector("#comment-id-"+comment_id);
      comment_list.append(comment_form); //after와 append, before와 prepend 
   }
   
   function replyWrite(comment_id){
      var reply_submit=$('#reply-submit').serialize();
      $.ajax({
            method: "POST",
            url: "/blog/api/reply?cmd=write",
            data: reply_submit,
            contentType: "application/x-www-form-urlencoded; charset=utf-8",
            dataType:"json",
            success: function(reply){
               console.log(reply);
               document.querySelector('#btn-show-' + comment_id).innerText = '보기';
               replyListShow(comment_id);
            document.querySelector('#btn-write-'+comment_id).innerText = "쓰기";
            //document.querySelector('#comment-id-'+reply.commentId).querySelector(".comment-list");
            $("#reply-form-" + comment_id).remove();  
            },
            error: function(xhr){
               console.log(xhr.status);
               
            }
            
         }); 
   }
</script>
</body>
</html>



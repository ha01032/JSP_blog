<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@ include file="/include/nav.jsp"%>
<script src="/blog/js/jquery-3.2.1.min.js"></script>
<c:if test="${empty sessionScope.user}">
	<script>
		alert('인증이 안된 유저입니다.');
		location.href = "/blog/user/login.jsp";
	</script>
</c:if>
<style>
/*
*
* ==========================================
* CUSTOM UTIL CLASSES
* ==========================================
*
*/
.file-upload input[type='file'] {
	display: none;
}

/*
*
* ==========================================
* FOR DEMO PURPOSES
* ==========================================
*
*/
body {
	height: 100vh;
}

.rounded-lg {
	border-radius: 1rem;
}

.custom-file-label.rounded-pill {
	border-radius: 50rem;
}

.custom-file-label.rounded-pill::after {
	border-radius: 0 50rem 50rem 0;
}
</style>

<section>
	<div class="container p-5">
		<!-- For demo purpose -->
		<div class="row mb-5 text-center text-white">
			<div class="col-lg-10 mx-auto"></div>
		</div>
		<!-- End -->


		<div class="row">
			<div class="col-lg-5 mx-auto">
				<div class="p-5 bg-white shadow rounded-lg">
					<img id="img_warp" src="${sessionScope.user.userProfile}" alt="" width="200" class="d-block mx-auto mb-4 rounded-pill">

					<!-- Default bootstrap file upload-->

					<h6 class="text-center mb-4 text-muted">프로필 사진 변경</h6>
					<form action="/blog/user?cmd=profile" method="POST" enctype="multipart/form-data">
						<div class="custom-file overflow-hidden rounded-pill mb-5">
							<input name="userProfile" id="customFile" type="file" class="custom-file-input rounded-pill"> <label id="fileNameLabel" for="customFile" class="custom-file-label rounded-pill">Choose file</label>
						</div>
						<!-- End -->

						<h6 class="text-center mb-4 text-muted">프로필 파일을 선택하세요(2MB 미만)</h6>

						<!-- Custom bootstrap upload file-->
						<label for="fileUpload" class="file-upload btn btn-primary btn-block rounded-pill shadow"><i class="fa fa-upload mr-2"></i>Browse for file ... <input id="fileUpload" type="file">
						</label>
						<!-- End -->
						<input class="file-upload btn btn-primary btn-block rounded-pill shadow" type="submit" value="전송"/>
					</form>

				</div>
			</div>
		</div>
	</div>
</section>

	<script>
		$("#customFile").on("change",handleImgFile);
		
		function handleImgFile(e){
			console.log(e);
			console.log(e.target);
			console.log(e.target.files);
			console.log(e.target.files[0]);
			var f = e.target.files[0];
			
			if(!f.type.match("image.*")){
				console.log("이미지 타입이 아닙니다");
				alert("이미지 타입이 아닙니다.");
				return;
			}
			var reader = new FileReader();
			
			reader.onload = function(e){
				console.log("================");
				console.log(e.target);
				console.log(e.target.result);
				$("#img_warp").attr("src",e.target.result);
				$("#fileNameLabel").text(f.name);
				
			}
			
			reader.readAsDataURL(f);			
			
		}
	</script>

<%@ include file="/include/footer.jsp"%>


</body>
</html>

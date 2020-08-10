<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp" %>

<h1 class="h3 mb-2">조회</h1>
<br>
  <div class="form-group">
    <label for="exampleFormControlInput1">게시물 번호</label>
    <input type="text" class="form-control" name='nno' placeholder="${get.nno }" readonly="readonly">
  </div>
  <div class="form-group">
    <label for="exampleFormControlSelect1">제목</label>
    <input type="text" class="form-control" name='title' placeholder="${get.title}" readonly="readonly">
  </div>
<div class="form-group">
	<label for="exampleFormControlTextarea1">내용</label>
	<textarea class="form-control" rows="10" name="content" readonly>${get.content}</textarea>
</div>
  <div class="form-group">
    <label for="exampleFormControlTextarea1">작성자</label>
    <input type="text" class="form-control" name='writer' placeholder="${get.writer}" readonly="readonly">
  </div>
  
	<!-- File upload -->
	<div class="bigPictureWrapper">
		<div class="bigPicture">
			<!-- 원본 이미지 출력 -->
		</div>	
	</div>
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">파일</div>
				<!--panel heading-->
				<div class="panel-body">
						<div class="uploadResult">
							<ul>
						<!-- 업로드한 파일 목록 -->
							</ul>
						</div>
				</div>
				<!--end panel body-->
			</div>
			<!--End panel-->
		</div>
	</div>
	<!--end row-->

<sec:authorize access="isAuthenticated()">
	<c:if test="${pinfo.username eq get.writer }">
		<button type="submit" class="btn btn-primary" data-oper="modify">수정</button>
	</c:if>
</sec:authorize>
<button type="submit" class="btn btn-primary" data-oper="list">목록</button>

<form id="actionForm">
<input type="hidden" name="nno" value='<c:out value="${get.nno }"/>'>
<input type="hidden" name="page" value='<c:out value="${cri.page}"/>'>
<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
</form>

<script>
$(document).ready(function() {
	var actionForm = $("#actionForm");
	
	$("button").on("click", function(e){
		e.preventDefault();
		
		var oper = $(this).data("oper");

		if(oper === 'list') {
			actionForm.attr("action", "/notice/list");
		} else {
			actionForm.attr("action", "/notice/modify");
		}

		actionForm.submit();
		
	}); //button
}); //document
</script>

<script>
$(document).ready(function() {
	(function() { //첨부파일 데이터를 가져오는 즉시 실행 함수.
		var nno = '<c:out value="${get.nno}"/>'; 
		
		$.getJSON("/notice/getAttachList", {nno:nno}, function(arr) {
			console.log(arr);
			var str = "";
			$(arr).each(function(i, attach) {
				if(attach.filetype) {
					var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);

					str += "<li data-path='"+attach.uploadPath+"'";
					str += "data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.filetype+"'>";
					str += "<div>";
					str+="<img src='/display?fileName="+fileCallPath+"'>";
					str+="</div>";
					str+="</li>";
				} else {
					str += "<li data-path='"+attach.uploadPath+"'";
					str += "data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.filetype+"'>";
					str += "<div>";
					str += "<span>"+attach.fileName+"</span><br/>";
					str += "<img src='/resources/img/file.png'>"
					str+="</div>";
					str+="</li>";
				}
			}); //each
			
			$(".uploadResult ul").html(str);
			
		});//end getJSON
	})();
	
	//첨부파일 클릭 이벤트 처리
	$(".uploadResult").on("click","li",function(e) { //클릭하는 업로드 파일의 속성을 파악해서 이미지를 띄우거나, 다운로드 받을 수 있게 한다.
		console.log("view image");
		
		var liObj = $(this);
		
		var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
		
		if(liObj.data("type")) {
			//파일 경로의 경우 함수로 전달될 때 문제가 생기므로 replace()를 이용해 변환하여 전달한다.
			showImage(path.replace(new RegExp(/\\/g),"/"));
		} else {
			//download
			self.location="/download?fileName="+path;
		}
	}); //end
	
	$(".bigPictureWrapper").on("click", function(e) {
			$(".bigPictureWrapper").hide();
	});
	
	function showImage(fileCallPath) { //이미지 띄우는 함수
		$(".bigPictureWrapper").css("display", "flex").show();
		$(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>");
	}
}); //document
</script>

<%@include file="../includes/footer.jsp" %>

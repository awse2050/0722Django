<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<h1 class="h3 mb-2">카테고리 조회</h1><br>

  <div class="form-group">
    <label for="exampleFormControlInput1">번호</label>
    <input type="text" class="form-control" name='cno' placeholder="${getCategory.cno }" readonly="readonly">
  </div>
  <div class="form-group">
    <label for="exampleFormControlSelect1">카테고리</label>
    <input type="text" class="form-control" name='ingr_category' placeholder="${getCategory.ingr_category }" readonly="readonly">
  </div>
  <div class="form-group">
    <label for="exampleFormControlSelect2">해시태그</label>
    <input type="text" class="form-control" name='tag' placeholder="${getCategory.tag }" readonly="readonly">
  </div>
  <div class="form-group">
    <label for="exampleFormControlTextarea1">유통기한(일)</label>
    <input type="text" class="form-control" name='expirationdate' placeholder="${getCategory.expirationdate }" readonly="readonly">
  </div>
  
  <!--FileUpload-->
  <div class='bigPictureWrapper'>
	<div class='bigPicture'>
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

						</ul>
					</div>
			</div>
			<!--end panel body-->
		</div>
		<!--End panel-->
	</div>
</div>
<!--end row-->
  
<button type="submit" class="btn btn-primary" data-oper="modify"> 수정</button>
<button type="submit" class="btn btn-primary" data-oper="list"> 목록</button>


<form class="actionForm">
<input type="hidden" name='cno' value='<c:out value="${getCategory.cno}"/>'>
<input type="hidden" name='page' value='<c:out value="${cri.page }"/>'>
<input type="hidden" name='amount' value='<c:out value="${cri.amount}"/>'>
<input type="hidden" name='type' value='<c:out value="${cri.type}"/>'>
<input type="hidden" name='keyword' value='<c:out value="${cri.keyword}"/>'>
</form>

<script>

$(document).ready(function() {
	
	var actionForm = $(".actionForm");
	console.log(actionForm);
	
	$("button[type='submit']").on("click", function(e) {
		e.preventDefault();
		
		console.log("click submit");
		var oper = $(this).data("oper");
		
		if(oper === "modify") { // 카테고리 수정창으로 갈떄
			/* actionForm.append("<input type='hidden' name='cno' value='${getCategory.cno}'>"); */
			actionForm.attr("action", "/admin/modify")
		} else if (oper === "list") { // 카테고리 목록으로 돌아갈 때.
			actionForm.attr("action", "/admin/categoryList");
		}
		actionForm.submit();
		
	});
	
})//doc
</script>

<!-- 게시물 조회 화면 처리 -->
<!-- 화면에서 첨부파일 조회하는 부분 스크립트 처리 -->
<script>
	$(document).ready(function(){
		
		console.log("SCRIPT");
		
		(function(){ // 첨부파일을 조회하는 즉시실행함수
			var cno = '<c:out value="${getCategory.cno}"/>';
			$.getJSON("/admin/getAttachList", {cno:cno}, function(arr) {
				console.log(arr);

				var str = "";

				$(arr).each(function(i, attach){
					//image type
					console.log("i : " + i );
					console.log("attach.filetype : " + attach.filetype); //fileType은 undifinded, filetype은 false
					if(attach.filetype) {
						console.log("-----------이미지 --------------");
						var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);

						str += "<li data-path='"+attach.uploadPath+"'";
						str += "data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.filetype+"'>";
						str += "<div>";
						str+="<img src='/display?fileName="+fileCallPath+"'>";
						str+="</div>";
						str+="</li>";
					} else {
						console.log("no 이미지 --------------");
						str += "<li data-path='"+attach.uploadPath+"'";
						str += "data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.filetype+"'>";
						str += "<div>";
						str += "<span>"+attach.fileName+"</span><br/>";
						str += "<img src='/resources/img/file.png'>"
						str+="</div>";
						str+="</li>";
					}
				});
				$(".uploadResult ul").html(str);

			}); //end getJson
		})(); //end function
		
		//첨부파일 클릭시 이벤트 처리
		 $(".uploadResult").on("click","li",function(e){
			console.log("view image");
			var liObj = $(this);
			
			var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
			
			if(liObj.data("type")){
				showImage(path.replace(new RegExp(/\\/g),"/"));
			}else{
				//다운로드
				self.location="/download?fileName="+path
			}
			
		});
			//해당 경로 이미지 보여주기
		function showImage(fileCallPath){
			//alert(fileCallPath);
			$(".bigPictureWrapper").css("display","flex").show();
				
			$(".bigPicture")
				.html("<img src='/display?fileName="+fileCallPath+"'>")
				.animate({width:'100%', height:'100%'},1000);
			} 
		//원본 이미지 창 닫기
		$(".bigPictureWrapper").on("click",function(e){
			$(".bigPicture").animate({width:'0%', height:'0%'},1000);
			setTimeout(function(){
				$('.bigPictureWrapper').hide();
			}, 1000);
		})
		
	});
		</script>


		

<%@include file="../includes/footer.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>
<h1 class="h3 mb-2">공지사항 수정</h1><br>
<form id="actionForm">
  <div class="form-group">
    <label for="exampleFormControlInput1">게시물 번호</label>
    <input type="text" class="form-control" name='nno' value="${get.nno }" readonly>
  </div>
  <div class="form-group">
    <label for="exampleFormControlSelect1">제목</label>
    <input type="text" class="form-control" name='title' value="${get.title}"> 
  </div>
<div class="form-group">
	<label for="exampleFormControlTextarea1">내용</label>
	<textarea class="form-control" rows="10" name="content">${get.content}</textarea>
</div>
  <div class="form-group">
    <label for="exampleFormControlTextarea1">작성자</label>
    <input type="text" class="form-control" name='writer' value="${get.writer}" readonly>
  </div>

  <!--FileUpload-->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">파일</div>
			<!--panel heading-->
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple> 
				</div>

				<div class="uploadResult">
						<ul>
						<!-- 업로드 파일 목록 -->
						</ul>
				</div>
			</div>
			<!--end panel body-->
		</div>
		<!--End panel-->
	</div>
</div>
<!--end row-->
<!-- Security CSRF Token -->
<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>

<sec:authorize access="isAuthenticated()">
	<c:if test="${pinfo.username eq get.writer }">
		<button type="submit" class="btn btn-primary" data-oper="modify">수정</button>
		<button type="submit" class="btn btn-primary" data-oper="remove">삭제</button>
		<button type="submit" class="btn btn-primary" data-oper="back">취소</button>
	</c:if>
</sec:authorize>

<!-- 유지 되어야 하는 데이터 -->
<input type="hidden" name="page" value='<c:out value="${cri.page}"/>'>
<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
</form>

<script>
$(document).ready(function() {
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880; //5MB
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
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
					str+="<button data-file=\'"+fileCallPath+"\' data-type='image' type='button' class='btn btn-primary'>"
					str+="<i class='fa fa-times'></i></button><br>"
					str+="<img src='/display?fileName="+fileCallPath+"'>";
					str+="</div>";
					str+="</li>";
				} else {
					str += "<li data-path='"+attach.uploadPath+"'";
					str += "data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.filetype+"'>";
					str += "<div>";
					str+="<button data-file=\'"+fileCallPath+"\' data-type='image' type='button' class='btn btn-primary'>"
					str+="<i class='fa fa-times'></i></button><br>"
					str += "<span>"+attach.fileName+"</span><br/>";
					str += "<img src='/resources/img/file.png'>"
					str+="</div>";
					str+="</li>";
				}
			}); //each
			
			$(".uploadResult ul").html(str);
			
		});//end getJSON
	})();
	
	$(".uploadResult").on("click", "button", function(e) {
		if(confirm("정말 지우겠습니까?")) { //'x'버튼 누르면 화면에서 사라진다.
			var targetLi = $(this).closest("li");
			targetLi.remove();
		}
	}); //uploadResult
	
	$("input[type='file']").change(function(e) {
		console.log('input type=file');
		var formData = new FormData();
		var inputFile = $("input[name='uploadFile']");
		var files = inputFile[0].files;
		
		for(var i=0; i<files.length;i++) {
			if(!checkExtension(files[i].name, files[i].size)) { //확장자, 크기 체크
				return false;
			}
			
			formData.append("uploadFile",files[i]); //key-value?
		} //end for
		
		$.ajax({
			url:'/uploadAjaxAction',
			processData:false,
			contentType:false,
			data:formData, 
			type:'POST',
			beforeSend:function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			dataType:'json',
			success:function(result) {
				console.log(result);
				showUploadResult(result); //업로드 결과 처리 함수
			}
		}); //ajax
		
	}); //input type='file'
	
	function checkExtension(fileName, fileSize) {
		if(fileSize>=maxSize) { //check size
			alert("파일이 너무 큽니다.");
			return false;
		}
		
		if(regex.test(fileName)) { //check extension
			alert("업로드 할 수 없는 파일입니다.");
			return false;
		}
		
		return true;
	} //checkExtension()
	
	function showUploadResult(uploadResultArr) {
		if(!uploadResultArr || uploadResultArr.length === 0) {return;}
		
		var uplaodUL = $(".uploadResult ul"); //upload ul태그
		
		var str = "";
		
		$(uploadResultArr).each(function(i, obj) {
			//image type
			if(obj.image){ //image file
				var fileCallPath=encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
				str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
				str+="<span>"+obj.fileName+"</span>";
				str+="<button data-file=\'"+fileCallPath+"\' data-type='image' type='button' class='btn btn-primary'>"
				str+="<i class='fa fa-times'></i></button><br>"
				str+="<img src='/display?fileName="+fileCallPath+"'>";
				str+="</div>";
				str+="</li>";
				
			} else { // other file
				var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");
				
				str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
				str+="<span>"+obj.fileName+"</span>";
				str+="<button data-file=\'"+fileCallPath+"\' data-type='file' type='button' class='btn btn-primary'>"
				str+="<i class='fa fa-times'></i></button><br>"
				str+="<img src='/resources/img/file.png'></a>"
				str+="</div>";
				str+="</li>";
			}
		}); 
		//이미지 혹은 그 외 파일을 구분해서 화면에 띄운다.
		uplaodUL.append(str);
	} //showUploadResult()
	

	
}); //document
</script>
<script>
$(document).ready(function() {
	var actionForm = $("#actionForm");
	
	$("button").on("click", function(e) {
		
		var oper = $(this).data("oper");
		
		console.log(oper);
		
		if(oper === 'modify') {
			e.preventDefault();
			
			var str = "";
			$(".uploadResult ul li").each(function(i, obj){
				var jobj = $(obj);
				
				str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str+="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str+="<input type='hidden' name='attachList["+i+"].filetype' value='"+jobj.data("type")+"'>";
			
			});

			actionForm.append(str);
			actionForm.attr("action","/notice/modify")
			.attr("method", "post")
		}
		
		if(oper === 'remove') {
			e.preventDefault();
			actionForm.attr("action", "/notice/remove")
			.attr("method", "post");
		}
		
		if(oper === 'back') { //page,amount,nno를 유지한 채 돌린다.
			var hidden = $("input[type='hidden']").clone();
			var	nno = $("input[name='nno']").clone();
			e.preventDefault();
			
			actionForm.empty();
			
			actionForm.append(hidden).append(nno);			
			actionForm.attr("action", "/notice/get");
		}
		
		actionForm.submit();
		
	}); //button
}); //document
</script>

<%@ include file="../includes/footer.jsp" %>
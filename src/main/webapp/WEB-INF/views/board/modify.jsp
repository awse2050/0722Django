<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<h1 class="h3 mb-2">게시물 수정</h1>

<form id="form" method="POST">
<!-- Security -->
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
	
	<div class="form-group">
		<label for="exampleFormControlInput1">게시물 번호</label> 
		<input type="text" class="form-control" name="bno" value="${get.bno}" readonly>
			
	</div>

	<div class="form-group">
		<label for="exampleFormControlInput1">제목</label> <input type="text"
			class="form-control" value="${get.title}" name="title">
	</div>

	<div class="form-group">
		<label for="exampleFormControlTextarea1">내용</label>
		<textarea class="form-control" rows="10" name="content">${get.content}</textarea>
	</div>

	<div class="form-group">
		<label for="exampleFormControlInput1">작성자</label> <input type="text"
			class="form-control" name="writer" value="${get.writer}" readonly>
	</div>

	<!-- File upload -->
<div class="bigPictureWrapper">
	<div class="bigPicture">
	</div>	
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

						</ul>
				</div>
			</div>
			<!--end panel body-->
		</div>
		<!--End panel-->
	</div>
</div>
<!--end row-->
		<!-- 로그인한 사용자가 작성한 게시물이어야만 수정/삭제할 수 있다. -->
		<sec:authorize access="isAuthenticated()">
			<c:if test="${pinfo.username eq get.writer}">
				<button type="submit" class="btn btn-secondary" data-oper='modBtn'>수정</button>
				<button type="submit" class="btn btn-secondary" data-oper='removeBtn'>삭제</button>
			</c:if>
		</sec:authorize>

	<button type="submit" class="btn btn-secondary" data-oper='back'>취소</button>
	
	<input type="hidden" name="page" value='<c:out value="${cri.page }"/>'>
	<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
	<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
	<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
	</form>

	<!--첨부파일 수정-->
	<script>
		$(document).ready(function(){
			var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
			var maxSize = 5242880; // 5MB
			/*SET Spring Security - Ajax */
			var csrfHeaderName = "${_csrf.headerName}";
			var csrfTokenValue = "${_csrf.token}";
			
			$(".uploadResult").on("click", "button", function(e) {
			console.log("delete File");
			if(confirm("Remove this file?")) {
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		}); //$(".uploadResult")

		function showUploadResult(uploadResultArr) {
			if(!uploadResultArr || uploadResultArr.length == 0) {return;}
			var uploadUL = $(".uploadResult ul");
			var str = "";

			$(uploadResultArr).each(function(i, obj) {
				//image type
				if(obj.image) {
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);

					str += "<li data-path='"+obj.uploadPath+"'";
					str += "data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'data-type='"+obj.image+"'";
					str += "><div>";
					str+="<span>"+obj.fileName+"</span>";
					str+="<button type='button' class='btn btn-warning btn-circle' data-file=\'"+fileCallPath+"\' data-type='image'>"
						+"<i class='fa fa-times'></i></button><br>";
					str+="<img src='/display?fileName="+fileCallPath+"'>";
					str+="</div>";
					str+="</li>";
				} else {
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");

					str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"'data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
					str += "<span>" +obj.fileName+"</span>";
					str += "<button type='button' class='btn btn-warning btn-circle'  data-file=\'"+fileCallPath+"\' data-type='file'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/resources/img/file.png'></a>";
					str += "</div>";
					str += "</li>";
				}
			});
			uploadUL.append(str);
		} //showUploadResult();
		
		function checkExtension(fileName, fileSize){
			if(fileSize >= maxSize) {
				alert("파일이 너무 큽니다.");
				return false;
			}

			if(regex.test(fileName)) {
				alert("업로드할 수 없는 파일입니다.");
				return false;
			}
			return true;
		} //checkExtension

		$("input[type='file']").change(function(e) {
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;

			for(var i=0; i<files.length;i++){
				if(!checkExtension(files[i].name, files[i].size) ){
					return false;
				}
				formData.append("uploadFile",files[i]);
			}
			
		$.ajax({
			url:'/uploadAjaxAction',
			processData:false,
			contentType:false,
			beforeSend:function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			data:formData,
			type:'POST',
			dataType:'json',
			success:function(result) {
				console.log(result);
				showUploadResult(result); //업로드 결과 처리 함수
			}
		}); //ajax	
		
		}); //input[type='file']

			//수정페이지에서 이미지를 조회하는 익명함수
			(function() {
				var bno = '<c:out value="${get.bno}"/>';

				$.getJSON("/board/getAttachList", {bno:bno} , function(arr){
					console.log(arr);

					var str = "";

					$(arr).each(function(i, attach){
						//imageType
						if(attach.filetype) {
							var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);

							str += "<li data-path='"+attach.uploadPath+"'";
							str += "data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.filetype+"'>";
							str += "<div>";
							str+="<button type='button' class='btn btn-warning btn-circle' data-file=\'"+fileCallPath+"\' data-type='image'>"
									+"<i class='fa fa-times'></i></button><br>";
							str+="<img src='/display?fileName="+fileCallPath+"'>";
							str+="</div>";
							str+="</li>";
						} else {
							str += "<li data-path='"+attach.uploadPath+"'";
							str += "data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.filetype+"'>";
							str += "<div>";
							str += "<span>"+attach.fileName+"</span><br/>";
							str += "<button type='button' class='btn btn-warning btn-circle'  data-file=\'"+fileCallPath+"\' data-type='file'><i class='fa fa-times'></i></button><br>";
							str += "<img src='/resources/img/file.png'>"
							str+="</div>";
							str+="</li>";
						}
					}); //forEach
					
					$(".uploadResult ul").html(str);
				}); //getJson
			})(); //end function
		}); // doc
	</script>
	
	<script>
		var formObj = $("form");
		
		$('button').on("click", function(e) {
			e.preventDefault();
			
			var oper = $(this).data("oper");
			console.log("operation : " + oper);
			
			if(oper==='back') {
				console.log("back...");
	            var bnoTag = $("input[name='bno']").clone(); //해당 name을 가진 태그의 value를 복사하여 저장한다.
				var hidden = $("input[type='hidden']").clone();
	            
				formObj.attr("action", "/board/get").attr("method","get");
				formObj.empty();
				formObj.append(bnoTag); //bno를 함께 보낸다.
				formObj.append(hidden);
				
			} else if(oper === 'removeBtn') {
				console.log("removeBtn....");
				if(confirm("정말 지우시겠습니까?")) {
					formObj.attr("action", "/board/remove");
				} else {
					return;
				}
			} else if(oper === 'modBtn') {
				console.log("modifyBtn....");

				var str = "";

				$(".uploadResult ul li").each(function(i, obj) {
					var jobj = $(obj);
					console.dir(jobj);

					str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
					str += "<input type='hidden' name='attachList["+i+"].filetype' value='"+jobj.data("type")+"'>";
				});
				formObj.attr("action", "/board/modify");
				formObj.append(str).submit();
			}

			formObj.submit();
		})
		
	</script>
<%@include file="../includes/footer.jsp"%>

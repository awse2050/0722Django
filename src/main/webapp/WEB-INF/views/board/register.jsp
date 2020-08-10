<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<h1 class="h3 mb-2">게시물 등록</h1>

	<form id="data" action="/board/register" method="post">
	  <div class="form-group">
	    <label for="exampleFormControlInput1">제목</label>
	    <input type="text" class="form-control" placeholder="제목" name="title">
	  </div>

	  <div class="form-group">
	    <label for="exampleFormControlTextarea1">내용</label>
	    <textarea class="form-control" rows="10" name="content"></textarea>
	  </div>
	  
	   <div class="form-group">
	    <label for="exampleFormControlInput1">작성자</label>
	    <input type="text" class="form-control" name="writer" placeholder="작성자"
	    value='<sec:authentication property="principal.username"/>' readonly>
	    
	    <!-- Security -->
	    <input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
	    
	  </div>
	  
<!--FileUpload-->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">붙여넣기</div>
			<!--panel heading-->
			<div class="panel-body">
					<div class="form-group uploadDiv">
						<input type='file' name='uploadFile' multiple>
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

	  <button type="submit" class="btn btn-secondary" id="regBtn">등록</button>
	  <button type="submit" class="btn btn-secondary" id="back">취소</button>
	</form>


	
 	<form id="hidden">
		<input type="hidden" name="page" value='${cri.page }'>
		<input type="hidden" name="amount" value='${cri.amount}'>
		<input type="hidden" name="type" value='${cri.type}'>
		<input type="hidden" name="keyword" value='${cri.keyword}'>
	</form>



<script>
	$(document).ready(function() {
		var dataForm = $("#data");
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; // 5MB
		/*SET Spring Security - Ajax */
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		

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
		
		$("button[type='submit']").on("click", function(e) {
			e.preventDefault();
			console.log("submit button");
			var str = "";
			$(".uploadResult ul li").each(function(i,obj){
				var jobj = $(obj);
				console.dir(jobj);
				console.log("loop test : " + i);
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].filetype' value='"+jobj.data("type")+"'>";
			}); //each
			dataForm.append(str).submit();
		}) //submit button

		$("#back").on("click", function(e) {
			e.preventDefault();
			var hidden = $("input[type='hidden']").clone();
            
            dataForm.attr("action", "/board/list").attr("method","get");
            dataForm.empty();
 			dataForm.append(hidden);
			dataForm.submit();
		});
		
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

		$(".uploadResult").on("click", "button", function(e) {
			console.log("delete file");
			var targetFile = $(this).data("file");
			var type = $(this).data("type");

			var targetLi = $(this).closest("li");

			$.ajax({
				url:'/deleteFile',
				data:{fileName: targetFile, type:type},
				beforeSend:function(xhr) {
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				dataType:'text',
				type:'POST',
				success:function(result){
					alert(result);
					targetLi.remove();
				}	
			}); //$.ajax
		}); //end

	}); //doc
	</script>

<%@include file="../includes/footer.jsp"%>

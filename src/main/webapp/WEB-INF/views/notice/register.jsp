<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../includes/header.jsp" %>
<h1 class="h3 mb-2">공지사항 등록</h1>
<form id="actionForm" action="/notice/register" method="post">
  <div class="form-group">
    <label for="exampleFormControlSelect1">제목</label>
    <input type="text" class="form-control" name='title'>
  </div>
<div class="form-group">
	<label for="exampleFormControlTextarea1">내용</label>
	<textarea class="form-control" rows="10" name="content" ></textarea>
</div>
  <div class="form-group">
    <label for="exampleFormControlTextarea1">작성자</label>
    <input type="text" class="form-control" name='writer'
    value='<sec:authentication property="principal.username"/>' readonly>
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

<button type="submit" class="btn btn-primary">등록</button>
<button type="submit" class="btn btn-primary" id="back">취소</button>

<!-- Security CSRF Token -->
<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }"/>
</form>

<script>
$(document).ready(function() { //FileUpload
	var actionForm = $("#actionForm");
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880; // 5MB
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
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
	
	$(".uploadResult").on("click","button", function(e) {
		// 클릭한 버튼의 데이터 타입이 image인지 file인지를 구분한다.
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		
		var targetLi = $(this).closest("li");
		
		$.ajax({
			url:'/deleteFile',
			data:{fileName:targetFile, type:type},
			beforeSend:function(xhr) {
				xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
			},
			dataType:'text',
			type:'POST',
			success:function(result) {
				//alert(result);
				targetLi.remove(); //삭제된 이미지가 있던 li태그릎 지운다.
			}
		});//ajax
		
	}); //end
	
	$("button[type='submit']").on("click", function(e) {
		e.preventDefault();
		var str = "";
		$(".uploadResult ul li").each(function(i, obj) {
			var jobj = $(obj);
			console.dir(jobj);
			str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
			str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
			str+="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
			str+="<input type='hidden' name='attachList["+i+"].filetype' value='"+jobj.data("type")+"'>";
		});
		actionForm.append(str).submit();
	});//end
	
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
		
	}); //input type='file'
	
	$("#back").on("click", function(e){
		e.preventDefault();
		self.location="/notice/list";
	});
	
});
</script>

<%@ include file="../includes/footer.jsp" %>
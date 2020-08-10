<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<h1 class="h3 mb-2">카테고리 변경</h1><br>
<form class='modifyForm' action='/admin/modify' method='post'>
  <div class="form-group">
    <label for="exampleFormControlInput1">번호</label>
    <input type="text" class="form-control" name='cno' value="${getCategory.cno }" readonly="readonly">
  </div>
  <div class="form-group">
    <label for="exampleFormControlSelect1">카테고리</label>
    <input type="text" class="form-control" name='ingr_category' value="${getCategory.ingr_category }" >
  </div>
  <div class="form-group">
    <label for="exampleFormControlSelect2">해시태그</label>
    <input type="text" class="form-control" name='tag' value ="${getCategory.tag }">
  </div>
  <div class="form-group">
    <label for="exampleFormControlTextarea1">유통기한(일)</label>
    <input type="text" class="form-control" name='expirationdate' value="${getCategory.expirationdate }" >
  </div>
  
 <!-- File upload -->
 <div class='bigPictureWrapper'>
	<div class='bigPicture'>
	</div>
</div>

  <div class="row">
  	<div class="col-lg-12">
  		<div class="panel panel-default">
  		
  		<div class="panel-heading">파일</div>
  		<!-- /.panel-heading -->
  		<div class="panel-body">
  		<div class="form-group uploadDiv">
  			<input type="file" name='uploadFile' multiple="multiple">
  		</div>
  		<div class='uploadResult'>
  		<ul>
  		</ul>
  		</div>
  	</div>
  </div>
 </div>
 </div>
  
  
  
<button type="submit" class="btn btn-primary" data-oper="modify"> 완료</button>
<button type="submit" class="btn btn-primary" data-oper="list"> 목록</button>
<button type="submit" class="btn btn-primary" data-oper="remove"> 삭제</button>

	<input type="hidden" name="page" value='<c:out value="${cri.page }"/>'>
	<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
	<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
	<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
	<!-- Security -->
<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
</form>

<form class="actionForm">
</form>

<script>
$(document).ready(function() {
	//첨부파일 추가
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880; // 5MB
	
	//x버튼 누르면 삭제
	$(".uploadResult").on("click", "button", function(e) {
	console.log("delete File");
	if(confirm("Remove this file?")) {
		var targetLi = $(this).closest("li");
		targetLi.remove();
		}
	 });//uploadResult끝
	 
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
				contentType:false,data:formData,type:'POST',
				dataType:'json',
				success:function(result) {
					console.log(result);
					showUploadResult(result); //업로드 결과 처리 함수
				}
			}); //ajax	
			
	});//inputtype file

	
	//첨부파일 보여주는 작업처리
	(function(){
		var cno = '<c:out value="${getCategory.cno}"/>';
		
		$.getJSON("/admin/getAttachList", {cno:cno}, function(arr){
			console.log(arr);
			
			var str="";
			
			$(arr).each(function(i, attach){
				//image type
				if(attach.filetype){
					//console.log("if");
					var fileCallpath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
					str +="<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' "
					str +="data-filename='"+attach.fileName+"' data-type='"+attach.filetype+"'><div>";
					str +="<span>"+attach.fileName+"</span>";
					str +="<button type='button' data-file=\'"+fileCallpath+"\'data-type='image'"
					str +="class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					
					str +="<img src='/display?fileName="+fileCallpath+"'>";
					str +="</div>";
					str +="</li>";
				}else{
					console.log("else");
					str +="<li data-path='"+attach.uploadPath+"'data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.filetype+"'><div>";
					
					str +="<span>"+attach.fileName+"</span><br/>";
					str +="<img src='/resources/img/file.png'>";
					str +="</div>";
					str +"</li>";
				}
			});
			$(".uploadResult ul").html(str);
			
		});//get json 끝
	})();//function 끝
});//doc

</script>
<script>
$(document).ready(function() {
	$("button[type='submit']").on("click", function(e){
		e.preventDefault();
		console.log("click button to modfiy page");
	var actionForm = $(".actionForm");
	var modifyForm = $(".modifyForm");
	// form안의 데이터를 가져온다,
	var cno = $("input[name='cno']").val();
	var ingr_category = $("input[name='ingr_category']").val();
	var tag = $("textarea[name='tag']").val();
	var expirationdate = $("input[name='expirationdate']").val();
	

		
		var oper = $(this).data("oper");
		if(oper === "list") { // 뒤로가거나 목록으로 가게끔.(우선은 목록으로 처리)
			actionForm.attr("action", "/admin/categoryList");
		} else if (oper === "remove") {
			console.log("remove button");
			if(confirm("Delete this file?")){
			actionForm.append("<input type='hidden' name='cno' value='${getCategory.cno}'>");
			actionForm.attr("action", "/admin/remove").attr("method", "post");
			}else{
				return;
			}
		} else if( oper === "modify") { // 수정완료시 검색,페이지,카테고리정보를 전달.
			console.log("modify button");
		/* 	actionForm.append("<input type='hidden' name='cno' value='"+cno+"'>");
			actionForm.append("<input type='hidden' name='ingr_name' value='"+ingr_category+"'>");
			actionForm.append("<input type='hidden' name='tag' value='"+tag+"'>");
			actionForm.append("<input type='hidden' name='expirationdate' value='"+expirationdate+"'>"); */
			
			var str ="";
			
			$(".uploadResult ul li").each(function(i, obj){
				var jobj = $(obj);
				console.dir(jobj);
				
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].filetype' value='"+jobj.data("type")+"'>";	
			});
			//actionForm.attr("action", "/admin/modify").attr("method","post");
			modifyForm.append(str);
			//actionForm.append(str).submit();
			
			modifyForm.submit();
			
			return;
		}
		// form의 데이터를 전송
		actionForm.submit();
	});
	});//doc
	</script>


<%@include file="../includes/footer.jsp"%>
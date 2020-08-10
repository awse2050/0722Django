<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<h1 class="h3 mb-2">레시피 수정</h1>

<form id="form" action="/recipe/recipeModify" method="post">

	<input type='hidden'  name='page' value='<c:out value="${cri.page }"/>'>
	<input type='hidden'  name='amount' value='<c:out value="${cri.amount }"/>'>
 	<input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
	<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'> 


	<div class="form-group">
		<label for="exampleFormControlInput1">recipe_no</label> <input
			type="text" class="form-control" name="recipe_no" 
			value='<c:out value="${recipeGet.recipe_no }"/>' readonly="readonly">
	</div>

	<div class="form-group">
		<label for="exampleFormControlInput1">레시피</label> <input type="text"
			class="form-control" name="recipe_name"
			value='<c:out value="${recipeGet.recipe_name }"/>'>
	</div>


	<div class="form-group">
		<label for="exampleFormControlInput1">재료</label> <input type="text"
			class="form-control" name="ingr_list"
			value='<c:out value="${recipeGet.ingr_list }"/>'>
	</div>




	<div class="form-group">
		<label for="exampleFormControlInput1">링크</label> <input type="text"
			class="form-control" name="recipe"
			value='<c:out value="${recipeGet.recipe }"/>'>
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
					<input type="file" name='uploadFile' multiple="multiple">
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
	
	<button type="submit" class="btn btn-secondary" data-oper='modify'>수정</button>
	<button type="submit" class="btn btn-secondary" data-oper='remove'>삭제</button>
	<button type="submit" class="btn btn-secondary" data-oper='list'>취소</button>
</form>




<form class="actionForm"></form>

<script>

$(document).ready(function(){
	
	
	
	var formObj=$("#form");
	
	$('button').on("click",function(e){
		e.preventDefault();
		
		var operation=$(this).data("oper");
		
		console.log("oper : "+ operation);
		
		if(operation ==='remove'){
			
			formObj.attr("action","/recipe/recipeRemove");
			
		}else if(operation === 'list'){
			
			formObj.attr("action","/recipe/recipeList").attr("method","get");
			
			var pageTag =$("input[name='page']").clone();
			var amountTag =$("input[name='amount']").clone();
			var keywordTag =$("input[name='keyword']").clone();
			var typeTag =$("input[name='type']").clone();
			
			formObj.empty();
			
			formObj.append(pageTag);
			formObj.append(amountTag);
			formObj.append(keywordTag);
			formObj.append(typeTag);
			
		}else if(operation === 'modify'){
			
			console.log("submit clicked");
			
			var str = "";
			
			$(".uploadResult ul li").each(function(i, obj) {
				
				var jobj = $(obj); // 사진의 정보.
				console.dir(jobj); // 콘솔에 정보 찍기
				
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].filetype' value='"+jobj.data("type")+"'>";
				
				
			});
			
			formObj.append(str).submit();
			
		}

		formObj.submit();

	});
});

</script>

<script>

$(document).ready(function(){
	(function(){
		
		var recipe_no = '<c:out value = "${recipeGet.recipe_no}" />'
		
		$.getJSON("/recipe/getAttachList",{recipe_no:recipe_no}, function(arr){
		
			console.log(arr);
			
			var str="";
			
		$(arr).each(function(i, attach){
				
				//image type
				if(attach.filetype){
					var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
					
					str += "<li data-path ='"+attach.uploadPath+"' data-uuid='"+attach.uuid
					+"' data-filename='"+attach.fileName+"' data-type='"+attach.filetype+"'><div>";
					
					str += "<span>" + attach.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image'";
					str += "class = 'btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str +="</li>";
				}else{
					
					str += "<li data-path ='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' "; 
					str += "data-filename='"+attach.fileName+"' data-type='"+attach.filetype+"'><div>";
					
					str += "<span> "+ attach.fileName+"</span><br/>";
					
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file'";
					str += "class = 'btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					
					str += "<img src ='/resources/img/file.png'>";
					str += "</div>";
					str += "</li>";
				}
			});
			
			$(".uploadResult ul").html(str);
		}); //end getjson
	})(); //end function
	
	 $(".uploadResult").on("click","button", function(e){
			console.log("delete file");
			
			if(confirm("파일을 지우시겠습니까? ")){
				
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		}); 
	
	 var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880; //5mb
		
		function checkExtension(fileName,fileSize){
			
				if(fileSize >= maxSize){
					alert("파일 사이즈 초과");
					return false;
				}
				
				if(regex.test(fileName)){
					alert("해당 종류의 파일은 업로드할 수 없습니다.");
					return false;
				}
				
				return true;
			
		}
		
		$("input[type='file']").change(function(e){
			
			var formData = new FormData();
			
			var inputFile = $("input[name='uploadFile']");
			
			var files = inputFile[0].files;
			
			for(var i = 0;i < files.length; i++){
				if(!checkExtension(files[i].name,files[i].size)){
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false,
				contentType: false, 
				data:formData,
				type:'POST',
				dataType:'json',
					success:function(result){
						console.log(result);
						showUploadResult(result);
					}
			});//$.ajax
			
		});
		
		function showUploadResult(uploadResultArr){
			if(!uploadResultArr || uploadResultArr.length == 0){return;}
			
			var uploadUL = $(".uploadResult ul");
			
			var str="";
			
			$(uploadResultArr).each(function(i, obj){
				if(obj.image) {
					var fileCallPath = encodeURIComponent( obj.uploadPath + "/s_"+obj.uuid+"_"+obj.fileName);
					str += "<li data-path='"+obj.uploadPath+"'";
					str += "data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'data-type='"+obj.image+"'";
					str += "><div>";
					str +="<span> "+ obj.fileName + "</span>";
					str += "<button type ='button' data-file=\'"+fileCallPath+"\' data-type='image' class ='btn btn-warning btn-circle'><i class ='fa fa-times'></i></button><br>";
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str += "</li>";
				} else {
					var fileCallPath = encodeURIComponent( obj.uploadPath + "/s_"+obj.uuid+"_"+obj.fileName);
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
					
					str += "<li data-path='"+obj.uploadPath+"'";
					str += "data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'data-type='"+obj.image+"'";
					str += "><div>";
					str += "<span> "+obj.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/resources/img/file.png'></a>";
					str += "</div>";
					str += "</li>";
				}
			});
			uploadUL.append(str);
		}
	
	
});
			
			
</script>



<%@include file="../includes/footer.jsp"%>

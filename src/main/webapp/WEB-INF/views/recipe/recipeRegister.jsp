<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<h1 class="h3 mb-2">레시피 등록</h1>

<form id="form" role="form" action="/recipe/recipeRegister" method="post">
	  <div class="form-group">
	    <label for="exampleFormControlInput1">레시피</label>
	    <input type="text" class="form-control"  name="recipe_name">
	  </div>
	  
	  
	  <div class="form-group">
	    <label for="exampleFormControlInput1">재료</label>
	    <textarea  class="form-control" rows="5" name="ingr_list"></textarea>
	  </div>
	   
	  
	  <div class="form-group">
	    <label for="exampleFormControlInput1">링크</label>
	    <input type="text" class="form-control" name="recipe" >
	  </div>
	  
<!--파일 업로드  -->
	<div class='bigPictureWrapper'>
		<div class='bigPicture'>
		</div>
	</div>
	<div class="row">
	
		<div class="col-lg-12">
			<div class="panel panel-default">
			
			<div class="panel-heading">Files</div>
			<!--/.panelheading  -->
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name='uploadFile' multiple>
				</div>
				
				<div class='uploadResult'>
				<ul>
				
				</ul>
				</div>
			</div>
			<!--end panel-body  -->
			</div>
		</div>
	
	</div>
	<!-- /.row -->
	
	  <button type="submit" class="btn btn-secondary" id="regBtn">등록</button>
	  <button type="reset" class="btn btn-secondary" id="back">취소</button>
</form>

	

<form class="actionForm">
</form>

<script>

$(document).ready(function(){
	
	var actionForm = $(".actionForm");
	// 목록으로 돌아갈때 (취소)	
	$("button#back").on("click", function(e) {
		e.preventDefault();
		actionForm.attr("action", "/recipe/recipeList");
		actionForm.submit();
	});
	
});

</script>

<script>

$(document).ready(function(e){
	var formObj = $("form[role='form']");
	
	$("button[type='submit']").on("click",function(e){
		
		e.preventDefault();
		
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
	}
	
	$(".uploadResult").on("click", "button", function(e){
		console.log("delete file");
		
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		
		var targetLi = $(this).closest("li");
		
		$.ajax({
			url: '/deleteFile',
			data: {fileName: targetFile, type:type},
			dataType:'text',
			type: 'POST',
			success: function(result){
				alert(result);
				targetLi.remove();
			}
		});//$.ajax
	});
});

</script>


<%@include file="../includes/footer.jsp"%>


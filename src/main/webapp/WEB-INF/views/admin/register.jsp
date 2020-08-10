<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<h1 class="h3 mb-2">등록</h1>

<form id="data" action="/admin/register" method="post">
	  <div class="form-group">
	    <label for="exampleFormControlInput1">카테고리</label>
	    <input type="text" class="form-control" placeholder="식재료 카테고리를 입력하세요" name="ingr_category">
	  </div>

	  <div class="form-group">
	    <label for="exampleFormControlTextarea1">태그</label>
	    <textarea class="form-control" rows="10" name="tag" placeholder="태그를 입력하세요. ','로 구분해주세요."></textarea>
	  </div>
	  
	   <div class="form-group">
	    <label for="exampleFormControlInput1">유통기한</label>
	    <input type="text" class="form-control" name="expirationdate" placeholder="유통기한을 입력하세요">
	  </div>
	  
	  <div class="row">
	  	<div class="col-lg-12">
	  		<div class="panel panel-default">
	  		
	  		<div class="panel-heading">File Attach</div>
	  		<!-- /.panel-heading -->
	  		<div class="panel-body">
	  			<div class="form-group uploadDiv">
	  				<input type="file" name='uploadFile' multiple>
	  			</div>
	  			
	  			<div class='uploadResult'>
	  			<ul>
	  			</ul>
	  			</div>
	  		</div>
	  		<!-- end panel-body -->
	  		</div>
	  		<!-- end panel-body -->
	  	</div>
	  	<!-- end panel -->
	  </div>
	  <!-- /.row -->
	  
	  <button data-oper='register' type="submit" class="btn btn-secondary" id="regBtn">등록</button>
	  <button data-oper='back' type="submit" class="btn btn-secondary" id="back">취소</button>
</form>

<form class="actionForm">
</form>

<script>

 $(document).ready(function(){
		//var formObj = $("#data");
		var dataForm = $("#data");
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880;
	
		function showUploadResult(uploadResultArr){
			if(!uploadResultArr || uploadResultArr.lenght == 0) {return;}
			var uploadUL = $(".uploadResult ul");
			
			var str="";
			$(uploadResultArr).each(function(i, obj){
    			//image type
    			//이미지 파일인 경우와 일반 파일의 경우에 보여지는 화면의 내용은 showUploadResult()내에 아래와 같은 HTML 태그들을 이용해서 작성한다.
    			
				if(obj.image){
    				var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
    				str +="<li data-path='"+obj.uploadPath+"'";
    				str +=" data-uuid='"+obj.uuid+"'data-filename='"+obj.fileName+"'data-type='"+obj.image+"'"
    				str +="><div>";
    				str +="<span>"+obj.fileName+"</span>";
    				str +="<button type='button' data-file=\'"+fileCallPath+"\' "
    				str +="data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
    				str +="<img src='/display?fileName="+fileCallPath+"'>";
    				str +="</div>";
    				str +="</li>";
    				
    			}else{

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
    	}//showUploadResult();
		
	function checkExtension(fileName, fileSize){
		
		if(fileSize >= maxSize){
			alert("파일 사이즈 초과");
			return false;
		}
		if(regex.test(fileName)){
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		return true;
	}//checkExtension
	
	$("button[type='submit']").on("click", function(e){
		e.preventDefault();
		console.log("submit clicked");

		var oper = $(this).data("oper");
		var str="";
		
		if(oper === "back") {
			  dataForm.attr("action", "/admin/categoryList").attr("method","get");
			  dataForm.submit();
		}
		
		$(".uploadResult ul li").each(function(i, obj){
			var jobj = $(obj);
			console.dir(jobj);
			
			str +="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
			str +="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
			str +="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
			str +="<input type='hidden' name='attachList["+i+"].filetype' value='"+jobj.data("type")+"'>";
		});//each
		
		
		dataForm.append(str).submit();
	});//submit

	$("input[type='file']").change(function(e){
		
		var formData = new FormData();
		
		var inputFile = $("input[name='uploadFile']");
		
		var files = inputFile[0].files;
		
		for(var i=0; i<files.length; i++){
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
		$.ajax({
			url:'/uploadAjaxAction',
			processData: false,
			contentType:false, 
			data:formData, 
			type:'POST',
			dataType:'json',
			success:function(result){
				console.log(result);
				showUploadResult(result);// 업로드 결과 처리 함수 
				
			}
		});//ajax 
	});
		$(".uploadResult").on("click", "button", function(e){
			console.log("delete file");
			
			var targetFile = $(this).data("file");
			var type=$(this).data("type");
			
			var targetLi = $(this).closest("li");
			
			$.ajax({
				url:'/deleteFile',
				data:{fileName:targetFile, type:type},
				dataType:'text',
				type: 'POST',
				success: function(result){
					alert(result);
					targetLi.remove();
				}
			});//$.ajax끝
		});
		
});// doc

</script>


<%@include file="../includes/footer.jsp"%>
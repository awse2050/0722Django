<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>
<h1 class="h3 mb-2">레시피 조회</h1>
<div class="form-group">
	<label for="exampleFormControlInput1">No</label> <input
		type="text" class="form-control" name="recipe_no" 
		value='<c:out value="${recipeGet.recipe_no }"/>' readonly="readonly">
</div>

<div class="form-group">
	<label for="exampleFormControlInput1">레시피</label> <input type="text"
		class="form-control" name="recipe_name"
		value='<c:out value="${recipeGet.recipe_name }"/>' readonly="readonly">
</div>

<div class="form-group">
	<label for="exampleFormControlInput1">재료</label> <input type="text"
		class="form-control" name="ingr_list"
		value='<c:out value="${recipeGet.ingr_list }"/>' readonly="readonly">
</div>

<div class="form-group">
	<label for="exampleFormControlInput1">링크</label> <input type="text"
		class="form-control" name="recipe"
		value='<c:out value="${recipeGet.recipe }"/>' readonly="readonly">
</div>

<!-- FileUpload -->
<div class='bigPictureWrapper'>
	<div class='bigPicture'>
	</div>
</div>
  
  <div class="row">
	
		<div class="col-lg-12">
			<div class="panel panel-default">
			
			<div class="panel-heading">파일</div>
			<!--/.panelheading  -->
			<div class="panel-body">
			
				<div class='uploadResult'>
				<ul>
				
				</ul>
				</div>
				
			</div>
			<!--end panel body  -->
		</div>
	</div>
	
</div>
<!-- end row -->

<button class="btn btn-secondary" data-oper="modify">수정</button>
<button class="btn btn-secondary" data-oper="list">목록</button>

<form id='operForm' action="/recipe/recipeModify" method="get">
	<input type='hidden' id='recipe_no' name='recipe_no' value='<c:out value="${recipeGet.recipe_no }"/>'>
	<input type='hidden'  name='page' value='<c:out value="${cri.page }"/>'>
	<input type='hidden'  name='amount' value='<c:out value="${cri.amount }"/>'>
	<input type='hidden' name='keyword' value='<c:out value="${cri.keyword }"/>'> 
 	<input type='hidden' name='type' value='<c:out value="${cri.type }"/>'>
</form>


<script>
	$(document).ready(function() {

		var operForm = $("#operForm");

		$("button[data-oper='modify']").on("click", function(e) {

			operForm.attr("action", "/recipe/recipeModify").submit();

		});

		$("button[data-oper='list']").on("click", function(e) {
			
			operForm.find("#recipe_no").remove();
			operForm.attr("action", "/recipe/recipeList");
			operForm.submit();
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
				console.log("i : " + i );
				console.log("attach.filetype : " + attach.filetype); //filetype은 undifinded, filetype은 false
				
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
			});
			
			$(".uploadResult ul").html(str);
			
			
		}); //end getjson
		
	})(); //end function 
	
	$(".uploadResult").on("click","li",function(e){
		console.log("view image");
		
		var liObj = $(this);
		
		var path = encodeURIComponent(liObj.data("path")+"/" + liObj.data("uuid")+"_"+liObj.data("filename"));
		
		if(liObj.data("type")){
			showImage(path.replace(new RegExp(/\\/g),"/"));
			
		}else{
			//download
			self.location="/download?fileName="+path;
		}
	});
	
	 function showImage(fileCallPath){
		  $(".bigPictureWrapper").css("display","flex").show();
		  
		  $(".bigPicture")
		  .html("<img src='/display?fileName="+ fileCallPath+"'>")
		  .animate({width:'100%', height: '100%'},1000);
	  }
	 
	 $(".bigPictureWrapper").on("click", function(e){
		 
		$(".bigPicture").animate({width:'0%', height: '0%'},1000);
		setTimeout(function(){
			$('.bigPictureWrapper').hide();
		},1000);
		
	 });
});

</script>

<%@include file="../includes/footer.jsp"%>
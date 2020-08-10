<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@include file="../includes/header.jsp"%>
    <link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap" rel="stylesheet">
 <!-- Page Heading -->
 
   <div class="card shadow mb-4">
            <div class="card-header py-3 form-inline">
          <h1>레시피</h1>
            </div>
          <!-- DataTales Example -->
          <div class="card shadow mb-4">
            <div class="card-body">
              <div class="table-responsive">
				<form id="searchForm" class="form-inline" action="/recipe/recipeList" style="float: right">
				<select class="btn btn-outline-primary dropdown-toggle" name='type'
				style="margin-right: 3px;">
					<option value='TC'
					<c:out value="${pageMaker.cri.type eq 'TC'?'selected':''}"/>>전체</option>
					<option value='T'
					<c:out value="${pageMaker.cri.type eq 'T' ? 'selected':''}"/>>레시피</option>
					<option value='C'
					<c:out value="${pageMaker.cri.type eq 'C' ? 'selected':''}"/>>재료</option>
				</select> 
				<input class="form-control mr-sm-2" name="keyword" type="search"
					placeholder="Search" value='<c:out value="${pageMaker.cri.keyword}"/>'>
				<input type='hidden' name='page' value="${pageMaker.cri.page }">
				<input type='hidden' name='amount' value="${pageMaker.cri.amount}">
				<button class="btn btn-outline-primary my-2 my-sm-0" type="submit">Search</button>
			</form>
			
				<button type="submit" id="regBtn" class="btn btn-secondary"
				style="margin-bottom: 10px">글쓰기</button>
              
                <table class="table table-bordered" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>No</th>
                      <th>레시피</th>
                      <th>재료</th>
                      <th>링크</th>
                    </tr>
                    <c:forEach items="${recipeList }" var="board">
                  <tbody>
                    <tr>
                    	<td><c:out value="${board.recipe_no }"/>&nbsp;</td>
                    	<td><a class='move' href='<c:out value="${board.recipe_no }"/>'>
                    	<c:out value="${board.recipe_name }"/></a></td>
                    	<td><c:out value="${board.ingr_list }"/></td>
                    	<td><c:out value="${board.recipe }"/></td>
                    </tr>
                    
                    </c:forEach>
                  </tbody>
                  </thead>
                  
            
                 
                </table>
                

                
                
                <!--페이징  -->
                <div class='pull-right'>
					<ul class="pagination">
					
					<c:if test="${pageMaker.prev }">
						<li class="page-item"><a class="page-link" href="${pageMaker.startPage-1 }"
							tabindex="-1">Previous</a></li>
					</c:if>
					
					<c:forEach var="num" begin="${pageMaker.startPage }" end="${pageMaker.endPage }">
						<li class="page-item  ${pageMaker.cri.page == num ? "active":""}">
						<a class="page-link" href="${num }">${num }</a>
						</li>
					</c:forEach>
						
					<c:if test="${pageMaker.next }">
						<li class="page-item"><a class="page-link" href="${pageMaker.endPage+1 }">Next</a>
						</li>
					</c:if>
					</ul>
				</div>
				<!--end pagination  -->
				
				<!--페이징 실제페이지를 클릭하면 동작하는 부분  -->
				<form id='actionForm' action="/recipe/recipeList" method='get'>
					<input type='hidden' name='page' value='${pageMaker.cri.page }'>
					<input type='hidden' name='amount' value='${pageMaker.cri.amount }'>
					<input type='hidden' name='type' value='<c:out value="${pageMaker.cri.type }"/>'>
					<input type='hidden' name='keyword' value='<c:out value="${pageMaker.cri.keyword }"/>'>
				
				</form>
				
              </div>
            </div>
          </div>
          
          <!-- Modal -->
<div class="modal" id="myModal" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Message</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<p>처리되었습니다.</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
$(document).ready(function(){
	
	var result = '<c:out value="${result}"/>'
	
	checkModal(result);
	
	history.replaceState({},null,null);
	
	function checkModal(result){
		if(result ===''|| history.state){
			return;
		}
		if(parseInt(result)>0){
			$(".modal-body").html("게시글" + parseInt(result) + "번이 등록되었습니다.");
		}
		$("#myModal").modal("show");
	}
	
	$("#regBtn").on("click",function(){
		self.location="/recipe/recipeRegister"
	});
	
	/* 페이징 버튼 이벤트처리 */
	var actionForm = $("#actionForm");
	
	$(".page-link").on("click",function(e){
		
		e.preventDefault();
		
		console.log('click');
		
		actionForm.find("input[name='page']").val($(this).attr("href"));
		
		actionForm.submit();
		
	});
	
	
	$(".move").on("click",function(e){
		
		e.preventDefault();
		actionForm.append("<input type='hidden' name='recipe_no' value='"+$(this).attr("href")+"'>");
		actionForm.attr("action","/recipe/recipeGet");
		actionForm.submit();
		
	});
	
	var searchForm=$("#searchForm");
	
	$("#searchForm button").on("click",function(e){
		if(!searchForm.find("option:selected").val()){
			alert("검색종류를 선택하세요");
			return false;
		}
		
		if(!searchForm.find("input[name='keyword']").val()){
			alert("키워드를 입력하세요");
			return false;
		}
		
		searchForm.find("input[name='page']").val("1");
		e.preventDefault();
		
		searchForm.submit();
	});
});
</script>


<%@include file="../includes/footer.jsp"%>
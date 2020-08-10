<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<div class="card shadow mb-4">
        <div class="card-header py-3 form-inline">
     		<h1> 카테고리 관리 </h1>
     	</div>
	<div class="card-body">
		<div class="table-responsive">
	<!-- Search Form -->
			<form id="searchForm" class="form-inline" action="/admin/categoryList" style="float: right">
				<select class="btn btn-outline-primary dropdown-toggle" name='type'
				style="margin-right: 3px;">
					<option value='tl'
					<c:out value="${pageMaker.cri.type eq 'tl'?'selected':''}"/>>전체</option>
					<option value='l'
					<c:out value="${pageMaker.cri.type eq 'l' ? 'selected':''}"/>>목록</option>
					<option value='t'
					<c:out value="${pageMaker.cri.type eq 't' ? 'selected':''}"/>>해시태그</option>
					
				</select> 
				<input class="form-control mr-sm-2" name="keyword" type="search"
					placeholder="Search" value='<c:out value="${pageMaker.cri.keyword}"/>'>
				<input type='hidden' name='page' value="${pageMaker.cri.page }">
				<input type='hidden' name='amount' value="${pageMaker.cri.amount}">
				<button class="btn btn-outline-primary my-2 my-sm-0" type="submit">Search</button>
			</form>
			<!-- END Search Form -->
<button type="submit" class="btn btn-secondary" id="register">카테고리 등록</button>
<br>
<br>
 <table class="table table-bordered">
  <thead>
    <tr>
      <th scope="col">번호</th>
      <th scope="col">목록</th>
      <th scope="col">해시태그</th>
      <th scope="col">유통기한(일)</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach items="${ category }" var="category">
    <tr>
      <td><c:out value="${category.cno }"/> </td>
      <td><a class="getBtn" href="<c:out value="${category.cno}"/>"><c:out value="${category.ingr_category}" /> </td>
      <td><c:out value="${category.tag}" /> </td>
      <td><c:out value="${category.expirationdate}" /> </td>
    </tr>
  </c:forEach>
  </tbody>
</table> 

 <!-- pagination -->
				<ul class="pagination">
					<c:if test="${pageMaker.prev}">
						<li class="page-item">
						<a class="page-link" href="${pageMaker.startPage-1}"
							tabindex="-1" aria-disabled="true">Previous</a></li>
					</c:if>
					<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage }">
						<li class="page-item ${pageMaker.cri.page == num ? "active":""}">
							<a class="page-link" href="${num }">${num}</a>
						</li>
					</c:forEach>
					<c:if test="${pageMaker.next }">
						<li class="page-item">
							<a class="page-link" href="${pageMaker.endPage+1}">Next</a>
						</li>
					</c:if>
				</ul>

</div>
</div>
</div>
<!-- 카테고리 하나를 조회할 때 페이지, 검색어 정보를 보낸다. -->
<form class="formObj" action="/admin/category" method="get">
	<input type="hidden" name="page" value='${pageMaker.cri.page }'>
	<input type="hidden" name="amount" value='${pageMaker.cri.amount}'>
	<input type="hidden" name="type" value='${pageMaker.cri.type}'>
	<input type="hidden" name="keyword" value='${pageMaker.cri.keyword}'>
</form> 

<form class="actionForm" action="/admin/categoryList" method="get">
	<input type="hidden" name="page" value='${pageMaker.cri.page }'>
	<input type="hidden" name="amount" value='${pageMaker.cri.amount}'>
	<input type="hidden" name="type" value='${pageMaker.cri.type}'>
	<input type="hidden" name="keyword" value='${pageMaker.cri.keyword}'>
</form>

<script>

  $(document).ready(function() {

	 var formObj = $(".formObj");
	 var searchForm = $("#searchForm");
	 var actionForm = $(".actionForm");
	 
	 //등록하면 register페이지로 이동한다.
	 $('#register').on("click", function(e){
		 e.preventDefault();
		 self.location = "/admin/register";
	 }); //register
	 
	 $(".getBtn").on("click", function(e) {
		 e.preventDefault();
		 /* 카테고리 조회시 검색,페이지정보 + 카테고리의 고유번호를 전달합니다. */
		 formObj.append("<input type='hidden' name='cno' value='"+ $(this).attr("href")+"'>");
		 formObj.submit();
	 });
	 
		$("#searchForm button").on("click", function(e) {
			if(!searchForm.find("input[name='keyword']").val()){
				alert("검색어를 입력하세요");
				return false;
			}
			if(!searchForm.find("option:selected").val()){
				alert("검색종류를 선택하세요.");
				return false;
			}
			searchForm.find("input[name='page']").val("1");
			e.preventDefault();
			
			searchForm.submit();
		}); //searchForm        
		
		
		$(".page-item a").on("click",function(e){
			e.preventDefault();
			console.log("this : " +this);
			//name이 page인 input태그를 찾아서 값을 내가 클릭하는 값으로 바꾼다.
			//.attr("href")는 링크를 추가하는 것 같은데 자세히는 모르겠다.
			actionForm.find("input[name='page']").val($(this).attr("href"));
			
			actionForm.submit();
		}); //paging
	 
	 
 }) 
 
</script> 

<%@include file="../includes/footer.jsp"%>
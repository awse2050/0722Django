<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
   
<%@include file="../includes/header.jsp"%>
<style>
 .userRemoveBtn {
 	font-size: 10px;
 	color: blue;
 }
</style>

<div class="card shadow mb-4">
        <div class="card-header py-3 form-inline">
     		<h1> 회원 관리 </h1>
     	</div>
	<div class="card-body">
		<div class="table-responsive">
<!-- 등록버튼, js 처리  -->
<!-- 회원아이디만  -->
<!-- Search Form -->
			<form id="searchForm" class="form-inline" action="/admin/userinfo" style="float: right">
				<select class="btn btn-outline-primary dropdown-toggle" name='type'
				style="margin-right: 3px;">
					<option value=''
					<c:out value="${pageMaker.cri.type eq ''?'selected':''}"/>>--</option>
					<option value='n'
					<c:out value="${pageMaker.cri.type eq 'n' ? 'selected':''}"/>>사용자</option>
					<option value='r'
					<c:out value="${pageMaker.cri.type eq 'r' ? 'selected':''}"/>>등록날짜</option>
				</select> 
				<input class="form-control mr-sm-2" name="keyword" type="search"
					placeholder="Search" value='<c:out value="${pageMaker.cri.keyword}"/>'>
				<input type='hidden' name='page' value="${pageMaker.cri.page }">
				<input type='hidden' name='amount' value="${pageMaker.cri.amount}">
				<button class="btn btn-outline-primary my-2 my-sm-0" type="submit">Search</button>
			</form>
			<!-- END Search Form -->
<!-- <button class="btn btn-primary" id="userReg">사용자 등록</button> -->
<br>
<br>

<table class="table table-bordered">
  <thead>
    <tr>
      <th scope="col">회원아이디</th>
      <th scope="col">회원이름</th>
    </tr>
  </thead>
  <tbody>
  <c:forEach items="${ userList }" var="User">
  <!-- username 을 id 로 변경, 등록날짜는 없어지고, 회원이름 태그를 추가 -->
    <tr>
      <td><a class="getBtn" href="<c:out value="${User.id }"/>"><c:out value="${User.id }"/></a>
       <a href="<c:out value="${User.id }"/>" class="userRemoveBtn">삭제</a> </td>
      <%-- <th><fmt:formatDate pattern="yyyy-MM-dd" value="${User.regdate}" /> </th> --%>
    	 <td><c:out value="${User.name }"/></td>
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

<!-- get page -->
<%-- <form class="formObj" action="/admin/get" method="get">
	<input type='hidden' name='username' value="${User.username}">
	<input type="hidden" name="page" value='${pageMaker.cri.page }'>
	<input type="hidden" name="amount" value='${pageMaker.cri.amount}'>
	<input type="hidden" name="type" value='${pageMaker.cri.type}'>
	<input type="hidden" name="keyword" value='${pageMaker.cri.keyword}'>
</form> --%>

<!-- Paging  or  GET Form -->
<form id="actionForm" action="/admin/userinfo" method="get">
<!-- username을 id로 변경 -->
	<input type='hidden' name='id' value="${User.id}">
	<input type="hidden" name="page" value='${pageMaker.cri.page }'>
	<input type="hidden" name="amount" value='${pageMaker.cri.amount}'>
	<input type="hidden" name="type" value='${pageMaker.cri.type}'>
	<input type="hidden" name="keyword" value='${pageMaker.cri.keyword}'>
	<!-- Security -->
<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
</form>
<script>

 $(document).ready(function() {

	/*  var formObj = $(".formObj"); */
	 var actionForm = $("#actionForm"); // GET, PAGING
	 var searchForm = $("#searchForm"); // 검색
	 
	 $(".userRemoveBtn").on("click",function(e) {
		 e.preventDefault(); // 기능 취소
		 if(confirm("정말 지우시겠습니까?" )) {
		 
		 actionForm.find("input[name='id']").val($(this).attr("href"));
		 actionForm.attr("action","/admin/userRemove");
		 actionForm.attr("method","post");
		 actionForm.submit();
		 } 
	 })
	 
	 $(".getBtn").on("click", function(e) { //사용자 한명의 정보를 얻어온다.
		 e.preventDefault(); // 기능 취소
		 
		 actionForm.find("input[name='id']").val($(this).attr("href"));
		 actionForm.attr("action","/admin/get")
		 actionForm.submit();
	 })
	 
	 $("#userReg").on("click", function(e) {// 사용자를 등록한다.
		 e.preventDefault();
		 self.location = "/admin/userRegister";
	 }); //userReg
	 
	 $(".page-item a").on("click",function(e){ // 페이지를 이동한다.
		e.preventDefault();
		console.log("this : " +this);
		//name이 page인 input태그를 찾아서 값을 내가 클릭하는 값으로 바꾼다.
		//.attr("href")는 링크를 추가하는 것 같은데 자세히는 모르겠다.
		actionForm.find("input[name='page']").val($(this).attr("href"));
		
		actionForm.submit();
	}); //paging
	 
	 $("#searchForm button").on("click", function(e) { // 검색한다.
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
		});
 })
 
</script> 

<%@include file="../includes/footer.jsp"%>

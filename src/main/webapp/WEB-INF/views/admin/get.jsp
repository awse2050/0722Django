<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>


<!-- 한 사용자의 냉장고를 보여준다. -->
<h1 class="h3 mb-2">${username}의 냉장고</h1>

<br>
<br>

<table class="table table-bordered">
  <thead class="thead-dark">
    <tr>
      <th scope="col">보유재료</th>
      <th scope="col">분류</th>
      <th scope="col">구매일</th>
      <th scope="col">수정일</th>
      <th scope="col">유효기간</th>
    </tr>
  </thead>
  <tbody>
  <!-- 냉장고 테이블의 데이터들. -->
  <c:forEach items="${ userInfo }" var="User">
    <tr>
      <th>
      <c:out value="${User.ingr_name }"/>
       </th>
      
       <th> <c:out value="${User.cno }"/></th>
       
      <!-- 	<select class="form-control form-control-sm">
  			<option ></option>
		</select> -->
       
      <th><fmt:formatDate pattern="yyyy-MM-dd" value="${User.regdate}" /> </th>
      <th><fmt:formatDate pattern="yyyy-MM-dd" value="${User.updatedate}" /> </th>
      <th><fmt:formatDate pattern="yyyy-MM-dd" value="${User.expirationdate}" /> </th>
    </tr>
  </c:forEach>
  </tbody>
</table>

<button class="btn btn-primary" id="modify">수정</button>
<button class="btn btn-primary" id="back">목록</button>


<form id="actionForm">
<!-- name속성 username을 id로 변경 -->
<input type="hidden" name="id" value="${username }">
<input type="hidden" name="page" value='<c:out value="${cri.page }"/>'>
<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
</form>

<script>
	$(document).ready(function() {
	
		var actionForm = $("#actionForm");
	
		$("#modify").on("click",function(e) {
			actionForm.attr("action","/admin/modifyFridge");
			actionForm.submit();
		});//modify
	
		$("#back").on("click", function(e) {
			e.preventDefault();
			// username을 id로 변경
			$("input[name='id']").remove();
			actionForm.attr("action","/admin/userinfo");
			actionForm.submit();
		}); //back
	});
</script>

<%@include file="../includes/footer.jsp"%>
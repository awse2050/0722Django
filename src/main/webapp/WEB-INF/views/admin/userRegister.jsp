<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>

<form id="data" action="/admin/userRegister" method="post">
	  <div class="form-group">
	    <label for="exampleFormControlInput1">사용자 ID</label>
	    <input type="text" class="form-control" placeholder="사용자 ID를 입력하세요" name="id">
	  </div>
	  <button type="submit" class="btn btn-secondary" id="regBtn">등록</button>
	  <button type="submit" id="back" class="btn btn-secondary" id="back">취소</button>
	  
	  	<!-- Security -->
<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
</form>

<script>
	$(document).ready(function() {
		$("#back").on("click", function(e) {
			e.preventDefault();
			self.location = "/admin/userinfo";				
		}); //#back
	}); //doc
</script>

<%@include file="../includes/footer.jsp"%>
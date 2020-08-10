<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp" %>
  <div class="card shadow mb-4">
            <div class="card-header py-3 form-inline">
              <h1 class="m-0 font-weight-bold text-primary form-inline">공지사항</h1>
            </div>
            <div class="card-body">
              <div class="table-responsive">
              <!-- Search Form -->
              <form id="searchForm" class="form-inline" action="/notice/list" style="float: right">
				<select class="btn btn-outline-primary dropdown-toggle" name='type'
				style="margin-right: 3px;">
					<option value='tcw'
					<c:out value="${pageMaker.cri.type eq 'tcw'?'selected':''}"/>>전체</option>
					<option value='tc'
					<c:out value="${pageMaker.cri.type eq 'tc' ? 'selected':''}"/>>제목+내용</option>
					<option value='t'
					<c:out value="${pageMaker.cri.type eq 't' ? 'selected':''}"/>>제목</option>
					<option value='c'
					<c:out value="${pageMaker.cri.type eq 'c' ? 'selected':''}"/>>내용</option>
					<option value='w'
					<c:out value="${pageMaker.cri.type eq 'w' ? 'selected':''}"/>>작성자</option>
				</select> 
				<input class="form-control mr-sm-2" name="keyword" type="search"
					placeholder="Search" value='<c:out value="${pageMaker.cri.keyword}"/>'>
				<input type='hidden' name='page' value="${pageMaker.cri.page }">
				<input type='hidden' name='amount' value="${pageMaker.cri.amount}">
				<button class="btn btn-outline-primary my-2 my-sm-0" type="submit">Search</button>
			</form>
		 	<button type="submit" class="btn btn-primary form-inline" id="register" display:inline-block;"
		 	style="margin-bottom: 10px; "> 등록</button>
		 	<br>
			<!-- End Search Form -->
			
                <table class="table table-bordered" width="100%" cellspacing="0">
                  <thead>
                    <tr>
                      <th>번호</th>
                      <th>제목</th>
                      <th>작성자</th>
                      <th>등록일</th>
                      <th>수정일</th>
                    </tr>
                  </thead>
                  <tfoot>
                    <tr>
                      <th>번호</th>
                      <th>제목</th>
                      <th>작성자</th>
                      <th>등록일</th>
                      <th>수정일</th>
                    </tr>
                  </tfoot>
                  <tbody>
                    <tr>
                    <c:forEach items="${list}" var="list">
                      <td><c:out value="${list.nno }"/></td>
                      <td>
                      <a class="move" href="${list.nno }"><c:out value="${list.title }"/></a>
                      </td>
					  <td><c:out value="${list.writer}"/></td>
                      <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${list.regdate }"/> </td>
                      <td><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${list.moddate}"/> </td>
                    </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          
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
				<!-- End Page -->
          
<form id="actionForm" action="/notice/list">
	<input type="hidden" name="page" value="${pageMaker.cri.page }">
	<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
	<input type="hidden" name="type" value="${pageMaker.cri.type }">
	<input type="hidden" name="keyword" value="${pageMaker.cri.keyword}">
</form>

<!-- Remove Modal -->
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
				<p>삭제되었습니다.</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
			</div>
		</div>
	</div>
</div>

<script>
	$(document).ready(function() {
		var actionForm = $("#actionForm");
		var result = '<c:out value="${result}"/>'; //remove결과 값
	    var searchForm = $("#searchForm");
		
	    checkModal(result);

	    function checkModal(result) {	//remove modal
	        if (result === 'success') {
	            $(".modal-body").html("게시글이 삭제되었습니다.");
	        } else {
	        	return;
	        }
	        $("#myModal").modal("show");
	    } //checkModal()
	    
		//게시물 링크
		$(".move").on("click", function(e) {
			e.preventDefault();
			actionForm.append("<input type='hidden' name='nno' value='"+$(this).attr("href")+"'>");
			actionForm.attr("action", "/notice/get");
			actionForm.submit();
		});
		
		//등록
		$("#register").on("click", function(e) {
			actionForm.attr("action", "/notice/register");
			actionForm.submit();
		});
		
		//페이징
		$(".page-item a").on("click", function(e) {
			e.preventDefault();
			actionForm.find("input[name='page']").val($(this).attr("href"));
			actionForm.submit();
		});
		
		//검색
		$("#searchForm button").on("click", function(e) {
			if(!searchForm.find("input[name='keyword']").val()){
				alert("검색어를 입력하세요");
				return false;
			}
			
			searchForm.find("input[name='page']").val("1");
			e.preventDefault();
			
			searchForm.submit();
		}); //searchForm        
		
	}); //document
</script>

<%@include file="../includes/footer.jsp" %>
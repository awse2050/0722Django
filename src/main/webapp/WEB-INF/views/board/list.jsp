<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>
<link href="https://fonts.googleapis.com/css2?family=Do+Hyeon&display=swap" rel="stylesheet">
<!-- Page Heading -->
  <div class="card shadow mb-4">
            <div class="card-header py-3 form-inline">
              <h1 class="m-0 font-weight-bold text-primary form-inline">자유게시판</h1>
            </div><!-- DataTales Example -->
<div class="card shadow mb-4">
	<div class="card-body">
		<div class="table-responsive">
		<!-- Search Form -->
			<form id="searchForm" class="form-inline" action="/board/list" style="float: right">
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
			<!-- END Search Form -->
			<table class="table table-bordered">
				<button type="submit" id="regBtn" class="btn btn-secondary"
				style="margin-bottom: 10px">글쓰기</button>
				<thead>
					<tr>
						<th>No</th>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<th>No</th>
						<th>제목</th>
						<th>작성자</th>
						<th>작성일</th>
					</tr>
				</tfoot>
				<c:forEach items="${list }" var="list">
					<tbody>
						<tr>
						<!--  href='/board/get?bno=<c:out value="${list.bno }" />' -->
							<td><c:out value="${list.bno }"/></td>
							<td><a class='move' 
							href='<c:out value="${list.bno }"/>'>
							<c:out value="${list.title }"/>
							<b><c:out value="${list.replyCnt==0? '' : [list.replyCnt] }"></c:out></b>
							</a></td>
							<td><c:out value="${list.writer}" /></td>
							<td><fmt:formatDate pattern="yyyy-MM-dd"
									value="${list.regdate}" />
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
				<!-- End Page -->
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
				<p>삭제되었습니다.</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
			</div>
		</div>
	</div>
</div>

<!-- Paging Form -->
<form id="actionForm" action="/board/list" method="get">
	<input type="hidden" name="page" value='${pageMaker.cri.page }'>
	<input type="hidden" name="amount" value='${pageMaker.cri.amount}'>
	<input type="hidden" name="type" value='${pageMaker.cri.type}'>
	<input type="hidden" name="keyword" value='${pageMaker.cri.keyword}'>
</form>

<script>
$(document).ready(function() {
    var result = '<c:out value="${removeResult}"/>';
	var actionForm = $("#actionForm");
	var searchForm = $("#searchForm");
	
    checkModal(result);

    function checkModal(result) {
        if (result === '') {
        	console.log("fail...remove....")
            return;
        }
        if (result === 'success') {
            console.log(result);
            $(".modal-body").html("게시글이 삭제되었습니다.");
        }

        $("#myModal").modal("show");
    }
	
	$("#regBtn").on("click", function(e) {
		e.preventDefault();
        actionForm.attr("action", "/board/register").attr("method","get");
		actionForm.submit();
	}); //regBtn()
	
	
	$(".page-item a").on("click",function(e){
		e.preventDefault();
		console.log("this : " +this);
		//name이 page인 input태그를 찾아서 값을 내가 클릭하는 값으로 바꾼다.
		//.attr("href")는 링크를 추가하는 것 같은데 자세히는 모르겠다.
		actionForm.find("input[name='page']").val($(this).attr("href"));
		
		actionForm.submit();
	}); //paging
	
	$(".move").on("click", function(e) {
		e.preventDefault();
		actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
		actionForm.attr("action","/board/get");
		actionForm.submit();
	}); //move
	
	$("#searchForm button").on("click", function(e) {
		if(!searchForm.find("input[name='keyword']").val()){
			alert("검색어를 입력하세요");
			return false;
		}
		
		searchForm.find("input[name='page']").val("1");
		e.preventDefault();
		
		searchForm.submit();
	}); //searchForm                                                                                                          
	
});//doc
</script>

<%@include file="../includes/footer.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>
	
<h1 class="h3 mb-2">게시물 조회</h1>

<div class="form-group">
	<label for="exampleFormControlInput1">게시물 번호</label> 
	<input type="text"
		class="form-control" name="bno" value="${get.bno}" readonly>
</div>

<div class="form-group">
	<label for="exampleFormControlInput1">제목</label> <input type="text"
		class="form-control" name="title" value="${get.title}" readonly>
</div>

<div class="form-group">
	<label for="exampleFormControlTextarea1">내용</label>
	<textarea class="form-control" rows="10" name="content" readonly>${get.content}</textarea>
</div>

<div class="form-group">
	<label for="exampleFormControlInput1">작성자</label> <input type="text"
		class="form-control" name="writer" value="${get.writer}" readonly>
</div>

<!-- File upload -->
<div class="bigPictureWrapper">
	<div class="bigPicture">
	</div>	
</div>

<!--FileUpload-->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">파일</div>
			<!--panel heading-->
			<div class="panel-body">
					<div class="uploadResult">
						<ul>

						</ul>
					</div>
			</div>
			<!--end panel body-->
		</div>
		<!--End panel-->
	</div>
</div>
<!--end row-->

	<!-- 게시물 버튼 -->
	<button type="submit" class="btn btn-secondary boardBtn" data-oper='list'>목록</button>
	<!-- set security -->
		<sec:authorize access="isAuthenticated()">
			<c:if test="${pinfo.username eq get.writer}">
				<button type="submit" class="btn btn-secondary boardBtn" data-oper='modify'>수정</button>
				<button type="submit" class="btn btn-secondary boardBtn" data-oper='remove'>삭제</button>
			</c:if>
		</sec:authorize>

<!-- Comment -->
<sec:authorize access="isAuthenticated()"><!-- 로그인한 사용자만 댓글 폼을 사용할 수 있다. -->
	<form id="addReply" action="/replies/new" method="POST">
	<div class="" style="margin-top: 15px;">
		<div class="form-group">
			<input type="text" class="form-control" name="reply"
				placeholder="댓글을 입력하세요.">
		</div>
		<div class="form-group">
			<label for="exampleFormControlInput1">댓글 작성자</label>
			<input type="text" class="form-control" name="replyer" 
			value='<sec:authentication property="principal.username"/>' readonly>
		</div>
		
		
		<button id="addReplyBtn" type="submit" class="btn btn-secondary">입력</button>
	</div>
	</form>
</sec:authorize>
<!--Reply-->
<div class="" style="margin-top: 15px;">
	<div class="col-lg-12">
		<!--/.pannel -->
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw"></i>Reply
			</div>
			<!--/.panel heading-->
			<div class="panel-body">
				<ul class="chat">
					<!-- Start reply -->
						<div>
							<div class="header">
							</div>
						</div>
					</li>
				</ul>
				<!--end Reply-->
				<!--end ul-->
			</div>
			<!-- /.panel .chat panel-->
			<div class="panel-footer"></div>
		</div>
	</div>
	<!--./end row -->
</div>
<!-- End Comment -->

<form id="form">
	<!-- Security -->
	<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" >
<input type="hidden" name='bno' value='<c:out value="${get.bno}"/>'>
<input type="hidden" name='page' value='<c:out value="${cri.page }"/>'>
<input type="hidden" name='amount' value='<c:out value="${cri.amount}"/>'>
<input type="hidden" name='type' value='<c:out value="${cri.type}"/>'>
<input type="hidden" name='keyword' value='<c:out value="${cri.keyword}"/>'>
</form>

<!-- Reply Modal -->
<!-- Modal -->
<div class="modal fade" id="replyModal" tabindex="-1" role="dialog">
	<div class="modal-dialog" role="document">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title">Reply</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label>댓글</label>
					<input class="form-control" name='reply' value=''>
				</div>
				<div class="form-group">
					<label>작성자</label>
					<input class="form-control" name='replyer' value=''>
				</div>
				<div class="form-group">
					<label>날짜</label>
					<input class="form-control" name='replyDate' value=''>
				</div>
			</div>
			<div class="modal-footer">
				<button id="modalModBtn" type="submit" class="btn btn-warning">수정</button>
				<button id="modalRemoveBtn" type="submit" class="btn btn-danger">삭제</button>
				<button id="modalCloseBtn" type="submit" class="btn btn-primary" data-dismiss="modal">취소</button>
			</div>
		</div>
	</div>
</div>

<script src="/resources/js/reply.js"></script>

<!-- 화면에서 첨부파일 조회하는 부분 스크립트 처리 -->
<script>
	$(document).ready(function(){
		(function(){ // 첨부파일을 조회하는 즉시실행함수
			var bno = '<c:out value="${get.bno}"/>';
			$.getJSON("/board/getAttachList", {bno:bno}, function(arr) {
				console.log(arr);

				var str = "";

				$(arr).each(function(i, attach){
					//image type
					console.log("i : " + i );
					console.log("attach.filetype : " + attach.filetype); //fileType은 undifinded, filetype은 false
					if(attach.filetype) {
						console.log("-----------이미지 --------------");
						var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);

						str += "<li data-path='"+attach.uploadPath+"'";
						str += "data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"'data-type='"+attach.filetype+"'>";
						str += "<div>";
						str+="<img src='/display?fileName="+fileCallPath+"'>";
						str+="</div>";
						str+="</li>";
					} else {
						console.log("no 이미지 --------------");
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

			}); //end getJson
		})(); //end function
		
		//첨부파일 클릭 시 이벤트 처리
		$(".uploadResult").on("click", "li", function(e) {
			console.log("view image");

			var liObj = $(this);

			var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));

			console.log("liObj.data(type)? : " + liObj.data("type"));

			if(liObj.data("type")) { //이미지 일 때
				showImage(path.replace(new RegExp(/\\/g),"/"));
			} else { //이미지가 아닐 때
				//download
				self.location = "/download?fileName="+path;
			}
		});

		//원본 이미지창 닫기
		$(".bigPictureWrapper").on("click", function(e){
			$(".bigPicture").animate({width:'0%', height:'0%'}, 500);
			setTimeout(function() {
				$(".bigPictureWrapper").hide()
			}, 500); //setTimeout
			});//$(".bigPictureWrapper")

		function showImage(fileCallPath) {
			// alert(fileCallPath);
			$(".bigPictureWrapper").css("display","flex").show();
			$(".bigPicture")
			.html("<img src='/display?fileName="+fileCallPath+"'>")
			.animate({width:'100%',height:'100%'}, 1000);
		}

	}); //doc 
</script>
<sec:authorize access=""></sec:authorize>

<!-- 댓글처리  -->
<script>
$(document).ready(function() {
	var bnoValue = '<c:out value="${get.bno}"/>';
	var replyUL = $(".chat");
	var modal = $("#replyModal");
	var modalInputReply = modal.find("input[name='reply']");
	var modalInputReplyer = modal.find("input[name='replyer']");
	var modalInputReplyDate = modal.find("input[name='replyDate']");
	
	var modalModBtn = $("#modalModBtn")
	var modalRemoveBtn = $("#modalRemoveBtn");
	
	var pageNum = 1;
	var replyPageFooter = $(".panel-footer");
	
	/*Security*/
	var replyer = null;
	
	<sec:authorize access="isAuthenticated()">

	replyer = '<sec:authentication property="principal.username"/>';
	
	</sec:authorize>
	
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";

	showList(pageNum);

	//Ajax spring security header
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	
	function showList(page) {
		console.log(page);
		
		replyUL.html("");
		
		replyService.getList({bno:bnoValue,page:page||1}, function(replyCnt,list) {

			//댓글 페이징처리 부분
			console.log("replyCnt : " +replyCnt);
			console.log("list : " + list);

			if(page == -1) {
				pageNum = Math.ceil(replyCnt/10.0);
				showList(pageNum);
				console.log("pageNum = " + pageNum);
				return;
			}

			var str="";
			if(list == null || list.length==0) {
				return;
			}

			for(var i=0, len=list.length||0;i<len;i++) {
				str+='<li class="left clearfix" data-rno="'+list[i].rno+'">';
				str+='<div><div class="header"><strong class="primary-font">'
					+list[i].replyer+'</strong>';
				str+='<small class="pull-right text-muted">'+replyService.displayTime(list[i].replyDate)+'</small></div>';
				str+='<p>'+list[i].reply+'</p></div></li>';
			}

			replyUL.html(str);
			showReplyPage(replyCnt);
			
		}); // end function
	} // end showList()
	
	
	$("#addReplyBtn").on("click", function(e) {
		e.preventDefault();
		var reply = $("input[name='reply']").clone();
		var replyer = $("input[name='replyer']").clone();
		
		var data = {
				bno : bnoValue,
				reply:reply.val(),
				replyer:replyer.val()
		};
		
		$("input[name='reply']").val("");
		//$("input[name='replyer']").val("");
		replyService.add(data, function(reply){
			console.log("reply : " + reply);
			showList(1);
			
		});
		
	});
	
	
	$(".chat").on("click", "li", function(e) {
		var rno = $(this).data("rno");
		console.log(rno);
		
		replyService.get(rno, function(reply){
			modalInputReply.val(reply.reply);
			modalInputReplyer.val(reply.replyer).attr("readonly", "readonly");
			modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly" ,"readonly");
			modal.data("rno", reply.rno);
			
			modal.find("button[id != 'modalCloseBtn']").hide();
			modalModBtn.show();
			modalRemoveBtn.show();
			
			$("#replyModal").modal("show");
		});
	}); //chat
	
	modalModBtn.on("click", function(e) {
		var originalReplyer = modalInputReplyer.val();
		var reply = {
				rno:modal.data("rno"),
				reply:modalInputReply.val(),
				replyer:originalReplyer
		};
		
		console.log("Original Replyer : " + originalReplyer);
		
		if(!replyer) { //작성자가 아니면 삭제할 수 없다.
			alert("로그인 후 다시 시도하세요.");
			modal.modal("hide");
			return;
		}

		if(replyer != originalReplyer) {
			alert("자신이 작성한 댓글만 삭제가 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		replyService.update(reply, function(result) {
			console.log("update pageNum : " + pageNum);
			alert("수정되었습니다.");
			modal.modal("hide");
			showList(pageNum);
		});
	});//Modify()
	
	modalRemoveBtn.on("click", function(e) {
		var rno = modal.data("rno");
		var originalReplyer = modalInputReplyer.val();
		
		console.log("Original Replyer : " + originalReplyer);
	
		if(!replyer) { //작성자가 아니면 삭제할 수 없다.
			alert("로그인 후 다시 시도하세요.");
			modal.modal("hide");
			return;
		}

		if(replyer != originalReplyer) {
			alert("자신이 작성한 댓글만 삭제가 가능합니다.");
			modal.modal("hide");
			return;
		}
		
		replyService.remove(rno, originalReplyer, function(result) {
			alert("삭제 되었습니다.");
			modal.modal("hide");
			showList(pageNum);
		});
	});

	function showReplyPage(replyCnt) {
		console.log("showReplyPage replyCnt : " + replyCnt);
		var endNum = Math.ceil(pageNum/10.0)*10;
		var startNum = endNum - 9;

		var prev = startNum != 1;
		var next = false;

		if(endNum * 10 >= replyCnt) {
			endNum = Math.ceil(replyCnt/10.0);
		}

		if(endNum*10 < replyCnt) {
			next = true;
		}

		var str = "<ul class='pagination'>";

		if(prev) {
			str += '<li class="page-item"><a class="page-link" href="'+(startNum-1)+'">Previous</a></li>'
		}

		for(var i=startNum; i<=endNum;i++) {
			var active = pageNum == i ? "active":"";
			str += '<li class="page-item'+active+'"><a class="page-link" href="'+i+'">'+i+'</a></li>';
		}

		if(next) {
			str+='<li class="page-item"><a class="page-link" href="'+(endNum+1)+'">Next</a></li>'
		}

		str +="</ul></div>"
		
		//console.log("str : " + str);
		
		console.log(replyPageFooter.val());
		
		replyPageFooter.html(str);
	}
	
	replyPageFooter.on("click", "li a", function(e) {
		e.preventDefault();
		
		var targetPageNum = $(this).attr("href");
		console.log("targetPageNum : " + targetPageNum);
		pageNum = targetPageNum;
		console.log("pageNum : " + pageNum);
		showList(pageNum);
	}); //replyPageFooter()
	
}); //doc()	

</script>

<!-- 화면 CRUD 처리 -->
<script>
	$(document).ready(function(){
	
		var formObj = $("form");
		console.log("formObj : " + formObj);
		
		$('.boardBtn').on("click", function(e) {
			e.preventDefault();
			var oper = $(this).data("oper");
			console.log("oper : " + oper);
	
			if(oper==='remove') {
				if(confirm("정말 삭제하시겠습니까?")) {
					formObj.attr("action", "/board/remove").attr("method","post");
				}
			} else if(oper === 'modify') {
				console.log("modifyBtn");
				formObj.attr("action", "/board/modify");
				
			} else if(oper ==='list') {
				console.log("listBtn");
				formObj.attr("action","/board/list");
			} 
			formObj.submit();
		});
		
		
	})	
</script>

<%@include file="../includes/footer.jsp"%>

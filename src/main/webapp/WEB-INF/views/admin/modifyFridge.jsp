<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="../includes/header.jsp"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<h1 class="h3 mb-2">${username}의 냉장고</h1>
<br>
<br>
<form id="form" method="post">

<table class="table table-bordered">
  <thead class="thead-dark">
  <!-- addBtn 속성 id로 변경 -->
    <tr>
      <th scope="col">선택 <button id="addBtn" >+</button></th>
      <th scope="col">보유재료</th>
      <th scope="col">분류</th>
      <th scope="col">구매일</th>
      <th scope="col">수정일</th>
      <th scope="col">유효기간</th>
    </tr>
  </thead>
  <tbody id="fridgeTable">
  
  <!-- 냉장고 테이블의 데이터들. -->
  <c:forEach items="${ userInfo }" var="User" varStatus="i">
    <tr>
      <td>
      	<input class="checkbox" type="checkbox" value='<c:out value="${User.fno }"/>'>
      </td>
      <!-- 식재료 태그부분 id, class속성 추가 -->
      <td>
		  <input type="hidden" id="fno" name='vos[${i.index }].fno' value='<c:out value="${User.fno }"/>'> 
	      <input id="ingr_name" class="ingrModiBtn" type="text" name='vos[${i.index }].ingr_name'
	      				 value='<c:out value="${User.ingr_name }"/>'  readonly="readonly">
		  <input type="hidden" name='vos[${i.index }].username' value="${username }">
	  </td>
      <td>
       	  <input id="cno" class="ingrModiBtn" type="text" name='vos[${i.index}].cno' value='<c:out value="${User.cno }"/>'>
      </td>
      <td><fmt:formatDate pattern="yyyy-MM-dd" value="${User.regdate}" /> </td>
      <td><fmt:formatDate pattern="yyyy-MM-dd" value="${User.updatedate}" /></td>  
      <td><fmt:formatDate pattern="yyyy-MM-dd" value="${User.expirationdate}" /></td>  
    </tr>
  </c:forEach>
  
  </tbody>
</table>
<!-- 수정버튼 삭제, 취소버튼을 저장버튼으로 변경 -->
<!-- <button id="modBtn" class="btn btn-primary fridgeBtn" data-oper='modBtn'>수정</button> -->
<button id="cancelBtn"class="btn btn-primary fridgeBtn" data-oper='listBtn'>저장</button>
<button id="removeBtn" class="btn btn-primary fridgeBtn" data-oper='removeBtn'>전체삭제</button>
<button id="selectRemoveBtn" class="btn btn-primary fridgeBtn" data-oper='selectRemoveBtn'>선택삭제</button>


<input type="hidden" name="page" value='<c:out value="${cri.page }"/>'>
<input type="hidden" name="amount" value='<c:out value="${cri.amount}"/>'>
<input type="hidden" name="keyword" value='<c:out value="${cri.keyword}"/>'>
<input type="hidden" name="type" value='<c:out value="${cri.type}"/>'>
<!-- Security -->
<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />

</form>
<input type="hidden" name="id" value="${username }">

<!-- 수정,  -->
<!-- 추가 모달창 처리방법 -->
<div id="addModal" class="modal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">재료 추가</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
   			<div class="modal-body">
				<div class="form-group">
					<label>재료이름</label>
					<input class="modalIngrName" type="text" name='ingr_name' placeholder="식재료를 입력하세요.">
				</div>
				<div class="form-group">
					<label>분류</label>
					<select class="selectCategory" name="cno" >
					</select>
				</div>
			</div>
      	<div class="modal-footer">
        	<button id="modalAddBtn" class="btn btn-primary" type="submit" >추가하기</button>
        	<button id="modalCancelBtn" class="btn btn-primary" type="submit" data-dismiss="modal">취소</button>
      	</div>
    </div>
  </div>
</div>
<!-- 추가 -->
 <!-- 수정 모달창 처리방법 -->
<div id="modModal" class="modal" tabindex="-1" role="dialog">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">재료 수정</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
   			<div class="modal-body" class="border border-info">
				<div class="form-group">
					<label>번호</label>
					<input class="modalFno" type="text" name='fno'  readonly="readonly">
				</div>
				<div class="form-group">
					<label>재료이름</label>
					<input class="modalIngrName" type="text" name='ingr_name' >
				</div>
				<div class="form-group">
					<label>분류</label>
					<select class="selectCategory" name="cno" >
					</select>
				</div>
			</div>
      <div class="modal-footer">
        <button id="modalModiBtn" class="btn btn-primary" type="submit" >수정하기</button>
        <button id="modalCancelBtn" class="btn btn-primary" type="submit" data-dismiss="modal">취소</button>
      </div>
    </div>
  </div>
</div> 

<!-- 냉장고의 삭제 및 추가에 대한 모듈화 -->
<script type="text/javascript" src="/resources/js/fridge.js"></script>

<script type="text/javascript">
/* 전체 변경 */
$(document).ready(function() {
	
	var modModal = $("#modModal") // 수정하는 모달창.
	var modal = $(".modal"); // 모달창 참조.
	var modalAddBtn = $("#modalAddBtn"); // 모달창에서 추가버튼.
	var modalModiBtn = $("#modalModiBtn"); // 모달창에서 수정버튼.
	var modalIngrName = $(".modal").find("input[name='ingr_name']"); // 모달창에서 식재료 이름찾기.
	var modalCno = $(".modal").find("select[name='cno']"); // 모달창에서 분류 찾기.
	var modalExpirationdate = $(".modal").find("input[name='expirationdate']"); // 모달창에서 유효기간부분.
	var modalFno = $(".modalFno").find("input[name='fno']");  // 수정 모달창에서의 fno값
	var categoryList = $(".selectCategory");	// 모달창에서 카테고리 목록을 뽑아주기위한 참조
	var fridgeAddBtn = $("#addBtn");			// 냉장고 추가를 위한 추가버튼 참조
	var selectRemoveBtn = $("#selectRemoveBtn")
	var ingrModiBtn = $(".ingrModiBtn"); // 보유재료나 분류를 누르면 수정창으로 가는 버튼.
	var name = '<c:out value="${username}"/>';  // 해당 사용자의 이름을 가져온다.
	var tr = ""; // 수정할때 클릭한 테이블의 tr을 참조하기 위한 변수 , 전역번수로 설정한다.
	
	/*Ajax Security*/
	var csrfHeaderName = "${_csrf.headerName}";
	var csrfTokenValue = "${_csrf.token}";
	
	//Ajax spring security header
	$(document).ajaxSend(function(e, xhr, options) {
		xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
	});
	
	console.log('======CSRF=======');
	console.log(csrfHeaderName);
	console.log(csrfTokenValue);
	
	
	/*End Security*/
	
	
	console.log(fridgeService); // 모듈화된 기능을 보여준다.
	
	// 냉장고 목록을 확인 할때 보유재료가 없으면 삭제버튼을 가린다.
	if($('#fridgeTable tr').length === 0 ) {
		console.log("no value");
		// $("#modBtn").hide();
		$("#removeBtn").hide();
		$("#selectRemoveBtn").hide();
	}
	
	//냉장고 수정 버튼 클릭 (모달창을 띄운다.)
	ingrModiBtn.on("click", function(e) {
		e.preventDefault();
		console.log("수정 클릭");
	 	tr = $(this).closest("tr"); // 해당재료의 열 데이터를 가져온다.
		// fno값을 가져온다.
		var fno = tr.find("input[id='fno']").val(); // 그 열에서 id가 fno인 값의 value값을 가져온다.
		var ingrname = tr.find("input[id='ingr_name']").val(); 
		var cno = tr.find("input[id='cno']").val();
		console.log(tr);
		console.log("fno :" + fno);
		console.log("ingrname : "+ingrname);
		console.log(cno);
		
		$(".modalFno").val(fno);			//선택했던 재료의 번호값을 모달창에 전달한다.
		$(".modalIngrName").val(ingrname);  //선택했던 재료의 이름을 모달창에 전달한다.
		$(".modalCno").val(cno);			//선택했던 재료의 분류값을 모달창에 전달한다.
		
		// {} 를 넣었더니 나왔다? 왜?...
		// 냉장고의 목록을 분류하기위한 카테고리 목록을 가져온다. (비동기)		
		fridgeService.getList({}, function(list){
			var str = ""; //태그생성에 필요한 문자열을 저장할 변수
		 	$(list).each(function(i, category){ // 배열로 처리,
		 		str +="<option value="+category.cno+">"+category.cno+". "+category.ingr_category+"</option>"
		 	})
		 	categoryList.append(str);
			$("#modModal").modal("show"); // 식재료 수정을 위한 모달창을 보여준다.
		});
	})
	
	// 수정하는 모달창에서 수정버튼을 눌렀을 때.
	modalModiBtn.on("click", function(e) {
		// ajax에서 data의 파라미터로 들어갈 데이터의 집합체.
		// 들어가면 JSON형태의 데이터로 바꿔서 판단하고 CONTROLLER에서 @RequestBody로 인해 VO객체로 변환.
		var fridge = {
			fno : modModal.find("input[name='fno']").val(),
			ingr_name : modModal.find("input[name='ingr_name']").val(),
			cno : modModal.find("select[name='cno']").val()
		};
		console.log("modidy btn click");
		console.log(fridge);
		// 데이터를 가지고 수정하기.  
		fridgeService.modify(fridge, function(result) {
			console.log(result);
		})  
		
		$("#modModal").modal("hide"); // 모달창 숨기기.
		// tr을 찾아서 그 값에다가 위에서 가져온 val를 추가.
		console.log(tr);
		// DB에 추가한 VALUE값들을 테이블의 값로 바꿔넣는다.
		tr.find("input[id='fno']").val(fridge.fno);  		
		tr.find("input[id='ingr_name']").val(fridge.ingr_name); 
		tr.find("input[id='cno']").val(fridge.cno);
	})
	
	//냉장고추가 버튼 클릭 (모달창을 띄운다.)
	fridgeAddBtn.on("click", function(e) {
		e.preventDefault();
		console.log("추가 클릭");
		// {} 를 넣었더니 나왔다? 왜?...
		// 냉장고의 목록을 분류하기위한 카테고리 목록을 가져온다. (비동기)		
		fridgeService.getList({}, function(list) {
			var str = ""; //태그생성에 필요한 문자열을 저장할 변수
			//  ajax를 사용해서 얻어온 목록을 list로 받는다.
			// 전체 데이터가 있는 list를 전체길이만큼 category변수에 넣어서 
			// category변수를 이용하여 생성할 태그의 값을 추가한다.
		 	$(list).each(function(i, category){ // 배열로 처리,
		 		//<option> 태그를 생성해주며 카테고리목록을 보여준다.
		 		console.log(category.cno);
		 		console.log(category.ingr_category);
		 		console.log("expirationdate : "+category.expirationdate);
		 		str +="<option value="+category.cno+">"+category.cno+". "+category.ingr_category+"</option>"
		 	})
		 	categoryList.append(str);
			$("#addModal").modal("show"); // 식재료 추가를 위한 모달창을 보여준다.
		});
	})
	
	// 추가하는 모달창에서 추가버튼을 누를경우 ajax를 이용해서 해당 페이지의 테이블에
	// 모달창에서 전송시킨 input태그의 value값들을 전송하고 
	// 테이블에 태그를 생성할때 각 값으로 추가함.
	modalAddBtn.on("click", function(e) {
		e.preventDefault();
		console.log(name);
		var str =""; // table의 하위태그로 들어갈 문자열
		console.log(name + ", "+modalIngrName.val()+ ", "+modalCno.val());
		
		// 테이블의 tr태그의 갯수를 의미한다.
		var idx = $("#fridgeTable tr").length ;
		
		// 추가할때 추가한 정보에 대한 새로운 태그를 만들어서 바로 쏴준다.
		str += "<tr>"
		str += "<td>"
		str += "<input class='checkbox' type='checkbox'>"
		str += "</td>";
		str += "<td>"
		str += "<input type='text' name='vos["+idx+"].ingr_name' value='"+modalIngrName.val()+"' readonly='readonly'> ";
		str += "</td>"
		str += "<td>";
		str += "<input type='text' name='vos["+idx+"].cno' value='"+modalCno.val()+"' readonly='readonly'> ";
		str += "<input type='hidden' name='vos["+idx+"].username' value='"+name+"'> ";
		str += "</td>"
		str += "<td></td>";
		str += "<td></td>";
		str += "<td></td>";
		str += "</tr>"; 
		console.log("str : "+str);
		
		// 수정할때 추가한 데이터가 있으면 add메서드를 부르고
		// 추가하지 않거나 있는 재료를 삭제하여 정보를 변경할 경우에는 add메서드를 호출하지않는다.
		if(modalIngrName.val()!==null && modalIngrName.val().length>0) {
			console.log("식재료 추가.")
			// Ajax를 통한 DB추가 작업
			fridgeService.add( 
				{username : name, ingr_name : modalIngrName.val() , cno : modalCno.val() },
				// 결과를 보여준다. result에는 success 또는 fail시 매개변수로 받은 값이 들어갈것임.
					function(result) {
					console.log("result ="+ result);
					// 테이블에 태그를 생성한다.
					$("#fridgeTable").append(str); // 테이블의 하위태그에 추가한 식재료를 형식에 맞게 추가.
				}
			); // end add
		} else {
			console.log("식재료 추가 안함.");
		}
		modalIngrName.val("");
		// 모달창을 숨긴다.
		$("#addModal").modal("hide");
		
		if($('#fridgeTable tr').length > 0 ) { // 사용자가 가진 식재료가 하나라도 있으면 창을 노출
			console.log("is value");
			$("#removeBtn").show();
			$("#selectRemoveBtn").show();
		} //if
		
	}); //end modalAddBtn
	
	$("input[type='checkbox']").on("click", function(e) {

		console.log("checkbox click");	
	});
	
	//선택삭제 버튼 클릭시.
	selectRemoveBtn.on("click", function(e) {
		// 콘솔에 체크된 태그가 나타난다.
		console.log("checkbox click");
		// 체크된 태그를 배열로 가져온다.
		// 하나하나 삭제하고 tr을 숨긴다.
		$("input[type='checkbox']:checked").each(function() {
			var fno = $(this).val();
			console.log("fno : " +fno);
			// 선택삭제를 위해 태그를 숨긴다.
			// 이후 완료 버튼을 누르면 DB에서 삭제작업을 진행한다.
			fridgeService.remove(fno, function(data) {
			console.log(data);
			});
			$(this).closest("tr").hide();
		});
	});
	
	var form = $("#form"); // CRUD를 위한 FORM 참조

	$('.fridgeBtn').on("click", function(e) {
		e.preventDefault();

		var oper = $(this).data("oper");
		
		if(oper==='listBtn') { //목록으로 갈 경우.(수정)
			//완료
			var username = $("input[name='id']").clone();
			var page = $("input[name='page']").clone();
			var amount = $("input[name='amount']").clone();
			var keyword = $("input[name='keyword']").clone();
			var type = $("input[name='type']").clone();
			
			form.empty(); //form태그 한 번 비우고.
			form.attr("action","/admin/get").attr("method", "get");
			form.append(username);
			form.append(page);
			form.append(amount);
			form.append(keyword);
			form.append(type);
			form.submit();
		} else if(oper === 'removeBtn') { // 전체삭제버튼
			if(confirm("정말 지우겠습니까?")) {
				//완료
				var username = $("input[name='id']").clone();
				
				form.empty();
				form.append(username);
				form.attr("action", "/admin/removeFridge");
				form.submit();
			}
		} 
	}); //class="fridgeBtn"
}); //doc
</script>
<%@include file="../includes/footer.jsp"%>
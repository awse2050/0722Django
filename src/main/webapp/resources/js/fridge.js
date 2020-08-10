
console.log("fridge module.....");

// fridgeService 변수 안에 여러가지 메서드가 들어가게 된다(function)
// 호출시 fridgeService.add( ~~ ) 	를 사용한다.
var fridgeService = (function() {
	
	// 식재료를 추가할 때 사용한다. 
	// 모달창에서 "추가"버튼을 클릭하게 되면 이 함수를 실행하게 바꿔야 한다.
	function add(fridge, callback, error) {
		console.log("fridge....");
		
		$.ajax({
			
			type : 'post',		// method방식을 지정
			url : '/admin/new', // 호출할 URI를 지정.
			data : JSON.stringify(fridge), //JS객체를 JSON으로 바꿔주는 역할을 한다.  반대메서드 => JSON.parse()
			contentType : "application/json; charset=utf-8", // 내가 보내는 데이터 타입을 알려주는 곳.
			success : function(result, status, xhr) {
				
				if(callback) {
					callback(result);
				}
			},
			error : function(xhr, status, er) {
				if (error) {
					error(er);
				}
			}
		})
	} // end function add
	
	function getList(param, callback, error) {
		 // 각 값의 변수를 가져와서 설정한다.
		var cno = param.cno;
		var ingr_name = param.ingr_name;
		
		// Get방식으로 JSON형태의 값을 받아올 때 쓴다
		$.getJSON("/admin/All.json", 
			function(data){
				if(callback) {
					callback(data);
				}
			}).fail(function(xhr,status,err) {
				if(error) {
				error();
				}
			});		
	}
	// 한 사용자의 냉장고데이터를 얻어온다.
	function get(username, callback, error) {
		$.get("/admin/"+username+".json", function(result) {
			
			if(callback) {
				callback(result);
			}
		}).fail(function(xhr,status, err) {
			if(error) {
				error();
			}
		})
	} // end get
	
	function remove(fno, callback, error) {
		$.ajax({
			type : 'delete',
			url : '/admin/'+fno,
			success : function(deleteResult, status, xhr) {
	            if(callback) {
	                callback(deleteResult);
	            }
	        },
	        error : function(xhr, status, er) {
	             if(error) {
	                error(er);
	             }
	        }	
		})
	}	
	function modify(fridge, callback, error) {
	
		console.log("modify=========================")
        console.log("fno : " + fridge.fno);

        $.ajax({
            type:'put',
            url:'/admin/' + fridge.fno,
            data:JSON.stringify(fridge),
            contentType:"application/json; charset=utf-8",
         
            success:function(result, status, xhr) {
                if(callback) {
                    callback(result);
                }
            },
            error:function(xhr, status, er) {
                if(error) {
                    error(er);
                }
            }
        });
    } //update()
	// 리턴할때 function을 리턴한다.
	return { add 	: add,
			 getList: getList,
			 get	: get,
			 remove : remove,
			 modify : modify
			 };
	// 즉시 실행 함수를 사용한다.
})();
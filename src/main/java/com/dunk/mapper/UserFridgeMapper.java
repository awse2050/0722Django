package com.dunk.mapper;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.Date;
import java.util.List;

import com.dunk.domain.UserFridgeVO;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;


// 냉장고 관련 매퍼
public interface UserFridgeMapper {
	
	// 냉장고에 있는 전체 목록 ==> 쓰지않는 기능이므로 삭제해도 무방하다.
	List<UserFridgeVO> getList(String username);
	// 한 유저가 가진 냉장고목록을보여줌.
	List<UserFridgeVO> get(String username);
	// 냉장고에 식재료 추가
	int insert(UserFridgeVO vo);
	// 냉장고 식재로 수정.
	int update(UserFridgeVO vo);
	// 특정 유저의 냉장고 삭제.
	int delete(String username);
	// ajax통신으로 사용하는 메서드
	// 선택삭제시 사용.
	// + 자동삭제를 할때 사용할 메서드.
	int fridgeDelete(long fno);
	
	// 오늘날짜와 일치하는 식재료의 fno의 목록을 찾기 위한 기능.
	List<UserFridgeVO> toDeleteList();
	// 유저가 가진 냉장고 목록에서 식재료를 골라서 태그와 비교해서 태그에 그 식재료가 있으면
	// 그 식재료가 태그로 등록되어있는 카테고리를 찾는다. 그 후 그 카테고리로 검색한다.
	String searchCategory(String ingr_name);
	// 검색할떄 이 결과의 값에서 result.getIngr_category
}
	


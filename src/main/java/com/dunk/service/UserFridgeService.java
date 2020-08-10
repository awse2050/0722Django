package com.dunk.service;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.dunk.domain.UserFridgeVO;
@Transactional
@Component // 크론사용.
public interface UserFridgeService {

	// 냉장고에 있는 목록
	List<UserFridgeVO> getList(String username);
	// 한 사용자의 냉장고 목록을 가져옴.
	List<UserFridgeVO> get(String username);

	int register(UserFridgeVO vo);
	
	int modify(UserFridgeVO vo);
	
	int remove(String username);

	int fridgeRemove(long fno);
	
	// 오늘날짜와 일치하는 식재료의 fno의 목록을 찾기 위한 기능.
	void toDeleteList();
	
	String searchCategory (String ingr_name);
	
	
}

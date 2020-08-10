package com.dunk.service;

import java.util.List;

import com.dunk.domain.Criteria;
import com.dunk.domain.DjangoMemberVO;


public interface DjangoMemberService {


	// 관리자가 사용자를 추가합니다.
	int registerUser(DjangoMemberVO vo);
	// 관리자 페이지에서 사용자의 목록을 출력합니다.
	List<DjangoMemberVO> getList(Criteria cri);
	// 관리자가 사용자를 삭제합니다.
	int remove(String id);
	// 관리자가 사용자 한명의 정보를 얻어옵니다.
	DjangoMemberVO get(String id);
	
	//-------------------검색 페이징
	int getTotal(Criteria cri);
}

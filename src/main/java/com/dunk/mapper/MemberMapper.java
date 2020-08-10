package com.dunk.mapper;

import com.dunk.domain.AuthVO;
import com.dunk.domain.MemberVO;

public interface MemberMapper {

	MemberVO read(String userid);

	int insert(MemberVO vo);
	
	int insertAuth(AuthVO auth);
	
	MemberVO checkId(String userid);
	
}

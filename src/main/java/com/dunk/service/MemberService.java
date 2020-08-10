package com.dunk.service;

import com.dunk.domain.MemberVO;

public interface MemberService {

	int register(MemberVO vo);
	
	MemberVO checkId(String userid);
	
}

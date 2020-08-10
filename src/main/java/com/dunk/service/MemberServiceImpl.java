package com.dunk.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dunk.domain.AuthVO;
import com.dunk.domain.MemberVO;
import com.dunk.mapper.MemberMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class MemberServiceImpl implements MemberService {

	@Autowired
	MemberMapper mapper;
	
	@Autowired
	PasswordEncoder pwEncoder;
	
	@Transactional
	@Override
	public int register(MemberVO vo) {
		String password = pwEncoder.encode(vo.getUserpw());
		vo.setUserpw(password);
		
		int result = mapper.insert(vo);
		
		log.info("=============================================================");
		log.info(result);

		if(result == 1) {
			mapper.insertAuth(new AuthVO(vo.getUserid(), "ROLE_USER"));
		}
		
		return result;
	}

	@Override
	public MemberVO checkId(String userid) {
		return mapper.checkId(userid);
	}

}

package com.dunk.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dunk.domain.Criteria;
import com.dunk.domain.DjangoMemberVO;
import com.dunk.mapper.DjangoMemberMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class DjangoMemberServiceImpl implements DjangoMemberService {

	@Autowired
	private DjangoMemberMapper mapper;
	
	@Override
	public int registerUser(DjangoMemberVO vo) {
		// TODO Auto-generated method stub
		log.info("register... : "+ vo );
		return mapper.insertUser(vo);
	}

	@Override
	public List<DjangoMemberVO> getList(Criteria cri) {
		// TODO Auto-generated method stub
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int remove(String id) {
		// TODO Auto-generated method stub
		log.info("delete ...  : "+id);
		return mapper.delete(id);
	}

	@Override
	public DjangoMemberVO get(String id) {
		// TODO Auto-generated method stub
		log.info("get id : "+id);
		return mapper.get(id);
	}

	@Override
	public int getTotal(Criteria cri) {
		// TODO Auto-generated method stub
		return mapper.getTotal(cri);
	}

}

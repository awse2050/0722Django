package com.dunk.service;

import java.util.List;

import com.dunk.domain.Criteria;
import com.dunk.domain.ReplyPageDTO;
import com.dunk.domain.ReplyVO;

public interface ReplyService {

	int register(ReplyVO vo);
	
	ReplyVO get(Long rno);
	
	int modify(ReplyVO vo);
	
	int remove(Long rno);
	
	List<ReplyVO> getList(Criteria cri, Long bno);
	
	ReplyPageDTO getListPage(Criteria cri, Long bno);
}

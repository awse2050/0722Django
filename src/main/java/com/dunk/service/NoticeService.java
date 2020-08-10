package com.dunk.service;

import java.util.List;

import com.dunk.domain.Criteria;
import com.dunk.domain.NoticeAttachVO;
import com.dunk.domain.NoticeVO;

public interface NoticeService {

	int register(NoticeVO vo);
	
	NoticeVO get(Long nno);
	
	List<NoticeVO> getList(Criteria cri);
	
	int modify(NoticeVO vo);
	
	int remove(Long nno);
	
	Long nextNno();
	
	int getTotal(Criteria cri);
	
	List<NoticeAttachVO> getAttachList(Long nno);
}

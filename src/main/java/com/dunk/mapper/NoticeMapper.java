package com.dunk.mapper;

import java.util.List;

import com.dunk.domain.Criteria;
import com.dunk.domain.NoticeVO;

public interface NoticeMapper {

	int insert(NoticeVO vo);
	
	NoticeVO read(Long nno);
	
	int update(NoticeVO vo);
	
	int delete(Long nno);
	
	Long nextNno();
	
	//Paging
	List<NoticeVO> getList(Criteria cri);
	
	int getTotal(Criteria cri);
}

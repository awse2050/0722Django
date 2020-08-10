package com.dunk.mapper;

import java.util.List;

import com.dunk.domain.NoticeAttachVO;

public interface NoticeAttachMapper {

	void insert(NoticeAttachVO vo);
	
	void delete(String uuid);
	
	List<NoticeAttachVO> findByNno(Long nno);
	
	void deleteAll(Long nno);
	
}

package com.dunk.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.dunk.domain.Criteria;
import com.dunk.domain.ReplyVO;

public interface ReplyMapper {
	
	int insert(ReplyVO vo);
	
	ReplyVO read(Long rno);
	
	int update(ReplyVO vo);
	
	int delete(Long rno);
	
	List<ReplyVO> getListWithPaging(
			@Param("cri")Criteria cri,
			@Param("bno")Long bno);
	
	int getCountByBno(Long bno);
}

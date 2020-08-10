package com.dunk.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.dunk.domain.BoardVO;
import com.dunk.domain.Criteria;

public interface BoardMapper {
	// C R U D
	int insert(BoardVO vo);
	BoardVO get(Long bno); //하나의 게시물
	int update(BoardVO vo);
	int delete(Long bno);
	Long nextBno();
	List<BoardVO> getList(Criteria cri);
	int getTotal(Criteria cri);
	//MyBatis는 2개 이상의 파라미터를 사용할 때 @Param을 붙인다.
	void updateReplyCnt(@Param("bno")Long bno, @Param("amount")int amount);
}

package com.dunk.service;

import java.util.List;

import com.dunk.domain.BoardAttachVO;
import com.dunk.domain.BoardVO;
import com.dunk.domain.Criteria;
import com.dunk.domain.ReplyPageDTO;

public interface BoardService {
	//서비스 계층은 비즈니스 용어를 사용한다.
	int register(BoardVO vo);
	
	List<BoardVO> getList(Criteria cri);
	
	BoardVO get(Long bno);
	
	int modify(BoardVO vo);
	
	int remove(Long bno);
	
	Long nextNum();
	
	int getTotal(Criteria cri);
	
	List<BoardAttachVO> getAttachList(Long bno);

}

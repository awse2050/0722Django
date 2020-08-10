package com.dunk.service;

import java.util.List;

import com.dunk.domain.CategoryAttachVO;
import com.dunk.domain.CategoryVO;
import com.dunk.domain.Criteria;

public interface CategoryService {

	CategoryVO get(Long cno);
	
	List<CategoryVO> getList();
	
	void register(CategoryVO vo);
	
	int modify(CategoryVO vo);
	
	int remove(Long cno);

	Long nextNum();
	
	int getTotal(Criteria cri);
	List<CategoryVO> getListWithPaging(Criteria cri);
	
	public List<CategoryAttachVO> getAttachList(Long cno);
	
}

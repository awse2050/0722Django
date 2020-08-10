package com.dunk.mapper;

import java.util.List;

import com.dunk.domain.CategoryVO;
import com.dunk.domain.Criteria;

public interface CategoryMapper {

	CategoryVO get(Long cno);
	
	List<CategoryVO> getList();
	
	int insert(CategoryVO vo);
	
	int update(CategoryVO vo);
	
	int delete(Long cno);
	
	Long nextCno();
	
	
	int getTotal(Criteria cri);
	List<CategoryVO> getListWithPaging(Criteria cri);
	
}

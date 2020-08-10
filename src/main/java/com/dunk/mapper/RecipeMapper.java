package com.dunk.mapper;

import java.util.List;

import com.dunk.domain.Criteria;
import com.dunk.domain.RecipeVO;

public interface RecipeMapper {
	
	
	public List<RecipeVO> getList();
	
	public List<RecipeVO> getListWithPaging(Criteria cri);
	
	public void insert(RecipeVO vo);
	
	public RecipeVO read(Long fno);
	
	public int delete(Long fno);
	
	public int update(RecipeVO vo);
	
	public int getTotalCount(Criteria cri);

}

package com.dunk.service;

import java.util.List;

import com.dunk.domain.Criteria;
import com.dunk.domain.RecipeAttachVO;
import com.dunk.domain.RecipeVO;

public interface RecipeService {
	
		public List<RecipeVO> getList(Criteria cri);
	
	    //insert
		public void register(RecipeVO vo);
		
		//read
		public RecipeVO get(Long recipe_no);
		
		//update
		public boolean modify(RecipeVO vo);
		
		//delete
		public boolean remove(Long recipe_no);
		
		public int getTotal(Criteria cri);
		
		public List<RecipeAttachVO> getAttachList(Long recipe_no);
	

}

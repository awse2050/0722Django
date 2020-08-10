package com.dunk.mapper;

import java.util.List;


import com.dunk.domain.RecipeAttachVO;

public interface RecipeAttachMapper {
	
	void insert(RecipeAttachVO attach);
	void delete(String uuid);
	List<RecipeAttachVO> findByRecipe_no(Long recipe_no);
	
	void deleteAll(Long recipe_no);
	
	List<RecipeAttachVO> getOldFiles();

}

package com.dunk.domain;

import java.util.List;

import lombok.Data;

@Data
public class RecipeVO {
	
	private Long recipe_no;
	private String recipe_name;
	private String ingr_list;
	
	private String recipe;
	private String img;
	
	private List<RecipeAttachVO> attachList;

	
}

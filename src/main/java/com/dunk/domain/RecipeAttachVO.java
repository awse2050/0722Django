package com.dunk.domain;

import lombok.Data;

@Data
public class RecipeAttachVO {
	
	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean filetype;
	
	private Long recipe_no;

}

package com.dunk.domain;

import lombok.Data;

@Data
public class CategoryAttachVO {

	private String fileName;
	private String uploadPath;
	private String uuid;
	private boolean filetype;
	
	private Long cno;
}

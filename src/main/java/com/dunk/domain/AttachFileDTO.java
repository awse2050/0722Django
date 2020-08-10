package com.dunk.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
	//파일업로드
	private String fileName;
	private String uploadPath;
	private String uuid;
	private boolean image;
	
	
}

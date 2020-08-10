package com.dunk.domain;

import java.util.List;

import lombok.Data;
import lombok.ToString;

@Data
//@Builder
@ToString
public class CategoryVO {

	private Long cno;
	private String ingr_category;
	private String tag;
	private Integer expirationdate;
	
	private List<CategoryAttachVO> attachList;
}

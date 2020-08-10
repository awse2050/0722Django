package com.dunk.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class NoticeVO {
	private Long nno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private Date moddate;
	
	private List<NoticeAttachVO> attachList;
}

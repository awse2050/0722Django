package com.dunk.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;
@Data
public class BoardVO {
	private Long bno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private Date moddate;
	private int replyCnt;
	private List<BoardAttachVO> attachList;
}

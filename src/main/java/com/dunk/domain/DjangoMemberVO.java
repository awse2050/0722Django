package com.dunk.domain;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
public class DjangoMemberVO {

	
	private Long mno;
	private String id, name, password, token;
	
}


package com.dunk.domain;

import java.util.Date;

import lombok.Builder;
import lombok.Data;
import lombok.ToString;

@Data
//@Builder
@ToString
public class UserFridgeVO {
// UserFridgeVO
	Long fno;
	String username;
	String ingr_name;
	Long cno;
	Date regdate;
	Date updatedate;
	Date expirationdate;
	
}

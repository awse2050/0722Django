package com.dunk.domain;

import java.util.ArrayList;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
public class UserFridgeList {
	private List<UserFridgeVO> vos;

	public UserFridgeList() {
		vos = new ArrayList<>();
	}
	
}

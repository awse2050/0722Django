package com.dunk.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Data;

@Data
public class Criteria {
	private Integer page;
	private Integer amount;

	private String type;
	private String keyword;

	public Criteria() {
		this(1, 10);
	}

	public Criteria(Integer page, Integer amount) {
		this.page = page;
		this.amount = amount;
	}

	public Integer getSkip() {
		return (page-1)*10;
	}

	public String[] getTypeArr() {
		return type == null || type.length() == 0 ? new String[] {} : type.split("");
	}

	public String getListLink() {
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("page", this.page)
				.queryParam("amount", this.amount)
				.queryParam("type", this.type)
				.queryParam("keyword", this.keyword);

		return builder.toUriString();
	}
}

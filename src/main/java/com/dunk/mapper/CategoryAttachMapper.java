package com.dunk.mapper;

import java.util.List;

import com.dunk.domain.CategoryAttachVO;

public interface CategoryAttachMapper {

	public void insert(CategoryAttachVO vo);
	
	public void delete(String uuid);
	
	public List<CategoryAttachVO> findByCno(Long cno);

	public void deleteAll(Long cno);
}

package com.dunk.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dunk.domain.Criteria;
import com.dunk.domain.RecipeAttachVO;
import com.dunk.domain.RecipeVO;
import com.dunk.mapper.RecipeAttachMapper;
import com.dunk.mapper.RecipeMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class RecipeServiceImpl implements RecipeService {

	@Setter(onMethod_=@Autowired)
	private RecipeMapper mapper;
	
	@Setter(onMethod_=@Autowired)
	private RecipeAttachMapper attachMapper;

	@Override
	public List<RecipeVO> getList(Criteria cri) {
		log.info("get List with criteria : " + cri);

		return mapper.getListWithPaging(cri);
	}

	@Transactional
	@Override
	public void register(RecipeVO vo) {

		log.info("register......."+vo);

		mapper.insert(vo);
		
		if(vo.getAttachList() ==null || vo.getAttachList().size() <=0) {
			return;
		}
		
		vo.getAttachList().forEach(attach -> {
			attach.setRecipe_no(vo.getRecipe_no());
			attachMapper.insert(attach);
		});

	}

	@Override
	public RecipeVO get(Long recipe_no) {

		log.info("get.............." + recipe_no);

		return mapper.read(recipe_no);
	}

	@Override
	public boolean modify(RecipeVO vo) {

		log.info("modify........"+vo);
		
		attachMapper.deleteAll(vo.getRecipe_no());
		
		boolean modifyResult = mapper.update(vo) ==1;
		
		if(modifyResult && vo.getAttachList() != null && vo.getAttachList().size() >0) {
			
			vo.getAttachList().forEach(attach -> {
				attach.setRecipe_no(vo.getRecipe_no());
				attachMapper.insert(attach);
			});
		}

		return modifyResult;
	}
	
	@Transactional
	@Override
	public boolean remove(Long recipe_no) {

		log.info("delete.........."+recipe_no);
		
		attachMapper.deleteAll(recipe_no);
		
		return mapper.delete(recipe_no)==1;

	}
	
	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}
	
	@Override
	public List<RecipeAttachVO> getAttachList(Long recipe_no){
		
		log.info("get Attach list by recipe_no"+recipe_no);
		
		
		return attachMapper.findByRecipe_no(recipe_no);
	}
}

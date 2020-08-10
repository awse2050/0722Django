package com.dunk.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dunk.domain.CategoryAttachVO;
import com.dunk.domain.CategoryVO;
import com.dunk.domain.Criteria;
import com.dunk.mapper.CategoryAttachMapper;
import com.dunk.mapper.CategoryMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class CategoryServiceImpl implements CategoryService {
//	@Autowired
//	private CategoryMapper mapper;

	@Setter(onMethod_ = @Autowired)
	private CategoryMapper mapper;

	@Setter(onMethod_ = @Autowired)
	private CategoryAttachMapper attachMapper;

	@Override
	public CategoryVO get(Long cno) {
		return mapper.get(cno);
	}

	@Override
	public List<CategoryVO> getList() {
		return mapper.getList();
	}

	@Transactional
	@Override
	public void register(CategoryVO vo) {
		log.info("register Category......" + vo);

		mapper.insert(vo);
		
		long cno = mapper.nextCno();
		
		log.info("last insert id : " +  cno);

		if (vo.getAttachList() == null || vo.getAttachList().size() <= 0) {
			return;
		}
		
		vo.getAttachList().forEach(attach -> {
			attach.setCno(cno);
			attachMapper.insert(attach);
		});
	}

	@Override
	public int modify(CategoryVO vo) {
		log.info("modify........"+vo);
		attachMapper.deleteAll(vo.getCno());
		int modifyResult = mapper.update(vo);
		
		if(modifyResult==1 && vo.getAttachList() !=null && vo.getAttachList().size() > 0) {
			vo.getAttachList().forEach(attach->{
				attach.setCno(vo.getCno());
				attachMapper.insert(attach);
			});
		}
		return modifyResult;
		//return mapper.update(vo);
	}

	@Transactional
	@Override
	public int remove(Long cno) {
		log.info("remove........."+cno);
		//log.info("deleteAll 위");
		attachMapper.deleteAll(cno);
		//log.info("deleteAll 아래");
		
		return mapper.delete(cno);
	}

	@Override
	public Long nextNum() {
		return mapper.nextCno();
	}

	@Override
	public int getTotal(Criteria cri) {
		// TODO Auto-generated method stub
		return mapper.getTotal(cri);
	}

	@Override
	public List<CategoryVO> getListWithPaging(Criteria cri) {
		// TODO Auto-generated method stub
		return mapper.getListWithPaging(cri);
	}

	
	 @Override 
	 public List<CategoryAttachVO> getAttachList(Long cno){
		 log.info("get Attach list by cno"+cno); 
		 log.info(attachMapper.findByCno(cno));
		 return attachMapper.findByCno(cno); 
		
	 }
	 

}

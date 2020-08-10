package com.dunk.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dunk.domain.UserFridgeVO;
import com.dunk.mapper.UserFridgeMapper;

import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class UserFridgeServiceImpl implements UserFridgeService {

	@Autowired
	private UserFridgeMapper mapper;
	@Override
	public List<UserFridgeVO> getList(String username) {
		// TODO Auto-generated method stub
		return mapper.getList(username);
	}

	@Override
	public List<UserFridgeVO> get(String username) {
		// TODO Auto-generated method stub
		return mapper.get(username);
	}

	@Override
	public int register(UserFridgeVO vo) {
		// TODO Auto-generated method stub
		return mapper.insert(vo);
	}

	@Override
	public int modify(UserFridgeVO vo) {
		// TODO Auto-generated method stub
		return mapper.update(vo);
	}

	@Override
	public int remove(String username) {
		return mapper.delete(username);
	}
	
	@Override
	public int fridgeRemove(long fno) {
		return mapper.fridgeDelete(fno);
	}
//  크론표현식 수정하기.
//	@Scheduled(cron = "0/10 * * 1/1 * ?")
	@Override
	public void toDeleteList() {
		mapper.toDeleteList().forEach( data -> {
			log.info("list : "+data);
			log.info(mapper.fridgeDelete(data.getFno()));
		});
	}
	
	@Override
	public String searchCategory (String ingr_name) {
		log.info("검색어 : "+ingr_name);
		return mapper.searchCategory(ingr_name);
		
	}

}

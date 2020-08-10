package com.dunk.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dunk.domain.Criteria;
import com.dunk.domain.NoticeAttachVO;
import com.dunk.domain.NoticeVO;
import com.dunk.mapper.NoticeAttachMapper;
import com.dunk.mapper.NoticeMapper;

@Service
@Transactional
public class NoticeServiceImpl implements NoticeService {

	@Autowired
	NoticeMapper mapper;
	
	@Autowired
	NoticeAttachMapper attachMapper;
	
	@Override
	public int register(NoticeVO vo) {
		int result = mapper.insert(vo);

		if(vo.getAttachList() == null || vo.getAttachList().size() <= 0) {
			return result;
		}

		vo.getAttachList().forEach(attach -> {
			attach.setNno(mapper.nextNno());
			attachMapper.insert(attach);
		});
		
		return result;
	}

	@Override
	public NoticeVO get(Long nno) {
		return mapper.read(nno);
	}

	@Override
	public List<NoticeVO> getList(Criteria cri) {
		return mapper.getList(cri);
	}

	@Transactional
	@Override
	public int modify(NoticeVO vo) {
		attachMapper.deleteAll(vo.getNno());

		int result = mapper.update(vo);
		
		if(result == 1 && vo.getAttachList()!=null 
				&& vo.getAttachList().size() > 0) {
			vo.getAttachList().forEach(attach -> {
				attach.setNno(vo.getNno());
				attachMapper.insert(attach);
			});
		}
		
		return result;
	}

	@Override
	public int remove(Long nno) {
		attachMapper.deleteAll(nno);
		return mapper.delete(nno);
	}

	@Override
	public Long nextNno() {
		return mapper.nextNno();
	}

	@Override
	public int getTotal(Criteria cri) {
		return mapper.getTotal(cri);
	}

	@Override
	public List<NoticeAttachVO> getAttachList(Long nno) {
		return attachMapper.findByNno(nno);
	}
}

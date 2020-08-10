package com.dunk.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.dunk.domain.BoardAttachVO;
import com.dunk.domain.BoardVO;
import com.dunk.domain.Criteria;
import com.dunk.domain.ReplyPageDTO;
import com.dunk.mapper.BoardAttachMapper;
import com.dunk.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
public class BoardServiceImpl implements BoardService {

	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public int register(BoardVO vo) {
		log.info("-----------------------register--------------------");
		log.info(" vo : " + vo);
		
		
		int count = mapper.insert(vo);
		
		if(vo.getAttachList()==null||vo.getAttachList().size()<=0) {
			return count;
		}
		
		vo.getAttachList().forEach(attach ->{
			attach.setBno(mapper.nextBno());
			attachMapper.insert(attach);
		});
		
		return count;
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		log.info("-----------------------getAllList--------------------");
		return mapper.getList(cri);
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("-----------------------getList--------------------");
		log.info("bno : " + bno);
		return mapper.get(bno);
	}

	@Transactional
	@Override
	public int modify(BoardVO vo) {
		log.info("-----------------------modify--------------------");
		log.info("vo : " + vo);
		log.info("vo.getBno() = " + vo.getBno());
		
		attachMapper.deleteAll(vo.getBno()); //������ �ִ� ÷�������� �����.
		
		int modResult = mapper.update(vo); //���� �Խù��� ������Ʈ �Ѵ�.
		
		if(modResult == 1 && vo.getAttachList() != null 
				&& vo.getAttachList().size()>0) { //�� ÷�������� �ִٸ� ����Ѵ�.
			vo.getAttachList().forEach(attach ->{
				attach.setBno(vo.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return modResult;
	}

	@Override
	public int remove(Long bno) {
		log.info("-----------------------remove--------------------");
		log.info("bno : " + bno);
		attachMapper.deleteAll(bno);
		return mapper.delete(bno);
	}

	@Override
	public Long nextNum() {
		log.info("-----------------------nextNumber--------------------");
		return mapper.nextBno();
	}

	@Override
	public int getTotal(Criteria cri) {
		return mapper.getTotal(cri);
	}

	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		log.info("get Attach list by bno : " + bno);
		return attachMapper.findByBno(bno);
	}


}

package com.dunk.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dunk.domain.BoardAttachVO;
import com.dunk.domain.BoardVO;
import com.dunk.domain.Criteria;
import com.dunk.domain.PageDTO;
import com.dunk.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@AllArgsConstructor
@RequestMapping("/board/*")
public class BoardController {
	
	BoardService service;
	
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		log.info("---------------deleteFiles()-------------------");
		log.info("attachList : " +attachList);
		
		attachList.forEach(attach -> {
			try {
				Path file = Paths.get("C:\\upload\\"+ attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
				Files.deleteIfExists(file);
				if(Files.probeContentType(file).startsWith("image")) { //�씠誘몄��씪 �븣�뒗 �뜽�꽕�씪 �뙆�씪源뚯� �궘�젣
					Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					Files.delete(thumbNail);
				}
			} catch (IOException e) {
				log.error("delete File Error : " +e.getMessage());
			} // try - catch
		}); //forEach
	} //deleteFiles()
	
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register(@ModelAttribute("cri")Criteria cri, Model model) {
		log.info("---------------/board/register-------------------");
		log.info("cri : " + cri);
		
	}
	
	@PostMapping("register")
	@PreAuthorize("isAuthenticated()")
	public String postRegister(BoardVO vo, RedirectAttributes rttr) {
		log.info("---------------POST REGISTER-------------------");
		log.info("vo : " + vo);
		
		if(vo.getAttachList() != null) {
			vo.getAttachList().forEach(attach -> log.info(attach));
		}

		int resultCnt = service.register(vo);
		log.info(resultCnt==1?"SUCCESS REGISTER" : "FAILED REGISTER");

		rttr.addAttribute("bno", service.nextNum());
		return "redirect:/board/get";
	}
	
	@GetMapping("/list")
	public void list(Model model, Criteria cri) {
		log.info("---------------/board/list-------------------");
		log.info("model : " + model);
		log.info("cri : " + cri);

		int total = service.getTotal(cri);
		model.addAttribute("list", service.getList(cri));
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	@GetMapping({"/get", "/modify"})
	public void get(Model model, Long bno, @ModelAttribute("cri")Criteria cri) {
		log.info("--------------- /board/get or modify -------------------");
		log.info("model : " + model);
		log.info("bno : " + bno);
		log.info("cri : " + cri);
		
		model.addAttribute("get", service.get(bno));
	}
	
	@PreAuthorize("principal.username == #vo.writer")
	@PostMapping("/modify") 
	public String postModify(@ModelAttribute("vo")BoardVO vo, RedirectAttributes rttr
			,@ModelAttribute("cri")Criteria cri) { 
		log.info("---------------Post Modify-------------------");
		log.info("vo : " +vo);
		log.info("cri : " +cri );
		
		int resultCnt = service.modify(vo);
		log.info("resultCnt : " + resultCnt);
		log.info(resultCnt == 1 ? "Success Modify":"Fail Modify");
		
		rttr.addAttribute("bno", vo.getBno());
		rttr.addAttribute("page", cri.getPage());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		
		return "redirect:/board/get";
	}
	
	@PreAuthorize("principal.username == #writer")
	@PostMapping("/remove")
	public String remove(Long bno, RedirectAttributes rttr, Criteria cri, String writer) {
		log.info("---------------Post Remove-------------------");
		log.info("bno : " + bno);
		log.info("writer :" + writer);
		
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		log.info("attachList : " + attachList);

		int resultCnt = service.remove(bno);
		deleteFiles(attachList);

		log.info("resultCnt : " + resultCnt);
		rttr.addFlashAttribute("removeResult", resultCnt == 1 ? "success":"failed");
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	@GetMapping(value="/getAttachList",
			produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {
		log.info("getAttachList " + bno);
		return new ResponseEntity<>(service.getAttachList(bno),HttpStatus.OK);
	}
}

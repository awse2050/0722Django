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

import com.dunk.domain.Criteria;
import com.dunk.domain.NoticeAttachVO;
import com.dunk.domain.NoticeVO;
import com.dunk.domain.PageDTO;
import com.dunk.service.NoticeService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/notice")
@Log4j
@AllArgsConstructor
public class NoticeController {

	NoticeService service;
	
	@GetMapping(value="/getAttachList",
			produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<NoticeAttachVO>> getAttachList(Long nno) {
		log.info("getAttachList : " + nno);
		return new ResponseEntity<>(service.getAttachList(nno), HttpStatus.OK);
	}
	
	private void deleteFiles(List<NoticeAttachVO> attachList) {
		if(attachList == null || attachList.size() == 0 ) {
			return;
		}
		
		log.info("************Delete Files*************");
		log.info(attachList);

		attachList.forEach(attach -> {
				try {
					Path file = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
					Files.deleteIfExists(file);
					if(Files.probeContentType(file).startsWith("image")) {
						Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
						Files.delete(thumbNail);
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
		}); //attachList.forEach
	}
	
	
	@GetMapping("/list")
	public void list(Model model,Criteria cri) {
		log.info("************LIST*************");
		log.info("cri : " + cri);

		int total = service.getTotal(cri);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("list", service.getList(cri));
	}
	
	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register() {
		log.info("************REGISTER*************");
	}
	
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(NoticeVO vo, RedirectAttributes rttr) {
		log.info("************POST REGISTER*************");
		log.info("vo : " + vo);
		
		if(vo.getAttachList() != null) {
			vo.getAttachList().forEach(attach -> log.info(attach));
		}
		
		service.register(vo);

		//내가 등록한 게시물을 바로 확인할 수 있게 nextNno을 파라미터로 넘긴다.
		rttr.addAttribute("nno", service.nextNno());
		return "redirect:/notice/get";
	}
	
	@GetMapping({"/get","/modify"})
	public void get(Model model, Long nno, @ModelAttribute("cri")Criteria cri) { //@ModelAttribute() - 화면에서 cri.~ 사용 가능
		log.info("************Get OR Modify*************");
		log.info("nno : " + nno);
		model.addAttribute("get", service.get(nno));
	}
	
	@PreAuthorize("principal.username == #writer")
	@PostMapping("/remove")
	public String remove(Long nno, RedirectAttributes rttr, @ModelAttribute("cri")Criteria cri, String writer) {
		log.info("************REMOVE*************");
		log.info(nno);
		
		List<NoticeAttachVO> attachList = service.getAttachList(nno);
		
		if(service.remove(nno) == 1) {
			//업로드 파일 삭제
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/notice/list"+cri.getListLink();
	}
	
	@PreAuthorize("principal.username == #vo.writer")
	@PostMapping("/modify")
	public String modify(NoticeVO vo, RedirectAttributes rttr, @ModelAttribute("cri")Criteria cri) {
		log.info("************Modify*************");
		log.info(vo);
		
		service.modify(vo);
		
		rttr.addAttribute("nno", vo.getNno());
		
		return "redirect:/notice/get"+cri.getListLink();
	}
}

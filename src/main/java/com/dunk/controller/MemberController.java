package com.dunk.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dunk.domain.MemberVO;
import com.dunk.service.MemberService;

import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/*")
@Log4j
public class MemberController {

	@Autowired
	MemberService service;
	
	@GetMapping("/register")
	public void register() {
		log.info("Register");
	}
	
	@PostMapping("/register")
	public String register(MemberVO vo, RedirectAttributes rttr) { 
		log.info("MEMBER REGISTER.........................."+vo);

		//이미 있는 계정이라면 return
		if(service.checkId(vo.getUserid()) != null) {
			rttr.addFlashAttribute("result", "failed");
			return "redirect:/register";
		}
		
		//계정 등록
		service.register(vo);
		
		return "redirect:/board/list";
	}
	
}

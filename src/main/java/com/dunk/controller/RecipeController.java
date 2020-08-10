package com.dunk.controller;


import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;


import com.dunk.domain.Criteria;
import com.dunk.domain.PageDTO;
import com.dunk.domain.RecipeAttachVO;
import com.dunk.domain.RecipeVO;
import com.dunk.service.RecipeService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/recipe")
@AllArgsConstructor
public class RecipeController {
	
	
	private RecipeService service;

	@GetMapping("/recipeList")
	public void recipeList(Criteria cri,Model model) {
		
		log.info("List: " + cri);
		model.addAttribute("recipeList", service.getList(cri));
		
		int total = service.getTotal(cri);
		
		log.info("total: " + total);
		
		model.addAttribute("pageMaker",new PageDTO(cri,total));
	}

	@PostMapping("/recipeRegister")
	public String foodRegister(RecipeVO vo, RedirectAttributes rttr) {

		log.info("========================");
		
		log.info("recipeRegister: " + vo);
			
		if(vo.getAttachList() != null) {
			vo.getAttachList().forEach(attach -> log.info(attach));
		}
		
		log.info("=========================");
			
		service.register(vo);
		
		rttr.addAttribute("recipe_no",vo.getRecipe_no());

		return "redirect:/recipe/recipeGet";
	}

	@GetMapping({"/recipeGet","/recipeModify"})
	public void get(@RequestParam("recipe_no") Long recipe_no, @ModelAttribute("cri") Criteria cri, Model model) {

		log.info("/recipeGet or recipeModify");

		model.addAttribute("recipeGet", service.get(recipe_no));
	}
	
	@PostMapping("/recipeModify")
	public String modify(RecipeVO vo, Criteria cri, RedirectAttributes rttr) {
		
		log.info("modify: "+ vo);
		
		if(service.modify(vo)) {
			rttr.addFlashAttribute("result","success");
		}
				
		return "redirect:/recipe/recipeList" +cri.getListLink() ;
	}
	
	@PostMapping("/recipeRemove")
	public String remove(@RequestParam("recipe_no") Long recipe_no, Criteria cri,  RedirectAttributes rttr) {
		
		log.info("remove...."+recipe_no);
		
		List<RecipeAttachVO> attachList = service.getAttachList(recipe_no);
		
		
		
		if(service.remove(recipe_no)) {
			
			//delete Attach Files
			deleteFiles(attachList);
			
			rttr.addFlashAttribute("result","success");
		}

		return "redirect:/recipe/recipeList" +cri.getListLink() ;
	}
	
	@GetMapping("/recipeRegister")
	public void register(@ModelAttribute("cri")Criteria cri, Model model) {
		
		log.info("---------------/recipe/recipeRegister-------------------");
		log.info("cri : " + cri);
		
	}
	
	@GetMapping(value ="/getAttachList",
			produces = MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
	public ResponseEntity<List<RecipeAttachVO>> getAttachList(Long recipe_no){
		
		log.info("getAttachList" + recipe_no);
		
		return new ResponseEntity<>(service.getAttachList(recipe_no), HttpStatus.OK);
		
	}
	
	private void deleteFiles(List<RecipeAttachVO> attachList) {
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
	
	

}

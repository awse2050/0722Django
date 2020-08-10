package com.dunk.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.dunk.domain.CategoryAttachVO;
import com.dunk.domain.CategoryVO;
import com.dunk.domain.Criteria;
import com.dunk.domain.DjangoMemberVO;
import com.dunk.domain.PageDTO;
import com.dunk.domain.UserFridgeList;
import com.dunk.domain.UserFridgeVO;
import com.dunk.mapper.MemberRoleMapper;
import com.dunk.service.CategoryService;
import com.dunk.service.DjangoMemberService;
import com.dunk.service.UserFridgeService;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Controller
@RequestMapping("/admin")
@Log4j
public class AdminController {

	// 냉장고
	@Setter (onMethod_ = @Autowired)
	private UserFridgeService userFridgeService;
	
	//카테고리 매퍼
	@Setter (onMethod_ = @Autowired)
	private CategoryService categoryService;
	
	//추가 ( 사용자 )
	@Setter (onMethod_ = @Autowired)
	private DjangoMemberService memberService; // 추가
	
	@Setter (onMethod_ = @Autowired)
	private MemberRoleMapper memberRoleService;
	
	// 사용자 전체 리스트를 보여준다.
	@GetMapping("/userinfo")
	public void admin(Model model, Criteria cri) {
		log.info("ADMIN get userList    !!!!!!!");
		// 등록되어있는 사용자의 이름을 보여준다.
		log.info("model : " + model);
		log.info("cri : " + cri);
		int total = memberService.getTotal(cri);
		log.info("total :"+total);
		model.addAttribute("userList", memberService.getList(cri)); //변경
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
	}
	//사용자 등록창으로 이동
	@GetMapping("/userRegister")
	public void userRegister() {
		log.info("************************userRegister*****************************");
	}
    //사용자 등록기능
	@PostMapping("/userRegister")
	public String postUserRegister(DjangoMemberVO vo) { // 매개변수변경
		log.info("************************POST USER REGISTER*****************************");
		log.info(vo);
		
		memberService.registerUser(vo); // 변경
		
		return "redirect:/admin/userinfo";
	}
	
	// 유저 삭제하기 ( 냉장고 db와 사용자 DB를 동시에 지워야함)
	@Transactional
	@PostMapping("/userRemove")
	public String userRemove(@ModelAttribute("id") String id, RedirectAttributes rttr, Criteria cri, UserFridgeVO vo) {
		log.info("remove userid : "+ id);
		log.info("get vo : "+vo);
		// FK 가 걸려있으므로 동시에 지울때 냉장고 db가 먼저 지워져야 가능함.
		// 눌러서 가져온 사용자의 이름을 저장하고.
		vo.setUsername(id);
		// id가 냉장고에서는 username이다.
		log.info("vo's username : "+vo.getUsername());
		// 권한을 삭제한다
		memberRoleService.delete(memberService.get(vo.getUsername()).getMno());
		// 냉장고 DB를 먼저 지운다.
		userFridgeService.remove(vo.getUsername());
		// 이후 사용자의 이름을 지운다.
//		int resultCnt = userService.remove(username);
		int resultCnt = memberService.remove(id);
				
		log.info("resultCnt : " + resultCnt);
		rttr.addFlashAttribute("removeResult", resultCnt >= 0 ? "success":"");
				
		return "redirect:/admin/userinfo" + cri.getListLink();
	}
	// 사용자의 냉장고 목록을 전체삭제
	@Transactional
	@PostMapping("/removeFridge")
	public String removeFridge(String id, Criteria cri, RedirectAttributes rttr) {
		log.info("************************FRIDGE REMOVE*****************************");
		log.info("id : "+id);
		
		userFridgeService.remove(id);
		rttr.addAttribute("id" , id);
		
		return "redirect:/admin/get" + cri.getListLink();
	}
	
	// 사용자가 가지고 있는 냉장고의  목록을 보여준다.
	@GetMapping({"/get","/modifyFridge"})
	public void getUser(@ModelAttribute("id") String id , Model model , @ModelAttribute("cri") Criteria cri ) {
//		 @ModelAttribute("cri") Criteria cri
		log.info("================== get User mapping============ ");
		log.info(userFridgeService.get(id));
		log.info("userid : "+id);
		log.info("cri : " + cri);
		model.addAttribute("username" , id);
		model.addAttribute("category", categoryService.getList());
		model.addAttribute("userInfo", userFridgeService.get(id));
	}
	
	@PostMapping("/modifyFridge")
	@PreAuthorize("permitAll")
	public String postModifyFridge(UserFridgeList list, RedirectAttributes rttr,  @ModelAttribute("cri")Criteria cri, 
				@ModelAttribute("id") String username) {
		log.info("************************POST MODIFY FRIDGE*****************************");
		log.info("list.getVos() : "+list.getVos());
		
		rttr.addAttribute("id", username);
		rttr.addAttribute("page", cri.getPage());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("keyword", cri.getKeyword());
		rttr.addAttribute("type", cri.getType());
		
		list.getVos().forEach(vo -> log.info(userFridgeService.modify(vo)));
			
		try {
			Thread.sleep(2000);
		} catch(Exception e) {
			
		}
		return "redirect:/admin/get";
	}
	
	//========================== 카테고리==================================
	//첨부파일 관련 데이터 JSON반환 처리
		@GetMapping(value="/getAttachList", produces = MediaType.APPLICATION_JSON_VALUE)
		@ResponseBody
		public ResponseEntity<List<CategoryAttachVO>> getAttachList(long cno){
			log.info("getAttachList"+cno);
			log.info("AttachList:"+categoryService.getAttachList(cno));
			return new ResponseEntity<>(categoryService.getAttachList(cno), HttpStatus.OK);
		}
		
		//카테고리 등록 창으로 가기
		@GetMapping("/register")
		public void categoryRegister() {
			log.info("--------------------------------/admin/register--------------------------------");
		}
		//카테고리 등록하기
		@PostMapping("/register")
		public String postRegister(CategoryVO vo, RedirectAttributes rttr) {
			log.info("-------------------------POST REGISTER------------------------------");
			log.info("vo : "+ vo);
			log.info("vo.getAtt : " + vo.getAttachList());
			log.info("vo.getAttachList()!=null : " + vo.getAttachList()!=null);
			
			
			
			if(vo.getAttachList()!=null) {
				vo.getAttachList().forEach(attach->log.info(attach));
			}
			
			log.info("-------------------------POST REGISTER------------------------------");
				
		//
			
			categoryService.register(vo);
			
			long cno = categoryService.nextNum();
			
			rttr.addAttribute("cno",cno);
			
			return "redirect:/admin/category";
		}
		//파일삭제
		private void deleteFiles(List<CategoryAttachVO> attachList) {
			if(attachList == null || attachList.size() == 0) {
				return;
			}
			log.info("delete attach files.............");
			log.info(attachList);
			
			attachList.forEach(attach->{
				try {
					Path file = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
					
					Files.deleteIfExists(file);
					if(Files.probeContentType(file).startsWith("image")) {
						Path thumNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
						
						Files.delete(thumNail);
					}
				}catch(Exception e) {
					log.error("delete file error"+e.getMessage());
				}//catch끝
			});//foreach끝
		}
		
		// 카테고리 목록 전체를 보여준다.
		@GetMapping("/categoryList")
		public void getCategoryList(Model model, Criteria cri) {
			
			log.info(" get Category List");
			// 카테고리 목록을 쏴준다.
			int total = categoryService.getTotal(cri);
			log.info("total :"+total);
			log.info("cri : " + cri);
			model.addAttribute("category", categoryService.getListWithPaging(cri));
			model.addAttribute("pageMaker", new PageDTO(cri, total));
		}
		
		// 카테고리 목록 중 하나의 세부정보를 보여준다.
		@GetMapping({"/category" , "/modify"})
		public void getCategory(@ModelAttribute("cno") Long cno, Model model ,@ModelAttribute("cri")Criteria cri) {
			
			log.info(" get or Modify Category Detail");
			log.info("get category cri : "+cri );
			// 카테고리 목록을 쏴준다.
			model.addAttribute("getCategory", categoryService.get(cno));
		}
		// 카테고리 수정하기.
		@PostMapping("/modify")
		@PreAuthorize("hasRole('ROLE_USER')")
		public String categoryModify(@ModelAttribute("vo") CategoryVO vo ,  RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri) {
			
			log.info(" Modify Category" );
			log.info("modify data : "+ vo);
			// 수정이 되었으면 1 아니라면 0
			log.info(categoryService.modify(vo));
			// 번호를 넘겨 조회페이지로 갈수있게 남긴다.
			rttr.addAttribute("cno" , vo.getCno());
			rttr.addAttribute("page", cri.getPage());
			rttr.addAttribute("amount", cri.getAmount());
			rttr.addAttribute("type", cri.getType());
			rttr.addAttribute("keyword", cri.getKeyword());
			// 수정을 했다면 다시 조회창으로 넘어갑니다.
			return "redirect:/admin/category";
		}
		// 카테고리 삭제하기(불필요한 정보 제거)
		@PostMapping("/remove")
		public String categoryRemove(@RequestParam("cno") Long cno, RedirectAttributes rttr, Criteria cri) {
			log.info("-----------------------------------POST REMOVE---------------------------");
			log.info("remove cno : "+ cno);
			List<CategoryAttachVO> attachList = categoryService.getAttachList(cno);
			
			int resultCnt = categoryService.remove(cno);

			log.info("resultCnt : " + resultCnt);
			
			if(resultCnt == 1) {
				deleteFiles(attachList);
				
				rttr.addFlashAttribute("result","success");
			}
			
			return "redirect:/admin/categoryList" + cri.getListLink();
			
		}
		
		// json데이터를 이용해서 식재료를 추가한다.
		@PostMapping(value="/new",  
				consumes = "application/json", // JSON데이터를 받을것이다.
				produces = {MediaType.TEXT_PLAIN_VALUE,  MediaType.APPLICATION_JSON_VALUE} ) // 둘 중 어느것으로도 처리가 가능해진다.
		@ResponseBody
		// ajax호출로 인해 보낸 JSON 데이터를 @RequestBody를 사용해 UserFridgeVO로 바꿔온다.
		public ResponseEntity<String> add(@RequestBody UserFridgeVO vo) { //RequestBody로  얻어온 JSON객체를 UserFridgeVO타입의 객체로 변환한다.
			int count = userFridgeService.register(vo);
			log.info("===============AJAX ADD================");
			log.info("count : "+count);
			return count == 1 ? new ResponseEntity<>( "success", HttpStatus.OK) : 
				new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		// consume=JSON데이터를 받아온다.
		// 특정 사용자의 냉장고 데이터를 받아온다.
		@GetMapping(value="/{username}",  
				produces = {MediaType.TEXT_PLAIN_VALUE,  MediaType.APPLICATION_JSON_VALUE} )
		@ResponseBody
		public ResponseEntity<List<UserFridgeVO>> getList(@PathVariable("username") String username) {
			List<UserFridgeVO> vo = userFridgeService.get(username);
			return vo !=null ? new ResponseEntity<>( vo , HttpStatus.OK)
								: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
		// 카테고리 목록을 받아옵니다
		@GetMapping(value="/All",
					produces = {MediaType.TEXT_PLAIN_VALUE, MediaType.APPLICATION_JSON_VALUE})
		@ResponseBody
		public ResponseEntity<List<CategoryVO>> getList() {
			
			return  new ResponseEntity<>( categoryService.getList() , HttpStatus.OK);
		}
		// 냉장고 선택삭제하기.
		@DeleteMapping(value="/{fno}",
					produces = {MediaType.TEXT_PLAIN_VALUE})
		public ResponseEntity<String> selectRemoveFridge(@PathVariable("fno") long fno) {
			
			
			return userFridgeService.fridgeRemove(fno)==1 ? new ResponseEntity<String>("success", HttpStatus.OK) 
					: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		// 추가
		// 냉장고 즉시 수정하기.
		@RequestMapping(method= {RequestMethod.PUT, RequestMethod.PATCH}, 
				value = "/{fno}",
				consumes = "application/json",
				produces = {MediaType.TEXT_PLAIN_VALUE})
		@ResponseBody
		public ResponseEntity<String> modify (
				@RequestBody UserFridgeVO vo,
				@PathVariable("fno") Long fno
				) {
			log.info("------------------------------modify------------------------------------");
			log.info("vo : " + vo);
			log.info("fno : " + fno);
			
			return userFridgeService.modify(vo) == 1
					?new ResponseEntity<>("success", HttpStatus.OK)
							:new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
		
}

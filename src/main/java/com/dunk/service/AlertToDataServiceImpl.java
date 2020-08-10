package com.dunk.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import com.dunk.domain.AlertToDataVO;
import com.dunk.mapper.AlertToDataMapper;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

import lombok.extern.log4j.Log4j;

@Service("AlertToDataService")
@Log4j
public class AlertToDataServiceImpl implements AlertToDataService {

	@Override
	public void test() {
		log.info("자동실행 테스트");
		System.out.println("println");
	}
	
	@Autowired
	private AlertToDataMapper mapper;
	
	@Override
	public int register() {
		// TODO Auto-generated method stub
		log.info("유통기한을 비교해서 등록.");
		return mapper.insert();
	}

	@Override
	public List<AlertToDataVO> getList() {
		// TODO Auto-generated method stub
		log.info("메세지를 보낼 식재료데이터 조회.");
		
		return mapper.getList();
	}

	@Override
	public int remove() {
		// TODO Auto-generated method stub
		log.info("기존 데이터 삭제. ");
		return mapper.delete();
	}
//	@Scheduled(cron = "0 0 20 1/1 * ?") 
	public void send() {
		log.info("20시에 메세지를 보냅니다");
		remove();
		register();
		List<AlertToDataVO> data = getList();
		log.info("data : "+data);
		
		data.forEach(i -> {
			FirebaseOptions options;
			// 구글 클라우드에서 콘솔에 대한 정보를 json형태로 파일을 가져와서 사용.
//			try (FileInputStream refreshToken = new FileInputStream("C:\\firebase\\Django-d066b0130c26.json")) { //
//
//				// firebaseConfig와 같은 역할을 한다.
//				options = new FirebaseOptions.Builder()
//						.setCredentials(GoogleCredentials.fromStream(refreshToken))
//						.setDatabaseUrl("https://django-1b7a8.web.app/") // 장고로 바꾸기.
//						.build();
			try { 
				// firebaseConfig와 같은 역할을 한다.
				options = new FirebaseOptions.Builder()
						.setCredentials(GoogleCredentials.getApplicationDefault())
						.setDatabaseUrl("https://django-1b7a8.web.app/") // 장고로 바꾸기.
						.build();

				FirebaseApp django;
				// initializeApp()과 같은 역할을 한다.
				if (FirebaseApp.getApps().isEmpty()) { // 체크를 하지 않으면 안된다???
					django = FirebaseApp.initializeApp(options);
				} else {
					django = FirebaseApp.getInstance();
				}
				// 권한..
				FirebaseAuth auth = FirebaseAuth.getInstance(django);
				FirebaseMessaging messaging = FirebaseMessaging.getInstance(django);
				// 메세지의 제목과 내용을 작성하는 작업. 현재는 임시로 Data를 지정해두었슴.
				Message message = Message.builder()
						// 메세지를 받아야하는 사람의 토큰을 얻어와서 setter로 설정한다,
						// 메세지를 받아오려면 유저가 가진 토큰을 찾아서 그 토큰을 적용시킴.
						.setToken(i.getToken())
						// 원하는 메세지의 제목과 내용을 지정한다 (title , content)
						.setNotification(new Notification("Django",i.getUsername()+"님이 보유하신 "+ i.getIngr_name() + "의 유통기한이 3일 남았습니다.")) 
						.build(); // 임시메세지.
				log.info(i.toString());
				log.info("받는사람 : "+i.getUsername());
				log.info("식재료 : "+i.getIngr_name());
//				messaging.send(message); // 메세지 보내는 작업.
				Thread.sleep(3000); // 3초마다 보내도록 한다.
				log.info("전송완료");
				log.info("5초 후 타 데이터 전송");
			} catch (Exception e) {
				e.printStackTrace();
			}
		});
	}
}
	

	


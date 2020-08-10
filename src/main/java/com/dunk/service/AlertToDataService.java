package com.dunk.service;

import java.io.FileInputStream;
import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import com.dunk.domain.AlertToDataVO;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.Notification;

@Transactional
@Component // 크론사용.
public interface AlertToDataService {
	// 있는 테이블에서 등록할것이기 때문에
	// 매개변수가 필요없다.
	int register();
	
	List<AlertToDataVO> getList();
	// 전체 데이터를 삭제할 것이므로 
	// 특정칼럼을 지정할 필요 없음. 
	int remove();
	
	void test();
	// 메세지를 보내는 작업. 
	
	// 크론을 이용해서 8시마다 메서드를 호출하는 방법으로 설정한다.
	default void send() {
		// 메세지를
		remove();
		register();
		List<AlertToDataVO> data = getList();

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
						.setToken("f_eRT_8xwh8O8qwHqWpQav:APA91bHlcgsxGED0gkHMPZtvO3jUj_CEUOwC0waIlVY1NjW0lBLnH72SvsFFLp8U_WDF2Icqe3QU9RAFDi2hbs5efp6p6Kx1inBbzD6hM_nA922BTmkpYUM_IQgw6ONKOhIVtC3a1xFa")
						// 원하는 메세지의 제목과 내용을 지정한다 (title , content)
						.setNotification(new Notification("Django", i.getIngr_name() + "의 유통기한이 다 되었습니다.")) 
						.build(); // 임시메세지.

				messaging.send(message); // 메세지 보내는 작업.
				Thread.sleep(3000); // 5초마다 보내도록 한다.

			} catch (Exception e) {
				e.printStackTrace();
			}
		});
	}
}
		
	


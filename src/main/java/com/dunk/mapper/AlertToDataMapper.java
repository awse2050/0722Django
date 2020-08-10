package com.dunk.mapper;
import java.util.List;

import com.dunk.domain.AlertToDataVO;

public interface AlertToDataMapper {

	// 있는 테이블에서 등록할것이기 때문에
	// 매개변수가 필요없다.
	int insert();
	
	List<AlertToDataVO> getList();
	// 전체 데이터를 삭제할 것이므로 
	// 특정칼럼을 지정할 필요 없음. 
	int delete();
	
}
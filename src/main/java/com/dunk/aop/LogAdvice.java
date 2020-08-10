package com.dunk.aop;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class LogAdvice {	//AOP
	@Before( "execution(* com.dunk.service.BoardService.*.*(..))")
	public void logBefore() {
		log.info("============");
	}
}

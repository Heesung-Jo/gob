package com.controller;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.NoSuchElementException;

import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import com.errorprocess.CustomException;
import com.errorprocess.ErrorCode;
import com.errorprocess.ErrorResponse;



@RestControllerAdvice("com")
@Order(Ordered.LOWEST_PRECEDENCE)
public class ErrorlowControllerAdvice {

/*
  @ExceptionHandler(value = Exception.class)
  @ResponseStatus(value = HttpStatus.BAD_REQUEST)
  protected ResponseEntity<ErrorResponse> handleException(Exception e) {
	  System.out.println("enum으로 왔다1");
	  System.out.println("enum으로 왔다1");
    ErrorResponse response = ErrorResponse.of(ErrorCode.EXPIRED_CODE); // 이거 나중에 책보고 수정할 것
    response.setDetail(e.getMessage());
    return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
  }
 */
	
   
}

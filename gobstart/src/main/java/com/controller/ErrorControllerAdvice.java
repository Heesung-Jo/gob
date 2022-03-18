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
@Order(Ordered.HIGHEST_PRECEDENCE)
public class ErrorControllerAdvice {

  @ExceptionHandler(value = NoSuchElementException.class)
  @ResponseStatus(value = HttpStatus.BAD_REQUEST)
  protected ResponseEntity<ErrorResponse> handleNoSuchElementException(Exception e) {
	  System.out.println("enum으로 왔다2");
    ErrorResponse response = ErrorResponse.of(ErrorCode.RESOURCE_NOT_FOUND);
    response.setDetail(e.getMessage());
    return new ResponseEntity<>(response, HttpStatus.NO_CONTENT);
  }

  
  @ExceptionHandler(value = IllegalArgumentException.class)
  @ResponseStatus(value = HttpStatus.BAD_REQUEST)
  protected ResponseEntity<Object> handleIllegalArgumentException(Exception e) {
	System.out.println("enum으로 왔다3");
	HashMap<String, Object> realdata = new LinkedHashMap<>();
	realdata.put("error", "com.enumfolder.[a-z]{1,20}");
	System.out.println(e.getMessage());
	realdata.put("detail", e.getMessage());
    
    return ResponseEntity.status(HttpStatus.OK).body(realdata);
  }
  
  //요 밑으로 쭉쭉 추가적인 ExceptionHandler들을 추가해서 처리합니다
  
  /* Custom Error Handler */
  @ExceptionHandler(value = CustomException.class)
  @ResponseStatus(value = HttpStatus.BAD_REQUEST)
  protected ResponseEntity<Object> handleCustomException(CustomException e) {
	  System.out.println("enum으로 왔다4");
	  HashMap<String, Object> realdata = new LinkedHashMap<>();
	  realdata.put("error", "custom");
	  realdata.put("detail", e.getMessage());

	  return ResponseEntity.status(HttpStatus.OK).body(realdata);
  }
  

}

package com.errorprocess;

public class CustomException extends Exception {

	  private ErrorCode errorCode;

	  public CustomException(String message, ErrorCode errorCode) {
	    super(message);
	    this.errorCode = errorCode;
	  }

	  public CustomException(ErrorCode errorCode) {
	    super(errorCode.getMessage());
	    this.errorCode = errorCode;
	  }

	  public CustomException(String message) {
		    super(message);
		  }

	  public ErrorCode getErrorCode() {
	    return this.errorCode;
	  }
	}

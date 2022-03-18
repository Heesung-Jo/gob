package com.spring;

import java.time.LocalDateTime;

public class Member {

	private Long id;
	private String division;
	private String password;
	private String name;

	public Member(String name, String division, 
			String password) {
		this.name = name;
		this.division = division;
		this.password = password;
		
	}

	void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public String getDivision() {
		return division;
	}

	public String getPassword() {
		return password;
	}

	public String getName() {
		return name;
	}


	public void changePassword(String oldPassword, String newPassword) {
		if (!password.equals(oldPassword))
			throw new WrongIdPasswordException();
		this.password = newPassword;
	}

	public boolean matchPassword(String password) {
		return this.password.equals(password);
	}

}

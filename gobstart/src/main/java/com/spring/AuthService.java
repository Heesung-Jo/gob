package com.spring;

import java.util.*;

public class AuthService {
	
	
	private HashMap<String, Member> memberDao = new HashMap<>();

	
	public void setMemberDao() {
		
		memberDao.put("조희성", new Member("조희성", "총무팀", "1234"));
		memberDao.put("김웅일", new Member("김웅일", "회계팀", "1234"));
		memberDao.put("장세호", new Member("장세호", "사업팀", "1234"));
		memberDao.put("이헌희", new Member("이헌희", "자금팀", "1234"));
		memberDao.put("user", new Member("user", "자금팀", "user"));
		
	}
	

	
	public Member authenticate(String name, String password) {
		
		Member member = memberDao.get(name);
		
		if (member == null) {
			throw new WrongIdPasswordException();
		}
		
		
		if (!member.matchPassword(password)) {
			throw new WrongIdPasswordException();
		} 
		
		return member;
	}

}

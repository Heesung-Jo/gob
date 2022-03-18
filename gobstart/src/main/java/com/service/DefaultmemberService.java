package com.service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import com.repository.TeamRepository;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcOperations;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Repository;

import com.repository.memberdao;
import com.repository.MemberRepository;
import com.repository.RoleRepository;

import com.entity.member;
import com.entity.roledata;
import com.entity.teamdata;
import com.enumfolder.Role;

/**
 * A default implementation of {@link memberService} that delegates to {@link EventDao} and {@link memberdao}.
 *
 * @author Rob Winch
 * @author Mick Knutson
 *
 */
@Repository
public class DefaultmemberService implements memberService {

    private static final Logger logger = LoggerFactory
            .getLogger(DefaultmemberService.class);

    @Autowired
    private memberdao userDao;
  //  private final PasswordEncoder passwordEncoder;
    @Autowired
    private MemberRepository userRepository;

    @Autowired
    private RoleRepository rolerepository;

	@Autowired
	private jsonmake jsonmake;
    

    
    @Autowired
    public DefaultmemberService(
                                  memberdao userDao,
                                  MemberRepository userRepository,
                                  RoleRepository rolerepository
                                  //final PasswordEncoder passwordEncoder
                                  ) {
        if (userDao == null) {
            throw new IllegalArgumentException("userDao cannot be null");
        }
        if (userRepository == null) {
            throw new IllegalArgumentException("userRepository cannot be null");
        }
        /*
        if (passwordEncoder == null) {
            throw new IllegalArgumentException("passwordEncoder cannot be null");
        }
        */
        
        this.userDao = userDao;

		// role 세팅
		
		// 기본 아이디 세팅
		
        member user = new member();
        user.setEmail("gochoking@naver.com");
        user.setRealname("조희성");
        user.setPassword("{noop}1234");
        //user.setRole(Role.팀원);
        
        List<roledata> roles = new ArrayList<>();
        
        roledata role1 = new roledata();
        role1.setRole("전체"); 
        role1.setMember(user);
        roledata role2 = new roledata();
        role2.setRole("회계팀원");        
        role2.setMember(user);
        roledata role3 = new roledata();
        role3.setRole("회계팀장");        
        role3.setMember(user);

        roles.add(role2);
        roles.add(role1);
        roles.add(role3);
        System.out.println(roles);
        user.setRoledata(roles);
        
        // 팀데이터도 일부 만들어 집어넣어야 함
        //user.setTeamdata();
        System.out.println("여기가 문제니");
        int id = createUser(user);
        
        
        System.out.println("여기었어?");
    }


    @Override
    public member getUser(int id) {
        return userDao.getUser(id);
    }

    @Override
    public member findUserByEmail(String email) {
        return userDao.findUserByEmail(email);
    }

    @Override
    public List<member> findUsersByEmail(String partialEmail) {
        return userDao.findUsersByEmail(partialEmail);
    }
    
    public List<member> findall() {
        return userRepository.findAll();
    }
    
    
    public void savedata(member mem, List<String> roles) {
    	 
    	 
    	 List<String> str_role = mem.getRoledata().stream().map(s -> s.getRole()).collect(Collectors.toList());
    	 
     	 List<roledata> newroles = new ArrayList<>();  
    	 
     	 // 없는 권한만 추가하기
     	 for(String role : roles) {
     		 
     		 int num = 0;
     		 for(String str : str_role) {
     			 if(role.equals(str) == true) {
     				 num = 1;
     				 break;
     			 }
     		 }
     		 
     		 if(num == 0) {
     	     	 roledata newrole = new roledata();
     	     	 newrole.setRole(role);
     	     	 newrole.setMember(mem);
     			 newroles.add(newrole);
     		 }
     		 
     	 }
   	 
     	 mem.setRoledata(newroles);
       	 userRepository.save(mem);
    	
    }
    
    

    /**
     * Create a new Signup User
     * @param user
     *            the new {@link member} to create. The {@link member#getId()} must be null.
     * @return
     */
    @Override
    public int createUser(member user) {
        String encodedPassword = user.getPassword(); // passwordEncoder.encode(user.getPassword());
        user.setPassword(encodedPassword);
        int userId = userDao.createUser(user);

        return userId;
    }

    
    
    
    

} // The End...

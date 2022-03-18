package com.service; 


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.InvocationTargetException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;
import java.util.stream.Collectors;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.*;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import com.service.UserContext;
import com.entity.Scopingdata;
import com.entity.answerstructure;
import com.entity.basemapping;
import com.entity.basequestion;
import com.entity.coa_process;
import com.entity.currentmanage;
import com.entity.member;
import com.entity.roledata;
import com.entity.uniteddata;
import com.entity.level0table;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.repository.CoadataRepository;
import com.repository.MemberRepository;
import com.repository.ScopingdataRepository;
import com.repository.TeamRepository;


import lombok.Getter;
import lombok.Setter;

import javax.annotation.PostConstruct;
import com.repository.ProcessdataRepository;
import com.repository.AnswerstructureRepository;
import com.repository.BasemapRepository;
import com.repository.Coa_processRepository;
import com.repository.BasequestionRepository;
import com.repository.CurrentmanageRepository;
import com.repository.UniteddataRepository;
import com.repository.Level0Repository;

@Setter
@Getter
@Service
public class currentmanageservice { 

 
	private ArrayList<String> currentgradearr = new ArrayList<>();
	private Integer current_num = 0;

	
	private HashMap<String, String> managemapping = new LinkedHashMap<>();
	
	private HashMap<String, String> currentviewarr0 = new LinkedHashMap<>();

	@Autowired
	private UserContext userContext;

	@Autowired
	private AnswerstructureRepository ansrepository;
	
	@Autowired
	private BasequestionRepository BasequestionRepository;
	@Autowired
	private CurrentmanageRepository CurrentmanageRepository;

	@Autowired
	private UniteddataRepository UniteddataRepository;

	@Autowired
	private unitedwork unitedwork;
	
	@Autowired
	private Level0Repository Level0Repository;
	
	
    @PostConstruct
    public void setting() {
    	
    	
    	
    	currentviewarr0.put("스코핑", "미완성");
    	currentviewarr0.put("조직도입력", "미완성");
    	currentviewarr0.put("팀매핑", "미완성");
    	currentviewarr0.put("문서매핑", "미완성");
    	currentviewarr0.put("프로세스매핑", "미완성");
    	
    	
    	managemapping.put("회계팀원", "재무보고");
    	managemapping.put("인사팀원", "인사");
    	managemapping.put("총무팀원", "구매");
    	managemapping.put("생산팀원", "재고");
    	managemapping.put("영업팀원", "매출");
    	managemapping.put("회계팀장", "재무보고");
    	managemapping.put("인사팀장", "인사");
    	managemapping.put("총무팀장", "구매");
    	managemapping.put("생산팀장", "재고");
    	managemapping.put("영업팀장", "매출");    	
    	
    	
    }

    
    // 현재단계 리턴해주기
    public List<String> currentgrade() {
    	
    	List<String> tem = new ArrayList<>();
    	
    	try {
    		//로그인이 된 경우
    		
    		System.out.println("여기왔음");
        	member user = userContext.getCurrentUser();
        	Set<String> roles = user.getRoledata().stream().map(s -> s.getRole()).collect(Collectors.toSet());
    		System.out.println(roles);
    		
        	tem = CurrentmanageRepository.findByGrade(current_num.toString()).stream().sorted()
        			.filter(s -> roles.contains(findmember(s, 1)) || roles.contains(findmember(s, 2))).map(s -> s.getViewname())
        			.collect(Collectors.toList());
    		
    	}catch(Exception e) {
    		//로그인이 아직 안된경우
    		tem.add("explanation");
    	}
    	
    	return tem;
    }
    
    
    public String findmember(currentmanage manage, int grade) {
    	
    	
    	
    	String role = "";
    	if(grade == 1) {
    		role = manage.getPerson1();
    	}else if(grade == 2) {
    		role = manage.getPerson2();
    	}else if(grade == 3) {
    		role = manage.getPerson3();
    	}
    	
    	return role;
    }

    public String findgrade(currentmanage manage, int grade) {
    	
    	
    	String role = "";
    	if(grade == 1) {
    		role = manage.getGrade1();
    	}else if(grade == 2) {
    		role = manage.getGrade2();
    	}else if(grade == 3) {
    		role = manage.getGrade3();
    	}
    	
    	return role;
    }
    
    
    public String currentupgrade() throws JsonProcessingException, NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {

    	// 먼저 권한 체크하기
    	member user = userContext.getCurrentUser();
        // 회계팀장 권한이 있는자만, 이것을 통과 시킬 수 있음. 
    	
    	int pass = 0;
    	for(roledata role : user.getRoledata()) {
    		if(role.getRole().equals("회계팀장") == true) {
    			pass = 1;
    		}
    	}
    	
    	if(pass == 0) {
    		return "권한이 없습니다.";
    	}
    	
    	
    	// 업그레이드를 해도 되는지 체크하기
    	if(current_num == 0) {

    		// 권한이 있는 것만 넘겨줄 것
    		for(level0table level :  Level0Repository.findAll()) {
      			if(level.getCurrentgrade().equals("미완성") == true) {
        			return "아직 미완성인 부분이 있습니다.";
    			}
    		};
    		// 여기에 basequestion의 0번대 질문을 포함시킬 것
    		for(basequestion base :  BasequestionRepository.findBySubprocess("0")) {
      			if(base.getCurrentgrade().equals("미완성") == true) {
        			return "아직 미완성인 부분이 있습니다.";
    			}
    		};
    		
    		
    		current_num++;
    		
    	}else if(current_num == 1) {
    		int failsure = 0;
    		for(answerstructure pro : ansrepository.findByStep("0")) {
    			if(pro.getCurrentgrade().equals("미완성")== true) {
           			failsure = 1;
    			};
    		};
    		
    		if(failsure == 1) {
    			return "아직 미완성인 부분이 있습니다.";
    		}else {
    			current_num++;
    		}
    		
    		unitedwork.unite_data();
    		
    	}else if(current_num == 2) {
    		
    		int failsure = 0;
    		for(uniteddata pro : UniteddataRepository.findAll()){
    			if(pro.getCurrentgrade().equals("미완성")== true) {
           			failsure = 1;
    			};
    		};
    		if(failsure == 1) {
    			return "아직 미완성인 부분이 있습니다.";
    		}else {
    			current_num++;
    		}
    		
    	}   	
       
    	return "다음 단계로 넘어갔습니다.";
    }
    
    
    // 현재단계에 대해 보여줄 뷰를 리턴해주기
    public HashMap<String, String> currentview() {
    	

    	HashMap<String, String> temp = new LinkedHashMap<>();
    	
    	member user = userContext.getCurrentUser();
    	
    	if(current_num == 0) {
    		
    		// 권한이 있는 것만 넘겨줄 것
    		Level0Repository.findAll().forEach(pro -> {
    			temp.put(pro.getRealname(), pro.getCurrentgrade());
    		});
    		
    		// 여기에 basequestion의 0번대 질문을 포함시킬 것
    		BasequestionRepository.findBySubprocess("0").forEach(pro -> {
    			temp.put(pro.getRealname(), pro.getCurrentgrade());
    		});
    		
    		return temp;
    		
    	}else if(current_num == 1) {
    		/*
    		BasequestionRepository.findAll().stream().filter(s -> s.getSubprocess().equals("0") == false).forEach(pro -> {
    			temp.put(pro.getQuestion(), pro.getCurrentgrade());
    		});
    		*/
    		
    		ansrepository.findByStep("0").stream().forEach(pro -> {
    			temp.put(pro.getMainprocess() + "/" + pro.getSubprocess1(), pro.getCurrentgrade());
    		});
    		
    		
    		return temp;
    	}else if(current_num == 3) {
    		UniteddataRepository.findAll().forEach(pro -> {
    			temp.put(pro.getProcessname1(), pro.getCurrentgrade());
    		});
    	}
    	
    	
    	return null;
    }

    
    // 구체적 단계 업데이트 하기
    
    // 스코핑 단계 업데이트
    public void upgrade_scoping(String viewname, String realname, Integer num) {
    	
    	
    	currentmanage manage = CurrentmanageRepository.findByViewname(viewname).get(0);
    	
    	CurrentmanageRepository.save(manage);
    	
    	level0table level0 = Level0Repository.findByRealname(realname).get(0);
    	level0.setPerson_charge(findmember(manage, num));
        level0.setCurrentgrade(findgrade(manage, num));
        level0.setRealgrade(num);
        Level0Repository.save(level0);
    }
    
    
    

}
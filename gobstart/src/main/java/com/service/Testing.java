package com.service; 


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
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

import com.entity.Scopingdata;
import com.entity.basicdata;
import com.entity.coa_process;
import com.entity.processoption;
import com.repository.CoadataRepository;
import com.repository.ScopingdataRepository;
import com.repository.TeamRepository;

import javax.annotation.PostConstruct;
import com.repository.ProcessdataRepository;
import com.repository.AnswerstructureRepository;
import com.repository.Coa_processRepository;


@Service
public class Testing { 

 	 // 계정과목 소분류 넘기기
	 private HashMap<String, String> coahash = new HashMap<>();
	 
	 @Autowired
	 private CoadataRepository CoadataRepository;
	 
	 @Autowired
	 private ScopingdataRepository ScopingdataRepository;
	 
	 @Autowired
	 private TeamRepository teamrepository;

	 @Autowired
	 private Coa_processRepository coa_processrepository;
	 
	 @Autowired
	 private ProcessdataRepository processrepository;
	 
	 private List<String> resultcoa = new ArrayList<>();

     
	 // 상세질문지에 대한 검증기능 구현
	 // unitedata에 들어간다고 생각하자
	 
	 
	 // 1. select에 대한 검증기능
	 @Transactional
	 public boolean test_detail_select(String process, String option_name, String option) {
		 // 먼저 프로세스에 해당하는 변수 뽑기
		 basicdata basic = processrepository.findByProcessname1(process).get(0);
		 processoption prooption = basic.getProcessoption().stream().filter(base -> base.getRealname().equals(option_name)).collect(Collectors.toList()).get(0);
		 
		 List<String> opts = new ArrayList<>();
		 
		 test(prooption.getOption1(), opts);
		 test(prooption.getOption2(), opts);
		 test(prooption.getOption3(), opts);
		 test(prooption.getOption4(), opts);
		 test(prooption.getOption5(), opts);
		 
		 // option으로 받은 값이 포함되어 있는지 확인할 것
		 if(opts.contains(option) == true) {
			 return true;
		 }else {
			 return false;
		 }
	 }
	 
	 
	 // 2. selectplus에 대한 검증기능
	 @Transactional
	 public boolean test_detail_selectplus(String process, String option_name, List<String> options) {
		 // 먼저 프로세스에 해당하는 변수 뽑기
		 basicdata basic = processrepository.findByProcessname1(process).get(0);
		 processoption prooption = basic.getProcessoption().stream().filter(base -> base.getRealname().equals(option_name)).collect(Collectors.toList()).get(0);
		 
		 List<String> opts = new ArrayList<>();
		 
		 test(prooption.getOption1(), opts);
		 test(prooption.getOption2(), opts);
		 test(prooption.getOption3(), opts);
		 test(prooption.getOption4(), opts);
		 test(prooption.getOption5(), opts);
		 
		 // 첫번째 무조건 위의 opts에 포함되어야 함
		 for(String option : options) {
			 if(opts.contains(option) == false) {
				 return false;
			 }
		 }
		 
		 // options의 글은 중복되면 안됨
		 
		 Set<String> sets = options.stream().collect(Collectors.toSet());
		 
		 if(sets.size() != options.size()) {
			 return false;
		 }
		 
		 return true;
	 }
	 
	 
	 
	 public void test(String name, List<String> opts) {
		 if(name != null) {
			 opts.add(name);
		 }
	 }
	 
	 
	 
	 



}
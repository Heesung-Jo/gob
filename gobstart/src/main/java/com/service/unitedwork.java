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
import com.entity.answerstructure;
import com.entity.basequestion;
import com.entity.basicdata;
import com.entity.parentnodedata;
import com.entity.processdata;
import com.entity.processoption;
import com.entity.result_value;
import com.entity.uniteddata;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.repository.AnswerstructureRepository;
import com.repository.BasequestionRepository;
import com.repository.CoadataRepository;
import com.repository.ParentnodedataRepository;
import com.repository.ProcessdataRepository;
import com.repository.ProcessoptionRepository;
import com.repository.Result_valRepository;
import com.repository.ScopingdataRepository;
import com.repository.UniteddataRepository;

import javax.annotation.PostConstruct;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

@Service
public class unitedwork { 

	 private HashMap<String, String> coahash = new HashMap<>();
	 
	 @Autowired
	 private ProcessdataRepository processdatarepository;

	 @Autowired
	 private ProcessoptionRepository processoptionrepository;
	 
	 @Autowired
	 private ParentnodedataRepository ParentnodedataRepository;
	 
	 @Autowired
	 private AnswerstructureRepository answerstructurerepository;
	
	 @Autowired
	 private Result_valRepository Result_valRepository;

	 @Autowired
	 BasequestionRepository BasequestionRepository;

	 @Autowired
	 private UniteddataRepository uniteddatarepository;

	 
	 private List<String> resultcoa = new ArrayList<>();
	
		 
	 @Transactional
	 public void test() {
		 uniteddata da = uniteddatarepository.findByProcessname1("지출결의서 작성").get(0);
		 Set<uniteddata> da2 = da.getSubunite();
		 if(da2 != null) {
			 for(uniteddata tem : da2) {
				 System.out.println(tem.getid());
			 }
		 }
		 
	 }
	    
	 @Transactional
	 public void unite_data() throws JsonProcessingException, NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException{
		 
		 // 아래 수정이 필요함
		 // 이미 unite가 있는 경우는 추가로 데이터를 저장하는 것이 아니라
		 // update하도록 수정할 것
		 // 이건 단계에 한번만 이루어지는 것이므로, 이렇게 안하고 uniteddata를 삭제차고 새로 추가하는 방향으로 수정했음
		 
		 // uniteddata 삭제하기
		 List<uniteddata> datas = uniteddatarepository.findAll();
		 for(uniteddata das : datas) {
			 
			 ParentnodedataRepository.deleteAllInBatch(das.getparentnodedata());
			 
			 for(processoption opt : das.getProcessoption()) {

				 Result_valRepository.deleteAllInBatch(opt.getResult_value());
				 processoptionrepository.delete(opt);;
			 }
			 uniteddatarepository.delete(das);
		 }
		 
		 
		 // unite data 하기
		 List<String[]> processnames = processdatarepository.findmain_subprocess();
		 
		 // superpro_subpro uniteddata에 다가도 새롭게 매핑을 위해서, 만든 해쉬 
		 HashMap<uniteddata, processdata> realdata = new HashMap<>();
		 HashMap<processdata, uniteddata> realdata_oppt = new HashMap<>();
		 
		 // 각 데이터 조회하기
		 for(String[] pros : processnames) {
			 String main = pros[0];
			 String sub = pros[1];

			 List<basicdata> pro_list = processdatarepository.findByMainprocessAndSubprocess(main, sub);
			 List<answerstructure> ans = answerstructurerepository.findByMainprocess(main);
			 
			 // ans를 기준으로 processdate를 확장할 것(unite)
	    	 ObjectMapper mapper = new ObjectMapper();
	    	 JSONParser jsonParse = new JSONParser();	
          	 
	    	 System.out.println(ans.size());
	    	 
	    	 
	    	 
			 if(ans.size() > 0) {
				 
				 // 아래에 if문이 아닐때의 대칭구조가 있다는 것을 염두에 두고 수정을 해야함
				 for(answerstructure an : ans) {
					 for(processdata pro : pro_list) {
						 
						 // basic 데이터 복제해서, unitedata 만들기
						 String temp = mapper.writeValueAsString(pro);  
						 uniteddata uni = new uniteddata();
						 uni = mapper.readValue(temp, uniteddata.class);
						 uni.setSubprocesstype(an.getSubprocess1());
						 
						 // 담당자들 이름도 저장하기
						 uni.setPersoncharge(an.getPerson_charge());
						
						 System.out.println(uni.getProcessname1());
						 
						 // processoption 새롭게 저장하기
						 makeprooption2(pro, uni, an.getSubprocess1());
						 // 데이터 매핑 저장하기
						 realdata.put(uni, pro);
						 realdata_oppt.put(pro, uni);
						 // 최종적으로 저장하기
						 uniteddatarepository.save(uni);
					 }
				 }
			 }else {
				 
				 // 위의 대칭구조임
				 for(processdata pro : pro_list) {
					 String temp = mapper.writeValueAsString(pro);  
					 uniteddata uni = new uniteddata();
					 uni = mapper.readValue(temp, uniteddata.class);

					 // processoption 새롭게 저장하기
					 makeprooption(pro, uni);
					 // 데이터 매핑 저장하기
					 realdata.put(uni, pro);
					 realdata_oppt.put(pro, uni);
					 // 최종적으로 저장하기
					 uniteddatarepository.save(uni);
					 
				 }
				 
			 }
			 
			 // 그리고 포괄질문지에서 option에 영향을 미치는 것은 추후 추가해서 구현할 것
			 
		 }

		 
		 // realdata로 superpro_subpro 관계 새롭게 매핑하기
		 
		 for(uniteddata unite : realdata.keySet()) {
			 
			 processdata pro = realdata.get(unite);
			 Set<uniteddata> set_tem = new HashSet<>();
			 set_tem.add(unite);
		 	 
			// superpro 저장하기
			 if(pro.getSuperpro() != null) {
				 Set<uniteddata> set_uni = new HashSet<>();
				 
				 for(processdata tem : pro.getSuperpro()) {
					 uniteddata tem_uni = realdata_oppt.get(tem);
					 set_uni.add(tem_uni);
				 }
				 unite.setSuperunite(set_uni);
				 
				 for(uniteddata tem : set_uni) {
					 
					 Set<uniteddata> newtem = tem.getSubunite();
					 if(newtem != null) {
						 newtem.add(unite);
						 tem.setSubunite(newtem);
					 }else {
						 tem.setSubunite(set_tem);
					 }
					 
				 }
			 }

			 
			 // subpro 저장하기
		 
			 
			 uniteddatarepository.save(unite);

		 }
		 
		 realdata = null;
		 realdata_oppt = null;
		 
	 }	
	
	 
	@Transactional 
	public void makeprooption(processdata pro, uniteddata uni) throws JsonProcessingException {

		 ObjectMapper mapper = new ObjectMapper();
    	 JSONParser jsonParse = new JSONParser();	
         
    	 List<processoption> opts_new = new ArrayList<>();
		
		 List<processoption> opts = pro.getProcessoption();
		 System.out.println("makeprooption1");
		// 프로세스 옵션 처리하기
		 for(processoption opt : opts) {
			 processoption opt_new = new processoption();
			 
			 
			 // 여기서 앞단 개괄질문서에서 나온 데이터와 연동시켜서 값을 변하게 해서 최종적으로는 입력을 해줘야함.
			 String temp2 = mapper.writeValueAsString(opt);  
			 opt_new = mapper.readValue(temp2, processoption.class);
			 opt_new.setProcessdata(uni);
			 opts_new.add(opt_new);
			 processoptionrepository.save(opt_new);
		 }
		 
		 uni.setProcessoption(opts_new);
		
	}

	
	// 혹시 위의 것이 망가질까봐 2번째 함수로 추가 구현
	@Transactional 
	public void makeprooption2(processdata pro, uniteddata uni, String subtype) throws JsonProcessingException, NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {

		 ObjectMapper mapper = new ObjectMapper();
    	 JSONParser jsonParse = new JSONParser();	
         
    	 List<processoption> opts_new = new ArrayList<>();
		
		 List<processoption> opts = pro.getProcessoption();
		 System.out.println("makeprooption2");
		// 프로세스 옵션 처리하기
		 for(processoption opt : opts) {
			 processoption opt_new = new processoption();
			 
			 // 여기서 앞단 개괄질문서에서 나온 데이터와 연동시켜서 값을 변하게 해서 최종적으로는 입력을 해줘야함.
			 String temp2 = mapper.writeValueAsString(opt);  
			 opt_new = mapper.readValue(temp2, processoption.class);
			 
			 String name = opt_new.getRealname(); // 이 name을 basequestion의 필드 prooptionname에서 있는지 찾아야함
			 List<basequestion> bases = BasequestionRepository.findByProoptionname(name);
			 
			  
			 if(bases.size() > 0) {

				 basequestion base = bases.get(0);
				 String change = base.getProoptionchange();
				 List<String> anss = base.getAnswer().stream().filter(s -> s.getSubprocess1().equals(subtype) == true).map(s-> s.getVal()).collect(Collectors.toList());

				 if(anss.size() > 0) {
					 String ans = anss.get(0);

					 for(int i = 1; i < 10; i++) {
						 
						 processoption pros = new processoption();
						 pros.setOption1(subtype);
						 
						 String word = "getOption" + i;
						 Method me = processoption.class.getMethod(word);
						 Object temp = me.invoke(opt_new); 
						 if(temp == null) {
							 continue;
						 }else if(temp.toString().length() <= 1) {
							 continue;
						 }

						 String text = temp.toString();
						 
						 String realtext = text.replace(change, ans);
		                 
						 System.out.println(text + " => " + realtext);
						 
						 Class<?>[] parameterTypes = new Class[1];
						 parameterTypes[0] = String.class;

						 String word2 = "setOption" + i;
						 Method me2 = processoption.class.getMethod(word2, parameterTypes);
						 
						 Object parameter[] = new Object[1];
						 parameter[0] = realtext;
						 me2.invoke(opt_new, parameter); // text 내용을 갈아끼웠음
						 
					 }
				 
				 }
			 }
			 
			 opt_new.setProcessdata(uni);
			 opts_new.add(opt_new);
			 processoptionrepository.saveAndFlush(opt_new);
		 }
		 
		 uni.setProcessoption(opts_new);
		
	}	
	
	

}
package com.service; 


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.*;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.*;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.ModelAndView;

import com.entity.Scopingdata;
import com.entity.basemapping;
import com.entity.basequestion;
import com.entity.coa_process;
import com.entity.member;
import com.entity.roledata;
import com.entity.teamdata;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.repository.CoadataRepository;
import com.repository.MemberRepository;
import com.repository.ScopingdataRepository;
import com.repository.TeamRepository;

import javax.annotation.PostConstruct;
import com.repository.ProcessdataRepository;
import com.repository.AnswerstructureRepository;
import com.repository.BasemapRepository;
import com.repository.BasequestionRepository;
import com.repository.Coa_processRepository;



@Service
public class Scoping { 

 	 // 계정과목 소분류 넘기기
	 private HashMap<String, String> coahash = new HashMap<>();
	 private HashMap<String, String> coahashbs = new HashMap<>();
	 private HashMap<String, String> coahashpl = new HashMap<>();

	 
	 @Autowired
	 private CoadataRepository CoadataRepository;
	 
	 @Autowired
	 private ScopingdataRepository ScopingdataRepository;
	 
	 @Autowired
	 private MemberRepository memberrepository;

	 @Autowired
	 private TeamRepository teamrepository;
	 
	 @Autowired
	 private BasemapRepository basemaprepository;
	 
	 @Autowired
	 private BasequestionRepository BasequestionRepository;

	 @Autowired
	 private Coa_processRepository coa_processrepository;
	 
	 @Autowired
	 private jsonmake jsonmake;

	 @Autowired
	 private memberService memberService;

	 
	 @Autowired
	 private currentmanageservice currentmanageservice;

	 
	 private List<String> resultcoa = new ArrayList<>();

	 // 계정과목 소분류 세팅
	 @PostConstruct
	 public void settingresultcoa() throws ParseException{
		 resultcoa = CoadataRepository.findresultcoa();
		
	 }

	 
	 // 모든 파일 불러오기
	 public List<Scopingdata> findall(){
		 return ScopingdataRepository.findAll();
	 }
	 
	 public HashMap<String, String> findparameter(){
		 
		 HashMap<String, String> tem = new HashMap<>();
		 tem.put("bspl", "자산/부채");
		 tem.put("cashamount", "금액");
		 tem.put("coaname", "계정명");
		 tem.put("realcoaname", "표준계정명");
		 tem.put("process", "프로세스");
		 tem.put("materiality", "스코핑여부");
		 
		 return tem;
	 }
	 
	 
	 
	 
	 
	 // 매핑 관련 (팀, 문서, 시스템 등을 매핑하는 것임)
	 
	 // 메핑 데이터 불러오기
	 public List<String> findteamdata(){
		 
		 List<String> teams = new ArrayList<>();
		 
		 teamrepository.findAll().forEach(team -> {
			 teams.add(team.getTeamname());
		 });
		 return teams;
	 }
	 
	 public List<String> findgroupprocess(){
		 
		 return coa_processrepository.findgroupprocess();
	 }	 


	 public List<JSONObject> findmapping(String category) throws JsonProcessingException, ParseException{
		 
		 return jsonmake.processtojson3(basemaprepository.findByCategory(category));
	 }
	 
	 public List<JSONObject> findpersonmapping() throws JsonProcessingException, ParseException{
		 
		 return jsonmake.processtojson3(teamrepository.findAll());
	 }
	 
	 
	 
	 
	 
	 // 매핑 데이터 저장하기
	 @Transactional(rollbackFor = Exception.class)
	 public void save_basemap(HashMap<String, String> data) throws Exception{
		 System.out.println(data);
	     for(String str : data.keySet()) {
	    	 
	    	 /*
	    	 if(data.get(str).equals("") == true) {
	    		 throw new CustomException(str + " 값이 입력되지 않았습니다.");
	    	 }
	    	 */
	    	 
	    	 basemapping base = basemaprepository.findByQuestion(str).get(0);
	    	 base.setRealname(data.get(str));
	    	 basemaprepository.save(base);
	     }
	 }
	 
	 @Transactional(rollbackFor = Exception.class)
	 public void save_basemap_person(HashMap<String, String> data, String opt) throws Exception{
		 System.out.println(data);

		 for(String str : data.keySet()) {
	    	 /*
	    	 if(data.get(str).equals("") == true) {
	    		 throw new CustomException(str + " 값이 입력되지 않았습니다.");
	    	 }
	    	 */
	    	 teamdata team = teamrepository.findByTeamname(str).get(0);
	    	 
	    	 String realrole = "";
	    	 if(opt.equals("person") == true) {
		    	 realrole = team.getPerson_charge();
	    	 }else if(opt.equals("leader") == true) {
	    		 realrole = team.getPerson_confirm();
	    	 }

	    	 
	    	 List<String> roles = new ArrayList<>();  //mem.getRoledata();
	    	 roles.add(realrole);
	    	 member mem = memberrepository.findByRealname(data.get(str)).get(0);
	    	 memberService.savedata(mem, roles);
	    	 
	    	 
	     }
	 }

	 @Transactional(rollbackFor = Exception.class)
	 public void save_basemap_person2(HashMap<String, String> data, String opt) throws Exception{
		 System.out.println(data);

		 //basequestion에서 찾을 것
		 
		 for(String str : data.keySet()) {
	        /*	 
	    	 if(data.get(str).equals("") == true) {
	    		 throw new CustomException(str + " 값이 입력되지 않았습니다.");
	    	 }
	    	 */
			 
	    	 currentmanageservice.getManagemapping();
	    	 teamdata team = teamrepository.findByTeamname(str).get(0);
	    	 String process = team.getProcess();
	    	 
	    	 List<basequestion> questions = BasequestionRepository.findByMainprocess(process);
	    	 
	    	 questions.forEach(s -> {
	    		 s.setPerson_charge(data.get(str));
	    	 });
	    	 
	    	 BasequestionRepository.saveAll(questions);
	    	 
	     }
	 }	 
	 
	 @Transactional(rollbackFor = Exception.class)
	 public void save_baseteam(List<member> list) {
		 
		 System.out.println(list);
		 
		 for(member mem : list) {
			 List<member> tem = memberrepository.findByEmail(mem.getEmail());
			 
			 if(tem.size() == 0) {

		    	 List<String> roles = new ArrayList<>();  //mem.getRoledata();
		    	 roles.add("전체");

		    	 
		    	 
		    	 mem.setPassword("{noop}1234");
		    	 memberService.savedata(mem, roles);

			 }
		 }
		 
		 
	 }
	 

	 
 	 // 계정과목 소분류 넘기기
	 public List<String> findresultcoa(){
		 return resultcoa;
	 }

	 public List<Scopingdata> coa_pro_map(List<Scopingdata> data) {
		 
		 for(Scopingdata scope : data) {
			 String coa = scope.getRealcoaname();
			 List<coa_process> pros = coa_processrepository.findByRealcoa(coa);
			 if(pros.size() > 0) {
				 String pro = pros.get(0).getProcess();
				 scope.setProcess(pro);
			 }
			 
		 }
		 
		 return data;

	 }
	 
	 
	 // 데이터 저장
	 @Transactional
	 public void save(List<Scopingdata> data) {
		 
		 System.out.println("scopingmake2");
		 for(Scopingdata scope : data) {
			
			 String coaname = scope.getCoaname();
			 List<Scopingdata> temp = ScopingdataRepository.findByCoaname(coaname);
			 System.out.println("scopingmake3");
			 if(temp.size() > 0) {
				 System.out.println("수정");
				 Scopingdata real = temp.get(0);
				 scope.setId(real.getId());
				 real = scope;
			 }
			 ScopingdataRepository.save(scope);
		 }
		 currentmanageservice.getCurrentviewarr0().put("Scoping", "팀장승인필요");
	 }
	 
	 
	 // 계정과목 세팅
	 public JSONObject coatest(Set<String> strs) throws ParseException {
	         
	 	 // coa마다 정규식 매칭을 시켜서, 포함되는 coa를 포함시킬 것
	 	 JSONObject result = new JSONObject();
     	 JSONObject faillist = new JSONObject();
     	 JSONObject afterresult = new JSONObject();
	 	 for(String str : strs) {
	 		 if(coahash.containsKey(str)) {
	 			 result.put(str, coahash.get(str));
	 		 }else {
	 			 faillist.put(str, 1);
	 		 }	 
	 	 }
		 
		  // faillist를 파이썬 서버에 요청할 것
		  afterresult = flaskrequest(faillist);
		  for(Object str : afterresult.keySet()) {
			  result.put(str.toString(), afterresult.get(str));
		  }
		  
		  System.out.println(result);
          return result;
	 }
		
	 // 계정과목 세팅 bs/pl 구분을 위해서 추가로 overload했음
	 public JSONObject coatest_bspl(HashMap<String, String> strs) throws ParseException {
	         
	 	 // coa마다 정규식 매칭을 시켜서, 포함되는 coa를 포함시킬 것
	 	 JSONObject result = new JSONObject();

	 	 JSONObject faillist_bs = new JSONObject();
     	 JSONObject faillist_pl = new JSONObject();
     	 JSONObject afterresult_bs = new JSONObject();
     	 JSONObject afterresult_pl = new JSONObject();

     	 for(String str : strs.keySet()) {
	 		 
	 		
	 		 if(strs.get(str).equals("BS") == true) {
		 		 if(coahashbs.containsKey(str)) {
		 			 result.put(str, coahashbs.get(str));
		 		 }else {
		 			 faillist_bs.put(str, 1);
		 		 }	 
	 			 
	 		 }
	 		 
	 		 if(strs.get(str).equals("PL") == true) {
		 		 if(coahashpl.containsKey(str)) {
		 			 result.put(str, coahashpl.get(str));
		 		 }else {
		 			 faillist_pl.put(str, 1);
		 		 }	 
	 			 
	 		 }
	 	 }
		 
		  // faillist를 파이썬 서버에 요청할 것
		  afterresult_bs = flaskrequest_opt(faillist_bs, "bs");
		  afterresult_pl = flaskrequest_opt(faillist_pl, "pl");
		  
		  
		  for(Object str : afterresult_bs.keySet()) {
			  result.put(str.toString(), afterresult_bs.get(str));
		  }
		  for(Object str : afterresult_pl.keySet()) {
			  result.put(str.toString(), afterresult_pl.get(str));
		  }
		  
          return result;
	 }	 
	 
	 
	 public JSONObject flaskrequest(JSONObject faillist) throws ParseException{
		  // 데이터마이닝 위하여 파이썬 플라스크를 사용하였음
			
		String url = "http://localhost:5000/testcoa";
		String sb = "";
		try {
			
	        Map<String,Object> params = new LinkedHashMap<>(); // 파라미터 세팅
	        params.put("coa", faillist);
	 
	        StringBuilder postData = new StringBuilder();
	        for(Map.Entry<String,Object> param : params.entrySet()) {
	            if(postData.length() != 0) postData.append('&');
	            postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
	            postData.append('=');
	            postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
	        }
	        byte[] postDataBytes = postData.toString().getBytes("UTF-8");
	 
	        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
	        conn.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
	        conn.setDoOutput(true);
	        conn.getOutputStream().write(postDataBytes); // POST 호출

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));

			String line = null;

			while ((line = br.readLine()) != null) {
				sb = sb + line + "\n";
			}
			
			br.close();
          
		   } catch (MalformedURLException e) {
			   e.printStackTrace();
		   } catch (IOException e) {
			   // TODO Auto-generated catch block
			   e.printStackTrace();
		   }

		JSONObject realdata = new JSONObject();
		JSONParser jsonParse = new JSONParser();
		realdata = (JSONObject) jsonParse.parse(sb.toString());
		System.out.println(realdata);
		return realdata; 
	 }

	 public JSONObject flaskrequest_opt(JSONObject faillist, String opt) throws ParseException{
		  // 데이터마이닝 위하여 파이썬 플라스크를 사용하였음
		  // opt는 bs인지 pl인지로 구분됨
			
		String url = "http://localhost:5000/testcoa" + opt;
		String sb = "";
		try {
			
	        Map<String,Object> params = new LinkedHashMap<>(); // 파라미터 세팅
	        params.put("coa", faillist);
	 
	        StringBuilder postData = new StringBuilder();
	        for(Map.Entry<String,Object> param : params.entrySet()) {
	            if(postData.length() != 0) postData.append('&');
	            postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
	            postData.append('=');
	            postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
	        }
	        byte[] postDataBytes = postData.toString().getBytes("UTF-8");
	 
	        HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
	        conn.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
	        conn.setDoOutput(true);
	        conn.getOutputStream().write(postDataBytes); // POST 호출

			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));

			String line = null;

			while ((line = br.readLine()) != null) {
				sb = sb + line + "\n";
			}
			
			br.close();
         
		   } catch (MalformedURLException e) {
			   e.printStackTrace();
		   } catch (IOException e) {
			   // TODO Auto-generated catch block
			   e.printStackTrace();
		   }

		JSONObject realdata = new JSONObject();
		JSONParser jsonParse = new JSONParser();
		realdata = (JSONObject) jsonParse.parse(sb.toString());
		System.out.println(realdata);
		return realdata; 
	 }	 
	 
	 

}
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
import com.entity.childnodedata;
import com.entity.coa_process;
import com.entity.parentnodedata;
import com.entity.processdata;
import com.entity.processoption;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.repository.CoadataRepository;
import com.repository.ScopingdataRepository;
import com.repository.TeamRepository;

import javax.annotation.PostConstruct;
import com.repository.ProcessdataRepository;
import com.repository.AnswerstructureRepository;
import com.repository.Coa_processRepository;


@Service
public class jsonmake { 

 	 // 계정과목 소분류 넘기기
	 private HashMap<String, String> coahash = new HashMap<>();
	 
     
	 // 상세질문지에 대한 검증기능 구현
	 // unitedata에 들어간다고 생각하자
	 
	 
	    // json 변환
	    // 제네릭 관련해서는 function은 이렇게 사용하고 클래스에는 아래와 같이 사용함
	    /*
	      public class World<T, S> {
	           private T data;
	           private S data2;
	      }
	     */
	    
	    @Transactional
		public <T> List<JSONObject> processtojson3(List<T> arr) throws JsonProcessingException, ParseException  {
	        

	     	List<JSONObject> realdata = new ArrayList<>();
	   	    JSONParser jsonParse = new JSONParser();

	    	for(T item : arr) {
	    		ObjectMapper mapper = new ObjectMapper();
	    		
	    		System.out.println(item.toString());
	        	String temp = mapper
	    			 .writeValueAsString(item);   // 반대의 경우임 => mapper.readValue(null, null)
	    	    //mapper.setVisibility(PropertyAccessor.FIELD, Visibility.ANY);
	    	    JSONObject jsonObj = (JSONObject) jsonParse.parse(temp);
	    	    realdata.add(jsonObj);
	    		
	    	}
	    	
	    	return realdata;
	    }
	    

	    @Transactional
		public <T> JSONObject processtojson3(T item) throws JsonProcessingException, ParseException  {
	        
	 
	   	    JSONParser jsonParse = new JSONParser();

	    		ObjectMapper mapper = new ObjectMapper();
	    		
	    		System.out.println(item.toString());
	        	String temp = mapper
	    			 .writeValueAsString(item);   // 반대의 경우임 => mapper.readValue(null, null)
	    	    //mapper.setVisibility(PropertyAccessor.FIELD, Visibility.ANY);
	    	    JSONObject jsonObj = (JSONObject) jsonParse.parse(temp);

	    	return jsonObj;
	    }
	    
	    
	    
	    @Transactional
		public JSONObject processtojson2(List<basicdata> arr) throws JsonProcessingException, ParseException  {

	    	 System.out.println(arr);
	    	 JSONObject realdata = new JSONObject();
	    	 JSONParser jsonParse = new JSONParser();
	    	 
	         for(processdata pro : arr) {
	        	 ObjectMapper mapper = new ObjectMapper();
	        	 String temp = mapper
	        			 .writeValueAsString(pro);   // 반대의 경우임 => mapper.readValue(null, null)
	        	 //mapper.setVisibility(PropertyAccessor.FIELD, Visibility.ANY);
	        	 JSONObject jsonObj = (JSONObject) jsonParse.parse(temp);

	        	 // 프로세스 옵션 집어넣기
	        	 System.out.println(pro.getid());
	             HashMap<String, JSONObject> prooption = new HashMap<>();   
	             
	             if(pro.getProcessoption().size() > 0) {
	                 for(processoption opt : pro.getProcessoption()) {
	                	 String temp2 = mapper.writeValueAsString(opt);        		     
	                	 JSONObject jsonObj2 = (JSONObject) jsonParse.parse(temp2);
	                	 prooption.put((String) jsonObj2.get("realname"), jsonObj2);
	                	 
	                	 // 나중에 여러개 있는 것도 있으면 확장을 해야함
	                	 if(opt.getResult_value().size() > 0) {
		                	 jsonObj2.put("resultval", opt.getResult_value().get(0));
	                	 }else {
	                		 jsonObj2.put("resultval", "미완성");
	                	 }
	                	 
	        	     }
	             }

	        	 jsonObj.put("processoption", prooption);

	        	 
	        	 
	        	 // superpro 집어넣기
	        	 Set<processdata> pro_temp = pro.getSuperpro();
	        	 if(pro_temp != null) {
	        		 ArrayList<String> tem = new ArrayList<>();
	        		 for(processdata pro_tem : pro_temp) {
	            		 tem.add(pro_tem.getProcessname1());
	        		 }
	            	 jsonObj.put("superpro", tem);

	        	 }

	        	// subpro 집어넣기
	        	 Set<processdata> pro_temp2 = pro.getSubpro();
	        	 if(pro_temp2 != null) {
	        		 ArrayList<String> tem = new ArrayList<>();
	        		 for(processdata pro_tem : pro_temp2) {
	            		 tem.add(pro_tem.getProcessname1());
	        		 }
	            	 jsonObj.put("subpro", tem);

	        	 }

	        	 
	        	 // 부모 데이터 집어넣기
	        	 
	             List<String> parent = new ArrayList<>();        	 
	             if(pro.getparentnodedata().size() > 0) {
	                 for(parentnodedata pa : pro.getparentnodedata()) {
	        		     parent.add(pa.getname());
	        	     }
	             }

	        	 jsonObj.put("parentnodedata", parent);

	        	 // 자식 데이터 집어넣기
	        	 
	             List<String> child = new ArrayList<>();
	             
	             if(pro.getchildnodedata().size() > 0) {
	            	 for(childnodedata ch : pro.getchildnodedata()) {
	            		 child.add(ch.getname());
	            	 }
	             }
	             
	        	 jsonObj.put("childnodedata", child);
	        	 
	        	 

	        	 System.out.println(jsonObj);
	        	 realdata.put(pro.getProcessname1(), jsonObj);
	         }
	         
	         return realdata;
	    }
	    
	    @Transactional
		public JSONObject processtojson(List<basicdata> arr) {
			
	    	// 지금 연산이 개별 건바이 건으로 조회하고 있는 것 같음 즉 최악의 쿼리인듯 하니 고민할 것
			JSONObject realdata = new JSONObject();
			JSONObject temp = new JSONObject();
			System.out.println(arr.size());
			
			for(processdata pro : arr) {
			
				temp.put("name", pro.getname());
				temp.put("companyname", pro.getcompanyname());
				System.out.println(pro.getcompanyname());
				
				temp.put("controlexplain", pro.getcontrolexplain());
				temp.put("controlname", pro.getcontrolname());
				temp.put("detailprocess", pro.getdetailprocess());
				temp.put("detailprocessname", pro.getdetailprocessname());
				temp.put("businesscode", pro.getbusinesscode());
				temp.put("processexplain", pro.getprocessexplain());
				temp.put("processname", pro.getprocessname());
				temp.put("team", pro.getteamdata().get(0).getTeamname());
				
				ArrayList<String> childs = new ArrayList<>();
				for(childnodedata data : pro.getchildnodedata()) {
					childs.add(data.getname());
					
				}
				temp.put("next", childs); 
				System.out.println(childs);
				
				ArrayList<String> pas = new ArrayList<>();
				for(parentnodedata data : pro.getparentnodedata()) {
					pas.add(data.getname());
				}
				temp.put("before", pas); 

				
				realdata.put(pro.getcontrolname(), temp);

				
			}
			return realdata;
		}



}
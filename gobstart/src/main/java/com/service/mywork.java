package com.service; 

 import javax.persistence.DiscriminatorValue; 
import javax.persistence.Entity; 

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import javax.persistence.Column;
import javax.persistence.DiscriminatorColumn;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.formula.functions.T;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.json.simple.JSONArray;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.stereotype.*;
import org.springframework.transaction.annotation.Transactional;


import com.entity.processdata;
import com.entity.processoption;
import com.entity.result_value;
import com.entity.teamdata;
import com.entity.uniteddata;
import com.enumfolder.Role;
import com.fasterxml.jackson.annotation.JsonAutoDetect.Visibility;
import com.fasterxml.jackson.annotation.PropertyAccessor;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.entity.nodedata;
import com.entity.parentnodedata;
import com.entity.childnodedata;
import com.entity.currentmanage;
import com.entity.member;
import com.repository.ParentnodedataRepository;
import com.repository.ProcessdataRepository;
import com.repository.TeamRepository;
import com.repository.RoleRepository;
import com.repository.ProcessoptionRepository;
import com.repository.UniteddataRepository;
import com.repository.Result_valRepository;
import com.repository.CurrentmanageRepository;

import com.entity.answerlist;
import com.entity.answerstructure;
import com.entity.basequestion;
import com.entity.basicdata;
import com.repository.BasequestionRepository;
import com.repository.Coa_processRepository;
import com.repository.AnswerlistRepository;
import com.repository.AnswerstructureRepository;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import javax.annotation.PostConstruct;
import javax.inject.Inject;


// jsp?????? ?????? ????????? ??????????????? ??????????????????, submit??? ?????????, ajax ????????? ??????????????? ????????? ???

@Service
public class mywork<E> { 


	private HashMap<String, ArrayList<String>> coaarray_bs = new LinkedHashMap<>(); 
	private HashMap<String, String> oppositecoa_bs = new LinkedHashMap<>(); 
	private HashMap<String, ArrayList<String>> coaarray_is = new LinkedHashMap<>(); 
	private HashMap<String, String> oppositecoa_is = new LinkedHashMap<>(); 
	private HashMap<String, HashMap<String, String>> processmap = new LinkedHashMap<>(); 
	private HashMap<String, HashMap<String, ArrayList<String>>> processinmap = new LinkedHashMap<>(); 
	

	
	private HashMap<String, String> processteammap = new LinkedHashMap<>();
	private HashMap<String, ArrayList<String>> coaprocessmap = new LinkedHashMap<>();

	private HashMap<String, String> teamteam1map = new LinkedHashMap<>();
	private HashMap<String, ArrayList<String>> teamteam2map = new LinkedHashMap<>();

	@Autowired
	private UserContext userContext;
	
	
	@Autowired
	private ProcessdataRepository processrepository;

	@Autowired
	private TeamRepository teamrepository;
	
	@Autowired
	private ProcessoptionRepository ProcessoptionRepository;
	
	@Autowired
	private ParentnodedataRepository parentnodedataRepository;
 	
	@Autowired
	private BasequestionRepository BasequestionRepository;

	@Autowired
	private AnswerstructureRepository AnswerRepository;

	@Autowired
	private AnswerlistRepository AnswerlistRepository;

	@Autowired
	private Coa_processRepository coa_processrepository;
    
	@Autowired
	private UniteddataRepository UniteddataRepository;

	
	@Autowired
	private Result_valRepository Result_valRepository;
	
	@Autowired
	private jsonmake jsonmake;

	@Autowired
	private CurrentmanageRepository CurrentmanageRepository;

	
	@Autowired
	private currentmanageservice currentmanageservice;

	
	public void mywork() { 
    	
    } 

	
	/* ????????????
	<li><a href="Scoping">Scoping</a></li>
	<li><a href="basemapping">?????? ??????</a></li>
	<li><a href="basestructure">???????????? ?????????</a></li>
	<li><a href="basequestion">???????????????</a></li>
	<li><a href="gojs_work">???????????????</a></li>
	<li><a href="gojs9">???????????????</a></li>
	<li><a href="explanation">????????????</a></li>
	*/
	

	
	
    public void save(processdata pro) {
    	processrepository.save(pro);
    }
    
 
    
    
    // ?????? ?????? ????????? ???????????? ????????? ????????? ???????????? ???????????? ????????? ?????? ??????????????? ????????? 
    public void confirm_scoping() {
    	
    }
    
    
    
    
    // processoption ????????????
    @Transactional
    public void process_answer(HashMap<String, List<String>> datas, String process){

		uniteddata pro =  UniteddataRepository.findByProcessname1(process).get(0);
		pro.getProcessoption().forEach((opt) -> {
	    	for(String str : datas.keySet()) {
	    		if(opt.getRealname().equals(str) == true) {
	    			
	    			
		    		List<String> vals = datas.get(str);
	    			List<result_value> result_val = new ArrayList<>();
		    		System.out.println(vals);
		    		
		    		for(String val : vals) {
		    			result_value tem = new result_value();
		    			tem.setVal(val);
		    			tem.setProcessoption(opt);
		    			result_val.add(tem);
		    		}
	    			
		    		Result_valRepository.deleteAllInBatch(opt.getResult_value());
	    			opt.getResult_value().addAll(result_val);
	    		}
	    	}
		});

		processrepository.save(pro);
    	
    }
    
    
    
    // processdata ????????????
    @Transactional
    public JSONObject getprocessquery(ArrayList<String> names, ArrayList<String> paras){
    	return processlist(processrepository.getprocessquery(names, paras));
    }
    @Transactional
    public JSONObject getprocessquery(String name1, String name2, String para1, String para2){
    	return jsonmake.processtojson(processrepository.getprocessquery(name1, name2, para1, para2));
    }
    @Transactional
    public JSONObject getprocessquery(String name, String para){
    	
    	return processlist(processrepository.getprocessquery(name, para));
    	
    }
    
    
    
    
    
    

    @Transactional
    public List<JSONObject> get_exist_subprocess2(String name1, String name2) throws JsonProcessingException, ParseException{

    	List<answerstructure> arrlist = AnswerRepository.findByMainprocessAndSubprocess1(name1, name2).stream().filter((pros) -> 
    		pros.getSubprocess2() != null 
    	).collect(Collectors.toList());
    	
    	return jsonmake.processtojson3(arrlist);
    	
    }

    
    
    //  
    public List<String> findstartlist(){
    	
    	return parentnodedataRepository.findstartlist().stream().collect(Collectors.toList());
    	
    }

    
    public List<String> findstartlist(member user){
    	
    	return parentnodedataRepository.findstartlist().stream().filter(s -> 
    		UniteddataRepository.findByProcessname1(s).get(0).getPersoncharge().equals(user.getRealname())
        ).collect(Collectors.toList());
    	
    }
    
    // ????????? ?????????????????? ???????????? ????????? ?????? ??????   
    public Set<String> findbasestartlist(){
    	
    	// ?????? ??????????????? ?????? ???????????? ???
    	List<String> pros = coa_processrepository.findgroupprocess();
    	Set<String> data = new HashSet<>();

	    member user = userContext.getCurrentUser();
    	
    	BasequestionRepository.findAll().forEach((base) -> {
    		if(base.getPerson_charge().equals(user.getRealname()) == true) {
    			data.add(base.getMainprocess());
    		}
    	});
    	System.out.println(pros);
    	System.out.println(data);
    	
    	return data;
    }


    public List<JSONObject> findstructurebasestartlist(String name) throws JsonProcessingException, ParseException{
    	
    	List<answerstructure> answerlist =  AnswerRepository.findByStep("0");
    	
    	return jsonmake.processtojson3(answerlist);
    }

    
    public List<basequestion> findrelatedbasequestion(String name){
    	return BasequestionRepository.findByMainprocess(name);
    }	
    
    
    public List<JSONObject> findstep0(String step0) throws JsonProcessingException, ParseException{

    	System.out.println(step0);
    	
    	// ?????? step0, "0"??? ?????? ????????? 1????????? ???????????? ??????????????????, ????????? ????????? ???????????? ????????? ?????????
    	List<basequestion> bases = BasequestionRepository.findByMainprocessAndSubprocess(step0, "0");
    	
    	List<answerstructure> ans = AnswerRepository.findByMainprocessAndStep(step0, "0");
    	
    	List<JSONObject> jsonlist = jsonmake.processtojson3(bases);
    	if(ans.size() > 0) {
    		List<JSONObject> json_ans = jsonmake.processtojson3(ans);
        	jsonlist.get(0).put("answer", json_ans);
    	}
    	
    	System.out.println(jsonlist);
    	
        return jsonlist;
    }

    public JSONObject findstep2(String mainprocess, String subprocess) throws JsonProcessingException, ParseException{

    	System.out.println(subprocess);
    	System.out.println(mainprocess);
    	// ?????? step0, "0"??? ?????? ????????? 1????????? ???????????? ??????????????????, ????????? ????????? ???????????? ????????? ?????????
    	List<basequestion> bases = BasequestionRepository.findByMainprocessAndSubprocess(mainprocess, "2");
    	JSONObject totaljson = new JSONObject();
    	
    	for(basequestion base : bases) {
        	ArrayList<JSONObject> jsonlist = new ArrayList<>();
        	
        	JSONObject json_base = jsonmake.processtojson3(base);
    		List<answerlist> anlist = base.getAnswer();
    		for(answerlist an : anlist) {
    			if(an.getSubprocess1().equals(subprocess)) {
    				JSONObject json = jsonmake.processtojson3(an);
    				jsonlist.add(json);
    			}
    		}
    		
    		json_base.put("answer", jsonlist);
    		totaljson.put(json_base.get("realname"), json_base);
    	}
    	
        return totaljson;
    }    
    
    
    public ArrayList<JSONObject> findnextstep(String process, String grade) throws JsonProcessingException, ParseException{

    	List<basequestion> bases = BasequestionRepository.findByMainprocessAndSubprocess(process, grade);
    	
    	ArrayList<JSONObject> answerlist = new ArrayList<>();
    	
    	for(basequestion que : bases) {
    		
    		JSONObject json = jsonmake.processtojson3(que);
        	List<answerlist> templist = que.getAnswer();
        	
        	if(templist.size() > 0) {
        		json.put("answer" , jsonmake.processtojson3(templist));
        	}
        	
        	answerlist.add(json);
    	}
    	
    	return answerlist;
    }	
    
    
    public ArrayList<uniteddata> findrelatedstart(String name){
    	
    	ArrayList<uniteddata> child = UniteddataRepository.findByProcessname1(name); 
    	System.out.println(name);
    	ArrayList<uniteddata> arr_return = new ArrayList<>();
    	Set<uniteddata> childs = new HashSet<>();
    	for(uniteddata chi : child) {
    		childs.add(chi);
    		arr_return.add(chi);
    		break;
    	}
    	
        int size = 1;
    	//211128 ?????? manytomany??? ???????????? ????????? ?????????
    	while(size == 1) {
    		
    		Set<uniteddata> next_arr = new HashSet<>();
    		if(childs.size() > 0) {
    			
               for(uniteddata chi : childs) {
            	   System.out.println(chi.getProcessname1());
            	   for(processdata ch : chi.getSuperpro()) {
            		   System.out.println("sub?????????");
            		   System.out.println(ch.getProcessname1());
                	   if(arr_return.contains(ch) == false) {
                		   next_arr.add((uniteddata) ch);
                		   arr_return.add((uniteddata) ch);
                	   }
            	   };
               }
               System.out.println(next_arr.size());
               childs = next_arr;
               if(next_arr.size() == 0) {
            	   size = 0;
            	   break;
               }
               
    		}else {
    			size = 0;
    			break;
    		}
    	}
    	
    	return arr_return;
    }
    
    public JSONObject findByName(String name) throws JsonProcessingException, ParseException{
    	return jsonmake.processtojson2(processrepository.findByProcessname1(name));
    }
    
    
    public processdata findByName2(String name) {
    	return processrepository.findByProcessname1(name).get(0);
    }
    
    
    
    
    
    // teamdata ??????
    
    // ????????? ????????? ?????? ???????????? ??? ??????. ????????? ?????? ???????????? ????????? ?????????
    public ArrayList<String> findwork(String name){
    	
    	System.out.println(name);
    	List<teamdata> teams = teamrepository.findByTeamname(name);
    	
    	ArrayList<String> process = new ArrayList<>();
    	
    	for(teamdata team : teams) {
    	    String temp = team.getProcessdata().getsubprocess();
    	
   		    if(process.contains(temp) == false) {
    			process.add(temp);
    		}
    	}
    	
    	return process;
    }
    
    public Set<String> findwork_person(String name){
    	
        
    	Set<String> process = UniteddataRepository.findByPersoncharge(name).stream().map(s -> s.getsubprocess()).collect(Collectors.toSet());
    	
    	return process;
    }

    
    
    // ?????????????????? answer ????????????
    @Transactional
	public void baseanswer(String name1, String name2, JSONObject answer)  {
        
    	// ????????? ?????? ?????? 0?????? ???????????? ??????.
    	basequestion question = BasequestionRepository.findByMainprocessAndSubprocess(name1, name2.toString()).get(0);

    	// ?????? item ?????????
    	List<answerstructure> current_ans = AnswerRepository.findByMainprocessAndStep(question.getMainprocess(), "0");
    	
    	for(answerstructure an : current_ans) {
    		for(answerlist ans : an.getAnswer()) {
        		AnswerlistRepository.delete(ans);
    		}
    		AnswerRepository.delete(an);
    	}
    	
    	// AnswerRepository.deleteAllInBatch(current_ans);

    	// ???????????? item?????? ???????????????

    	ArrayList<answerstructure> answerstructure = new ArrayList<>();

    	for(Object s : answer.keySet()) {

       		answerstructure ans1 = new answerstructure();
    		ans1.setMainprocess(name1);
    		ans1.setSubprocess1(s.toString());
    		ans1.setPerson_charge(answer.get(s.toString()).toString());
    		ans1.setCurrentgrade("?????????");
       		ans1.setVal(s.toString());
       		ans1.setStep("0");
       		answerstructure.add(ans1);
    	}
    	
    	question.setCurrentgrade("???????????????");
   		AnswerRepository.saveAll(answerstructure);
    	BasequestionRepository.save(question);
    }

    @Transactional
	public List<JSONObject> baseinventoryquestion() throws JsonProcessingException, ParseException {
		List<basequestion> que = BasequestionRepository.findByMainprocessAndSubprocess("????????????", "1");
    	return jsonmake.processtojson3(que);
    }
    
    @Transactional
	public void baseanswer_step2(String mainprocess, String subprocess, HashMap<String, String> answer) throws ParseException  {
        
    	// ?????? ??? ????????? ?????? 0??? ?????? ?????? ?????? ????????? ???????????? ??????.

    	// ?????? item ?????????findByMainprocessAndSubprocess1
    	answerstructure ans = AnswerRepository.findByMainprocessAndSubprocess1AndStep(mainprocess, subprocess, "0").get(0);
    	System.out.println(mainprocess);
    	System.out.println(subprocess);
    	List<answerlist> anlist = AnswerlistRepository.findByMainprocessAndSubprocess1AndStep(mainprocess, subprocess, "2");
		if(anlist.size() > 0) {
    	    AnswerlistRepository.deleteAllInBatch(anlist);
		}
		
    	for(Object name : answer.keySet()) {
    		
    		basequestion question = BasequestionRepository.findByRealname(name.toString());

    	    // ?????? ????????????
    		JSONParser parser = new JSONParser();
        	ArrayList<answerlist> answerlist = new ArrayList<>();
        	
        	// ???????????? item?????? ???????????????
    		JSONObject data = (JSONObject) parser.parse(answer.get(name).toString());
        	for(Object s : data.values()) {
            	ArrayList<answerstructure> answerstructure = new ArrayList<>();
                System.out.println(s);
        		answerlist ans0 = new answerlist();
        		ans0.setMainprocess(ans.getMainprocess());
        		ans0.setSubprocess1(ans.getSubprocess1());
        		
           		ans0.setVal(s.toString());
           		ans0.setStep(question.getSubprocess());
           		answerlist.add(ans0);
        	}

        	ans.setAnswer(answerlist);
       		question.setAnswer(answerlist);

        	AnswerlistRepository.saveAll(answerlist);
        	BasequestionRepository.save(question);    		
    		
    	}
    	
    	ans.setCurrentgrade("???????????????");
    	AnswerRepository.save(ans);
    	
    	
    	
    	
    }    

    @Transactional
	public void baseanswer_step3(String subprocess, HashMap<String, String> answer) throws ParseException  {
        
    	// ????????? ??? ????????? ?????? ???????????? ????????? ???????????? ??????.
    	// ?????? item ?????????
		
 		List<answerstructure> ans = AnswerRepository.findByMainprocessAndSubprocess1("????????????", subprocess);

 		System.out.println(subprocess);
 		
        for(answerstructure an : ans) {
        	String abc = an.getSubprocess2();
        	if(abc != null) {
                
        		List<answerlist> anlist = an.getAnswer();
        		if(anlist.size() > 0) {
        			for(answerlist answer1 : anlist) {
                    	AnswerlistRepository.delete(answer1);
        			}
        		}
        		
                AnswerRepository.delete(an);
        	}
        }

    	
    	for(Object name : answer.keySet()) {


            //?????? ????????????        	
        	
    		JSONParser parser = new JSONParser();
        	ArrayList<answerstructure> list = new ArrayList<>();
        	
        	// ???????????? item?????? ???????????????
    		JSONObject data = (JSONObject) parser.parse(answer.get(name).toString());
    		
    		if(data.values().size() > 0) {
            	for(Object s : data.values()) {
                    System.out.println(s);
                    answerstructure ans0 = new answerstructure();
            		ans0.setMainprocess("????????????");
            		ans0.setSubprocess1(subprocess);
            		
            		JSONObject temp = (JSONObject) s;
               		ans0.setSubprocess2(temp.get("from").toString());
               		ans0.setSubprocess3(temp.get("to").toString());
               		list.add(ans0);
            	}
    		}else {
                answerstructure ans0 = new answerstructure();
        		ans0.setMainprocess("????????????");
        		ans0.setSubprocess1(subprocess);
           		ans0.setSubprocess2(name.toString());
           		list.add(ans0);    			
    		}

        	AnswerRepository.saveAll(list);
    		
    	}
    }  
    
    @Transactional
	public void baseanswer_final(String pro1, String pro2, String pro3, HashMap<String, String> answer) throws ParseException  {
        
    	// ?????? ??? ????????? ?????? 1??? ?????? ?????? ?????? ????????? ???????????? ??????. ??? ?????? ?????????
		answerstructure ans = AnswerRepository.findByMainprocessAndSubprocess1AndSubprocess2AndSubprocess3("????????????", pro1, pro2, pro3).get(0);
    	// ?????? item ?????????
		
		List<answerlist> anlist = ans.getAnswer();
		
		if(anlist.isEmpty() == false) {
        	AnswerlistRepository.deleteAllInBatch(anlist);
		}

		System.out.println("??????????????? ??????");
    	for(Object name : answer.keySet()) {
    		
    		basequestion question = BasequestionRepository.findByRealname(name.toString());
 
        	// ?????? ????????????
    		JSONParser parser = new JSONParser();
        	ArrayList<answerlist> answerlist = new ArrayList<>();
        	
        	// ???????????? item?????? ???????????????
    		JSONObject data = (JSONObject) parser.parse(answer.get(name).toString());
        	for(Object s : data.values()) {
            	ArrayList<answerstructure> answerstructure = new ArrayList<>();
                System.out.println(s);
        		answerlist ans0 = new answerlist();
        		ans0.setMainprocess(ans.getMainprocess());
        		ans0.setSubprocess1(ans.getSubprocess1());
        		ans0.setSubprocess2(ans.getSubprocess2());
        		ans0.setSubprocess3(ans.getSubprocess3());
           		ans0.setVal(s.toString());
           		ans0.setStep(question.getSubprocess());
           		answerlist.add(ans0);
        	}

        	ans.setAnswer(answerlist);
       		question.setAnswer(answerlist);

        	AnswerlistRepository.saveAll(answerlist);
        	BasequestionRepository.save(question);    		
    		
    	}

    	ans.setCurrentgrade("???????????????");
    	AnswerRepository.save(ans);

    }  
    
    
    
    
    


    @Transactional
	public JSONObject processlist(List<basicdata> arr) {

		JSONObject realdata = new JSONObject();
		JSONObject childdata = new JSONObject();
		JSONObject padata = new JSONObject();
		
		
		System.out.println(arr.size());
		
		for(processdata pro : arr) {
			JSONObject temp = new JSONObject();
			temp.put("name", pro.getname());
			temp.put("companyname", pro.getcompanyname());
			System.out.println(pro.getdetailprocessname());
			
			temp.put("controlexplain", pro.getcontrolexplain());
			temp.put("controlname", pro.getcontrolname());
			temp.put("detailprocess", pro.getdetailprocess());
			temp.put("detailprocessname", pro.getdetailprocessname());
			temp.put("businesscode", pro.getbusinesscode());
			temp.put("processexplain", pro.getprocessexplain());
			temp.put("processname", pro.getprocessname());
			temp.put("team", pro.getteamdata().get(0).getTeamname());

			JSONArray childs = new JSONArray();
			for(childnodedata data : pro.getchildnodedata()) {
				childs.add(data.getname());
			}
			

			JSONArray pas = new JSONArray();
			for(parentnodedata data : pro.getparentnodedata()) {
				pas.add(data.getname());
			}

			childdata.put(pro.getdetailprocessname(), childs);
			padata.put(pro.getdetailprocessname(), pas);
			realdata.put(pro.getdetailprocessname(), temp);
			
		}

		realdata.put("child", childdata);
		realdata.put("parent", padata);

		System.out.println(realdata);
		return realdata;
	}
	
	
    
    // ??????, array ?????? get, set???
    
    public HashMap<String, String> getoppositecoa(String opt){
    	if(opt.equals("BS") == true) {
    		return oppositecoa_bs;
    	}else {
    		return oppositecoa_is;
    	}
    }


    public HashMap<String, ArrayList<String>> getcoaarray(String opt){
    	if(opt.equals("BS") == true) {
    		return coaarray_bs;
    	}else {
    		return coaarray_is;
    	}
    }
    
    public HashMap<String, String> getprocessteammap(){
    	return processteammap;
    }


    public HashMap<String, HashMap<String, String>> getprocessmap(){
    	return processmap;
    }
    
    
    public HashMap<String, ArrayList<String>> getcoaprocessmap(){
    	return coaprocessmap;
    }
    
    public HashMap<String, String> getteamteam1map(){
    	return teamteam1map;
    }
    
    public HashMap<String, ArrayList<String>> getteamteam2map(){
    	return teamteam2map;
    }

  
    
  /*  
    // ?????? ?????? ???????????? ????????? ??????
	public void setprocesssetting() {
		
		
		
		// rcm ???????????? ??????
		// ??????????????? ?????? ???????????? ?????? ???
		try {
    		rcmlistmake("Total", "????????????.xls", 2, 37, "subwork");
    		
    		//??????????????? ????????? ??????????????? ????????? ???
    		processrepository.setparentnodetotal();
		}catch(Exception e) {
			System.out.println(e);
		}
		
		// coa ??????
		processlistmakexl("BS", "(AAS)?????? CoA ??? Process_JSH.xls", oppositecoa_bs, coaarray_bs, 0, 0, 0);
		processlistmakexl("IS", "(AAS)?????? CoA ??? Process_JSH.xls", oppositecoa_is, coaarray_is, 0, 0, 0);
		
		// ???????????? ??????
		String[] arr = {"????????????"}; //, "?????????", "??????", "??????", "??????", "????????????", "??????", "????????????", "??????"};
		
		for(String key : arr) {
			System.out.println(key);
			HashMap<String, String> array = new HashMap<>();
			HashMap<String, ArrayList<String>> inarray = new HashMap<>();
			processmap.put(key, array);
			
			processlistmakexl2(key, "sub-process??? ????????? mapping.xls", array, inarray, 0, 23, 0, 0);
			System.out.println(array.size());
		}
		
		
		
		
		// ???????????? vs ??? ??????
		processlistmakexl("team", "??????.xls", processteammap, null, 0, 0, 1);
		
		// coa vs process ??????
		processlistmakexl("processmap", "??????.xls", null, coaprocessmap, 1, 0, 0);		

		// team vs team ??????
		processlistmakexl("teammapping", "??????.xls", teamteam1map, teamteam2map, 0, 0, 0);		


	
	}

	*/
    
	
	
    // xl ???????????? ????????? ?????????
    public void processlistmakexl(String sheetname, String name, HashMap<String, String> oppositearray,
    		       HashMap<String, ArrayList<String>> inarray, int pos, int pos2, int opt) {
      // ??? ????????? ????????? ????????????, pos??? ?????? ?????? ????????? ????????????
      try {
      	FileInputStream fis = new FileInputStream("C:\\java\\gob\\???????????????\\??????\\" + name); //"/usr/local/gob/" "C:\\java\\gob\\???????????????\\??????\\"
      	HSSFWorkbook book = new HSSFWorkbook(fis);
      	HSSFSheet sheet = book.getSheet(sheetname);
      	//??????????????? null?????? null??? ??? ????????? ????????? ???
      	//????????? ???????????? 0?????? ??????????????? ??? ????????? ???
      	//https://blog.naver.com/wlgh325/221391234592
      	int rowexisting = 1;
      	int rownum = 0;
      	while(rowexisting == 1) {	

      	HSSFRow row = sheet.getRow(rownum);
         
  		
  	    ArrayList<JSONObject> sentences = new ArrayList<>();
  	    JSONObject obj = new JSONObject();
  	    String activitystring = "";
  	    String real = "";
      	int existing = 1;
      	
      	if(row != null) {
      		
      		// ???????????? ???
      		String coa = row.getCell(pos2).toString();
       		
      	    //	String processname = row.getCell(2).toString();
      		int num = pos;
      		ArrayList<String> array = new ArrayList<>();
      		
          	while(existing == 1) {
          		HSSFCell line = row.getCell(num);
          	    if(line != null && line.toString().isEmpty() == false) {
          	    	array.add(line.toString());
          	    	          	    	
          	    	//oppositecoa ?????????
          	    	if(oppositearray != null) {
          	    		if(opt == 0) {
                  	    	oppositearray.put(line.toString(), coa);
          	    		}else {
          	    			oppositearray.put(coa, line.toString());
          	    		}
          	    	}
          	    	num += 1;
          	    }else {
          	    	existing = 0;
          	    }
 
          	}
          	
          	// array??? coaarray??? ????????????
          	if(inarray != null) {
  	    		inarray.put(coa, array);
          	}
 
  	            rownum += 1;
      	}else {
      		rowexisting = 0;
      		
      	}
      	
      	book.close();
  	}
  	
      }catch(FileNotFoundException e) {
    	  System.out.println(e);
      }catch(IOException e) {
    	  System.out.println(e);
      }
      
      
    }   
	

 // xl ???????????? ????????? ?????????
    public void processlistmakexl2(String sheetname, String name, HashMap<String, String> oppositearray,
    		       HashMap<String, ArrayList<String>> inarray, int row1, int row2, int opt, int real) {
      // ??? ????????? ????????? ????????????, pos??? ?????? ?????? ????????? ????????????
      try {
      	FileInputStream fis = new FileInputStream("C:\\java\\gob\\???????????????\\??????\\" + name); ///usr/local/gob/"
      	HSSFWorkbook book = new HSSFWorkbook(fis);
      	HSSFSheet sheet = book.getSheet(sheetname);
      	//??????????????? null?????? null??? ??? ????????? ????????? ???
      	//????????? ???????????? 0?????? ??????????????? ??? ????????? ???
      	//https://blog.naver.com/wlgh325/221391234592
      	int rowexisting = 1;
      	int rownum = 0;
      	while(rowexisting == 1) {	

      	HSSFRow row = sheet.getRow(rownum);
         
  	    ArrayList<JSONObject> sentences = new ArrayList<>();
  	    JSONObject obj = new JSONObject();
  	    String activitystring = "";
  	    
      	int existing = 1;
      	
      	if(row != null) {
      		
      		
      		// ???????????? ???
      		String coa = row.getCell(real).toString();
       		
       		
      	//	String processname = row.getCell(2).toString();
      		ArrayList<String> array = new ArrayList<>();
          	for(int num = row1; num <= row2; num++) {
          		HSSFCell line = row.getCell(num);
          	    if(line != null && line.toString().isEmpty() == false) {
          	    	array.add(line.toString());
          	    	          	    	
          	    	//oppositecoa ?????????
          	    	if(oppositearray != null) {
          	    		if(opt == 0) {
                  	    	oppositearray.put(line.toString(), coa);
          	    		}else {
          	    			oppositearray.put(coa, line.toString());
          	    		}
          	    	}
          	    }
 
          	}
          	
          	// array??? coaarray??? ????????????
          	if(inarray != null) {
  	    		inarray.put(coa, array);
          	}
 
  	            rownum += 1;
      	}else {
      		rowexisting = 0;
      		
      	}
      	
      	book.close();
  	}
  	
      }catch(FileNotFoundException e) {
    	  System.out.println(e);
      }catch(IOException e) {
    	  System.out.println(e);
      }
      
      
    }  
    
 
    // xl ???????????? ????????? ?????????
    public void rcmlistmake(String sheetname, String name, int row1, int row2, String para)
   		 throws ClassNotFoundException, IllegalAccessException, InstantiationException
         ,NoSuchMethodException, InvocationTargetException 
    {
      // ??? ????????? ????????? ????????????, pos??? ?????? ?????? ????????? ????????????
      	
      try {
    	  
      	FileInputStream fis = new FileInputStream("C:\\java\\gob\\???????????????\\??????\\" + name); ///usr/local/gob/"
      	HSSFWorkbook book = new HSSFWorkbook(fis);
      	HSSFSheet sheet = book.getSheet(sheetname);
      	
      	
      	//??????????????? null?????? null??? ??? ????????? ????????? ???
      	//????????? ???????????? 0?????? ??????????????? ??? ????????? ???
      	//https://blog.naver.com/wlgh325/221391234592
      	int rowexisting = 1;

      	for(int num = row1; num <= row2; num++) {
      		
      		HSSFRow row = sheet.getRow(num);
         
  	        ArrayList<JSONObject> sentences = new ArrayList<>();
  	        JSONObject obj = new JSONObject();
  	        String activitystring = "";
  	    
      	    int existing = 1;
      	    processdata pro = new basicdata();
      	    if(row != null) {
      	      //subwork(row, pro);
      	      	
      	      // ???????????? ?????????????????? subwork ????????? ????????? ?????????????????? subwork??? ????????????????????? ???????????? ?????? ????????????????????? ??????????????? ???????????????, 
      	      // ?????? ???????????? ?????? ??????????????? ?????? new subclass(){@override
      	      //	                                  subwork(){ ~~~~ ????????? ???????????? ?????? ~~~ } 
      	      // ????????? ??????????????? ?????????. ??????????????? ????????? ?????? ?????????????????????       	    	
      	      // ????????? invoke??? ?????????	
      	      
      	      Method me = mywork.class.getMethod(para, HSSFRow.class, processdata.class);
      		  Object[] param = new Object[] {row, pro};
              me.invoke(mywork.class.newInstance(), param);
              
      	    }
      	
      	  processrepository.save(pro);
      	}
      	book.close();
      }catch(FileNotFoundException e) {
    	  System.out.println(e);
      }catch(IOException e) {
    	  System.out.println(e);
      }
      
      
    }      
    
 
    // ?????? invoke ????????? ?????? ?????? ??????
    public void subwork(HSSFRow row, processdata pro) {
	      // rcm ??? ?????? ????????????
		  ArrayList<String> array = new ArrayList<>();
		  
		  
	      String businesscode  = makestring(row, 0);
	      if(businesscode  != null) {
	      pro.setbusinesscode (businesscode );
	      }

	      String companyname = makestring(row, 1);
	      if(companyname != null) {
	      pro.setcompanyname(companyname);
	      }

	      String processcode = makestring(row, 2);
	      if(processcode != null) {
	      pro.setprocesscode(processcode);
	      }

	      String processname = makestring(row, 3);
	      if(processname != null) {
	      pro.setprocessname(processname);
	      }

	      String subprocesscode = makestring(row, 4);
	      if(subprocesscode != null) {
	      pro.setsubprocesscode(subprocesscode);
	      }

	      String subprocess = makestring(row, 5);
	      if(subprocess != null) {
	      pro.setsubprocess(subprocess);
	      }

	      String riskcode = makestring(row, 6);
	      if(riskcode != null) {
	      pro.setriskcode(riskcode);
	      }

	      String risk = makestring(row, 7);
	      if(risk != null) {
	      pro.setrisk(risk);
	      }

	      String riskgrade = makestring(row, 8);
	      if(riskgrade != null) {
	      pro.setriskgrade(riskgrade);
	      }

	      String detailprocess = makestring(row, 9);
	      if(detailprocess != null) {
	      pro.setdetailprocess(detailprocess);
	      }

	      String detailprocessname = makestring(row, 10);
	      if(detailprocessname != null) {
	      pro.setdetailprocessname(detailprocessname);
	      }

	      String processexplain = makestring(row, 11);
	      if(processexplain != null) {
	      pro.setprocessexplain(processexplain);
	      }

	      String controlcode = makestring(row, 12);
	      if(controlcode != null) {
	      pro.setcontrolcode(controlcode);
	      }

	      String controlname = makestring(row, 13);
	      if(controlname != null) {
	      pro.setcontrolname(controlname);
	      }

	      String controlexplain = makestring(row, 14);
	      if(controlexplain != null) {
	      pro.setcontrolexplain(controlexplain);
	      }
		  
	      String teams = makestring(row, 47);
	      if(teams != null) {
	    	  
	    	  // split??????
	    	  String[] teamarr = teams.split( "," );
	    	  for(String team : teamarr) {
	    		  
	    		  teamdata tempteam = new teamdata();
	    		  tempteam.setTeamname(team.trim());
	    		  pro.addteamdata(tempteam);
	    	  }
	      }
	      
	      // ?????? ????????????
	      String node = makestring(row, 50);
	      System.out.println(node);
	      if(node != null) {

	         childnodedata act2 = new childnodedata();
	         act2.setname(node);
	         act2.setsubprocess(pro.getsubprocess());
             pro.addchildnodedata(act2);

	      }    	

    }

    // ?????? invoke ????????? ?????? ?????? ??????
    public void subwork_node(HSSFRow row, processdata pro) {
	      // node ???????????? // ?????? ??? ????????? ???????????? ?????? split ?????? ???????????? list??? ??????????????? ???
	      String node = makestring(row, 75);
	      if(node != null) {
	    	  
	    	  
	    	  processdata parent = processrepository.getprocessquery("detailprocessname", node).get(0);
	    	  parentnodedata act = new parentnodedata();
	    	  act.setname(parent.getdetailprocessname());
              pro.addparentnodedata(act);

	    	  childnodedata act2 = new childnodedata();
	    	  act2.setname(pro.getdetailprocessname());
              parent.addchildnodedata(act2);
              
	    	   
	      }

    }
  
    
    ////
    public String makestring(HSSFRow row, int num) {

    	HSSFCell line = row.getCell(num);
  	    if(line != null && line.toString().isEmpty() == false) {
  	    	return line.toString();
  	    }
   	
    	return null;
    }

	// detailprocess??? ??????, ????????? ???????????? ???????????? ?????? ??????
	public String finddetailprocess(String name){
		List<basicdata> pros = processrepository.getprocessquery("detailprocessname", name); 
		processdata pro = pros.get(0);
		return null;
	}

	class subclass{
		
	}
    
    
}
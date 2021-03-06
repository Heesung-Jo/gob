package com.controller;

import java.util.*;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.net.*;
import java.nio.charset.StandardCharsets;
import java.io.*;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.validation.Errors;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ModelAttribute;


import com.entity.member;
import com.service.memberService;
import javax.validation.Valid;
import org.springframework.validation.BindingResult;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.service.memberService;
import com.service.Scoping;

import com.entity.member;
import com.service.UserContext;

import com.survey.SignupForm;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;

import java.io.UnsupportedEncodingException;

import com.spring.AuthService;
import com.spring.Member;
import com.spring.AuthService;
import com.spring.WrongIdPasswordException;
import com.entity.basicdata;
import com.entity.coadata;
import com.entity.processdata;
import com.entity.roledata;
import com.entity.teamdata;


import com.service.mywork;
import com.service.unitedwork;
import com.service.currentmanageservice;

@Controller
@RequestMapping
public class LoginController {
	

	@Autowired
	private memberService memberservice;

	@Autowired
	private mywork mywork;

	@Autowired
	private unitedwork uniwork;
	
	@Autowired
	private currentmanageservice currentmanageservice;

    private final UserContext userContext;
    private final memberService memberService;
    @Autowired
    private Scoping scoping;
	
	/*
    private AuthService authService;
    
    public void setAuthService(AuthService authService) {
        this.authService = authService;
    }
   */

    @Autowired
    public LoginController(UserContext userContext, memberService memberService) {
        if (userContext == null) {
            throw new IllegalArgumentException("userContext cannot be null");
        }
        if (memberService == null) {
            throw new IllegalArgumentException("calendarService cannot be null");
        }
        this.userContext = userContext;
        this.memberService = memberService;
    }

    
    @GetMapping("/register/loginForm")
    public String form(LoginCommand loginCommand, Model model) {
    	System.out.println(123);
    	System.out.println(1239090);
        //@PathVariable("name") String name
        model.addAttribute("currentgrade", currentmanageservice.currentgrade());

    	return "login";
    }

    @GetMapping("/view/home")
    public String home(Model model) {
    	model.addAttribute("currentgrade", currentmanageservice.currentgrade());
      return "home";
    }


    @GetMapping("/view/currentview")
    public String currentview(Model model) {
    	
    	model.addAttribute("currentgrade", currentmanageservice.currentgrade());
    	
    	// ????????? ???????????????
    	model.addAttribute("currentarr", currentmanageservice.currentview());
    	
      return "currentview";
    }

    
    
	@GetMapping("/scope/subwindow")
    public String getsubwindow(
    		Model model, HttpSession session, 
    		HttpServletResponse response) {
		model.addAttribute("currentgrade", currentmanageservice.currentgrade());
    	  System.out.println("subwin");
         return "/scope/subwindow";
    }
    
	@GetMapping("/view/basestructure")
    public  String baseinventorymake(
    		HttpSession session, HttpServletResponse response, SessionStatus sessionStatus,
    		Model model) {
    	
		//uniwork.test();
		model.addAttribute("currentgrade", currentmanageservice.currentgrade());
	      return "basestructure";
	}

	@GetMapping("/view/basemapping")
    public  String basemapping(
    		HttpSession session, HttpServletResponse response, SessionStatus sessionStatus,
    		Model model) {
		model.addAttribute("currentgrade", currentmanageservice.currentgrade());
	      return "basemapping";
	}
	
	
    @GetMapping("/view/explanation")
    public String explanation(Model mav) {
    	
		String url = "http://localhost:5000";
		String sb = "";
		mav.addAttribute("currentgrade", currentmanageservice.currentgrade());
		try {
			
		  // post ?????? //?????? ?????? ????????? ?????????	
	        Map<String,Object> params = new LinkedHashMap<>(); // ???????????? ??????
	        params.put("name", "james");
	        params.put("email", "james@example.com");
	        params.put("reply_to_thread", 10394);
	        params.put("message", "Hello World");
	 
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
	        conn.getOutputStream().write(postDataBytes); // POST ??????

       /* get??????			
			HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
       */
			
			BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"));
			String line = null;

			while ((line = br.readLine()) != null) {
				sb = sb + line + "\n";
			}

			System.out.println("========br======" + sb.toString());
			if (sb.toString().contains("ok")) {
				System.out.println("test");
				
			}
			br.close();
			System.out.println("" + sb.toString());

		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mav.addAttribute("test", sb.toString()); // "test1"??? jsp???????????? ????????? ??????, 
        						//sb.toString??? value???(???????????? test)
    	
      	
      return "explanation";
    }

    @GetMapping("/view/gojs")
    public String gojs(Model model) {
    	model.addAttribute("currentgrade", currentmanageservice.currentgrade());
      return "gojs";
    }
    
    @GetMapping("/view/gojs9")
    public String gojs5(Model model) {
      
      System.out.println("????????? ??????");
      ArrayList<String> processlist = mywork.findwork("?????????");
      System.out.println("????????? ??????");
      model.addAttribute("currentgrade", currentmanageservice.currentgrade());
      model.addAttribute("processlist", processlist);
      return "gojs9";
    }

    @GetMapping("/view/gojs_work")
    public String gojs6(Model model) {
      
      System.out.println("????????? ??????");
      
      member user = userContext.getCurrentUser();
      Set<String> processlist = mywork.findwork_person(user.getRealname());
      System.out.println("????????? ??????");
      model.addAttribute("currentgrade", currentmanageservice.currentgrade());
      model.addAttribute("processlist", processlist);
      return "gojs_work";
    }


    @GetMapping("/view/basequestion")
    public String basequestion(Model model) {
    	model.addAttribute("currentgrade", currentmanageservice.currentgrade());
      return "basequestion";
    }

    
    
    
    // ????????? ???????????? ????????? ?????? ?????? ??? ???????????? ???
    @RequestMapping("/view/Scoping")
    public String Scoping(Model model) {
    	
    	member user = userContext.getCurrentUser();
    	model.addAttribute("currentgrade", currentmanageservice.currentgrade());
    	
    	int number = 0;
    	for(roledata role : user.getRoledata()) {
    		if(role.getRole().equals("????????????") == true) {
    			number = 1;
    			break;
    		}else if(role.getRole().equals("????????????") == true) {
    			number = 2;
    			break;
    		}
    	}
    	System.out.println(user.getRoledata().toString());
    	System.out.println(number);
    	
    	
    	if(number == 1) {
    		
    		// ?????? ?????? ????????? 1????????? ????????? ?????????
    		
    		int grade = currentmanageservice.getLevel0Repository().findByRealname("Scoping").get(0).getRealgrade();  
   
    		System.out.println(grade);
    		/* ????????? ??????, ????????? ?????? ???????????? ??? ?????? ????????? ????????? ????????? ?????? ?????????
   		
    		if(grade != 1) {
        		return "loginsuccess";
        	}
    		*/
    		
    		// ??????????????? ??????
        	
            model.addAttribute("oppositecoa_bs", mywork.getoppositecoa("BS"));
            model.addAttribute("oppositecoa_is", mywork.getoppositecoa("IS"));
            model.addAttribute("coaarray_bs", mywork.getcoaarray("BS"));
            model.addAttribute("coaarray_is", mywork.getcoaarray("IS"));

            model.addAttribute("coaprocessmap", mywork.getcoaprocessmap());
            model.addAttribute("teamteam1map", mywork.getteamteam1map());
            model.addAttribute("teamteam2map", mywork.getteamteam2map());
            model.addAttribute("processmap", mywork.getprocessmap());

            model.addAttribute("processteammap", mywork.getprocessteammap());
        	return "Scoping";
    		
    	}else if(number == 2) {

    		int grade = currentmanageservice.getLevel0Repository().findByRealname("Scoping").get(0).getRealgrade();  
    		System.out.println(grade);
    		
    		/* ????????? ??????, ????????? ?????? ???????????? ??? ?????? ????????? ????????? ????????? ?????? ?????????
        	if(grade == 1) {
        		return "loginsuccess";
        	}
    		*/
    		
    		// ??????????????? ??????
    		
    		System.out.println(scoping.findparameter());
    		model.addAttribute("scoping", scoping.findall());
    		model.addAttribute("parameter", scoping.findparameter());
    		return "Scoping_confirm";
    		
    	}
    	
        return null;
    }
    
    
    
    @PostMapping("/register/login")
    public String submit(
    		LoginCommand loginCommand, Errors errors, HttpSession session,
    		HttpServletResponse response, Model model) {
    	
    	model.addAttribute("currentgrade", currentmanageservice.currentgrade());
    	System.out.println(123);
    	System.out.println(loginCommand.getusername());
    	System.out.println(errors);
    	
        if (errors.hasErrors()) {
            return "login/loginForm";
        } 
        try {
        	
        	/*
            Member auth = authService.authenticate( loginCommand.getusername(),
                    loginCommand.getPassword());
            System.out.println("123123123");
            session.setAttribute("authInfo", auth);
            */

            return "survey/surveyForm";
        } catch (WrongIdPasswordException e) {
            errors.reject("idPasswordNotMatching");
            return "register/loginForm";
        }
    }

    @PostMapping("/view/processsubmit")
    public String processsubmit(
    		@RequestParam Map<String, String> data, HttpSession session,
    		HttpServletRequest request, HttpServletResponse response, Model model) 
            throws UnsupportedEncodingException {
    	model.addAttribute("currentgrade", currentmanageservice.currentgrade());
      	request.setCharacterEncoding("UTF-8");
      	//response.setContentType("text/html;charset=UTF-8");

        // ????????? ????????? ????????? ????????? ????????? ???????????? ?????? ????????? ???
      	
     	
      	// ????????? ????????? ????????????
    	for(String pro : data.keySet()) {
    		System.out.println(pro);
        	
    		// table ???????????? ???????????? ????????? ???????????????, process???_hidden, process???_???????????? ????????? ?????? ?????? ????????? ?????? ????????????
    		// ????????? process?????? ???????????? ????????? ????????? ??????
    		if(pro.contains("_hidden") != true) {
        		// ???????????? ??????
        		processdata process = new basicdata();
            	process.setname(pro);
              
            	// ??? ??????
        		String[] arrayParam = request.getParameterValues(pro);
              	for (int i = 0; i < arrayParam.length; i++) {
              		
              		teamdata team = new teamdata();
              		
              		team.setTeamname(arrayParam[i]);
              	    process.addteamdata(team);
              	}
              	
              	// coa ??????
              	coadata coa = new coadata();
              	//coa.setname(request.getParameter(pro + "_hidden"));
              	//process.setcoadata(coa);

            	mywork.save(process);
      		}
        	
    	}

    	
    	// ?????? ?????? ????????? ????????????
    	return "inputsuccess";
    }	
    
    
    @RequestMapping("/view/loginSuccess")
    public String submit2(Model model) {
    	
    	model.addAttribute("currentgrade", currentmanageservice.currentgrade());
    	return "loginsuccess";
    }
    
    @RequestMapping("/register/realform")
    public String signup(@ModelAttribute SignupForm signupForm, Model model) {
    	model.addAttribute("currentgrade", currentmanageservice.currentgrade());
        return "realform";
    }
 
    
    @RequestMapping(value="/register/realform", method=RequestMethod.POST)
    public String signup(@ModelAttribute @Valid SignupForm signupForm, BindingResult result
    		, RedirectAttributes redirectAttributes, Model model
    ) {
        if(result.hasErrors()) {
        	System.out.println("error??? ????????????");
            return "realform";
        }
        model.addAttribute("currentgrade", currentmanageservice.currentgrade());
        String email = signupForm.getEmail();
        System.out.println(email);
        
        /*
        if(memberservice.findUserByEmail(email) != null) {
            result.rejectValue("email", "errors.signup.email", "Email address is already in use.");
            return "realform";
        }
        */
        
        member user = new member();
        user.setEmail(email);
        user.setName(signupForm.getname());
        user.setPassword("{noop}" + signupForm.getPassword());

        //logger.info("CalendarUser: {}", user);

        System.out.println("????????? ?????????");
        int id = memberservice.createUser(user);
        user.setId(id);
        userContext.setCurrentUser(user);
        System.out.println("????????? ?????????");
        redirectAttributes.addFlashAttribute("message", "You have successfully signed up and logged in.");
        return "redirect:/view/Scoping";
    }
    
    
    // ?????? ????????? ????????????
	@RequestMapping(value = "/view/upload_organization", method = RequestMethod.POST)
	public String upload(@RequestParam("uploadFile") MultipartFile file,
			     Model model) throws IllegalStateException, IOException {
		model.addAttribute("currentgrade", currentmanageservice.currentgrade());
		String filename = file.getOriginalFilename();
		System.out.println(filename);
		String path = System.getProperty("user.dir"); 
		
		String FILE_PATH = path + "/upload";
		if(!file.getOriginalFilename().isEmpty()) {
			
			file.transferTo(new File(FILE_PATH, filename));
			model.addAttribute("msg", "File uploaded successfully.");
			model.addAttribute("fileName", filename);
		
		}else{
		
			model.addAttribute("msg", "Please select a valid mediaFile..");
		}
		
		return "basemapping";
	}    
    
    // ?????? ???????????? ????????????
	
	
	@RequestMapping("/view/download_organization")
	@ResponseBody
	public byte[] download(HttpServletResponse response,
			      @RequestParam String filename, Model model) throws IOException{
		model.addAttribute("currentgrade", currentmanageservice.currentgrade());
		String path = System.getProperty("user.dir"); 
		
		String FILE_PATH = path + "/download";
		
		File file = new File(FILE_PATH, "???????????????.xlsx");
		
		byte[] bytes = FileCopyUtils.copyToByteArray(file);
		
		String fn = new String(file.getName().getBytes("utf-8"), "ISO-8859-1");
		System.out.println(fn);

		response.setContentType("application/octet-stream;charset=utf-8");

		response.setHeader("Content-Disposition", "attachment;filename=\"" + fn + "\"");
		response.setContentLength(bytes.length);
		
		return bytes;
	}
	
	
	/*
	@RequestMapping(value ="/view/download_organization")
	public ResponseEntity<byte[]> downloadTest(@RequestHeader(name = HttpHeaders.USER_AGENT) String userAgent){

		String path = System.getProperty("user.dir"); 
		
		String FILE_PATH = path + "/download";
		
		File file = new File(FILE_PATH, "???????????????.xlsx");
		
		byte[] bytes = FileCopyUtils.copyToByteArray(file);
		
		HttpHeaders guavaHeader = new HttpHeaders();	
	
	  guavaHeader.setContentType(MediaType.APPLICATION_OCTET_STREAM);
	  guavaHeader.set("Content-Disposition", "attachment; filename=" + new String("??????.txt".getBytes(), StandardCharsets.ISO_8859_1));
	  return new ResponseEntity<byte[]>(file, guavaHeader, HttpStatus.OK);	
	  
	}
	*/
	
}

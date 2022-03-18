<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>

<head>
    <title>유형자산</title>
</head>

<style>


.droptarget {
  float: left; 
  width: 200px; 
  height: 600px;
  border: 1px solid #aaaaaa;
}

.controlform {
  float: left; 
}

</style>

<script src = "http://code.jquery.com/jquery-3.4.1.js"></script>

<script type="text/javascript">

// 캔버스 그릴것을 좀 더 정교화하기, 먼저 선들 지저분하니 먼저 클리어 시킬 것


//아작스 관련
var canvasmake = {};

var english = {
		품의서 : "apprvlrq",
		마스터파일 : "mstrfl_ppe",
		전표 : "sttmnt",
		계산서 : "bl",
		계약서 : "cntrct",
		계산내역 : "clcldtl",
		대사 : "rcncl"
}

    english["승인"] =  "apprvl"
    english["대사"] =  "rcncl"
	english["검토"] =  "vrf"
	english["물리적통제"] =  "phsclctrl"
	english["감독통제"] =  "cre"
	english["기준정보관리통제"] =  "ctrliuc"
	english["품의서"] =  "apprvlrq"
	english["마스터파일"] =  "mstrflppe"
	english["전표"] =  "sttmnt"
	english["계산서"] =  "bl"
	english["계약서"] =  "cntrct"
	english["계산내역"] =  "clcldtl"
	english["승인대상문서"] =  "apprvldoc"
	english["대사대상문서 1쌍"] =  "rcncldoc1set"
	english["검토대상문서"] =  "vrfdoc"
	english["접근제한"] =  "acsrst"
	english["리뷰대상정보"] =  "rvwinfo"
	english["권한이 있는 인원의 관리"] =  "mngprsath"
	english["작성자"] =  "prprr"
	english["자산번호"] =  "asstno"
	english["계정과목"] =  "acct"
	english["일자"] =  "dt"
	english["시스템내부에서 생성 : IPE 또는 IUC로 식별"] =  "sysinside_ipeoriuc"
	english["승인권자"] =  "apprvlref"
	english[ "승인시 참고정보(문서)"] = "apprvlref2"
	english["차이 있는 경우"] =  "dif"
	english["검토기준_재계산"] =  "vrfcrt_rclc"
	english["관리대장작성"] =  "prprctrl"
	english["리뷰대상문서"] =  "rvwdoc"
	english["기준정보 변경 권한"] =  "athchgiuc"
	english["검토자"] =  "rvwr"
	english["상각방법"] =  "dprmthd"
	english["전표일자"] =  "sttmntdt"
	english["금액"] =  "amt"
	english["시스템외부에서 생성 : EUC로 식별"] =  "sysoutside_euc"
	english["차이 없는 경우"] =  "xdif"
	english["검토기준_정책"] =  "vrfcrt_plc"
	english["항목"] =  "itm"
	english["취득금액"] =  "acqamt"
	english["차변금액"] =  "dbtamt"
	english["거래상대방"] =  "ctrprt"
	english["액션 중 검토를 요구함"] =  "vrfdrngact"
	english["사유"] =  "rsn"
	english["취득일자"] =  "acqdt"
	english["대변금액"] =  "crdtamt"
	english["수량"] =  "qnt"
	english["취득수량"] =  "acqqnt"
	english["담당자"] =  "preparer2"
	english["담당부서"] =  "preparer1"
	english["소유자"] =  "owner2"
	english["소유부서"] =  "owner1"
	english["작성문서명"] = "madedocument"

var korea = {
		apprvlrq : "품의서 ",
		mstrfl_ppe : "마스터파일",
		sttmnt : "전표",
		bl : "계산서",
		cntrct : "계약서",
		clcldtl : "계산내역",
		rcncl : "대사"
}

     korea[ "apprvl"] = "승인"
	 korea[ "rcncl"] = "대사"
	 korea[ "vrf"] = "검토"
	 korea[ "phsclctrl"] = "물리적통제"
	 korea[ "cre"] = "감독통제"
	 korea[ "ctrliuc"] = "기준정보관리통제"
	 korea[ "apprvlrq"] = "품의서"
	 korea[ "mstrflppe"] = "마스터파일"
	 korea[ "sttmnt"] = "전표"
	 korea[ "bl"] = "계산서"
	 korea[ "cntrct"] = "계약서"
	 korea[ "clcldtl"] = "계산내역"
	 korea[ "apprvldoc"] = "승인대상문서"
	 korea[ "rcncldoc1set"] = "대사대상문서 1쌍"
	 korea[ "vrfdoc"] = "검토대상문서"
	 korea[ "acsrst"] = "접근제한"
	 korea[ "rvwinfo"] = "리뷰대상정보"
	 korea[ "mngprsath"] = "권한이 있는 인원의 관리"
	 korea[ "prprr"] = "작성자"
	 korea[ "asstno"] = "자산번호"
	 korea[ "acct"] = "계정과목"
	 korea[ "dt"] = "일자"
	 korea[ "sysinside_ipeoriuc"] = "시스템내부에서 생성 : IPE 또는 IUC로 식별"
	 korea[ "apprvlref"] = "승인권자"
	 korea[ "apprvlref2"] = "승인시 참고정보(문서)"
	 korea[ "dif"] = "차이 있는 경우"
	 korea[ "vrfcrt_rclc"] = "검토기준_재계산"
	 korea[ "prprctrl"] = "관리대장작성"
	 korea[ "rvwdoc"] = "리뷰대상문서"
	 korea[ "athchgiuc"] = "기준정보 변경 권한"
	 korea[ "rvwr"] = "검토자"
	 korea[ "dprmthd"] = "상각방법"
	 korea[ "sttmntdt"] = "전표일자"
	 korea[ "amt"] = "금액"
	 korea[ "sysoutside_euc"] = "시스템외부에서 생성 : EUC로 식별"
	 korea[ "xdif"] = "차이 없는 경우"
	 korea[ "vrfcrt_plc"] = "검토기준_정책"
	 korea[ "itm"] = "항목"
	 korea[ "acqamt"] = "취득금액"
	 korea[ "dbtamt"] = "차변금액"
	 korea[ "ctrprt"] = "거래상대방"
	 korea[ "vrfdrngact"] = "액션 중 검토를 요구함"
	 korea[ "rsn"] = "사유"
	 korea[ "acqdt"] = "취득일자"
	 korea[ "crdtamt"] = "대변금액"
	 korea[ "qnt"] = "수량"
	 korea[ "acqqnt"] = "취득수량"
	 korea[ "preparer2"] = "담당자"
	 korea[ "preparer1"] = "담당부서"
	 korea[ "owner2"] = "소유자"
	 korea[ "owner1"] = "소유부서"
	 korea["osp"] ="OSP"
	 korea["prequency"] ="수행빈도"
	 korea["submitdocument"] ="최종적으로 보관하는 방식"
	 korea["currentdocument"] ="작성문서"	 
	 korea["madedocument"] ="참고되거나 작성되는 자료의 수령방식"
     korea["documentsubject"] = "문서명"
	 
	 
var tagattrobject = {
		apprvlrq: {prprr: "작성자", rvwr: "검토자", itm: "항목", rsn: "사유", amt: "금액"} ,
		mstrfl_ppe: {asstno: "자산번호", dprmthd: "상각방법", acqamt: "취득금액", acqdt: "취득일자", acqqnt: "취득수량"},
		sttmnt: {acct: "계정과목", sttmntdt: "전표일자", dbtamt: "차변금액", crdtamt: "대변금액", prprr: "작성자", rvwr: "검토자"},
		bl: {dt: "일자", amt: "금액", ctrprt: "거래상대방", qnt: "수량"},
		cntrct: {dt: "일자", amt: "금액", ctrprt: "거래상대방", qnt: "수량"},
		clcldtl: {sysinside_ipeoriuc: "시스템내부에서 생성 : IPE 또는 IUC로 식별", sysoutside_euc: "시스템외부에서 생성 : EUC로 식별", vrfdrngact: "액션 중 검토를 요구함"}
}

var object = {};
var request;
var makingnumber = 0;
var makingobject = {}
var divisions = [];
var divisionlist = [];
var enumhash = {};
var selectedname ="";
var realname = "";
var submaking = {};
var subwin = {};
var processlist = [];


function createRequest(){
	
	try{
		request = new XMLHttpRequest();
		
		
	} catch (exception){
		try {
			request = new ActiveXObjet('Msxml2.XMLHTTP');
		} catch (innerException){
			request = new ActiveXObject('Microsoft.XMLHTTP');
		}
		
	}
     return request;	
   }
   

var buttontext = {10 : "관련내용 작성", 0 : "관련내용 수정", 1 : "관련내용 닫기"}



class making{
	
	constructor(){

		this.form = {};
		this.url = "";
		this.controlform = {};
		this.formdata = {};
		this.before;
		this.top = 0;
		this.res = {};
		this.number;
		this.document = [];
		this.next;
		this.activity;
		this.process;
		this.stage = 0;
		this.sentencetag = {};
		this.questiontag = {};
		this.question = {};
		this.questioncondition = {};
		this.liststring = {};
		this.stringlistarr = [];
		this.jsonset = new Set(['jsonmake']);
		this.controltag = {};
		
		this.jsontag = {};
		this.taketag = {};
		this.takemapping = {};
		this.data = {};
		
		this.exception = new Set(["url", "process"]);
		this.buttontext = 10;
		this.documentcount = 0;
		this.name = "";
		this.formcon = {};
		this.checking = {osp : true}
		
		this.selection = {
				
				preparer2 : divisions, owner2 : divisions,
				media : enumhash["media"], meddetail : enumhash["meddetail"], 
				transsystem : enumhash["transsystem"],
		}
	
	}
	
	documenting() {
		
		for(var i in this.document){
			
			this.button(korea[this.document[i].name] + " 작성하기", 
					() => {
				        for(var j in this.document[i]){ 
				        	console.log(j);
				        	this.checkbox(j)
				               
				        }
				     });
		}
		
		document.body.appendChild(this.controlform);

	}
    
	buttonindex(){
		
		if(this.buttontext == -1){
			this.buttontext = 0;
			return -1;
		}else{
			return this.stage;
		}
		
	}
	
	
	sendingform = () => {
        
        console.log(this.controlform);
        
        //여기에 아작스 추가해서, controlmethod 실행시켜서 가이드 요건들 추가할 것
        
        this.controlmethod();
        this.controlform.submit();
        console.log("submit 후임")
		
	}
	
	controlmethod = () => {
		
		var queryString = $("form[name=controlform]").serialize() ;

   		$.ajax({
   			type : "POST",
   			url : "/pja/controlmethod",
   			data : queryString,
   			success : (res) => {
   				var val = res.body;
   				console.log(val);
   				if(val == 1){
	   				//this.res = res;
   					console.log("success");
   					this.controlform.submit();
   				}else{
   					this.controlmethod_an(val);
   				}
   			}
   		})		
	}
	
	sending = () => {
        
   		//form data 전환하기
   		
   		
   		$.ajax({
   			type : "POST",
   			url : this.url,
   			data : this.formdata,
   			success : (res) => {
   				
   				console.log(res);
   				if(res == 1){
	   				//this.res = res;
	   				this.controlform.parentNode.removeChild(this.controlform);
                    this.stage = (this.stage + 1) % 2;
	   				alert("입력이 잘 되었습니다.");
   					form[this.activity + "button"].value = "관련내용 수정";
   					console.log(this.controlform);
   				}
   			}
   		})
   		
   		
   		
    }   
	
	controlmethod_an = (anw) => {

		if(this.controltag["owner"]){
			this.controltag["owner"].parentNode.removeChild(this.controltag["owner"]);
		}
		
		this.controltag["owner"] = document.createElement("div");
		this.controlform.appendChild(this.controltag["owner"]);

		for(var i in anw){
			this.subtext(i + "에 " + anw[i] +"를 입력해 주세요", this.controltag["owner"]);
			break;
		}
		
	}
	
	questioncontrol = (call) => {

		if(this.questiontag["owner"]){
			this.questiontag["owner"].parentNode.removeChild(this.questiontag["owner"]);
		}

		this.questiontag["owner"] = document.createElement("div");
		this.controlform.appendChild(this.questiontag["owner"]);

		var con = this.question["owner"][this.questioncondition["owner"]];
		
		this.subtext(con.질문, this.questiontag["owner"]);
		
		if(con.답변){
			var tem = this.subselect(con.답변, this.questiontag["owner"], "","","",1)
			
			this.button("확인하기", () => {
				
				if(con.답변[tem.value] != "미비점"){
					//현재 상태 업데이트
					this.questioncondition["owner"] = con.답변[tem.value];
					this.firsttesting();
					console.log(190909090);
					
				}else{
					//hidden tag(onwertesting) 추가해서 보낼 것
					this.hiddentag("ownertesting", con.답변[tem.value]);
					console.log(this.controlform)
					call();
					
				}
			}, this.questiontag["owner"]);
		}
	}
	
	firsttesting = (call) => {
		
		// owner1이 팀장급 이하인 담당자일 경우
		console.log(this.sentencetag)
		
		/* 이 부분 var arr = ["owner2", .....] 식으로 수정할 것
		// 그래서 일괄적으로 조건과 수행으로 수정할 것
		
		if(this.sentencetag.owner2.value == "담당자"){
			
			// 서버에서 이미 이 문제점이 해결되었는지 확인하기
			// 아작스 요청후 이것을 실행하도록 수정할 것
			this.questioncontrol(call)

			
		}else{
			// 오류가 없으니 제출하면 됨.
			
			call()
		}
		*/
		call();
		
	}
	
	
	valuetesting = (call) => {
		// 공백이 있을 경우에는 request를 하지않고, 다시 입력하라고 여기서 요청을 보냄
		/* 모양이 바뀌어서 일단 아래를 삭제
   		for(var i in this.formdata){
   		  if(i != "process"){	
   			if(this.controlform[i].value == ""){
   				alert("값이 비어 있는 곳이 있습니다. 모두 입력해 주세요")
   				return
   			}else{
   	   			this.formdata[i] = this.controlform[i].value;
   			}
   		  }	
   		}
		*/ 
 
		call();
		
	}
	//
	
		
conditioning = (name , call, tag, cou, i) => {

   		$.ajax({
   			type : "POST",
   			url : 'condition/media',
   			data : {name : name},
   			success : (res) => {
   				console.log(res)
   				call(res, tag, cou, i);		
			
			}
		})
		
}

conditionloop = (array, value) => {
	console.log(array)
	for(var i in array.call){
		this.conditioning2(array.call[i].func, array.call[i].para, value, array.call[i].name);
	}
}

conditioning2 = (name, para, value, tagname) => {
	return new Promise(resolve => {
		
		console.log(value);
		
   		$.ajax({
   			type : "POST",
   			url : 'condition/' +  name,
   			data : {name : para, value : value},
   			success : (res) => {
   				console.log(res)
   				console.log(this.controlform[tagname]);
   				
 	   			this.updateselecttag(res, this.controlform[tagname]);
   		
   				
   				resolve()
			
			}
		})			
	})

}
	
	process(res){
		
	   	if(res.success.type == "success"){
	   		//
	   		this.appending(res);
	   		
	   	}else{
	   		//실패하였으므로 새롭게 입력받을 form을 만들어야 함
			actcount += 1;
			this.next = actcount;
			console.log(12345)

			//현재 작성된 폼의 
			var acting = new making();
			acthash[actcount] = acting;
			acting.number = actcount;
			acting.before = this.number;
			acting.appending(res);

	   	}		
	}   	

	
	showing = () => {
		document.body.appendChild(this.controlform);
		return this;
	}

	nonshowing = () => {
	       this.controlform.parentNode.removeChild(this.controlform);
	}
    
	temptext = (key, korea, val ,where) => {
		
		console.log(where)
		return () => {this.text(key, korea,val, where)}
		
	}
	
	addlisten2 = (tag, action, tem) => {
		 
		   tag.addEventListener(action, () => {
			   console.log(tem)	   
			   tem.innerText = tag.value}, false);
	}
	
	
	makesentence(res, name){

		//querySelect
		console.log(name)
		
		this.sentencetag[name] = document.createElement("div");
		this.sentencetag[name].style = "overflow : hidden; border : 1px solid black";
		this.controlform.appendChild(this.sentencetag[name]);
		
		for(var i in res){
			
			var style = "float : left;"
			
			if(res[i].type == "string"){
			    var tem = this.subtext(res[i]["value"] + "\u00A0", this.sentencetag[name], "div", res[i].name);
			
			}else if(res[i].type == "array"){
			    var tem = this.subselect(res[i]["value"], this.sentencetag[name], res[i].name,
			    		(res, tag, name) => {
			    			this.conditionloop(res,  tag.target.value)}
			    , res[i]);
		    	this.sentencetag[res[i].name] = tem;

			}else if(res[i].type == "check"){
				
				if(korea[res[i]["value"]]){
					var realvalue = korea[res[i]["value"]];
				}else{
					var realvalue = res[i]["value"];
				}
				
			    var tem = this.checkbox(res[i].name, realvalue, this.sentencetag[name]);
		    	this.sentencetag[res[i].name] = tem;
			
			}else if(res[i].type == "check2"){
				
				if(korea[res[i]["value"]]){
					var realvalue = korea[res[i]["value"]];
				}else{
					var realvalue = res[i]["value"];
				}
				
			    var tem = this.checkbox2("check2", res[i].name, "아래항목들", realvalue, this.sentencetag[name]);
		    	this.sentencetag[res[i].name] = tem;

			}else if(res[i].type == "array2"){	

				if(korea[res[i]["value"]]){
					var realvalue = korea[res[i]["value"]];
				}else{
					var realvalue = res[i]["value"];
				}

				
				//array2control이란 함수를 만들면 될 것 같음
				
				var button1 = this.button("항목추가", () => {
					var val = this.stringlistarr.length;
					this.stringlistarr[val] = this.select2("stringlist[" + val + "].key", "stringlist[" + val + "].value", realvalue)
				});
				var button2 = this.button("항목삭제", ()=>{
					var val = this.stringlistarr.pop();
 				    val.parentNode.removeChild(val);
				});
				
			    this.stringlistarr[0] = this.select2("stringlist[0].key", "stringlist[0].value", realvalue);
			
			}else if(this.jsonset.has(res[i].type)){	
			    console.log(res);
			    
				var count = Object.keys(this.jsontag).length;
                var jsonname = "jsonmake" + count;
			    
				this.jsontag[jsonname] = document.createElement("div");
				this.jsontag[jsonname].style = "border : 1px solid black"
				
				for(var i1 = 0; i1 < 10; i1++){
					if(res[i].value[i1]){
						console.log(res[i].value[i1]);
						var tag = this.jsonmake(res[i].value[i1]);
						tag.style = "overflow: hidden; ";
						this.jsontag[jsonname].appendChild(tag);
						
					}else{
						break;
					}
				}
				
              if(jsonname == "jsonmake0"){  /// 0일때는 첫번째 아래항목에 대응하고 그 다음부터는 체크박스 addon으로 사용하기위해 구분
                 this.jsoncheck(jsonname, name) 
              }else{
            	 //jsonmake0은 hidden으로 이름을 아래항목에다가 세기고 그 외에는 자체에다가 hidden으로 세김
       		   var field = document.createElement("input");
    		   field.setAttribute("type", "hidden");
    		   field.setAttribute("name", jsonname);
    		   this.jsontag[jsonname].appendChild(field);
            	  
              }				
				console.log(this.jsontag[jsonname])
			 /*
			   console.log(field.checked);
			   if(field.checked == true){
				   for(var i in realvalue){
					   
					   if(korea[realvalue[i]]){var real = korea[realvalue[i]]}else{real = realvalue[i]}
					   this.liststring[i] = this.checkbox(key2 + "." + realvalue[i], real);
				   }   
			   }else if(field.checked == false){
				   for(var i in realvalue){
		   				this.liststring[i].parentNode.removeChild(this.liststring[i]);

				   }   
				   
			   }	 
			 */
			}else if(res[i].type == "take"){
			    
				//앞에서 끌어오기 위해서 take를 만들었음
				var tag = this.jsonmake(res[i].value);
				
				this.sentencetag[name].appendChild(tag);
				this.taketag[res[i].name] = tag;
				this.takemapping[res[i].name] = res[i].value[res[i].name][0]; 
				
				
			}else if(res[i].type == "text"){
				
			    var tem = this.onlytext(res[i].name, this.sentencetag[name]);
			    tem.value = "작성필요";
			    style = style + "height : 15px"
		    	this.sentencetag[res[i].name] = tem;
				
			}else if(res[i].type == "find"){
				
				var tem = this.subtext(this.sentencetag[res[i].name].value, this.sentencetag[name], "div", res[i].name);
				
				this.addlisten2(this.sentencetag[res[i].name], "change", tem);
				style =style + "background : black; color : white;"
			}	
			tem.style = style;
		    
		}
	}

	
	jsoncheck = (jsonname, name) => {
	    var tem = this.checkbox(jsonname, "아래항목", this.sentencetag[name], () => {
	    	console.log(jsonname)
	    	console.log(this.controlform[jsonname])
			 if(this.controlform[jsonname].value == "true"){
    			 this.jsontag[jsonname].parentNode.removeChild(this.jsontag[jsonname])
	    	 }else{
    	    	 this.controlform.appendChild(this.jsontag[jsonname])
	         }
         });

	}
	
	array2control(arr){
		
		for(var i in arr){

			if(i == "필수"){
			   for(var i in arr){
					this.array2essential(arr[i]);
			   }
			}else if(i == "선택"){
				for(var i in arr){
    				this.array2nonessential(arr[i])
				}
			} 
		}
	}
	
	
	//0720 여기부터
	jsonmake(arr){
		
		
 	    var pword = document.createElement("div");
		
        // 앞으로 data에 이것저것 데이터 집어넣고 여기서 통제활동서 들어오는 데이터도 컨트롤 할 것
        
        
        var reallist = []; // hash에 순서가 부여되지 않아서 순서 부여를 위해서 reallist를 사용 arr의 제목의 가장 끝은 순서를 뜻함
        
        for(var i = 0; i < Object.keys(arr).length; i++){
        	reallist.push(0)
        };
        
		for(var i in arr){
			
			
			var list = [];
			
			
			for(var j = 0; j <= 10; j++){
				if(arr[i][j] != null){
					
					// "data[x]" 꼴을 실제 this.data[x]로 변형시킬것
					var val = arr[i][j]
					
					if(typeof(val) == "object"){
						
					}else if(arr[i][j].match("data\\[.+\\]")){
						var temp = arr[i][j].match("data\\[.+\\]")
						val = this.data[temp[0].substring(5, temp[0].length - 1)]
					}
					
					list.push(val);
					
				}else{
					break;
				}
			}
			
			
			// 나중에 다양하게 변형해보자
			// i의 끝숫자가 리스트의 순번으로 세팅할 것
			if(Object.keys(arr).length == 1){
				
			    var count = "0";
			    var val = i.substring(0, i.length - count.length);
			}else if(i.match('[0-9]+$')){
				var count = i.match('[0-9]+$')[0];	
				var val = i.substring(0, i.length - count.length);
			}

			var abc = this[val].apply(this[val], list)
			abc.style = "float : left;";
			console.log(reallist);
			console.log(count);
			
			reallist.splice(count, 1, abc);
		}
		
		
		console.log(reallist);
		
		
		for(var i in reallist){
			pword.appendChild(reallist[i]);
		}
		
		
		return pword;
		
	}
	
	
	array2essential(key, val){
			this.stringlistarr[this.stringlistarr.length] = this.text2("stringlist[" + key + "].key", "필수 : " + val,"stringlist[" + key + "].value")
            return this.stringlistarr[this.stringlistarr.length];
	}
	
	array2nonessential(){
            key = this.stringlistarr.length
			this.stringlistarr[key] = this.text2("선택 : ", "stringlist[" + key + "].key", "", "stringlist[" + key + "].value", "")

			// 선택값은 추가추가해서 더 많이 사용할 수 있도록 버튼 활성화 하기
			
			// 버튼에 id 값 같은 것을 집어넣어야 함. 0720
			var button1 = this.button("항목추가", () => {
				this.array2nonessential();
			});
			
			this.stringlistarr[val].appendChild(button1);

			var button2 = this.button("항목삭제", (val) => {
				//가장 큰 값부터 삭제하는 것이 아닌 누른 항목에 관한 값을 삭제하는 방식으로 가야함
			    val.parentNode.parentNode.removeChild(val.parentNode);
			});

			this.stringlistarr[val].appendChild(button2);
	        return this.stringlistarr[this.stringlistarr.length];
	}
	
	
	documenttype(res, cou){
		

		
		
		// div로 계층을 구현하기 위해서 위에서 tag를 추가로 만듦
		var realtag = document.createElement("div");
		this.subtext("문서의 작성", realtag);
		realtag.style = "overflow : hidden; border : 3px solid black";
        this.controlform.appendChild(realtag);
        
		
		for(var i in res){
			
			if(i.match("document$")){

				var temptag = document.createElement("div");
				temptag.style = "float : left; border : 3px solid black";
				realtag.appendChild(temptag);

				/*
				
				this.subtext(korea[i], temptag);
	            // 콜백함수 구현
	            // 미디어에 관한 것 구현
     			  console.log(this.meddetail);
	            
	            
	            //문서(sentence)와 연관시키기 위해서 아래와 같이 셋팅을 함
	            this.select("documenttype[" + cou + "]." + i + ".media", "미디어", this.selection["media"], 
	         		   (res, tag, cou, i) => {
	         			  if(this.sentencetag[i + ".media"]){this.sentencetag[i + ".media"].innerText = res.value;}
	         			   
	         			   this.conditioning(res.value, (res, tag, cou, i) => {
	                            this.select("documenttype[" + cou + "]." + i + ".meddetail", "파일종류", res.meddetail, 
	                            		(res) => {if(this.sentencetag[i + ".meddetail"]){this.sentencetag[i + ".meddetail"].innerText = res.value;}}, tag);
	                            
                    	        this.select("documenttype[" + cou + "]." + i + ".transsystem", "파일전송", res.transsystem, 
                    	        		(res) => {if(this.sentencetag[i + ".transsystem"]){this.sentencetag[i + ".transsystem"].innerText = res.value;}}, tag);
                                
	         			   }, tag, cou, i)
	        			   
	         		   }, temptag, cou, i);
	            
	            this.select("documenttype[" + cou + "]." + i + ".meddetail", "파일종류", 
	            		(res) => {if(this.sentencetag[i + ".meddetail"]){this.sentencetag[i + ".meddetail"].innerText = res.value;}}, "", temptag);
	            this.select("documenttype[" + cou + "]." + i + ".transsystem", "파일전송", 
	            		(res) => {if(this.sentencetag[i + ".transsystem"]){this.sentencetag[i + ".transsystem"].innerText = res.value;}}, "", temptag);			

	            // 나머지 기본내용 세팅
                this.documentcount += 1;
	            // 문서명을 추가로 받을수 있게 버튼 추가
				this.button("문서명 추가" , 
							this.temptext("documenttype[" + cou + "]." + i + ".documentsubject[" + this.documentcount + "].name", "문서명", "", temptag)
						, temptag)

				*/		
						
				console.log(res[i])
	            for(var j = 0; j < res[i].length ; j++){
	            	
	            	if(res[i][j].type == "string"){
						this.text("documenttype[" + cou + "]." + i + "." + res[i][j] + "[0].name", korea[res[i][j]], "", temptag);
	            	}else{
	            		this.select(res[i][j].name, korea, this.selection[res[i][j].type] , "", temptag, "", "")
	            	}
				}
	            
				
				
			}else{

				this.subtext("작성항목", realtag);
				// 다쿠먼트 스트링에 대한 것
	            // 나머지 기본내용 세팅

	            for(var j = 0; j < res[i].length ; j++){
					this.checkbox("documenttype[" + cou + "].documentstring["+ j +"].val", res[i][j], realtag);
				}
				
			}
			
		}
		
		console.log(this.controlform)
		
	}
	
	appending(res, parameter) {

		// parameter는 나중에 바인딩을 편하기 위해서 만듬
		
		   this.res = res;
           console.log(res);
           
		   // 이것을 button, message, document 등의 함수로 구성해서 바꿀것
		   var num = 0;
		   
		   // selection 값을 
		   
		   for(var i in res){

			   var val = res[i];
			   if(val == null){
				   val = "";
			   }
		      
			   // 내용 적기
			   if(korea[i]){
				   
				   // korea
				   var kor = i
				   if(korea[i]){
					   kor = korea[i];
				   }
				   
				   
				   if(this.selection[i]){
					   
					   this.select(parameter + i, kor, this.selection[i]);
				   
				   }else if(this.checking[i]){
					   
					   this.checkbox(parameter + i, kor)   
		
				   }else if(typeof(res[i]) == "object" && res[i] != null){
					    
					   this.select(parameter + i, kor, res[i]);
				    	   
				   }else{
					   
					   this.text(parameter + i, kor, val);
				   
				   }
			   }   
		   }
		  
		
			//var abc = document.getElementById(this.activity);
			//abc.innerText = document.form[this.activity].value;
		}


	// 이 아래로는 액션을 위한 동작을 코딩함
	
	makeform(url){
		       console.log(url);
		       
		       this.url = url
			   var form = document.createElement("form");
			   
			   form.setAttribute("charset", "UTF-8");
			   form.setAttribute("name", "controlform");
			   form.setAttribute("method", "Post");  //Post 방식
			   //form.style = "position : absolute; top : " + this.top + "px";   
			   if(url){
				   form.setAttribute("action", url);   
			   }
 
			   // 리액트를 사용하면 해결될 문제
    		   var field = document.createElement("input");
    		   field.setAttribute("type", "hidden");
    		   field.setAttribute("name", "number");
    		   field.value = this.name;
    		   form.appendChild(field);

    		   // 제목 쓰기
    		   var field = document.createElement("h3");
    		   field.setAttribute("id", this.name);
    		   field.innerText = this.name;
    		   form.appendChild(field);
    		   
       		   this.controlform = form			
    		   var abc = document.getElementsByClassName("controlform");
    		   console.log(abc)
    		   for(var i = 0; i < abc.length; i++){
    			   abc[i].appendChild(form);
    			   break;

    		   }
    		    

	}
	
	hiddentag(name, value, where){
		
		   var field = document.createElement("input");
		   field.setAttribute("type", "hidden");
		   field.setAttribute("name", name);
		   field.value = value;
		   if(where){
			   where.appendChild(field);
		   }else{
			   this.controlform.appendChild(field);
		   }

	}
	
	code(data){

		if(data.name == "number"){
			this.number = data.array;
		}

		if(data.name == "next"){
			this.next = data.array;
		}

		if(data.name == "before"){
			this.before = data.array;
		}
	}


	subtext = (key, where, temsize, name) => {
		
		var size = "div";
		if(temsize){
			size = temsize;
		}
		
		
		   var field = document.createElement(size);
		   field.innerText = key;
		   
		   if(name){field.setAttribute("name", name);}
		   
		   if(where){
			   where.appendChild(field);
		   }else{
			   this.controlform.appendChild(field);
		   }
		   
		   return field;
		   
		}
	
	updateselecttag(data, where){

		console.log(data)
        if(where){
        	
        
		for(var j in data.ok){
	       	   var option = document.createElement("option");
	       	   option.innerText = data.ok[j];
	           where.appendChild(option);
			}

        }
	}
	
	
	onlytext = (data, where) => {

		console.log(data)
       
        	
 		var field = document.createElement("input");
		field.setAttribute("type", "text");
		field.setAttribute("name", data);
		field.setAttribute("value", "");
		
		if(where){   
		   where.appendChild(field);
           
        }
		
		return field;
	}

	
	
	subselect = (data, where, name, call, res, opt) => {
		
	
       var real = document.createElement("div");
	   var field = document.createElement("select");
	   
	   if(name){field.setAttribute("name", name);}
	   
   	   for(var j in data){
       	   var option = document.createElement("option");
           console.log(opt);
           
       	   if(opt == 1){
           	   option.innerText = j;
       		   
       	   }else{
           	   option.innerText = data[j];
       	   }
           field.appendChild(option);
		}
		   
   	    real.appendChild(field)
		   
	   if(where){
		   where.appendChild(real);
	   }else{
		   this.controlform.appendChild(real);
	   }

  	   // 혹시 변동값에 반응한다면 함수를 추가로 집어넣을것
  	   if(call){
  		   console.log(name)
  		  field.addEventListener("change", (tag) => call(res, tag, name), false);
  	   }
   	    
	   return field;		
	}

	
	//select와 text를 함께 묶음으로 두기위해 만들었음
	select2 = (key1, key2, data, where) => {
	       var real = document.createElement("div");
		   var field = document.createElement("select");
		   field.setAttribute("name", key1);

		   for(var j in data){
	       	   var option = document.createElement("option");
           	   option.innerText = data[j];
	           field.appendChild(option);
			}
		   real.appendChild(field);

		   var field = document.createElement("input");
		   field.setAttribute("type", "text");
		   field.setAttribute("name", key2);
           real.appendChild(field);

    	   if(where){
    		   where.appendChild(real);
    	   }else{
    		   this.controlform.appendChild(real);
    	   }
          
    	   return real;
	}
	
	
	select = (key, korea, data , call, where, cou, i) => {
		
		   if(this.formcon[key]){
		   // 기존의 것이 있다면 지우고 다시 만들기
		       var pword = this.formcon[key][0]
               console.log(pword)
		       this.formcon[key][1].parentNode.removeChild(this.formcon[key][1]);

		   }else{
			   var pword = document.createElement("div");
		   }
		   
		   pword.innerText = korea;
		   var field = document.createElement("select");

		   
		   
		   

		   
		   field.setAttribute("name", key);
     	   this.formdata[key] = "";

     	   for(var j in data){
         	   var option = document.createElement("option");
         	   option.innerText = data[j];
               field.appendChild(option);
			}
           
     	   // 혹시 변동값에 반응한다면 함수를 추가로 집어넣을것
     	   if(call){
     		  field.addEventListener("change", () => call(field, where, cou, i), false);
     	   }
     	   
		   pword.appendChild(field);
		   
		   if(!this.formcon[key]){
			   
			   if(where){
				   where.appendChild(pword);
			   }else{
				   this.controlform.appendChild(pword);
			   }
		   }
	       this.formcon[key] = [pword, field]; 
	       return pword;
	       
	}
	
	changecheck(field, val){
		
		field.value = val;
	}
	
	// 체크하면 새로운 항목을 아래에 펼쳐지게 할 생각으로 만들었음
	checkbox2 = (key, key2, kor, realvalue, where) => {
		
		   var pword = document.createElement("div");
		   pword.innerText = kor;

		   var field_sub = document.createElement("input");
		   field_sub.setAttribute("type", "hidden");
		   field_sub.setAttribute("name", key);
		   field_sub.value = false;
		   
		   var field = document.createElement("input");
		   field.setAttribute("type", "checkbox");
		   field.addEventListener("change", ()=> {
			   this.changecheck(field_sub, field.checked)
			   console.log(field.checked);
			   if(field.checked == true){
				   for(var i in realvalue){
					   
					   if(korea[realvalue[i]]){var real = korea[realvalue[i]]}else{real = realvalue[i]}
					   this.liststring[i] = this.checkbox(key2 + "." + realvalue[i], real);
				   }   
			   }else if(field.checked == false){
				   for(var i in realvalue){
		   				this.liststring[i].parentNode.removeChild(this.liststring[i]);

				   }   
				   
			   }
			   
		   }, false);
           field.value = false;
		   //this.formdata[key] = ""
		   pword.appendChild( field_sub);
		   pword.appendChild(field);
		   
		   
		   if(where){
			   where.appendChild(pword);
		   }else{
			   this.controlform.appendChild(pword);
		   }
		   this.formcon[key] = pword; 
		   return pword;
	}
	
	takeget = (json) => {
		
		var pword = document.createElement("div");
		console.log(json);
		for(var i = 0; i < Object.keys(json).length; i++){

	    	this.taketag[json[i]].addEventListener("change", () => {
		    	var string = "";
		    	
		    	for(var ia = 0; ia < Object.keys(json).length; ia++){
		    	  
		    	  console.log(this.controlform[this.takemapping[json[ia]]]);	
				  if(this.controlform[this.takemapping[json[ia]]].value == "true"){
					string = string + "," + this.taketag[json[ia]].innerText;
			    	
			    	console.log(string);
				  }
		    	}
		    	pword.style = "float : left; border : 1px solid red"
		    	pword.innerText = string.substring(1, string.length);
		    	
    		}, false);
	    	
		}
		
		return pword;
	}
	
	
	checkbox = (key, korea, where, call, addon) => {
		
		   var pword = document.createElement("div");

		   var field_sub = document.createElement("input");
		   field_sub.setAttribute("type", "hidden");
		   field_sub.setAttribute("name", key);
		   field_sub.value = false;
		   
		   var field = document.createElement("input");
		   field.setAttribute("type", "checkbox");
           
		   
		   if(addon){
			   console.log(addon)
                
			   field.addEventListener("change", () => {
				   console.log(this.jsontag[addon])
				   if(this.controlform[addon]){
						 this.jsontag[addon].parentNode.removeChild(this.jsontag[addon])
					 }else{
						 this.controlform.appendChild(this.jsontag[addon])
					 }
				   this.changecheck(field_sub, field.checked);
			   }, false);
			   
			   
		   }else if(call){
			   field.addEventListener("change", () => {
				   call();
				   this.changecheck(field_sub, field.checked);
			   }, false);
			  
		   }else{
			   field.addEventListener("change", () => this.changecheck(field_sub, field.checked), false);
		   }
		   
           field.value = false;
		   //this.formdata[key] = ""
		   pword.appendChild(field_sub);
		   pword.appendChild(field);
		   field.after(korea);
		   
		   
		   
		   
		   if(where){
			   where.appendChild(pword);
		   }else{
			   this.controlform.appendChild(pword);
		   }
		   
		   
		   this.formcon[key] = pword; 
		   return pword;
	}
	

	button(key, call, where){
		   
		   var field = document.createElement("input");
		   field.setAttribute("type", "button");
		   field.setAttribute("value", key);
		   field.addEventListener("click", call, false);
		   
		   if(where){
			   where.appendChild(field);
		   }else{
			   this.controlform.appendChild(field);
		   }
		   
	}

	text = (key , korea, val, where) => {

		 console.log(this)
		 console.log(where)
		 
		 if(!val){val = ""}
		 
    	   var pword = document.createElement("div");
		   pword.innerText = korea;
		   this.formdata[key] = "";
		   var field = document.createElement("input");
		   field.setAttribute("type", "text");
		   field.setAttribute("name", key);
		   field.setAttribute("value", val);
		   pword.appendChild(field);
		   
		   if(where){
			   where.appendChild(pword);
		   }else{
			   this.controlform.appendChild(pword);
		   }
		   this.formcon[key] = pword; 
		   
		   return pword;

	}

	text2 = (text, key1, val1, key2, val2, korea, where) => {

   	   var pword = document.createElement("div");
		   pword.innerText = korea;
		   var field = document.createElement("input");
		   field.setAttribute("type", "text");
		   field.setAttribute("name", key1);
		   field.setAttribute("value", val1);
		   pword.appendChild(field);

		   var field = document.createElement("input");
		   field.setAttribute("type", "text");
		   field.setAttribute("name", key2);
		   field.setAttribute("value", val2);
		   pword.appendChild(field);

		   if(where){
			   where.appendChild(pword);
		   }else{
			   this.controlform.appendChild(pword);
		   }
	}

}


class canvasmaking {
	
	constructor (obj, name, form) {
		//super();
		this.name = name;
		this.sublist = obj;
		this.position = {};
		this.form = form;
		this.totaldata = {};
		this.data = {top : 10, left : 20};
		this.leftsize = 150;
		this.fontsize = 15;
		this.topsize = 40;
		this.buttonsize = 50
        this.currentview = {};
		this.formdata = {};
		
		// 캔버스 가져오기
     	this.canvas = document.getElementById('canvas');
     	this.context = this.canvas.getContext('2d');
        this.context.font = this.fontsize + "px Arial";
	
	}
	
	// 아작스 하기
	
	sending = () => {
		console.log(8888888);
		
		return new Promise(resolve => {
			
			console.log(this.formdata);
			console.log('canvas/' + this.name);
	   		$.ajax({
	   			type : "POST",
	   			url : 'canvas/' + this.name,
	   			data : this.formdata,
	   			success : (res) => {
	   				
	   				console.log(res);
	   				
	   				if(res != null && typeof(res) == "object"){

	   				   var made  = new making();
                       made.name = this.name;
                       made.formdata = this.formdata;
                       made.process = res.process;
                       made.act = res.act;
                       made.top = this.canvas.height;
                       made.document = res.doc;
                       var url = "/pja/processtest/" + made.name;
                       made.makeform(url);
                       //made.document	ing();
                       made.subtext("기본내용");
                      // made.appending(res.process, "");
                      
                       // 콜백함수 구현
                       made.data["division"] = res.division;
                       
                       console.log(made)
                  
                       /*
                       made.select("media", "미디어", made.selection["media"], 
                    		   () => {
                    			   made.conditioning(made.controlform.media.value, (res) => {
                    				   console.log(res)
                                       made.select("meddetail", "파일종류", res.meddetail);
                                       made.select("transsystem", "파일전송", res.transsystem);
                    			   })
                   			   
                    		   });
                       
                       made.select("meddetail", "파일종류", "");
                       made.select("transsystem", "파일전송", "");
                       
                       
                       made.subtext("액티비티");
                       made.appending(res.act , "Activitydata.");
                       */
                       // 이 함수에 여러개를 집어넣을 것(documenttype 하단으로 모든 것을 보냈으므로)
                      
                       //made.documenttype(res.documenttype, 0)
                       made.button("제출하기", () => made.firsttesting(() => made.valuetesting(made.sendingform))); //valuetesting(made.sendingform)

                       
                       var sample = made.subtext(res.sentences_sample, made.sentencetag["sample"], "div", "sample");
                       sample.style =  "border : 3px solid red";
                       made.makesentence(res.sentences_approve, "approve")
                       //made.makesentence(res.sentences_document, "document")
                       makingobject[name] = made;

                    // 답변 양식 세팅   
               		made.questiontag = {};
               		made.question = {owner : {질문1 : {질문 : made.process.name + "을 팀장급 이상이 아닌 담당자가 승인하고 있습니까?",
            				                                                         답변 : {그렇다 : "미비점", 아니다 : "질문2"}}
            		                         ,질문2 : {질문 : "그럼 승인자를 다시 선택해 주세요"}}
            		}
               		made.questioncondition = {owner : "질문1"}
                       
                       
                       resolve(made);
	   				};
	   			}
	   		})	
		})	
	}
	
	objmaking = () => {

		
	}

	showing = async(name) => {
	
	  
	  if(this.currentview.nonshowing){
		  console.log("들어왔니")
		  this.currentview.nonshowing();  
	  }	
	  
	  this.name = name;
	  this.currentview = await this.sending();
	  this.currentview.showing();
	  
		
	}

	addlisten = (tag, name) => {
		  console.log(name);
		   tag.addEventListener("click", () => this.showing(name), false);
	}
	
	
	
    // sublist 순환시키기
	sublistloop = () => {

	   this.data = {top : 10, left : 20}	
	   this.name = this.formdata.name;	
	   var first = this.sublist[this.name];

	   // 사각형 그리고 다음위치 세팅 그리고 jstl의 테그를 끌어옴
	   //this.rect()
	   
	   this.form[this.name + '보조'].parentNode.style = "position : absolute; width: 180px; left : " + this.data.left + "px;" + "top : " + this.data.top + "px; border: 1px solid #aaaaaa; overflow: hidden;";

	   this.position[this.name] = {top : this.data.top, left : this.data.left};
	   this.data.top += this.topsize * 2;

	   // 맞는 jstl의 버튼의 위치 끌어오기
	   
	   var temp = first.subpro;
	   var nextarr = Array.prototype.slice.call(temp);
	   var templeft = this.data.left;
	   
	   while(nextarr.length > 0){

		   var count = 0;
		   var temp2 = []
           this.data.left = templeft;
		   
		   for(var i in nextarr){
			   
			   // 사각형 그리고 다음위치 세팅 그리고  맞는 jstl의 버튼의 위치 끌어오기
			   this.name = nextarr[i];
			   //this.rect()
		   	   
			  // makingobject[this.name] = await this.sending();
			   var left = 0 // this.data.left + this.leftsize;
			   
			   this.form[this.name + '보조'].parentNode.style = "position : absolute; width : 180px; left : " + this.data.left + "px;" + "top : " + this.data.top + "px; border: 1px solid #aaaaaa; overflow: hidden;";;
			   this.position[this.name] = {top : this.data.top, left : this.data.left};
	
               
               console.log(this.name);
               
			   this.line(this.position[this.sublist[this.name].superpro], this.data)
			   this.data.left += this.leftsize * 2;
			   
			   if(this.sublist[this.name].subpro.length > 0){
				   
				   for(var j in this.sublist[this.name].subpro){
					   temp2.push(this.sublist[this.name].subpro[j]);
				   }
			   }
			  
		   }
		   nextarr = Array.prototype.slice.call(temp2);
		   this.data.top += this.topsize * 2;
	   }
	   
	   console.log(makingobject)
   }
	
	
	
	// 사각형 그리기
	rect(){
		
     	this.context.strokeRect(this.data.left, this.data.top, this.leftsize, this.topsize)
        this.context.fillText(this.name, this.data.left + 10, this.data.top + this.topsize/2 -5)  
        this.context.fillText(this.sublist[this.name].preparer1, this.data.left + 10, this.data.top + this.topsize/2 + 15)  
       
	}	
		
	
	// 선 그리기
    line(a, b){
    	this.context.beginPath();
    	this.context.moveTo(a.left + this.leftsize/2, a.top + this.topsize);
    	this.context.lineTo(b.left + this.leftsize/2, b.top);
        this.context.stroke();
	}
	
    button(val, leftplus, topplus, name){
    	
		var field = document.createElement("input");
		field.setAttribute("type", "button");
		field.setAttribute("value", val);
		field.addEventListener("click", this.sending, false);
		
		var left =  this.data.left + this.leftsize + leftplus;
		var top =  this.data.top + topplus;
		field.style = "position : absolute; left : " + left + "px;" + "top : " + top + "px";
		document.body.appendChild(field);
	}
	
}  






function openchild(name)
{
	console.log(name);
    // window.name = "부모창 이름"; 
    window.name = "parentForm";
    // window.open("open할 window", "자식창 이름", "팝업창 옵션");
    var url = '<c:url value = "/subwindow" />'
    subwin = window.open(url,
            "childForm", "left = 500, top = 250, width=570, height=350, resizable = no, scrollbars = no");    

    selectedname = name;
    
    submaking = new making();
    submaking.makeform("/pja/subwindow2");

}




   // 윈도우 켜진후
    window.onload = function(){
    
	 
    	var sess = document.getElementsByClassName("sess");

    	var request = createRequest(request);
     	request.onreadystatechange = function (event){
    		if(request.readyState ==4){
    			if (request.status == 200){
        			//console.log(request.response)
        			
    			}
    		}
    	}
     	
     	
     	realname = "${name}" 

     	
        <c:forEach var = "q2" items = "${processlist}" >
            processlist.push("${q2}")
        </c:forEach>
     	
     	
     	canvasmake = new canvasmaking(object, realname , form)
     	
     	console.log(canvasmake)
     	//canvasmake.makeform();
        <c:forEach var = "q" items = "${formdata}" >
        	canvasmake.formdata["${q.key}"] = "${q.value}";
        </c:forEach>

        canvasmake.sublist = JSON.parse(`${sublist}`);
        
        console.log(canvasmake.sublist)
        
        canvasmake.sublistloop();  
        console.log(canvasmake.formdata)
     	
     	// 부서리스트 집어넣기
        <c:forEach var = "q2" items = "${divisioninfo}" >
            divisions.push("${q2}")
        </c:forEach>
        <c:forEach var = "q2" items = "${divisionlist}" >
            divisionlist.push("${q2}")
        </c:forEach>

            
        <c:forEach var = "q2" items = "${enumhash}" >
           var temp = []
        <c:forEach var = "q3" items = "${q2.value}" >
           temp.push("${q3.key}");
        </c:forEach> 
           enumhash["${q2.key}"] = temp;
        </c:forEach>   	
         
        canvasmake.sending();    
    }

   
</script>


<body>

	<form name = "form" action = "/pja/inputaction" method = "post">
     <div class="droptarget" ondrop="drop(event)" ondragover="allowDrop(event)" id = "bmodel">
      <c:forEach var = "q2" items = "${sublist}" >
        <div id = "${q2.key}" ondragstart="dragStart(event)" ondragend="dragEnd(event)" draggable="true"> ${q2.key}
         <c:if test= "${authInfo.division eq q2.value.preparer1}" >
            <input type =  "button" name = "${q2.key}" class = "${q2.value.preparer1}" value = "${ q2.value.writen}"  />
         </c:if>
         <input type = "button" name = "${q2.key}보조" class = "${q2.value.preparer1}" value = "추가" onClick = "openchild('${q2.key}')" />
        </div>
      </c:forEach>
     </div> 
	</form>       
    

    <div class="droptarget" ondrop="drop(event)" ondragover="allowDrop(event)" id = "amodel">
    </div>
    
    <div class = "controlform"></div>
     
    <canvas id = 'canvas' width ="300px" height ="800px" style = "position : absolute;  pointer-events: none; left : 0px; top :0px; "/> 
    

</body>
   

<script>

var amodel = document.getElementById("amodel");
var bmodel = document.getElementById("bmodel");

var currentkey= "";
var currenttime = 0;
var currenttemp = 0
var currenttag = ""
var currentx = 0

function distance(a, b){
	  var dist = (a.x - b.x)*(a.x - b.x) + (a.y -b.y)*(a.y -b.y)
	  return Math.sqrt(dist);  
	}


function dragStart(event) {
      console.log(event.target)
	  event.dataTransfer.setData("Text", event.target.id);
      currentkey = event.target.id
      currenttemp = 1;
	}

function dragEnd(event) {
	}

function allowDrop(event) {
		
	  event.preventDefault();
	  //너무 자주 실행하는 것을 방지하기 위해서
	  if(currenttime == 0){
	  
	 	  
	  setTimeout(()=> currenttime = 0, 100) 
	  
      var realdist = 10000;
	  var realtag = "";
	  var realx = 0;
	  var val = "";
	  
	  
	  // 여기서 거리체크하기
	  bmodel.childNodes.forEach((e) => {
		   
		    if(e.style && currentkey != event.target.id){
		      var x = e.getBoundingClientRect().left;
		      var y = e.getBoundingClientRect().top;
		      var dist = distance({x: event.clientX, y: event.clientY}, {x: x, y: y});
		      if(dist < realdist){
		        realdist = dist;
		        realtag = e;
		        realx = x;
		      }

		    }    
		  })
      
		  if(realtag.style){
			  realtag.style.backgroundColor = "blue"
			  
			  if(realtag.id != currenttag && currenttemp != 1){
				  
				  if(currenttag){
					  var tag = document.getElementById(currenttag);
					  console.log(tag)
					  tag.style.backgroundColor = "white";
				  }
				  currenttag = realtag.id
				  
				  // 아래로 집어넣을집, 배열하나 추가해서 옆으로 집어넣을지 결정하기
			  
				  currentx = decision(realx, event.clientX)
				 
				  
			  }
			  currenttemp = 0  
		  }
	  }
	}

    function decision(x1, x2){
    	
    	var val1 = Math.floor(x1/200);
    	var val2 = Math.floor(x2/200);
    	
    	if(val2 > val1){
    		return 1;
    	}
    	return 0;
    }

	function drop(event) {
	  event.preventDefault();
      var data = canvasmake.sublist[currenttag]
	  var eventtag = event.dataTransfer.getData("Text");

      var tag =document.getElementById(currenttag)
      console.log(canvasmake.sublist)
      tag.style.backgroundColor = 'white';
	  
      if(data){
		  var superpro = canvasmake.sublist[eventtag].superpro;
		  
		  if(canvasmake.sublist[superpro]){
		    // 부모의 자식들 순번 중 eventtag의 순번을 찾아서 그 순번에 splice를 이용해 그 eventtag의 자식들을 집어넣기
    	    for(var i = 0; i < canvasmake.sublist[superpro].subpro.length; i++){
    		  
             if(canvasmake.sublist[superpro].subpro[i] == eventtag){
            	 canvasmake.sublist[superpro].subpro.splice(i, 1);
            	 var count = 0
            	 for(var j = 0; j < canvasmake.sublist[eventtag].subpro.length; j++){
            		  var current = canvasmake.sublist[eventtag].subpro[j];
            		  canvasmake.sublist[current].superpro = superpro;
            		  canvasmake.sublist[superpro].subpro.splice(i + count, 0, current);
            		  count += 1;
            	 }
             }
    	    }
		  
		  }else{
			// 처음부터 최상위 노드였다면, 자식들의 부모만 ""로 바꿀것
         	 for(var j = 0; j < canvasmake.sublist[eventtag].subpro.length; j++){
          		var current = canvasmake.sublist[eventtag].subpro[j];
       		     canvasmake.sublist[current].superpro = "";
       		     //최상위 노드를 이름으로 지정해 줄 것. 다만 여러개의 배열이라면 현재로선 약간 문제가 있으니 어떻게 해결할 지 고민할 것
       		     //수정사항
       		     canvasmake.formdata.name = current;
         	 }			
		  }

		  // currentx가 1일때는 push하고, 그렇지 않을때는 자식을 밀어내고 중간에 끼어넣기
		  // 수정사항
		  canvasmake.sublist[eventtag].superpro = currenttag;
		  var pos = 0
          
		  if(currentx == 1){
			  canvasmake.sublist[currenttag].subpro.push(eventtag)
			  canvasmake.sublist[eventtag].subpro = []
		  }else{
		  
		      var child = canvasmake.sublist[currenttag].subpro[pos];
		      canvasmake.sublist[currenttag].subpro.splice(pos, 1, eventtag);
		      if(child){
		    	     canvasmake.sublist[eventtag].subpro = [child]
		    	     canvasmake.sublist[child].superpro = eventtag;
		      }else{
		    	     canvasmake.sublist[eventtag].subpro = []
		      }
		  
		  }
		  // 위치는 다시 정렬했으니, 다시 그릴것
		  console.log(canvasmake);
		  canvasmake.sublistloop();

      }	  
	  
	  
	  /* 나중을 위해서 남겨둠   
	  console.log(data)
	  var realdist = 10000;
	  var realtag = "";
	  var val = "";
	  
	  bmodel.childNodes.forEach((e) => {
	    if(e.style){
	      var x = e.getBoundingClientRect().left;
	      var y = e.getBoundingClientRect().top;
	      
	      var dist = distance({x: event.clientX, y: event.clientY}, {x: x, y: y});
	      if(dist < realdist){
	        realdist = dist;
	        realtag = e;
	        if(y > event.clientY){
	           val = "before";
	        }else{
	           val = "after";
	        }
	      }

	    }    
	  })

	  console.log(data);
	  
	  
	  //event.target.appendChild(document.getElementById(data));
	   if(val == "before"){
	    realtag.before(document.getElementById(data));
	   }else{
	    realtag.after(document.getElementById(data));
	   } 

	  */ 
	   
	/*
	◎ append() - 컨텐츠를 선택된 요소 내부의 끝 부분에서 삽입
	◎ prepend() - 콘텐츠를 선택한 요소 내부의 시작 부분에서 삽입
	◎ after() - 선택한 요소 뒤에 컨텐츠 삽입
	◎ before() - 선택된 요소 앞에 컨텐츠 삽입

	간단하게 예를 들어보면
	<p>  중앙  </p>  이렇게 태그가 있을경우

	append() 는    <p>  중앙  여기에 값이들어감</p>
	prepend() 는   <p>여기에 값이들어감  중앙  </p>
	after() 는        <p>  중앙  </p>여기에 값이들어감
	before() 는      여기에 값이들어감<p>  중앙  </p> 
	*/


	}

</script>






</html>

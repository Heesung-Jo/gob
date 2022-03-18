<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<style>

table.maintable {
    border: 1px solid #444444;
    border-collapse: collapse;
    width: 100%;
   
  }
  
table.maintable th {
  border: 1px solid #444444;
  font-weight: bold;
  background: #dcdcd1;
  width: 100px;

  }

table.maintable td {
    border: 1px solid #444444;
    background: white;
    height: 25px;
    width: 100px;
  }

#content_wrap {
   width: 100%;
   overflow: hidden;
}

#content_center {
   width: 100%;
   overflow: hidden;
}

#content_right { 
  background: white;
  float: left;
  width: 20%;
  height: 100%;
}


#content_left {
 
  width : 70%;
  border: 1px solid #5F6673;
  background: #f7f9fa;
  height: 100%;
  float: left;
  
}


 #content_bottom {
  height: 40%;
  width: 95%;
  display: inline-block;
  border: 1px solid #444444;
  font-weight: bold;
  background: white;
  padding: 0px;
  overflow: hidden;
}


 .listmanage{
  height: 50px;
  width: 95%;
  display: inline-block;
  border: 1px solid #444444;
  font-weight: bold;
  background: white;
  padding: 0px;
  overflow: hidden;
}

#inventory {
  height: 20px;
  display: inline-block;
  overflow: hidden;
  
}

.detailcontent{
  float : left; 
  border: 1px solid black; 
  height: 45%; 
  width: 200px;
  background: gray;
  cursor: pointer;
}

</style>

    <div id = "content_center">
       
       <div id = "content_left">
       </div>
      
       <div id = "content_right">
         <input type = "button" value = "조직도입력" onClick = "basemethod('organization')"/>
         <input type = "button" value = "담당자매핑하기" onClick = "basemethod('person')"/>
         <input type = "button" value = "팀장매핑하기" onClick = "basemethod('leader')"/>
         <input type = "button" value = "팀매핑하기" onClick = "basemethod('team')"/>
         <input type = "button" value = "문서매핑하기" onClick = "basemethod('document')"/>
         <input type = "button" value = "프로세스매핑하기" onClick = "basemethod('system')"/>
       </div> 
       
    </div>
     
    <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
    <script src="/js/go-debug.js"></script>
    <script src="/js/Figures.js"></script>
    <script src = "http://code.jquery.com/jquery-3.4.1.js"></script>
     
     
<script type="text/javascript">

var maincontent ={}

function basemethod(data){
	
	if(data == "organization"){
		maincontent = new organization();
	}else if(data == "team"){
		new teammapping("team", "팀매핑");
	}else if(data == "document"){
		new documentmapping("document", "문서매핑");
	}else if(data == "system"){
		new systemmapping("system", "프로세스매핑")
	}else if(data == "person"){
		new personmapping("person")
	}else if(data == "leader"){
		new personmapping("leader")
	}
	
}

function comma(str){ 
    str = String(str); 
    return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'); 
 } 
 
function numbertag(str, tag){
 	  str = String(str); 
 	  var arr = /[^0-9\-\,]/g.exec(str);

 	  if(arr){
 	  	return tag; 
 	  }else{
 	  	return tag + "text-align: right;"
 	  }
}

function excelExport(event){

    var input = event.target;
    var reader = new FileReader();

    reader.onload = () => {

    	var fileData = reader.result;
        var wb = XLSX.read(fileData, {type : 'binary'});

        var sheet = wb.SheetNames[0];
        var total = wb.Sheets[sheet]["!ref"]
        var start = total.indexOf(":");
        var lastcell = total.substring(start + 1, 10);
        var range = XLSX.utils.decode_cell(lastcell);

        var rowval = maincontent.tablesize.height - 1 //Math.min(range.r+1, this.tablesize.height - 1);
        var colval = maincontent.tablesize.width - 1  //Math.min(range.c+1, this.tablesize.width - 1);
       

        maincontent.tablearr[0][0].innerText = "구분"
        maincontent.tablearr[0][1].innerText = "사업부"
        maincontent.tablearr[0][2].innerText = "팀명"
        maincontent.tablearr[0][3].innerText = "이름"	
        maincontent.tablearr[0][4].innerText = "메일"	
        maincontent.tablearr[0][5].innerText = "직위"	
        
        for(var r = 1; r <= rowval; r++){
           for(var c = 1; c <= colval; c++){

               try{
             	  var tem = comma(wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: c-1})].v)
                  maincontent.tablearr[r][c].innerText = tem
                  maincontent.tablearr[r][c].style = numbertag(tem, "")
                  maincontent.tablearr[r][0].innerText = r	
                  maincontent.member_number = r
               }catch{
            	  maincontent.tablearr[r][c].innerText = "";
               }
           }
        }
        // row를 2로 임의로 배정했으나, 앞으로 이것도 자동 추가해야함
        
        
        // 사실 여기부터 필요있는 코드임. 위의 코드는 원래는 그냥 서버에서 넘겨받는 것임
        wb.SheetNames.forEach(function(sheetName){
	        
	        // 아래 참고하면 경로 읽는 법 알수 있음
	        //var test = wb.Sheets[sheetName][XLSX.utils.encode_cell({c: 1, r: 1})];
	        //var test = wb.Sheets[sheetName]["A1"];

            // A3:B7  => {s:{c:0, r:2}, e:{c:1, r:6}}.
	        //var rowObj =XLSX.utils.sheet_to_json(wb.Sheets[sheetName]);
	        //console.log(JSON.stringify(rowObj));
        })
    };
    reader.readAsBinaryString(input.files[0]);
}








 function ajaxmethod(link, data, act){
	
	return new Promise(resolve => {	
	// 스프링 시큐리티 관련
	var header = $("meta[name='_csrf_header']").attr('content');
	var token = $("meta[name='_csrf']").attr('content');
	
		$.ajax({
			type : "POST",
			url : "/view/" + link,
			data : data,
			beforeSend: function(xhr){
			  if(token && header) {
				  //console.log(header);
				  //console.log(token);
		       // xhr.setRequestHeader(header, token);
			  } 
		    },
		    success : (res) => {
				
		    	// 211015
		    	// res는 있는데, 그림이 안 그려졌음
            	console.log(res);

		    	if(res.error){

		    		var word = new RegExp(res.error.replace(".", "\."), "g");
		    		
		    		if(res.error == "custom"){
			    		alert(res.detail);
		    		}else if(word.exec(res.detail).length > 0){

	     			  var array = word.exec(res.detail);
	     			  if(array.length > 0){
	     				  var word1 = array[0].replace("com.enumfolder.", "")
	     			      alert(word1 + "에 들어갈 수 없는 문자열이 들어가 있습니다. 확인해 주세요")
	     			  }
		    		}
		    		
		    		return
		    	}

		    	
		    	if(act){
		    		act();
		    	}
		    	
		    	resolve(res);	

			},
        error: function (jqXHR, textStatus, errorThrown)
        {
               console.log(errorThrown + " " + textStatus);
        }
		})	
	  
		
	})	
}



function makediv(value, style){
	
	var field = document.createElement("div");
	
	// style은 json 형식으로 받을 것
	if(style){
		for(var i in style){
			field.setAttribute(i, style[i]);
		}
	}
	
	field.innerText = value
	return field;    	
}

function maketext(name){
	
	var field = document.createElement("input");
	field.setAttribute("type", "text");
	field.setAttribute("name", name);
	field.setAttribute("value", "");
	
	return field;    	
}


function makeselect(data, name){
    
	   var field = document.createElement("select");
	   field.setAttribute("name", name);
	   for(var i in data){
       	   var option = document.createElement("option");
       	   option.innerText = data[i];
           field.appendChild(option);
	   }
	  
		return field;    	
 }




function makebutton(key, call){
	   
	  var field = document.createElement("input");
	  field.setAttribute("type", "button");
	  field.setAttribute("value", key);
	  field.addEventListener("click", call, false);
	   
      return field	   
}



// 1. 조직도를 입력받기 위한 클래스
// 구조는 1) 조직도 입력 엑셀파일 다운로드 받는 테그
//      2) 조직도 엑셀파일을 업로드 받는 테그 // 업로드를 사용하지는 않고, 스코핑처럼 테이블을 펼친 후 서버로 입력받는 형식으로 구성 
class organization{
	
	constructor(){
		 this.tablesize = {width : 6, height : 50}; 
	     this.tablearr = {};
	     this.member_number = 0;
	     
	   	 var maindiv = document.getElementById("content_left");
	   	 
	     for(var k = maindiv.childNodes.length - 1; k > 0; k--){
	        	maindiv.removeChild(maindiv.childNodes[k]); 
	     }

	     var form = this.makedownloadform("download_organization");
	     var excel = this.makeuploadexcel()
	     var table = this.maketable();
	   	 
	     
	   	 maindiv.appendChild(form); 
	   	 maindiv.appendChild(excel);
	   	 
	   	 
	   	 // 아래 makesubmit 구현할 것
	   	 // 그리고 3열 팀원, 팀장, 임원 검증하고 입력되도록 검증기능 구현할 것
	        var button = makebutton("제출하기", () => {

        	var data = {}
        	var num = 0;
        	for(var i = 1; i <= this.member_number; i++){
        		data["member[" + num + "].division"] = this.tablearr[i][1].innerText
        		data["member[" + num + "].teamname"] = this.tablearr[i][2].innerText
        		data["member[" + num + "].realname"] = this.tablearr[i][3].innerText
        		data["member[" + num + "].email"] = this.tablearr[i][4].innerText
        		//data["member[" + num + "].roledata[0].role"] = this.tablearr[i][5].innerText

        		num++
        	}
	        	
        	console.log(data);
        	ajaxmethod("basemap_team", data, () => alert("잘 입력이 되었습니다."));

        })

	       maindiv.appendChild(button);
	       maindiv.appendChild(table); 
	}

/*
 	   <form action="download_organization" method="post">
		    <input type="hidden" name="filename" value="${fileName}">
		    <input type="submit" value="다운로드">
	   </form>
       
	   <form action="upload_organization" method="post" enctype="multipart/form-data">
	 	  Select File : <input type="file" name="uploadFile" />
		  <button type="submit">Upload</button>
       </form>
 */
	
      makedownloadform(url){
       
	       this.url = url
		   var form = document.createElement("form");
		   
		   form.setAttribute("charset", "UTF-8");
		   form.setAttribute("name", "controlform");
		   form.setAttribute("method", "Post");  //Post 방식
		   //form.style = "position : absolute; top : " + this.top + "px";   
		   if(url){
			   form.setAttribute("action", url);   
		   }

		   var field = document.createElement("input");
		   field.setAttribute("type", "hidden");
		   field.setAttribute("name", "filename");
		   field.value = "조직도입력.xlsx";
		   form.appendChild(field);

		   var field = document.createElement("input");
		   field.setAttribute("type", "submit");
		   field.value = "입력양식 다운로드";
		   form.appendChild(field);
           
		   return form;
     }	
	
	makeuploadexcel(){
		
		var field = document.createElement("input");
		field.setAttribute("type", "file");
		field.setAttribute("id", "excelFile");
		field.setAttribute("onchange", "excelExport(event)");
		return field;		
	}
    
	makesubmit(){
		
		console.log(this.tablearr)
		//ajaxmethod("basemap_team")
	}
	
	maketable(){
		 
	    	var table = document.createElement("table"); // div 가 나은것 같으면
	        //this.additem3(this.testbutton);

	        //this.selectsheet.addEventListener('change', ()=>{this.fromexcel(this.wb, this.selectsheet.value)});

	      	table.setAttribute("class", "maintable");

	      	// processlist 반영하기 
	    	for(var i = 0; i < this.tablesize.height;i++){
	    	    this.tablearr[i] = {}
	    	    var subdiv = this.maketrtd(this.tablearr[i], this.tablesize.width, null, {"width": "100px"});
	     		table.appendChild(subdiv)
	    	}

	      	return table;
	    }

       maketrtd(arr, count, td, stylearr){
	        
	        var div = document.createElement("tr");
	     	for(var i = 0; i < count;i++){
	 
	     		if(td){
	             	var subdiv = document.createElement(td)
	     		}else if(i == 0){
	             	var subdiv = document.createElement("th")
	             	
	        	}else{
	             	var subdiv = document.createElement("td")
	        	}

	    	   arr[i] = subdiv;
	    	   
	    	   
	    	   for(var j in stylearr){
	        	   subdiv.setAttribute(j, stylearr[j]);
	    	   }
	    	   
	    	   div.appendChild(subdiv);
	     	}
	    	return div
	    }  

	    
	    ///// 끝입니다.
	
}


class basemapping{
	
	constructor(data, word){

		this.start(data, word);
		this.realhash = {}

	}
	
	async start(data, word){
		// 아작스 메서드로 먼저 데이터 받아오기
		var res = await ajaxmethod("basemapping", {data: data});
	   	var maindiv = document.getElementById("content_left");
	   	 
	   	console.log(res);
	   	
	    for(var k = maindiv.childNodes.length - 1; k > 0; k--){
	        	maindiv.removeChild(maindiv.childNodes[k]); 
	    }

		
		// 질문지 만들기

		for(var i in res){
			
			var div = makediv(res[i].question);
			var text = maketext(res[i].question);
			this.realhash[res[i].question] = text;
   	   	    maindiv.appendChild(div); 
		   	maindiv.appendChild(text);
		}
		
		console.log(123)
        // 최종 제출버튼 만들기
        var button = makebutton("제출하기", () => {

        	var arrhash = {}
        	for(var i in this.realhash){
        		arrhash[i] = this.realhash[i].value
        	}
        	console.log(arrhash);
        	ajaxmethod("basemap_submit/" + word, arrhash, () => alert("잘 입력이 되었습니다."));

        })

        maindiv.appendChild(button);
		
	}
}

class teammapping extends basemapping{

	constructor(data, word){
		super(data, word)
	}
    	
}


class systemmapping extends basemapping{

	constructor(data, word){
		super(data, word)
	}
}


class documentmapping extends basemapping{

	constructor(data, word){
		super(data, word)
	}
}


class personmapping extends basemapping{

	constructor(data){
		super(data)
	}
	
	async start(word){
		// 아작스 메서드로 먼저 데이터 받아오기
		var res = await ajaxmethod("basemapping", {data: word});
	   	var maindiv = document.getElementById("content_left");
	   	 
	   	console.log(res);
	   	
	    for(var k = maindiv.childNodes.length - 1; k > 0; k--){
	        	maindiv.removeChild(maindiv.childNodes[k]); 
	    }

		
		// 질문지 만들기
		var data = res['data'];
		var person = res['person'].map(s => s.realname);
		
		for(var i in data){
			var div = makediv(data[i].teamname);
			var text = makeselect(person, data[i].teamname);
			this.realhash[data[i].teamname] = text;
   	   	    maindiv.appendChild(div); 
		   	maindiv.appendChild(text);
		}
		
		console.log(123);
        // 최종 제출버튼 만들기
        var button = makebutton("제출하기", () => {

        	var arrhash = {}
        	for(var i in this.realhash){
        		arrhash[i] = this.realhash[i].value
        	}
        	console.log(arrhash);
        	ajaxmethod("basemap_" + word, arrhash, () => alert("잘 입력이 되었습니다."));

        })

        maindiv.appendChild(button);
		
	}	
	
}



window.onload = () => {
	
}

</script>

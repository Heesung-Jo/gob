<%@ page contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>


<style>

  table {
    width: 100%;
    border: 1px solid #444444;
    border-collapse: collapse;
  }
  th, td {
    border: 1px solid #444444;
  }


#content_right { 
  float: left;
  background: white;
  margin: 20px 0 5px 20px;
  overflow: hidden;
  width: 23%;
}

#content_right > div { 
  overflow: hidden;
  height: 50px;
}

#content_right > div > input, select { 
  float: left;
  height: 28px;
  border: 1px solid black;
  padding: 0px;
}



#tablediv {
  float: left;
  width : 65%;
  border-right: 1px solid #5F6673;
  background: #f7f9fa;
  height: 85%;
  overflow: scroll;
  
}
	
table.maintable {
    border: 1px solid #444444;
    border-collapse: collapse;
    width: 2000px;
   
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
  
table.maintable select {

  background: pink;
}

table.settlement {
  border-collapse: collapse;
  text-align: left;
  line-height: 1.5;
  border-left: 1px solid #ccc;
  width: 100%;
  
}

table.settlement thead th {
  padding: 10px;
  font-weight: bold;
  border-top: 1px solid #ccc;
  border-right: 1px solid #ccc;
  border-bottom: 2px solid black;
  background: #dcdcd1;
}
table.settlement tbody th {
 
  padding: 5px;
  font-weight: bold;
  vertical-align: top;
  border-right: 1px solid #ccc;
  border-bottom: 1px solid #ccc;
  background: #ececec;
}
table.settlement td {
  
  padding: 5px;
  vertical-align: top;
  border-right: 1px solid #ccc;
  border-bottom: 1px solid #ccc;
  background: white
}






</style>


<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.14.3/xlsx.full.min.js"></script>
<script src = "http://code.jquery.com/jquery-3.4.1.js"></script>

<script>


// https://docs.sheetjs.com/ 참고할 것
var processmap = {} // 서버에서 넘어와서 있다고 가정
var mainsubprocess = {}
var coaarray = {}  // 저거 패키지 있으니, readfile로 읽어드릴 것. 서버에서 이런식으로 넘어와서 있다고 가정
var oppositecoa = {}
var bs_val = {}
var divisionmapping = {}
var processteam = {}


// 이것으론 BS 및 PL 및 Team만
function hashdatafromexcel(wb, hash, sheet, opt, arr){ // arr는 있다면 사용할 것

	console.log(wb.Sheets[sheet]);
	
    var total = wb.Sheets[sheet]["!ref"]
    var start = total.indexOf(":");
    var lastcell = total.substring(start + 1, 10);
    var range = XLSX.utils.decode_cell(lastcell);
           
        
    // 사실 아래 작업은 서버에서 하는 역할 임시적으로 하는 것이니 서버에서는 달라져야함
    for(var r = 0; r <= range.r; r++){
      
      if(opt == 1){ // 컬럼 2 ~ n을 컬럼 1에 있는 내용으로 매핑시킬 사전 만들기  

        for(var c = 0; c <= range.c; c++){
            if(wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: c})] && wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})]){
               hash[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: c})].v] = wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v
            }
        }

      }else if(opt == 2){ // 컬럼 2의 값을 1의 값에 매핑시키기

         hash[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v] = wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 1})].v
      
      }else if(opt == 3){ //컬럼 2 ~ n을 컬럼 1의 배열로 집어넣기
        
        hash[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v] = []
        for(var c = 1; c <= range.c; c++){
            if(wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: c})]){
                hash[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v].push(wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: c})].v);
            }            
        }

      }else if(opt == 4){ // arr에 있는 값으로 매핑하기 위해서 만듬
         
         hash[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v] = arr[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v]

      }else if(opt == 5){ // arr에 있는 값으로 반대로 array가 되도록 매핑
      	 
      	 var val = arr[wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v];
      	 if(hash[val]){
      	 	hash[val].push(wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v)
      	 }else{
      	 	hash[val] = [wb.Sheets[sheet][XLSX.utils.encode_cell({r: r, c: 0})].v]
      	 }

      }

        
    }

    return hash;        	

}

function arraydatafromexcel(arr){
    
}


window.onload = function(){

	table = new showing();
 
}

function excelExport(event){

    var input = event.target;
    var reader = new FileReader();
    reader.onload = function(){
        var fileData = reader.result;
        var wb = XLSX.read(fileData, {type : 'binary'});
        // coaarray 읽어드려서 만들기
        table.wb = wb;
        table.fromexcel(wb);
        table.makeselectsheet(wb.SheetNames);

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



function excelExport_old(event){

    var input = event.target;
    var reader = new FileReader();
    reader.onload = function(){
        var fileData = reader.result;
        var wb = XLSX.read(fileData, {type : 'binary'});
        // coaarray 읽어드려서 만들기
        //coaarray["BS"] = hashdatafromexcel(wb, {}, "BS", 3);
        //oppositecoa["BS"] = hashdatafromexcel(wb, {}, "BS", 1);
        //coaarray["IS"] = hashdatafromexcel(wb, {}, "IS", 3);
        //oppositecoa["IS"] = hashdatafromexcel(wb, {}, "IS", 1);

        divisionmapping = hashdatafromexcel(wb, divisionmapping, 'teammapping', 1);
        processteam = hashdatafromexcel(wb, processteam, 'team', 2);
        processmap =  hashdatafromexcel(wb, processmap, 'processmap', 3);
        
        // 사실 여기부터 필요있는 코드임. 위의 코드는 원래는 그냥 서버에서 넘겨받는 것임

        // BS/IS 읽어드리기
        var arr = ["realbs", "realis"] 
        var form = new makecoa();
       
        form.maindiv = document.getElementById("maindiv");
        
        for(var data in arr){
           var sheet = arr[data]
           form[sheet] = hashdatafromexcel(wb, form[sheet], sheet, 2);
        }
        
        // 회사 팀 읽어드리기
        form['realteam'] = hashdatafromexcel(wb, {}, 'realteam', 5, divisionmapping);
        form['companyteam'] = hashdatafromexcel(wb, {}, 'realteam', 4, divisionmapping);
        console.log(form['companyteam']);

        form.makeform();

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




class showing{

    // 210518, 210712 설명열 추가할 것(지금은 계정과목, 전표번호 등 밖에 없는데 다른 설명열도 추가할 것)
    // 210712 정산표 보여줄 때, 자산순서 등을 유동성 등으로 우선순위 정할 것, 그리고 차감계정은 묶어서 처리할 것
    // 지금 생각으로는 sortedrealcoa에 rank변수를 추가하고, 자바스크립트 function(a, b){return a > b} 등으로 정렬하는 기능활용
	// sorting_sortedrealcoa라는 함수를 아래에 만듬. 거기가서 수정할 것은 수정할 것
    
    // 211216
    // 지금 모든 계정과목이 안들어오고 있음 처음 테이블 만들때 모든 행을 포함하지는 않기 때문인데, 다 포함하도록 수정이 필요함

	constructor(obj){
    	
    	this.func_turn_arr = [];
        // 처음 원장 받는 view와 관련된 것
        this.coasetarr = {}  // 서버에서 넘어올 것이고  
                             // {"차변": ["차변"], "대변": ["대변"], "합계": ["합계","잔액"], "계정과목": ["계정과목", "계정명"], "전표번호": ["전표번호"]}
                             // 자동으로 제목행 세팅을 위해서 만든 오브젝트 
        this.tablearr = {};  // 좌측 즉 메인테이블에 대한 컨트롤을 위해서
                             // 각 table[r][c]를 넣어놓음
        this.table = {};     // 좌측 즉 메인테이블 그 자체를 의미함
        this.tablearr_scope = {} // 스코핑 관련 테이블 컨트롤을 위해서 만들었음. 위와 사용방법은 동일함
        
        this.settlementarr = {} // 이건 정산표 모드일때 tablearr

                                      // 211216
        this.materiality = 100000000; // 처음에 PL을 받을 필요가 있음. 거기서 당기순이익 뽑아서, 중요성 산정하도록 수정필요
        
        this.tablediv = document.getElementById("tablediv");
        this.content_right = document.getElementById("content_right");

        this.selectsheet = {};  // wb(엑셀파일)에서 선택된 시트를 의미함

        this.testbutton = {};   // 원장분석을 시작하기 위한 버튼
        
        // 여기까지가 처음뷰 관련
        this.selectlabel = {}; // 행시작열에 달려있는 label들임
        this.itemselect = {};  // 행시작행에 달려있는 select
        this.itemarray = {};   // {제목행 : 1, 전표번호 : 3 ... 등의 오브젝트}
        this.tablesize = {width : 20, height : 50}; 
        this.realis = {};
        this.realcoa = new Set([]);  // coa 배열임
        this.realcoaobj = {};        // coa 관련 object
        
        this.coasum = {};            // subclass는 전표번호별로 만든 것이라면
                                     // 이것은 coa별로 subclass내용을 집계한 것임
                                           
                                     //반드시 this.coasum에 밑에랑 연동을 위해서                 

        this.subwin = {}                                     
                                     
        // 여기서부터 두번째 뷰인 정산표 관련된 변수임
        this.sortedcoa = []
        
        this.ajaxmethod("/view/sortedcoa", {"a":"a"}, (res) => {
        	this.sortedcoa  = res
        }); 

        // ajax 후 리턴 된 coa
        this.sortedrealcoa = {}      // subwindow에서 최종 확정된 coa  
        this.coasortobj = {};
        this.middlecoa = {};
        this.makecoasortobj();  

        // 정산표 관련 tag
        this.maintag = {};  // 왼쪽의 maintable을 집어넣기 위한 것
        this.righttag = {}; // 오른쪽 것
        this.bottomtag = {}; // 아래쪽 것
        
        
        // 이것도 서버에서 받아올 것이며
        // {이자수익: {분류1: 손익, 분류2: 손익류 ... 등이 될 것임}}
        // 이건 prob와 subclass 관련                

        this.realteam = {};
        this.wb = {};
        this.sheetname = "";
        this.subsumarr = {};
        this.subclass = {};
        this.probmodel = {};
        this.probmodel_total = {};
        this.smallval = 0.000001; // 나중에는 전표숫자에 연동되도록 수정할 것
        this.countmodel = [] // [{type: new Set([]), count: 1}] 이런식으로 만들예정



        this.func_turn_arr = [this.maketable, this.makelabel, this.makeitemselect];
        this.func_turn_act(0);
        
	}

	
    
    // 연속 함수 실행
    
    func_turn_act(count){
    	
    	if(count < this.func_turn_arr.length - 1){
    		var real = count + 1;
        	this.func_turn_arr[count](() => {this.func_turn_act(real)});
    	}else if(count = this.func_turn_arr.length - 1){
    		this.func_turn_arr[count]();
    	}
    	
    }
    
    
	//^^ 아작스 관련
	//
	//
	//

    

	
	ajaxmethod(link, data, act){
		
		return new Promise((resolve) => {
		
			
		// 스프링 시큐리티 관련
		var header = $("meta[name='_csrf_header']").attr('content');
		var token = $("meta[name='_csrf']").attr('content');
		
   		$.ajax({
   			type : "POST",
   			url : link,
   			data : data,
   			beforeSend: function(xhr){
   			  if(token && header) {
   		        xhr.setRequestHeader(header, token);
   			  } 
   		    },
   		    success : (res) => {

   		    	if(act){
   	   				act(res)
   		    	}

   		    	resolve()

   		    },
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	  })
	}
	
	
	

    //^^ 가공 후 자료 보여주는 함수 기술
    //
    //
    //
    //
    makesettlement = () => {
        
        // 기존 테이블 삭제하기
        this.table.parentNode.removeChild(this.table);
        this.selectsheet.parentNode.removeChild(this.selectsheet);
        this.testbutton.parentNode.removeChild(this.testbutton);
        this.content_right.parentNode.removeChild(this.content_right);
        

        // 구조를 좌측, 오른쪽, 아래쪽 세 구도를 잡기위해서
        // tablediv에 upperdiv를 만들고 집어넣고, upperdiv에는 좌측 ,오른쪽을 집어넣고, float: left함
        // 아래쪽은 그냥 tablediv에 집어넣음
        
        var upperdiv = document.createElement("div")
        this.tablediv.appendChild(upperdiv)
       
        // 정산표 관련 테이블 만들기
        var tableup = document.createElement("div");
        
        
    	var table = document.createElement("table")
        table.setAttribute("class", "settlement");

    	upperdiv.appendChild(tableup);
    	tableup.appendChild(table);
    	this.maintag = table;
        
        tableup.style = "float: left; overflow: scroll; width: 70%;  height: 500px; border: 1px solid #444444;"
        // 계정과목별로 펼치기
        // 210518 이것도 이제 손익, 영업, 투자, 재무로 쪼개서 보여줄 것
        // 구조 계정과목, 손익, 숫자, 영업, 숫자, 투자, 숫자, 재무, 숫자, 대체, 숫자 총 11개
        
        
        
        // 제목열 만들기
    	var thead = document.createElement("thead");
   	    this.maintag.appendChild(thead);
   	    var temp = {}
    	var subdiv = this.maketrtd(temp, 8, "th");
   	    temp[0].innerText = "계정";
   	    temp[1].innerText = "손익";
   	    temp[2].innerText = "영업";
   	    temp[3].innerText = "투자유입";
   	    temp[4].innerText = "투자유출";
   	    temp[5].innerText = "재무유입";
   	    temp[6].innerText = "재무유출";
   	    temp[7].innerText = "대체";

   	    thead.appendChild(subdiv);
        
        // 내용열 만들기
    	var tbody = document.createElement("tbody");
    	this.maintag.appendChild(tbody);
      
    	
    	// 보여줄 계정들 순서 정렬하기
    	
    	
    	var turn = []
        for(var i of this.realcoa){
    	  
           if(this.sortedrealcoa[i]["분류1"] == "BS" && this.sortedrealcoa[i]["분류2"] != "현금및현금성자산"){
        	   turn.push(i);
        	   
           }
         }
    	
        for(var i of this.realcoa){
      	  
            if(this.sortedrealcoa[i]["분류1"] == "자산/부채에 차감하는 계정" ){
         	   //주계정의 위치찾기
         	   var main = this.sortedrealcoa[i]['main'];
         	   for(var j = 0; j < turn.length; j++){
         		   if(turn[j] == main){
         			   turn.splice(j + 1, 0, i)
         			   break
         		   }
         	   }
            }
    	
        }

    	
    	// 이제 집어넣기
        
      for(var i in turn){
    	  
    	    this.settlementarr[turn[i]] = {}
    		var subsum = this.cal_subsum2(turn[i]);
    	    var subdiv = this.maketrtd(this.settlementarr[turn[i]], 8);
    	    tbody.appendChild(subdiv)
    	   
     		this.settlementarr[turn[i]][0].innerText = turn[i];
    	    this.settlementarr[turn[i]][1].innerText = this.comma(subsum["손익"].sum);
    	    this.settlementarr[turn[i]][2].innerText = this.comma(subsum["영업"].sum);
    	    this.settlementarr[turn[i]][3].innerText = this.comma(subsum["투자유입"].sum);
    	    this.settlementarr[turn[i]][4].innerText = this.comma(subsum["투자유출"].sum);
    	    this.settlementarr[turn[i]][5].innerText = this.comma(subsum["재무유입"].sum);
    	    this.settlementarr[turn[i]][6].innerText = this.comma(subsum["재무유출"].sum);
    	    this.settlementarr[turn[i]][7].innerText = this.comma(subsum["대체"].sum);

    	    for(var num = 1; num <= 7; num++){
    			var field = document.createElement("input");
    			field.setAttribute("type", "checkbox");
    	        this.settlementarr[turn[i]][num].appendChild(field)
    	    	this.settlementarr[turn[i]][num].style = "text-align: right;"
    	    	this.additem4(field, turn[i], subsum[temp[num].innerText].arr);
    	    }

    		this.beforecoa = turn[i];
       }
        // 우측 상세내역 볼 테이블
    	var div = document.createElement("div")
    	upperdiv.appendChild(div)
    	this.righttag = div;
     
    	div.style = "float: left; overflow: scroll; width: 28%;  height: 500px; border: 1px solid black;"
        
        // 아래쪽 테이블 전표번호별 수정가능한 테이블 만들기
        // 210408 수정되는 기능 추가해야함. 드랍다운 기능 추가해야함
        var div = document.createElement("div")
        this.tablediv.appendChild(div)
        this.bottomtag = div;
        div.style = "overflow: scroll; width: 100%;  height: 300px; border: 1px solid black;"


        this.tablediv.style = "width: 97%;"
    }

    sorting_sortedrealcoa(){
    	
    	var arr = [];
    	for(var i in this.sortedrealcoa){
    		arr.push({coa: i, rank: 1})  //210712 여기서 rank 1의 값을 middlecoa에 rank반영하게하고 해서 여기서 가져오게 해야함
    	}
    	
    	arr.sort((a, b) => {
    		return a.rank - b.rank
    	})
    	
    	
    }
    
    
    
    cal_subsum = (coa) => {
        var sum = 0;


        for(var i in this.coasum[coa]){
            sum += this.coasum[coa][i]["sum"];
        }

        return sum;
    }


    coasort(coa){
    	
        for(var i = 0; i <= 2; i++){
        	
        	if(i in this.sortedcoa[coa] == true){
        	    return this.sortedcoa[coa][i]
        	}
        }
        
        
    }
    
    cal_subsum2 = (coa) => {
    	
        var sum = {"손익": {sum: 0, arr: new Set([])}, "영업": {sum: 0, arr: new Set([])}, "투자유입": {sum: 0, arr: new Set([])}, "투자유출": {sum: 0, arr: new Set([])}, "재무유입": {sum: 0, arr: new Set([])}, "재무유출": {sum: 0, arr: new Set([])}, "대체": {sum: 0, arr: new Set([])}};
        for(var i in this.coasum[coa]){
        	
           // 이건 과거코드였음 var sortcoa = this.middlecoa[this.coasortobj[this.coasort(i)]]["분류3"]
           // 이제 계정 선택을 sortedrealcoa로 했기때문에 그것으로 선택하도록 할 것
           if(this.sortedrealcoa[i]["분류1"] == "현금흐름이 없는 손익" ||
        		   this.sortedrealcoa[i]["분류1"] == "처분손익" ||
        		           this.sortedrealcoa[i]["분류1"] == "이자손익"){
        	   var sortcoa = "손익"
           }else{
        	   
        	   var tem = this.sortedrealcoa[coa]["분류2"];
        	   var 메인분류 = this.middlecoa[tem]['분류2'];
        	   var 주계정 = this.middlecoa[tem]['분류3']
        	   
        	   if(주계정 == "주계정"){
        		   var maincoa = this.sortedrealcoa[coa]["main"];
        		   tem = this.sortedrealcoa[maincoa]["분류2"];
        		   주계정 = this.middlecoa[tem]['분류3']
        	   }
        	   
        	   var 계정 = this.sortedrealcoa[i]["분류2"];
        	   var 분류2 = this.middlecoa[계정]['분류2']
        	   
        	   
        	   
        	   if(메인분류 == "중간"){
         	    	   sortcoa = "영업"
              }else if(분류2 == "중간" || 분류2 == "현금" || 분류2 == "손익"){
        		   sortcoa = 주계정
        	   }else{
        		   sortcoa = "대체"
        	   }
           }

    	   if(sortcoa == "재무" || sortcoa == "투자"){
    		   if(this.coasum[coa][i]["sum"] < 0){
    			   sortcoa = sortcoa + "유출";
    		   }else{
    			   sortcoa = sortcoa + "유입";
    		   }
    	   }   
           
           sum[sortcoa]["sum"] += this.coasum[coa][i]["sum"];
           sum[sortcoa]["arr"].add(i);
        }
   
        
        return sum;
    }

    makecoasortobj = () => {
       // 210620 서버에서 이 부분은 연산시키자
       // 영업, 투자, 재무에서 대체로 돌리는 것 적용할 것
       // 그리고 손익까지 지금 계정별로 뜨는데 이것도 개선할 것
       // 그리고 순서도 유동순서와 주계정 순서로 뜨도록 바꿀 것
       // this.realcoa가 결정되면 이 배열을 ajax로 넘기고
       // 연산해서 coasortobj가 결정되는 구조로 가자
       
    }

    makebutton = () => {
        var button = document.createElement("Input");
        button.setAttribute('type', "button");
        button.setAttribute('value', "Confirm");
        button.addEventListener('click',()=>{this.coamapping()});
        return button;
    } 

    coamapping = () => {
        
        for(var i in this.coamap){
            this.realcoa[this.coamap[i].value] = 1
        }

        this.processmap()    
    }


   comma = (str) => { 
      str = String(str); 
      return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'); 
   } 

   numbertag = (str, tag) => {
   	  str = String(str); 
   	  var arr = /[^0-9\-\,]/g.exec(str);

   	  if(arr){
   	  	return tag; 
   	  }else{
   	  	return tag + "text-align: right;"
   	  }
 
   }

    // 이거 테이블로 바꿀것 // 이미 다 구조 테이블로 바꿈
    makediv2 = (arr) => {
    	var div = document.createElement("div")
        div.style = "overflow : hidden; width: 500px ";
        
        for(var i in arr){
        	var subdiv1 = document.createElement("div")
        	var style = "float : left; width : 100px; border: 1px solid gold;";
     	    subdiv1.style = style;
     	    subdiv1.innerText = arr[i];
            div.appendChild(subdiv1);

        }

        return div;

    }


    makediv = (text1, text2, text3) => {
    	var div = document.createElement("div")
        div.style = "overflow: hidden; width: 500px ";

    	var subdiv1 = document.createElement("div")
    	var style = "float: left; width : 100px; border: 1px solid gold;";
    	subdiv1.style = this.numbertag(text1, style);
    	subdiv1.innerText = this.comma(text1);
    	this.numbertag(text1);

    	var subdiv2 = document.createElement("div")
    	var style = "float: left; width : 100px; border: 1px solid gold;";
    	subdiv2.style =this.numbertag(text2, style);
        subdiv2.innerText = this.comma(text2);
        


        div.appendChild(subdiv1);
        div.appendChild(subdiv2);

        if(text3){
        	var subdiv3 = document.createElement("div")
        	var style = "float : left; width : 150px;border: 1px solid gold;";
        	subdiv3.style =this.numbertag(text3, style);
            subdiv3.innerText = this.comma(text3);
            div.appendChild(subdiv3);
        }  
        return div;
    }

   
    makedivarr = (arr) => {

      var div = document.createElement("div")
      div.style = "overflow: hidden; width: 500px ";

      for(var i in arr){

    	var subdiv1 = document.createElement("div")
    	var style = "float: left; width : 100px; border: 1px solid gold;";
    	subdiv1.style = this.numbertag(arr[i], style);
    	subdiv1.innerText = this.comma(arr[i]);
    	this.numbertag(arr[i]);

        div.appendChild(subdiv1);
      }
      return div;
        
    }
   


    makespan = (text1, text2) => {
    	var div = document.createElement("div")
        div.style = "overflow : hidden; ";

    	var subdiv1 = document.createElement("span")
    	var style = "width: 5%; border: 1px solid gold;";
    	subdiv1.style = this.numbertag(text1, style);
    	subdiv1.innerText = this.comma(text1);
    	this.numbertag(text1);

    	var subdiv2 = document.createElement("span")
    	var style = "width: 5%; border: 1px solid gold;";
    	subdiv2.style =this.numbertag(text2, style);
        subdiv2.innerText = this.comma(text2);

        div.appendChild(subdiv1);
        div.appendChild(subdiv2);

        return div;
    }


    makeselect = (arr) => {
        

        var select = document.createElement('select');
        
        for(var i in arr){
            var opt = document.createElement('option');
            //opt.setAttribute('value', i)
            opt.innerText = i;
            select.appendChild(opt)
        }
        return select;

    }

    //^^ viex에 관한 함수
    maketable = (func) => {
    	this.table = document.createElement("table"); // div 가 나은것 같으면
    	
    	this.tablediv.appendChild(this.table); 
    	this.selectsheet = document.getElementById("selectsheet");
    	this.testbutton = document.getElementById("testbutton");
        this.additem3(this.testbutton);

        this.selectsheet.addEventListener('change',()=>{this.fromexcel(this.wb, this.selectsheet.value)});

      	this.table.setAttribute("class", "maintable");
    	                         //밑의 함수는 ~~~div2
                                                   //가 아닌 ~~~div로
        // processlist 반영하기 
    	for(var i = 0; i < this.tablesize.height;i++){
    	    this.tablearr[i] = {}
    	    var subdiv = this.maketrtd(this.tablearr[i], this.tablesize.width, null, {"width": "100px"});
     		this.table.appendChild(subdiv)
    	}
    	     
    	if(func){
        	func()
    	}                         

    }
    

    maketable_scope = (data, func) => {
    	
    	var table = document.createElement("table"); // div 가 나은것 같으면

    	// testbutton을 기존것을 활용할지 고민해볼 것
    	this.testbutton = document.getElementById("testbutton");

        // 제목행
       	var thead = document.createElement("thead");
       	table.appendChild(thead);
        var temp = {}
        var subdiv = this.maketrtd(temp, 11, "th");
        temp[0].innerText = "계정과목";
        temp[1].innerText = "표준계정과목";
        temp[2].innerText = "BS/PL";
        temp[3].innerText = "금액";
        temp[4].innerText = "질적특성1";
        temp[5].innerText = "질적특성2";
        temp[6].innerText = "질적특성3";
        temp[7].innerText = "질적특성4";
        temp[8].innerText = "질적특성5";
        temp[9].innerText = "질적특성6";
        
        temp[10].innerText = "스코핑 결과";
        
        thead.appendChild(subdiv)
    	
    	
    	// 내용행
	    var tbody = document.createElement("tbody");
        table.setAttribute("class", "settlement");
        table.appendChild(tbody);
      	
      	
        var startrow = this.itemarray["제목행"];
        var num = 0;
        for(var ai in this.tablearr){
     	   if(ai >= startrow){

     		   this.tablearr_scope[num] = {}
        	   var subdiv = this.maketrtd(this.tablearr_scope[num], 11, null, {"width": "100px"});
         	   
        	   var coaname = this.tablearr[ai][this.itemarray["계정과목"]].innerText;
        	   
        	   if(coaname == ""){
        		   continue;
        	   }
        	   
        	   var cashamount = this.tablearr[ai][this.itemarray["금액"]].innerText;
        	   this.tablearr_scope[num][0].innerText = coaname;
        	   
        	   this.tablearr_scope[num][1].innerText = this.subwin.subtable.tablearr[coaname].value;  // 표준계정을 의미함
        	   this.tablearr_scope[num][2].innerText = this.tablearr[ai][this.itemarray["BS/PL"]].innerText;
        	   this.tablearr_scope[num][3].innerText = cashamount;
        	   
        	   // 질적특성 열
        	   this.tablearr_scope[num][4].innerText = 0;
        	   this.tablearr_scope[num][5].innerText = 0;
        	   this.tablearr_scope[num][6].innerText = 0;
        	   this.tablearr_scope[num][7].innerText = 0;
        	   this.tablearr_scope[num][8].innerText = 0;
        	   this.tablearr_scope[num][9].innerText = 0;

        	   
        	   cashamount = Number(cashamount.replaceAll(",", ""))
        	  
        	   if(this.materiality < cashamount){
            	   this.tablearr_scope[num][10].innerText = "Scoping";
        	   }
        	   
        	   tbody.appendChild(subdiv);
         	   num++
     	   }
        }
      	
      	// 테이블 갈아까기
    	this.table.parentNode.removeChild(this.table); 
      	this.table = table;
    	this.tablediv.appendChild(table); 
      	this.table.setAttribute("class", "maintable");
      	
        // 우측 테이블도 갈아끼우기
        
        for(var k = this.content_right.childNodes.length - 1; k > 0; k--){
        	this.content_right.removeChild(this.content_right.childNodes[k]); 
        }
      	
        // button 만들어 끼우기
        var div = document.createElement("h3");
        div.innerText = "스코핑 확정하기";
        this.content_right.appendChild(div);
        
        var button = this.makebutton();
        this.content_right.appendChild(button);
      	
    	if(func){
        	func()
    	}                         
    }

    makebutton = () => {
        var button = document.createElement("Input");
        button.setAttribute('type', "button");
        button.setAttribute('value', "Confirm");
        button.addEventListener('click',()=>{
        	this.scopingmake()
        });
        return button;
    } 

    scopingmake(){
    	
        var data = {}
        var startrow = this.itemarray["제목행"];
        var num = 0;
        
        console.log(this.tablearr_scope);
        
        for(var ai in this.tablearr_scope){
     	   if(ai >= startrow && this.tablearr_scope[ai][0].innerText != ""){
     		   data["Scopingdata[" + num + "].coaname"] = this.tablearr_scope[ai][0].innerText;
     		   data["Scopingdata[" + num + "].realcoaname"] = this.tablearr_scope[ai][1].innerText;
     		   data["Scopingdata[" + num + "].bspl"] = this.tablearr_scope[ai][2].innerText;

     		   var cashamount = this.tablearr_scope[ai][3].innerText;
        	   cashamount = parseInt(cashamount.replaceAll(",", ""))
     		   data["Scopingdata[" + num + "].cashamount"] = cashamount;
        	   
     		   data["Scopingdata[" + num + "].quality1"] = this.tablearr_scope[ai][4].innerText;
     		   data["Scopingdata[" + num + "].quality2"] = this.tablearr_scope[ai][5].innerText;
     		   data["Scopingdata[" + num + "].quality3"] = this.tablearr_scope[ai][6].innerText;
     		   data["Scopingdata[" + num + "].quality4"] = this.tablearr_scope[ai][7].innerText;
     		   data["Scopingdata[" + num + "].quality5"] = this.tablearr_scope[ai][8].innerText;
     		   data["Scopingdata[" + num + "].quality6"] = this.tablearr_scope[ai][9].innerText;
     		   data["Scopingdata[" + num + "].materiality"] = this.tablearr_scope[ai][10].innerText;
         	   
     		   num++
     	   }
        }
         
        console.log(data)
        // ajax로 먼저 계정과목을 표준계정과목으로 세팅하기
        this.ajaxmethod("/view/scopingmake", data, (res) => {
     	   console.log(res)
     	   
     	   if(res == "success"){
     		   alert("스코핑이 완료되었습니다. 이제 포괄질문서를 작성해 주세요.")
     		   location.href= "/view/loginSuccess";	
     	   }else{
     		   
     		   if("error" in res){
     			  var word = new RegExp(res.error.replace(".", "\."), "g");
     			  
     			  var array = word.exec(res.detail);
     			  if(array.length > 0){
     				  var word1 = array[0].replace("com.enumfolder.", "")
     			      alert(word1 + "에 들어갈 수 없는 문자열이 들어가 있습니다. 확인해 주세요")
     			  }
     		   }
     	   }
     	   
         });     	
    }
    
    
    
    maketrtd = (arr, count, td, stylearr) => {
       
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
    

    
    makelabel = (func) => {

        this.tablearr[0][0].innerText = "행시작"
        for(var i = 1; i < this.tablesize.height; i++){
           // 라디오 버튼을 테이브 앞단에 둬, 제목열 선택할 수 있게할 것
           this.selectlabel[i] = document.createElement("input")
           this.selectlabel[i].setAttribute('type', "radio");
           this.selectlabel[i].setAttribute('name', "subject");
           
           this.additem2(this.selectlabel[i], i);

           this.tablearr[i][0].appendChild(this.selectlabel[i])   
        }
        if(func){
            func()
        }
    }


    //이벤트 함수는 모두 additem 식으로 죽 늘려나갈 것
    additem1 = (item, i) => {
           item.addEventListener('change',(me)=>{
               if(me.target != "없음"){
                  this.itemarray[me.target.value] = i
               }
               
           });        
    }

    additem2 = (item, i) => {
           item.addEventListener('change',(me)=>{
                this.itemarray["제목행"] = i;
           })
    }

    additem3 = (item) => {
           item.addEventListener('click',(me)=>{
                
                this.nextlevel()
           })

    }
    
    // 정산표 계정과목이 선택되면 그 안의 내용을 보여주기 위한 것 
    additem4(item, coa, subarr){
        
       item.addEventListener('click',(me)=>{

               // 기존의 우측에 있던 노드 삭제 
           if(item.parentNode.childNodes.length > 1){
               for(var k = item.parentNode.childNodes.length - 1; k > 1; k--){
                    item.parentNode.removeChild(item.parentNode.childNodes[k]); 
               }
           }

           if(item.checked == true){
                
                // 테이블 만들어 추가하기
               	var table = document.createElement("table");
               	item.parentNode.appendChild(table);
               
               
                // 제목행 
               	var thead = document.createElement("thead");
               	table.appendChild(thead);
   	            var temp = {}
    	        var subdiv = this.maketrtd(temp, 2, "th");
   	            temp[0].innerText = "계정";
   	            temp[1].innerText = "금액";
   	           
   	            thead.appendChild(subdiv)

               // 내용행
        	    var tbody = document.createElement("tbody");
   	            table.setAttribute("class", "settlement");
   	            table.appendChild(tbody);
        

        	for(var i in this.coasum[coa]){
         		
        		if(subarr.has(i) == true){
        	      var tem = {}
        	      var subdiv = this.maketrtd(tem, 2);
        	      tbody.appendChild(subdiv)
        		  tem[0].innerText = i;
        	      tem[1].innerText = this.comma(this.coasum[coa][i]["sum"]);
        	      tem[1].style = "text-align: right;"
                  this.additem5(subdiv, coa, i);
        		}
        	}               
          }      
       })
    }

    additem5 = (item, coa1, coa2) => {

      
      item.addEventListener('click',(me)=>{
            // 기존의 노드가 있으면 삭제
            
           if(this.righttag.childNodes){
              for(var k = this.righttag.childNodes.length - 1; k >= 0; k--){
        	     this.righttag.removeChild(this.righttag.childNodes[k]); 
              }
           }
           // 테이블 만들어 추가하기
           var table = document.createElement("table");
           this.righttag.appendChild(table);
               
               
           // 제목행 
           var thead = document.createElement("thead");
           table.appendChild(thead);
   	       var temp = {}
    	   var subdiv = this.maketrtd(temp, 3, "th");
   	       temp[0].innerText = "전표번호";
   	       temp[1].innerText = "금액";
   	       temp[2].innerText = "보기"; 
   	       thead.appendChild(subdiv)

            // 내용행
    	    var tbody = document.createElement("tbody");
   	        table.setAttribute("class", "settlement");
   	        table.appendChild(tbody);
        
            	
            for(var i in this.coasum[coa1][coa2].arr){

       	      var tem = {}
       	      var subdiv = this.maketrtd(tem, 3);
       	      tbody.appendChild(subdiv)
       		  tem[0].innerText = this.coasum[coa1][coa2].arr[i]["전표번호"];
       	      tem[1].innerText = this.comma(this.coasum[coa1][coa2].arr[i]["금액"]);
       	      tem[1].style = "text-align: right;";
   	          tem[2].innerText = "보기";
              this.additem6(subdiv, this.coasum[coa1][coa2].arr[i]["전표번호"]);
             
            }

          
        })
    }

    
    additem6 = (item, num) => {

        item.addEventListener('click',(me)=>{

               // 기존의 우측에 있던 노드 삭제 
           while (this.bottomtag.hasChildNodes()){
                   this.bottomtag.removeChild(this.bottomtag.firstChild);
           } 

           // 이제 우리가 원하는 것 집어넣기
           // 210408 mainarr가 뭉쳐서 들어가도록 solvearr 집어넣도록 보완해야함
           // 테이블 만들어 추가하기
           var table = document.createElement("table");
           this.bottomtag.appendChild(table);
               
               
           // 제목행 
           var thead = document.createElement("thead");
           table.appendChild(thead);
   	       var temp = {}
    	   var subdiv = this.maketrtd(temp, 4, "th");
   	       temp[0].innerText = "전표번호";
   	       temp[1].innerText = "계정과목";
   	       temp[2].innerText = "금액"; 
   	       temp[3].innerText = "상대계정"; 
   	       thead.appendChild(subdiv)

            // 내용행
    	    var tbody = document.createElement("tbody");
   	        table.setAttribute("class", "settlement");
   	        table.appendChild(tbody);
        
            	
            for(var i in this.subclass[num].solvearr){

       	      var tem = {}
       	      var subdiv = this.maketrtd(tem, 4);
       	      tbody.appendChild(subdiv)
       		  tem[0].innerText = this.subclass[num].solvearr[i]["전표번호"];
       	      tem[1].innerText = this.subclass[num].solvearr[i]["계정과목"];
       	      tem[2].innerText = this.comma(this.subclass[num].solvearr[i]["금액"]);
       	      tem[2].style = "text-align: right;";
       	      tem[3].innerText = this.subclass[num].solvearr[i]["상대계정"];
            }
         })
    }



    // 각종 테스트 함수 등
    async nextlevel(){
           
           // 파일 테스트
           if(this.sheetname == ""){
               alert("파일을 선택해주세요")
               return
           } 

           // 계정과목 테스트
           for(var ai in this.itemarray){
               if(!this.itemarray["계정과목"]){
                   alert("계정과목 열을 선택해주세요")
                   return
               } 
           }

           if(!this.itemarray["BS/PL"]){
               alert("BS/PL 열을 선택해주세요")
               return
           } 
 
           // 전표번호 테스트
           if(!this.itemarray["계정레벨"]){
               alert("계정레벨 열을 선택해주세요")
               return
           } 


           // 합계- 일단 합계만 두고, 추후에 차변, 대변 추가하는 것으로
           if(!this.itemarray["금액"]){
               alert("금액 열을 선택해주세요")
               return
           } 

            // 제목행 선택
            if(!this.itemarray["제목행"]){
               alert("시작 행을 선택해주세요")
               return
           } 
            
           // data 집어넣기. 이 앞단에 계정레벨에 따라 변형되는 코드를 집어넣어야 할 것 같음 
           var data = {}
           var startrow = this.itemarray["제목행"];
           for(var ai in this.tablearr){
        	   var coa_num = this.itemarray["계정과목"];
        	   var coa = this.tablearr[ai][coa_num].innerText;
        	   if(ai >= startrow && coa != ""){
            	   var bspl_num = this.itemarray["BS/PL"];
            	   var bspl = this.tablearr[ai][bspl_num].innerText;
            	   
            	   data[coa] = bspl
        	   }
           }
           
           /* 이건 child쪽으로 밀고 마지막에 스코핑 확정될 때 받을 것
           var data = {}
           var startrow = this.itemarray["제목행"];
           var num = 0;
           for(var ai in this.tablearr){
        	   if(ai >= startrow){
        		   data["Scopingdata[" + num + "].bspl"] = this.tablearr[ai][this.itemarray["BS/PL"]].innerText;
        		   data["Scopingdata[" + num + "].coaname"] = this.tablearr[ai][this.itemarray["계정과목"]].innerText;
        		   data["Scopingdata[" + num + "].coalevel"] = this.tablearr[ai][this.itemarray["계정레벨"]].innerText;
        		   //data["cashamount"] = this.tablearr[ai][this.itemarray["금액"]].innerText;
            	   num++
        	   }
           }
           */
            
           console.log(data)
           // ajax로 먼저 계정과목을 표준계정과목으로 세팅하기
           await this.ajaxmethod("/view/coamake", data, (res) => {
        	   console.log(res)
        	   this.coasortobj = res
        	   
            }); 
           
           
           this.openchild();
             
    }

    testrow = () => {

    }

    testsum = () => {

    }


        
    // select 만드는 함수 등    
    makeitemselect = (func) => {

    	for(var i = 1; i < this.tablesize.width; i++){

           // 라디오 버튼을 테이브 앞단에 둬, 제목열 선택할 수 있게할 것
           
           this.itemselect[i] = document.createElement("select");
           this.itemselect[i].style = "width: 100%;"
           // 선택할 옵션
           var opt = document.createElement('option');
           opt.innerText = "없음";
           
           this.itemselect[i].appendChild(opt);
           var opt = document.createElement('option');
           opt.innerText = "BS/PL";
           this.itemselect[i].appendChild(opt);

           var opt = document.createElement('option');
           opt.innerText = "계정레벨";
           this.itemselect[i].appendChild(opt);

           
           var opt = document.createElement('option');
           opt.innerText = "계정과목";
           this.itemselect[i].appendChild(opt);

           var opt = document.createElement('option');
           opt.innerText = "금액";
           this.itemselect[i].appendChild(opt);

           
           // 이벤트 함수 집어넣기
           this.additem1(this.itemselect[i], i);  
 
           // 옵션 집어넣기
           this.tablearr[0][i].appendChild(this.itemselect[i])   
           
        }
        
        if(func){
        	func()
        }
        

    }

    makeselectsheet = (arr) => {
        

        for(var k = this.selectsheet.childNodes.length - 1; k > 1; k--){
        	this.selectsheet.removeChild(item.parentNode.childNodes[k]); 
        }
        
        
        
        for(var i in arr){
            var opt = document.createElement('option');
            //opt.setAttribute('value', i)
            opt.innerText = arr[i];
            this.selectsheet.appendChild(opt)
        }
        
        return this.selectsheet;
    }  
    
    //## subclass 관련함수
    // 계정과목 모델 만들기
    coamake = () => {
        // 이 부분은 추후 생각해야 함

    }

    // 확률모델 만들기
    makeprob = () => {
        for(var i in this.subclass){
            this.probmodel = this.subclass[i].makeprob(this.probmodel)
        }

        
    }
    
    // 확률모델 실패한 서브 클래스는 probdistcal 실행하기
    probdistcal = () => {
        for(var i in this.subclass){
            if(this.subclass[i].failsure > 1){
               this.subclass[i].probdistcal()
            }
        }
    }
        


  // 이것을 현재는 사용하지 않음. 확률적으로 맞는 것 같지 않음 
  // 확률거리를 계산하기 위한 함수 
  // 현재는 차변, 대변 평균이나, 차변만, 대변만 옵션들 추가해야 할듯 
  probcal = (a, b, opt) => {

	  var prob = this.smallval
      if(opt == "차변"){
         prob = b in this.probmodel[a]['차변'] ? this.probmodel[a]['차변'][b]/this.probmodel[a]['차변']["total"] : this.smallval;
      }else if(opt == "대변"){
         prob = b in this.probmodel[a]['대변'] ? this.probmodel[a]['대변'][b]/this.probmodel[a]['대변']["total"] : this.smallval;
      }else{
         var 차변 = b in this.probmodel[a]['차변'] ? this.probmodel[a]['차변'][b] : 0;
         var 대변 = b in this.probmodel[a]['대변'] ? this.probmodel[a]['대변'][b] : 0;
         prob = (차변 + 대변)/(this.probmodel[a]['차변']["total"] + this.probmodel[a]['대변']["total"]);
         prob = prob > 0 ? prob : this.smallval; 
      }
      
      return prob;
  }





 makeprobtotal = () => {
      
      // 이미 한 계정으로 아래 함수 잘 돌아가는 것 확인했으나,
      // this.coaarray로는 확인이 안되었으니, 이것만 확인하면 됨
      
      for(var a of this.coaarray){
         var arr = {};     // 계정별로 {거리, 이전계정, 통과여부} 이렇게 arr를 구성함
         arr[a] = {거리: 1};

         // 모든 가능한 것을 다 돌려보면 비효율이므로 5번까지만 일단 돌려봄
         for(var i = 0; i < 5; i++){
              arr = this.findpath(arr);
         }
         this.probdistarray[a] = arr    
      }
 }
  
  test_prob = () => {
     

     //for(var i in this.probmodel){
        var arr = {};
        arr["투자주식"] = {확률: 1, 이전계정: [], 통과여부: 0}
        var result = this.makeprobtotal_cal(arr);
        this.probmodel_total["투자주식"] = result;
     //} 

     
  }

  optcal = (opt, coa) => {
         
      // 현재는 coa는 의미없음, 나중에 처분손익류는 방향이 같은 부분이 있기때문에 이를 위해서, coa도 받게했음
      if(opt == "차변"){
          return "대변";
      }

      if(opt == "대변"){
          return "차변";
      }
  }
   
  makeprobtotal_cal = (arr) => {
    
    // 장기대여금의 prob안에 이자수익, 대손충당금 등이 있겠지만, 
    // 없는 계정에 대한 확률을 임의로 추정해서 20개 이상의 making시 유사도 순을 뽑기위해서
    // 없는 계정에 대한 확률을 만듬
    // 차변 대변 구별없이 산정함
    
    // 다섯번까지 확장해봄. 나중에는 더 늘릴지 고민할 것 
    for(var num = 0; num < 5; num++){
       
       for(var a in arr){ 
               
          // 계정추가하기
          if(arr[a]["통과여부"] == 0){
              

              var temp = Object.keys(this.probmodel[a]["차변"]).concat(Object.keys(this.probmodel[a]["대변"]))
              var temp = new Set(temp);
              temp.delete("total");

              for(var i of temp){    
                   var prob = arr[a]["확률"] * this.probcal(a, i, "종합");
                   
                   // 차변 대변 구별을 위해서 optcal이란 함수를 만듬
                    
                   if(i in arr){
                          arr[i]["확률"] += prob;
                          arr[i]["이전계정"].push(a);
                   }else{
                      arr[i] = {확률: prob, 이전계정: [a], 통과여부: 0}
                   }
              }

              arr[a]["통과여부"] = 1;
          }
        }
     }  
     
     return arr;
  }

    // 연산 실행하기
    execute(){
        for(var i in this.subclass){
            this.subclass[i].execute()
            
     	   // 카운트 모델 만들기
     	   if(this.subclass[i].solvearr.length > 0){
        	   this.makecountmodel(this.subclass[i].solvegroup)
     	   }
        }
    }

    execute2(){
    	
    	// 카운터 모델에 의해 쪼갤질 가능성이 다양한 경우에는 확률에 따라 최적치 도출하기
        for(var i in this.subclass){
        	this.subclass[i].countmodel = this.countmodel;
            this.subclass[i].execute2()
            
        }
    	
        
    }

     
    execute3(){
        for(var i in this.subclass){
            this.subclass[i].execute3(this.sortedrealcoa, this.중분류_손익);
            
        }
    	
    }

    execute4(){
        for(var i in this.subclass){
            this.subclass[i].execute4();
            
        }
    }
    
    execute5(){
            for(var i in this.subclass){
                this.subclass[i].execute5();
                
            }
            
    }
    
   //
   
    execute_incometype(){
        for(var i in this.subclass){
            this.subclass[i].execute_incometype(this.sortedrealcoa, this.middlecoa);
            
        }
    	
    }
   
    
   // 정산표 배열에 집어넣기(coasum)
   inputcoasum = () => {
       
       // 이런 구조의 배열임
       // {장기대여금: {이자수익: {sum: , arr: []}, .....}}

       for(var i of this.realcoa){
           this.coasum[i] = [];
       } 

       

       for(var i in this.subclass){

           for(var j in this.subclass[i].solvearr){
               var 계정과목 = this.subclass[i].solvearr[j]["계정과목"];
               var 상대계정 = this.subclass[i].solvearr[j]["상대계정"];

               if(상대계정 in this.coasum[계정과목] == true){
                  this.coasum[계정과목][상대계정].arr.push(this.subclass[i].solvearr[j]);
                  this.coasum[계정과목][상대계정].sum += this.subclass[i].solvearr[j]["금액"];
               }else{
                  this.coasum[계정과목][상대계정] = {sum: this.subclass[i].solvearr[j]["금액"], arr: [this.subclass[i].solvearr[j]]};
               }               
           }

       }
   }
   
   makecountmodel(group){
	   
	   
	   // group = [{0,1,2}, {3, 4}] 합 0이 성공한 배열들 모음임
	   // arr는 mainarr말고 grouparr임
	 
	 for(var i in group){  
	   var dataset = new Set([])
	   for(var j in group[i]){
		   
		   dataset.add(group[i][j]["계정과목"])
	   }
	   
       	   
	   // 집합 비교연산하여 카운트 하기
	   var success = 0;
	   for(var i in this.countmodel){
		   if(this.equal(this.countmodel[i].type, dataset) == true){
			   this.countmodel[i].count += 1;
			   success = 1
			   break
		   }
	   }
	   
	   if(success == 0){
		   this.countmodel.push({count: 1, type: dataset})
	   }
	 }
   }
   
   
   // 집합 비교연산
   equal = (as, bs) => {
	    if (as.size !== bs.size) return false;
	    for (var a of as) if (!bs.has(a)) return false;
	    return true;
    }

    //## 엑셀파일에 대한 함수들
    
    openchild(){
    	
        // window.name = "부모창 이름"; 
        window.name = "parentForm";
        // window.open("open할 window", "자식창 이름", "팝업창 옵션");
        var url = '<c:url value = "/scope/subwindow" />'
        this.subwin = window.open(url,
                "childForm", "left = 500, top = 250, width=570, height=350, resizable = no, scrollbars = no");    
    }

    
    autosetting(){
          
         // 자동으로 계정과목 세팅을 위해서 만들었음
         // 계정과목 배열은 서버에서 넘겨받을 것임
         // coasetarr 구조: {"차변": [], "대변": [], "합계": [], "계정과목": [], "전표번호": [], "설명": []}
         // 이와 같은 구조가 될 것임

         var row = 1;

         this.coasetarr = {"금액": ["금액","잔액"], "계정과목": ["계정과목", "계정명"], "소분류": ["소분류"]}
         // 210518 향후에는 coamapping 하는 것처럼 
         // 정규식 이런 것 사용해서 정확성 올릴 것           
         
         for(var c = 1; c <= this.tablesize.width - 1; c++){
            for(var i in this.coasetarr){
                var tem = this.tablearr[row][c].innerText;
                for(var z in this.coasetarr[i]){
                   if(this.coasetarr[i][z] == tem){
                      this.itemselect[c].value = i;
                      this.itemarray[i] = c;
                   }
                }
             }
         }
         


    }
   


    fromexcel(wb, sheet){ // arr는 있다면 사용할 것
    
       if(!sheet){
           sheet = wb.SheetNames[0];
       }
       
       // 엑셀파일 이름 세팅
       this.sheetname = sheet;
       
       var total = wb.Sheets[sheet]["!ref"]
       var start = total.indexOf(":");
       var lastcell = total.substring(start + 1, 10);
       var range = XLSX.utils.decode_cell(lastcell);

       var rowval = this.tablesize.height - 1 //Math.min(range.r+1, this.tablesize.height - 1);
       var colval = this.tablesize.width - 1  //Math.min(range.c+1, this.tablesize.width - 1);
      
       
       for(var r = 1; r <= rowval; r++){
          for(var c = 1; c <= colval; c++){

              try{
            	 var tem = this.comma(wb.Sheets[sheet][XLSX.utils.encode_cell({r: r-1, c: c-1})].v)
                 this.tablearr[r][c].innerText = tem
                 this.tablearr[r][c].style = this.numbertag(tem, "")
              }catch{
                 this.tablearr[r][c].innerText = "";
              }

          }
       }
       
       // 나중에 asyia, await 등 고민할 것 
       this.autosetting();
    }
        
}  




class makecoa{

	constructor(){
        this.realbs = {};
        this.realis = {};
        this.realteam = {};
        this.coamap = {};
        this.realcoa = {};
        this.maintag = {};
        this.button = {};
        this.processlist = {};
	    this.companyteam = {};
	    this.divisionmapping = divisionmapping
	    this.processteam = processteam;
	    this.bi = ["비유동", "비금융", "비상각"]
	    this.remove = ["/(비){0,1}유동/g", "/(비){0,1}금융/g", "/(비){0,1}상각/g"];
	    this.maindiv = {};

	}


    processmap = () => {
       
       this.maintag.parentNode.removeChild(this.maintag); 
       for(var i in this.realcoa){
           for(var j in processmap[i]){
               var pro = processmap[i][j];
               if(this.processlist[pro]){
                  this.processlist[pro].push(i);
               }else{
                  this.processlist[pro] = [i];
               }

           }
       }

       this.makeprocessform();

    }

    makeprocessform = () => {
    	
       var form = document.createElement("form");
	   form.setAttribute("charset", "UTF-8");
	   form.setAttribute("name", "controlform");
	   form.setAttribute("method", "Post");  //Post 방식
	   this.maindiv.appendChild(form)
	   
	   var field = document.createElement("input");
		field.setAttribute("type", "submit");
		field.setAttribute("value", "제출해보자");
		form.appendChild(field);
	   
	   //form.style = "position : absolute; top : " + this.top + "px";   
	   form.setAttribute("action", "processsubmit");   
    	
    	var div = document.createElement("table"); // div 가 나은것 같으면
    	form.appendChild(div)             // div로 바꾸고
    	this.maintag = div;                        //밑의 함수는 ~~~div2
                                                   //가 아닌 ~~~div로
        // processlist 반영하기 
    	for(var i in this.processlist){
    		console.log(i);
    		var subdiv = this.makebuttondiv2(i, this.processlist[i])

    		div.appendChild(subdiv)
    	}

    }
    

    // tr, td로 구성
    makebuttondiv2 = (text, coas) => {
       
     	var div = document.createElement("tr")
    	var subdiv = document.createElement("td")
    	subdiv.innerText = text;
        div.appendChild(subdiv);
        
        var divisions = this.finddivision(text);

        var subdiv = document.createElement("td") 
        for(var j in divisions){
           var select = this.makeselect(this.companyteam);
           select.setAttribute("name", text);
           select.value = divisions[j];
           subdiv.appendChild(select);
        }         
        div.appendChild(subdiv);
        
    	var subdiv = document.createElement("td");
    	subdiv.innerText = "여기는 프로세스 설명을 담을 것";
        div.appendChild(subdiv);

        // 여기는 관련 계정을 담을 것
        var subdiv = document.createElement("td");
        var word = "";
        for(var i in coas){
           word = word + coas[i] + ", "
        }
        subdiv.innerText = word;
        div.appendChild(subdiv); 
        
        // 관련 계정은 hidden input으로 하여 넘겨버릴것
        var hiddendiv = document.createElement("input");
        hiddendiv.setAttribute("type", "hidden");
        hiddendiv.setAttribute("name", text + "_hidden");
        hiddendiv.setAttribute("value", word);

        div.appendChild(hiddendiv); 
        
        // 지금 바로는 원하는데로 안받아지므로, submit를 바꿔서, ajax 형태로 입력되도록 수정할 것
        
        return div;       
    }   
    
    // div로 구성
    makebuttondiv = (text, coas) => {
        
    	var div = document.createElement("div")
        div.style = "overflow : hidden";

    	var subdiv = document.createElement("div")
    	subdiv.style = "float : left; width : 150px; margin: 1px; border: 1px solid gold;";
    	subdiv.innerText = text;
        div.appendChild(subdiv);
        
        var divisions = this.finddivision(text);

        for(var j in divisions){
           var select = this.makeselect(this.companyteam);
           select.value = divisions[j];
           div.appendChild(select);
        }         

    	var subdiv = document.createElement("div");
    	subdiv.style = "float : left; width : 150px; border: 1px solid gold;";
    	subdiv.innerText = "여기는 프로세스 설명을 담을 것";
        div.appendChild(subdiv);

        // 여기는 관련 계정을 담을 것
        var subdiv = document.createElement("div");
        subdiv.style = "float : left; width : 150px;  border: 1px solid gold;";
        var word = "";
        for(var i in coas){
           word = word + coas[i] + ", "
        }
        subdiv.innerText = word;
        div.appendChild(subdiv); 
        return div;
    }
 

    finddivision = (process) => {

    	var team = this.processteam[process];
    	return this.realteam[team]; // 일단은 이렇게 하고 알고리즘 추가해갈것
    }

    makeform = () => {

    	var div = document.createElement("div")
    	

    	this.maindiv.appendChild(div)
    	this.maintag = div;

        // BS/IS 반영하기 
    	for(var i in this.realbs){
    		var subdiv = this.makediv(i, this.realbs[i], "BS")
    		div.appendChild(subdiv)
    	}
    	for(var i in this.realis){
    		var subdiv = this.makediv(i, this.realis[i], "IS")
    		div.appendChild(subdiv)
    	}

    	// 컨펌 버튼 추가하기
    	//var button = this.makebutton();
        //this.maindiv.appendChild(button) 
    	//this.button = button;

    }


    

    coamapping = () => {
        
        for(var i in this.coamap){
            this.realcoa[this.coamap[i].value] = 1
        }

        this.processmap()    
    }


   comma = (str) => { 
      str = String(str); 
      return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,'); 
   } 

   numbertag = (str, tag) => {
   	  str = String(str); 
   	  var arr = /[^0-9]/g.exec(str);
   	  

   	  if(arr){
   	  	return tag; 
   	  }else{
   	  	return tag + "text-align: right;"
   	  }
 
   }


    makediv = (text1, text2, opt) => {
    	var div = document.createElement("div")
        div.style = "overflow : hidden; ";

    	var subdiv1 = document.createElement("div")
    	var style = "float : left; width : 150px; border: 1px solid gold;";
    	subdiv1.style = this.numbertag(text1, style);
    	subdiv1.innerText = this.comma(text1);
    	this.numbertag(text1);

    	var subdiv2 = document.createElement("div")
    	var style = "float : left; width : 150px;border: 1px solid gold;";
    	subdiv2.style =this.numbertag(text2, style);
        subdiv2.innerText = this.comma(text2);

        div.appendChild(subdiv1);
        div.appendChild(subdiv2);
        
        // 선택가능한 계정 집어 넣어주기
        var subdiv3 = document.createElement("div")
        var select = this.makeselect(coaarray[opt]);
        subdiv3.appendChild(select);
        subdiv3.style = "float : left; height: 21px; width : 200px;border: 1px solid gold";

        div.appendChild(subdiv3);

        this.coamap[text1] = select;
        

        // 가장 유사한 계정 선택해주기
        var similar = this.typefind(text1, opt); //
        if(similar){
        	select.value = similar;
        }

        return div;
    }

    makeselect = (arr) => {
        

        var select = document.createElement('select');
        
        for(var i in arr){
            var opt = document.createElement('option');
            //opt.setAttribute('value', i)
            opt.innerText = i;
            select.appendChild(opt)
        }
        return select;

    }





// 이 하단부터는 주로 써칭하는 알고리즘에 관한 것 기술할 것
    typefind = (name, opt) => {
        // 위의 type 만들것 
        // array는 임시로 가정함. array = {'계정명' : '수익 등 real 계정'}
        if(oppositecoa[opt][name]){
            return oppositecoa[opt][name]
        }
      //  if(oppositesub[name]){
      //      return oppositesub[name]
      //  }
        // 완전히 똑같이 일치하는 것이 없으니 순환하면서 가장 유사한 것 찾기
        var grade1 = 0;
        var decide1 = "";
        
        

        for(var i in oppositecoa[opt]){
            
            var compare = i;
            //compare = compare.replace("(", "");
            //compare = compare.replace(")", "");
            var val = this.wordprocess(name, compare);
            this.wordprocess2(name, compare);
            var temp = this.similarmatch(name, compare) + val;
            
            if(temp > grade1){
                grade1 = temp;
                decide1 = oppositecoa[opt][i];
            }    
        }

        return decide1;
/*
       var grade2 = 0;
       var decide2 = "";

       for(var i in oppositesub){
            
            var compare = i;
            //compare = compare.replace("(", "");
            //compare = compare.replace(")", "");
            
            var temp = this.similarmatch(name, compare);
            
            if(temp > grade2){
                grade2 = temp;
                decide2 = oppositesub[i];
            }    
        }
        
        if(grade1 > grade2){
            return decide1;
        }else{
            return decide2;   
        }
 */
    }
 
 wordprocess2 = (name) => {

     for(var i in this.remove){
         name.replace(i, "");
     }

     return name;
 }

 wordprocess = (word, compare) => {
     var grade = 0;
     for(var i in this.bi){
         if(word.match(i) && compare.match(i)){
             grade += i.length;
         }  
     }

     return grade;
 }

 similarmatch = (word1, word2) => {

    var before = 0;
    var realsimil = 0;
    var simil = 0;
    var simil_pos = 0;
    var tem = 0;
    var arg = 2;

    for(var i = 2; i <= word1.length + 1; i++){
        
        var pos = word2.match(word1.substring(before, i));
       
        
        if(pos && i != word1.length + 1){
            simil = simil + 1
            var pos_record = pos.index;
            tem = tem + 1
        
        }else{

            if(tem > 0){
                var a1 = before / word1.length
                var a2 = pos_record / word2.length
                var dist1 = Math.sqrt((a1 - a2) * (a1 - a2))

                // 보통자본금/보통adsfasfasdfadf자본금
                // 앞으로만 dist를 계산하면 사실 끝단어인데도 불구하고 차이가 커짐
                // 즉 뒤에서 읽는 거리도 포함하여 더 거리가 작은것을 기준으로 반영
                a1 = (i - 1) / word1.length;
                a2 = (pos_record + i - 1 - before)/word2.length;
                var dist2 = Math.sqrt((a1 - a2) * (a1 - a2))
                var dist = (dist1 + dist2)/2; // 처음에는 min을 사용했으나
                                              // 단기금융상품/상품 찾지못하여
                                              // 평균을 사용함
                realsimil = realsimil + (arg - dist) * tem
                
                tem = 0
            }

            before = i - 1
        }
    
    }
    
    // word2가 보통 길이가 더 긴것을 보정해주기 위하여
    return realsimil/Math.max(1, (word2.length/word1.length));

   }

}



</script>

<body>


<div id ="tablediv" ></div>




<div id = "content_right">

<h3>원장이 있는 파일선택</h3>

<div>
<input type="file" id="excelFile" onchange="excelExport(event)"/>
</div>

<div> 
<input type="button" id ="testbutton" value="실행하기" style = "width: 75px;"/>
<select id = "selectsheet" style = "width: 173px;"></select>
</div>

<div id = "maindiv"></div>

</div>


</body>

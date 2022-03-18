<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html>
<head>
    <title>계정명확인</title>
</head>

<style>


table {
    border: 1px solid #444444;
    border-collapse: collapse;
  }
  
table th {
  border: 1px solid #444444;
  font-weight: bold;
  background: #dcdcd1;
  width: 200px;

  }

table td {
    border: 1px solid #444444;
    background: white;
  }


select {
      width: 100%;
      height: 100%;
      border: 0px;
}


</style>


<script type="text/javascript">


   

   
   
   function submitact(){
	   window.close();
   }

   
   // 윈도우 켜진후
   window.onload = function(){
	  
	  console.log(opener.table.coasortobj)
	  subtable = new subwindow(opener.table.coasortobj);
	  //210622 생성된 창을 보고 어떻게 수정할지 고민할 것
   }

   
   class subwindow{
	   
	   constructor(coasortobj){
		   
		   this.tag1 ={};
		   this.tablearr = {}
		   //this.중분류 = 중분류
		   this.button = document.getElementById("button");
		   this.button.addEventListener('click',()=>{this.confirm()});
		   this.subject =  document.getElementById("subject");
		   this.condition = "coaconfirm";
		   this.middlecoa = Object.keys(opener.table.middlecoa);
		   this.middlecoa.sort();
		   this.coasortobj = coasortobj; 
		   this.coasubwindow()
		   
	   }
	   
	   
	   // 처음에 이런 함수로 구성했다가 아래의 함수로 바꿈 
	   // 손익류, 차감형, 등을 나누는 것보다 그냥 죽 나열해서 바꾸게 하는게 나을 것 같으므로
	   
	   sort_coa(i){
		   
		   var val = opener.table.coasort(i);
		   if(val){
			   if(val in opener.table.coasortobj){
				   if(opener.table.coasortobj[val] in opener.table.middlecoa){
					   if("분류2" in opener.table.middlecoa[opener.table.coasortobj[val]]){
						   return opener.table.middlecoa[opener.table.coasortobj[val]]["분류2"];
					   }
				   }
			   }
		   }
		   return null;
	   }
	   
	   
	   coasubwindow(){
	   	   
	 	   // subwindow table에 집어넣을 계정배열들 순서대로 정렬하기
	 	   var arr = []
	 	   
	 	   this.tag1 = this.maketable(this.coasortobj);
	 	   var temp = document.getElementById("tag1")
	 	   temp.appendChild(this.tag1);
	    }  	   
	   
	   
	   makeselect(arr){
	       var select = document.createElement('select');
	       for(var i in arr){
	           var opt = document.createElement('option');
	           //opt.setAttribute('value', i)
              opt.innerText = arr[i];
              select.appendChild(opt)
	       }
	       return select;
	   }   

	   
	   // 첫번째 질문테이블 // 계정분류를 위한 질문테이블
	   maketable(arr){
		   
		   // 이제 집어넣기 
	       // 테이블 만들어 추가하기
	   	   var temptable = document.createElement("table");
	       
	       // 제목행 
	       var thead = document.createElement("thead");
	   	   temptable.appendChild(thead);
	       var temp = {}
	       var subdiv = this.maketrtd(temp, 2, "th");
	       temp[0].innerText = "회사계정"
	       temp[1].innerText = "표준계정분류";
	       
	       thead.appendChild(subdiv);
	       // 내용행

	       var tbody = document.createElement("tbody");
	       temptable.appendChild(tbody);
	       
	       for(var i in arr){
		       var tem = {}
	           var subdiv = this.maketrtd(tem, 2);
               
		       // 내일은 이것을 수정해야함
	           var sel = this.makeselect(opener.table.sortedcoa)
	           sel.value = arr[i]

	           tem[0].innerText = i;
	           tem[1].appendChild(sel);
	           tbody.appendChild(subdiv);
	           
	           this.tablearr[i] = sel;

	       } 

	       return temptable;
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
	   
	   
	   confirm(){
		   this[this.condition]();
	   }
	   
	   coaconfirm(){
		   
		   opener.table.maketable_scope()
		   window.close();
		   
	   }
	   

	   coaconfirm2(){
		   
		   // arr의 구조가 이럼
		   //210708 이거 할 차례임 이거 반영하고, 그 다음 바로 정산표가 뜨는게 아니도록 수정할 것
		   // table => td.innertext = 계정, td.sel = 분류
		   
		   for(var i in this.tablearr){
			  if(this.examtest(i) == true){
				    opener.table.sortedrealcoa[i]["main"] = this.tablearr[i].value
			  }else{
				    alert(i + "계정에 대한 차감계정을 선택해주세요. 단, 차감계정을 선택하면 안 됩니다.")
				    return
			  } 
		   }
	   
           // 210619 여기에 table 코드 집어넣을 것
           opener.table.makeprob();
	       opener.table.execute3();
	       opener.table.execute();
         
           opener.table.execute2();
           opener.table.execute4();
           opener.table.execute5();
           opener.table.execute_incometype();
           
           opener.table.inputcoasum();
           
           opener.table.makesettlement();
           
	       window.close();
	   }
	   

	   execute_func(arr_func){
		   for(var i in arr_func){
			   if(opener.table.execute_condition != "stop"){
			       arr_func[i]();
			   }else{
				   break
			   }
		   }
	   }
	   
	   examtest(i){
		   if(this.tablearr[i].value in opener.table.sortedrealcoa){
			   if(opener.table.sortedrealcoa[this.tablearr[i].value] != "자산/부채에 차감하는 계정"){
				   return true;
			   }
		   }
		   
		   return false;
	   }
	   
   }
   
   
   
   
</script>


<body>
    <h2 >계정과목별 분류표</h2>

    <input type = "button" id = "button" value = "확정하기" />

    <div id = "main">
      <p id = "subject">각종 계정과목 분류</p>
      <div id = "tag1"></div> 
    </div>
    

</body>
</html>

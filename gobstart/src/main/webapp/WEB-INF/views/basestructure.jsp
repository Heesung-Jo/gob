
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<title>Simple Block Editor</title>
</head>


<style>


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
  width: 15%;

}


#content_left {
 
  width : 60%;
  border: 1px solid #5F6673;
  background: #f7f9fa;
  height: 50%;
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


.detailcontent{
  float : left; 
  border: 1px solid black; 
  height: 45%; 
  width: 200px;
  background: gray;
  cursor: pointer;
}

</style>


<body>
  <!-- This top nav is not part of the sample code -->
         <script src="/js/go-debug.js"></script>
         <script src="/js/Figures.js"></script>
         <script src = "http://code.jquery.com/jquery-3.4.1.js"></script>
     
         <script src="/js/go.js"></script>
         <script src="/js/assets/js/goSamples.js"></script>
         <script src="/js/extensions/Figures.js"></script>
         <script src="/js/extensions/DrawCommandHandler.js"></script>


     <span id = "step0" class = "listmanage"></span>

      <div  id = "content_bottom"   >
        <div  id = "item" class = "listmanage"  style = "width: 1300px; height: 500px;">
        </div>
      </div>
 
      
</body>
<!--  This script is part of the gojs.net website, and is not needed to run the sample -->



<script> 



    function makeselect(arr, select){
        
        var opt = document.createElement('option');
        opt.innerText = "??????";
        select.appendChild(opt)

        for(var i in arr){
            var opt = document.createElement('option');
            //opt.setAttribute('value', i)
            opt.innerText = arr[i].text;
            select.appendChild(opt)
        }
        return select;

    }




      // div ?????? ?????????
      
      function additem(){
          //var currentitem = this.totalarr[this.countnumber]
          var div = makediv(currentitem.question, {id: "detailcontent"})
          var item = document.getElementById('content_bottom');
        	
          item.appendChild(div);
      }

      function makediv(value, style){
      	
      	var field = document.createElement("div");
      	
      	// style??? json ???????????? ?????? ???
      	if(style){
      		for(var i in style){
      			field.setAttribute(i, style[i]);
      		}
      	}
      	
      	field.innerText = value
      	return field;    	
      }      


      function inputitem(currentitem){
      	var div = makediv(currentitem.question, {id: "detailcontent"})
    	var item = document.getElementById('content_bottom');
    	item.appendChild(div);
      }

      function makediv(value, style){
      	var field = document.createElement("div");
      	// style??? json ???????????? ?????? ???
      	if(style){
      		for(var i in style){
      			field.setAttribute(i, style[i]);
      		}
      	}
      	
      	field.innerText = value
      	return field;    	
      }

      
 

  	
  	//////////////////////////////
  	//
  	//
  	//
  	//
  	//
  	///////////////////////////////
  	//
  	//
  	//
  	//
  	///////////////////////////////
  	
class diagram{
	
    constructor(){

       this.countnumber = 1;  // ????????? this.totalarr??? ????????? ????????? ???????????????, ???????????? ????????? ???????????? ???????????? ?????????
       
       this.countprocess = "";
       
       this.totalarr = [];
       this.totalanswer = {}
       this.step1list = {}
       this.step2now = ""
       this.step1now = ""
       this.step0now = ""
   	   this.currentitems = []
       
       this.answerlist = {};
       // ??????????????? ?????? ???????????? ??????????????? ?????? ??? ?????????, ????????? ????????? localStorage??? ??????
       this.content_bottom = document.getElementById('content_bottom');
       this.content_wrap = document.getElementById('content_wrap');
       this.step1 = document.getElementById('step1');
       this.step0 = document.getElementById('step0');
       
  	   var listmanage = document.getElementById('listmanage');
  	   var button_confirm = document.getElementById('confirm');
 
       var select1 = document.getElementById('select1');
       
       /*
       button_confirm.addEventListener('click', (me) => {
			this.confirm_final()
        })
        */

    }

    /*
	confirm_final = () => {
		
		// ????????? ???????????? ??????
		var header = $("meta[name='_csrf_header']").attr('content');
		var token = $("meta[name='_csrf']").attr('content');
		console.log("why")
		
		// ajax ??????
   		$.ajax({
   			type : "POST",
   			url : "/view/confirm_final",
   			beforeSend: function(xhr){
   			  if(token && header) {
   		       // xhr.setRequestHeader(header, token);
   			  } 
   		    },
   		    success : (res) => {
   		    	
   		    	// ????????? ????????? ????????? ??????, listmanage????????? ?????? ?????? 
   		    	console.log(res);
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	}
    */
    
    itemmake(){
    	
    	var item = document.getElementById('item');
    	for(var ia = item.childNodes.length - 1; ia >= 0; ia--){
    		console.log(item.childNodes[ia])
    		item.removeChild(item.childNodes[ia]);
    	}
    	
    	this.currentitems = [];
    	for(var ia in this.totalarr){
    
            	var currentitem = this.totalarr[ia]
            	var div = this.makediv(currentitem.question, {id: "detailcontent"})
            	item.appendChild(div);
            	this.currentitems.push(currentitem);

            	if(currentitem.inputs){
            		
            		console.log(currentitem.inputs)
                	var text = this["make" + currentitem.inputs](this.countnumber)
                	
                	// ????????? ?????? ???????????? //
                	var select = this.makeselect_real(this.members, this.countnumber)
                	text.appendChild(select)
                	
                   	var field = document.createElement("div");
            		field.setAttribute("name", this.countnumber);
            		field.appendChild(text)
                	item.appendChild(field);
            		
            		if(currentitem.answer.length > 0){
            			var num = 0
            			for(var ans in currentitem.answer){

            				if(num == 0){
            					
            					var input = text.querySelector("input[type=text]")
            					input.value = currentitem.answer[ans].val
               					var select = text.querySelector("select")
               				   	select.value = currentitem.answer[ans].person_charge
                            	
                            	
            				}else{
            					var div = this["make" + currentitem.inputs + "_add"](currentitem.answer[ans].val)
            					field.appendChild(div);
                            	var select = this.makeselect_real(this.members, this.countnumber)
                            	select.value = currentitem.answer[ans].person_charge
                            	div.appendChild(select)

            				}
            				num++
            			}
            		}
            		
            	}
    
    	}
    	
	    // ???????????? ?????? ????????????
        var button = document.createElement("input");
        button.setAttribute('type', "button");
        button.value = "????????????"

        item.appendChild(button);
        this.additem_submit(button)
        
    }
    
    
    makediv(value, style){
    	
    	
    	var field = document.createElement("div");
    	
    	// style??? json ???????????? ?????? ???
    	if(style){
    		for(var i in style){
    			field.setAttribute(i, style[i]);
    		}
    	}
    	
    	field.innerText = value
    	return field;    	
    }

    
	listmake = () => {
		
		// ????????? ???????????? ??????
		var header = $("meta[name='_csrf_header']").attr('content');
		var token = $("meta[name='_csrf']").attr('content');
		
		// ajax ??????
   		$.ajax({
   			type : "POST",
   			url : "/view/baselistmake",
   			beforeSend: function(xhr){
   			  if(token && header) {
   		       // xhr.setRequestHeader(header, token);
   			  } 
   		    },
   		    success : (res) => {
   		    	
   		    	// ????????? ????????? ????????? ??????, listmanage????????? ?????? ?????? 
   		    	console.log(res);
                this.listmake_detail(res, this.step0);
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	}	

	
	
	listmake_detail(res, listmanage){
	    	
            for(var i in res){
            	if(res[i]){
                	var div1 = this.makediv(res[i], {"class": "detailcontent"});
                	listmanage.appendChild(div1);
                	
                	// ??? div1????????? ?????? ????????? ????????????
                	this.additem2(div1);
            	}
            }
	}
	
	
	

	additem2 = (item) => {

		item.addEventListener('click', (me) => {

			this.poolmake({step0: me.target.innerText})
        })
    }

	
	
    additem_submit = (item) => {

    	item.addEventListener('click',(me) => {
            
        	var tagss = document.getElementsByName("1");
        	
        	// ???????????? select, textplus ?????? ?????? ????????? ???????????????
        	if(tagss.length > 0){

        		var tags = tagss[0];
        	    var data = {}
        	    var num = 0;
        	    var list = tags.querySelectorAll("div");  //"input[type=text]")
        	    
        	    for(var i = 0 ; i < list.length; i++){
                    var text = list[i].querySelector("input[type=text]");  
                    var select = list[i].querySelector("select");  
        	    	data[text.value] = select.value;
            	}

    	        console.log(data);
        	    // 220112 ?????? ???????????? ???
        	    var data_json = JSON.stringify(data)
        	    
        	    // ????????? ??????
            	var currentitem = this.currentitems[0];
                var process = currentitem.mainprocess;
                
                // ????????? ????????? ????????????
        	    this.ajaxmethod("basesturctureanswer/" + process , {"step0": data_json}, () => alert("??? ?????????????????????."))

        	}
            console.log(data)
         	
        })
    }
	
	poolmake = (stephash) => {
		
		// step0, 1, 2 ???????????? ????????? ?????? ?????????
		// ????????? ?????????, ?????? step??? ?????? step??? ?????? ????????? ???????????? ?????????
		// ?????? step??? ????????? ????????? ?????? ?????? step ????????? ????????? ??????
		
		// ????????? ???????????? ??????
		var header = $("meta[name='_csrf_header']").attr('content');
		var token = $("meta[name='_csrf']").attr('content');
		
		// ajax ??????
   		$.ajax({

   			type : "POST",
   			data : stephash,
   			url : "/view/basestructure",
   			beforeSend: function(xhr){

   			  if(token && header) {
   				  //console.log(header);
   				  //console.log(token);
   	    	      // xhr.setRequestHeader(header, token);
   			  } 
   		    },
   		    success : (res) => {
   		    	
   		    	console.log(res);
                this.totalarr = res.arr;
                this.members = res.members;
                this.countnumber = 1;
                
                this.itemmake();
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	}		
	
	
	
	ajaxmethod = (link, data, act) => {
		
		console.log(link);
		
		// ????????? ???????????? ??????
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
   		    	// res??? ?????????, ????????? ??? ????????????
   		    	console.log(res);
   		    	console.log(res.processjson);
   		    	
   		    	if(res){
   	   		    	if(act){
   	   	   				act(res.processjson)
   	   		    	}
   		    	}
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	}
 
	// make + select ??? ?????????
    makeselect(data, val){
        
        // option1 ~ option5 ????????? for??? 5????????? ????????? ???
  	   var field = document.createElement("select");
  	   field.setAttribute("name", val);
  	   for(var j = 1; j <= 5; j++){
  		   
  		   if(data['option' + j] != ""){
  	       	   var option = document.createElement("option");
            	   option.innerText = data['option' + j];
                field.appendChild(option);
  		   }else{
  			   break
  		   }

  	   }
  	  
 		return field;    	
     }

	
    makeselect_real(data, val){
        
        // option1 ~ option5 ????????? for??? 5????????? ????????? ???
  	   var field = document.createElement("select");
  	   field.setAttribute("name", val);
  	   for(var j in data){
  		   
       	   var option = document.createElement("option");
       	   option.innerText = data[j];
           field.appendChild(option);

  	   }
  	  
 		return field;    	
     }
	
	
    makeselectplus(data, val){
        
        var div1 = document.createElement("div");
        
        // ????????? select??? ?????????
    	var field = this.makeselect(data, val);
    	      
    	   // ?????? ???????????? ?????????
        var button = document.createElement("input");
        button.setAttribute('type', "button");
        button.value = "??????"
        
        div1.appendChild(field);
        div1.appendChild(button);
        
        // ????????? ?????? select ???????????? ??????
        this.additem_plus(button, data, val, div1, button);
        
        return div1;
   	   
     }
	
    maketextplus(val){
        
        var div1 = document.createElement("div");
        
        // ????????? text??? ?????????
 		var field = document.createElement("input");
		field.setAttribute("type", "text");
    	      
    	   // ?????? ???????????? ?????????
        var button = document.createElement("input");
        button.setAttribute('type', "button");
        button.value = "??????"
        
        div1.appendChild(field);
        div1.appendChild(button);
        
        // ????????? ?????? select ???????????? ??????
        this.additem_textplus(button, val, div1, button);
        return div1;
        
     }	

    
    maketextplus_add(val){
    	// ?????? select??? ????????? ??????????????? ??????????????? ???????????? ??????????????? ???????????? ???????????? ????????? ???
 
  	    	// ?????? ??????
  	    	var divs = document.createElement("div");
  	    	divs.innerText = ", ";
  	    	
            // ????????? text??? ?????????
		    var field = document.createElement("input");
	        field.setAttribute("type", "text");
  	    	divs.appendChild(field);
  	    	field.value = val
        	
         	// ?????? ?????? ??????
            var button_remove = document.createElement("input");
            button_remove.setAttribute('type', "button");
            button_remove.value = "X"
            divs.appendChild(button_remove);
            
            
            // ?????? ????????? ?????? ?????? ????????????
            this.additem_remove(button_remove, divs);
            
            return divs
    }
    
    
    additem_textplus(item, val, div1, button){

    	item.addEventListener('click',(me)=>{
        	
        	// ?????? select??? ????????? ??????????????? ??????????????? ???????????? ??????????????? ???????????? ???????????? ????????? ???
            var tags = document.getElementsByName(val)[0];
        	console.log(tags)
            
      	    if(tags.childNodes.length < 5){

      	    	// ?????? ??????
      	    	var divs = document.createElement("div");
      	    	divs.innerText = ", ";
      	    	
                // ????????? text??? ?????????
 		        var field = document.createElement("input");
		        field.setAttribute("type", "text");
      	    	divs.appendChild(field);
            	
             	// ?????? ?????? ??????
                var button_remove = document.createElement("input");
                button_remove.setAttribute('type', "button");
                button_remove.value = "X"
                divs.appendChild(button_remove);
                tags.appendChild(divs);
                
                // ?????? ????????? ?????? ?????? ????????????
                this.additem_remove(button_remove, divs);
                
                // member ?????? ?????? // ????????? ?????? ???????????? //
            	var select = this.makeselect_real(this.members, this.countnumber)
            	divs.appendChild(select)
                
                
       	    }else{
      	    	alert("?????? ????????? ?????????????????????.")
      	    }
        
        })
    }

    additem_remove(item, parentitem){
    	
    	item.addEventListener('click',(me) => {
    		parentitem.parentNode.removeChild(parentitem); 
    	})
    
     }
   }  	
 
  	
   window.onload = function(){
	   var diagram1 = new diagram();
	   diagram1.listmake();
   } 	
  	

  </script>


</html>
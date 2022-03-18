
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
  width: 20%;
  height: 50%;
}


#content_left {
 
  width : 70%;
  border: 1px solid #5F6673;
  background: #f7f9fa;
  height: 50%;
  float: left;
  
}


 #content_bottom {
  height: 70%;
  width: 70%;
  display: inline-block;
  border: 1px solid #444444;
  font-weight: bold;
  background: white;
  padding: 0px;
  overflow: scroll;
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
     <span id = "inventory" style = "display: none">
           <input type = "radio"  name = "inventoryitem" value = "0" checked >일반질문</input>
           <input type = "radio"  name = "inventoryitem" value = "1" >공정흐름</input>
     </span>
      
     <div id = "content_center">
       <div id = "content_left">
         <div id="myDiagramDiv" style="border: solid 1px black; width:100%; height:100%"></div>
       </div>
      
       <div id = "content_right">
         <h3>공정추가하기</h3>
         <h5>선공정</h5>
         <select id = "select1" style = "width: 173px;"></select>
         <h5>후공정</h5>
         <select id = "select2" style = "width: 173px;"></select>
         <h5>공정이름</h5>
         <input type = "text" id = "myworkname"/>
         <input type = "button" id = "myworkbutton" value = "추가하기"/>
       </div> 
     </div>
     
      <div  id = "inventoryprocess" style = "height: 20px; display: none">
      
      </div>

     
      <div  id = "content_bottom"   >
        <div  id = "item"   style = "width: 1300px; height: 500px;">
        </div>
      </div>
      
      
</body>
<!--  This script is part of the gojs.net website, and is not needed to run the sample -->



<script> 

    var myDiagram= {}    
    var $$ = go.GraphObject.make;    

    // Common context menu button definitions

    // All buttons in context menu work on both click and contextClick,
    // in case the user context-clicks on the button.
    // All buttons modify the node data, not the Node, so the Bindings need not be TwoWay.

    // A button-defining helper function that returns a click event handler.
    // PROPNAME is the name of the data property that should be set to the given VALUE.
    function ClickFunction(propname, value) {
      return function(e, obj) {
          e.handled = true;  // don't let the click bubble up
          e.diagram.model.commit(function(m) {
            m.set(obj.part.adornedPart.data, propname, value);
          });
        };
    }

    // Create a context menu button for setting a data property with a color value.
    function ColorButton(color, propname) {
      if (!propname) propname = "color";
      return $$(go.Shape,
        {
          width: 16, height: 16, stroke: "lightgray", fill: color,
          margin: 1, background: "transparent",
          mouseEnter: function(e, shape) { shape.stroke = "dodgerblue"; },
          mouseLeave: function(e, shape) { shape.stroke = "lightgray"; },
          click: ClickFunction(propname, color), contextClick: ClickFunction(propname, color)
        });
    }

    function LightFillButtons() {  // used by multiple context menus
      return [
        $$("ContextMenuButton",
          $$(go.Panel, "Horizontal",
            ColorButton("white", "fill"), ColorButton("beige", "fill"), ColorButton("aliceblue", "fill"), ColorButton("lightyellow", "fill")
          )
        ),
        $$("ContextMenuButton",
          $$(go.Panel, "Horizontal",
            ColorButton("lightgray", "fill"), ColorButton("lightgreen", "fill"), ColorButton("lightblue", "fill"), ColorButton("pink", "fill")
          )
        )
      ];
    }

    function DarkColorButtons() {  // used by multiple context menus
      return [
        $$("ContextMenuButton",
          $$(go.Panel, "Horizontal",
            ColorButton("black"), ColorButton("green"), ColorButton("blue"), ColorButton("red")
          )
        ),
        $$("ContextMenuButton",
          $$(go.Panel, "Horizontal",
            ColorButton("brown"), ColorButton("magenta"), ColorButton("purple"), ColorButton("orange")
          )
        )
      ];
    }

    // Create a context menu button for setting a data property with a stroke width value.
    function ThicknessButton(sw, propname) {
      if (!propname) propname = "thickness";
      return $$(go.Shape, "LineH",
        {
          width: 16, height: 16, strokeWidth: sw,
          margin: 1, background: "transparent",
          mouseEnter: function(e, shape) { shape.background = "dodgerblue"; },
          mouseLeave: function(e, shape) { shape.background = "transparent"; },
          click: ClickFunction(propname, sw), contextClick: ClickFunction(propname, sw)
        });
    }

    // Create a context menu button for setting a data property with a stroke dash Array value.
    function DashButton(dash, propname) {
      if (!propname) propname = "dash";
      return $$(go.Shape, "LineH",
        {
          width: 24, height: 16, strokeWidth: 2,
          strokeDashArray: dash,
          margin: 1, background: "transparent",
          mouseEnter: function(e, shape) { shape.background = "dodgerblue"; },
          mouseLeave: function(e, shape) { shape.background = "transparent"; },
          click: ClickFunction(propname, dash), contextClick: ClickFunction(propname, dash)
        });
    }

    function StrokeOptionsButtons() {  // used by multiple context menus
      return [
        $$("ContextMenuButton",
          $$(go.Panel, "Horizontal",
            ThicknessButton(1), ThicknessButton(2), ThicknessButton(3), ThicknessButton(4)
          )
        ),
        $$("ContextMenuButton",
          $$(go.Panel, "Horizontal",
            DashButton(null), DashButton([2, 4]), DashButton([4, 4])
          )
        )
      ];
    }

    // Node context menu

    function FigureButton(fig, propname) {
      if (!propname) propname = "figure";
      return $$(go.Shape,
        {
          width: 32, height: 32, scale: 0.5, fill: "lightgray", figure: fig,
          margin: 1, background: "transparent",
          mouseEnter: function(e, shape) { shape.fill = "dodgerblue"; },
          mouseLeave: function(e, shape) { shape.fill = "lightgray"; },
          click: ClickFunction(propname, fig), contextClick: ClickFunction(propname, fig)
        });
    }
    
    function makeAdornmentPathPattern(w) {
        return $$(go.Shape,
          {
            stroke: "dodgerblue", strokeWidth: 2, strokeCap: "square",
            geometryString: "M0 0 M4 2 H3 M4 " + (w+4).toString() + " H3"
          });
      }

      // Link context menu
      // All buttons in context menu work on both click and contextClick,
      // in case the user context-clicks on the button.
      // All buttons modify the link data, not the Link, so the Bindings need not be TwoWay.

      function ArrowButton(num) {
        var geo = "M0 0 M16 16 M0 8 L16 8  M12 11 L16 8 L12 5";
        if (num === 0) {
          geo = "M0 0 M16 16 M0 8 L16 8";
        } else if (num === 2) {
          geo = "M0 0 M16 16 M0 8 L16 8  M12 11 L16 8 L12 5  M4 11 L0 8 L4 5";
        }
        return $$(go.Shape,
          {
            geometryString: geo,
            margin: 2, background: "transparent",
            mouseEnter: function(e, shape) { shape.background = "dodgerblue"; },
            mouseLeave: function(e, shape) { shape.background = "transparent"; },
            click: ClickFunction("dir", num), contextClick: ClickFunction("dir", num)
          });
      }

      function AllSidesButton(to) {
        var setter = function(e, shape) {
            e.handled = true;
            e.diagram.model.commit(function(m) {
              var link = shape.part.adornedPart;
              m.set(link.data, (to ? "toSpot" : "fromSpot"), go.Spot.stringify(go.Spot.AllSides));
              // re-spread the connections of other links connected with the node
              (to ? link.toNode : link.fromNode).invalidateConnectedLinks();
            });
          };
        return $$(go.Shape,
          {
            width: 12, height: 12, fill: "transparent",
            mouseEnter: function(e, shape) { shape.background = "dodgerblue"; },
            mouseLeave: function(e, shape) { shape.background = "transparent"; },
            click: setter, contextClick: setter
          });
      }

      function SpotButton(spot, to) {
        var ang = 0;
        var side = go.Spot.RightSide;
        if (spot.equals(go.Spot.Top)) { ang = 270; side = go.Spot.TopSide; }
        else if (spot.equals(go.Spot.Left)) { ang = 180; side = go.Spot.LeftSide; }
        else if (spot.equals(go.Spot.Bottom)) { ang = 90; side = go.Spot.BottomSide; }
        if (!to) ang -= 180;
        var setter = function(e, shape) {
            e.handled = true;
            e.diagram.model.commit(function(m) {
              var link = shape.part.adornedPart;
              m.set(link.data, (to ? "toSpot" : "fromSpot"), go.Spot.stringify(side));
              // re-spread the connections of other links connected with the node
              (to ? link.toNode : link.fromNode).invalidateConnectedLinks();
            });
          };
        return $$(go.Shape,
          {
            alignment: spot, alignmentFocus: spot.opposite(),
            geometryString: "M0 0 M12 12 M12 6 L1 6 L4 4 M1 6 L4 8",
            angle: ang,
            background: "transparent",
            mouseEnter: function(e, shape) { shape.background = "dodgerblue"; },
            mouseLeave: function(e, shape) { shape.background = "transparent"; },
            click: setter, contextClick: setter
          });
      }    
    // Show the diagram's model in JSON format
    
    function load(nodedata, linkdata) {
      data = { "class": "GraphLinksModel", "nodeDataArray": nodedata, "linkDataArray": linkdata}
      
      myDiagram.model = go.Model.fromJson(data);
    }

    function makeselect(arr, select){
        
        var opt = document.createElement('option');
        opt.innerText = "없음";
        select.appendChild(opt)

        for(var i in arr){
            var opt = document.createElement('option');
            //opt.setAttribute('value', i)
            opt.innerText = arr[i].text;
            select.appendChild(opt)
        }
        return select;

    }
	
    function make_diagram_hash(){
		
    	var realhash = {};
    	var mapping = {}
    	var num = 0;

    	for(var ia in myDiagram.model.Cc){
    		// cc[num] =JSON.stringify(myDiagram.model.Cc[ia])
    		var item = myDiagram.model.Cc[ia]
    		mapping[item.key] = item.text;
    	}
    	
    	for(var ia in mapping){
    		realhash[mapping[ia]] = {};
    	}
    	
    	for(var ia in myDiagram.model.Nc){
    		var from = myDiagram.model.Nc[ia].from
    		var to = myDiagram.model.Nc[ia].to
    		realhash[mapping[from]][to] = {from: mapping[from], to: mapping[to]};
    	}
    	return realhash;
	}
    
      function addnodedata2(res, act){
    	  
    	  var nodedata = [];
    	  var nodehash = {};
    	  var linkdata = [];
    	   var next = [];
    	   // 첫번재 노드를 찾기
    	   var first = new Set([]);
    	   var elimi = new Set([]);
    	   
    	   for(var i in res){
    		   if(res[i].subprocess2){
        		   first.add(res[i].subprocess2);
    		   }
    		   if(res[i].subprocess2){
        		   elimi.add(res[i].subprocess3);
    		   }
    	   }
    	   var current = [[...first].filter(x => !elimi.has(x))[0]];
    	   console.log(current)
           var realpro = current[0];
           var realcou = 1;
           nodehash[realpro] = {"key": realcou, "loc":"0 0", "text": realpro, posx: 0, posy: 0}           
           console.log(nodehash)
           // 순환하기
           
           var cou = 0
           while(cou < 30 && current.length > 0){
        	   
        	   var temp = new Set([])
        	   for(var cu in current){
        		   var pro = current[cu];
        		   console.log(pro)
                   var y_current = nodehash[pro].posy;
                   
        		   for(var i in res){
            		   if(res[i].subprocess2 == pro){

            			   if(res[i].subprocess3 != null){
                			   temp.add(res[i].subprocess3)
            			   
            			     if(res[i].subprocess3 in nodehash == false){
            				  //nodedata 넣기
            				   var x = nodehash[pro].posx + 150
            				   realcou++
            		           nodehash[res[i].subprocess3] = {"key": realcou, "loc":x + " " + y_current, "text": res[i].subprocess3, posx: x, posy: y_current}           
            				   y_current += 100
            			     }else{
            				  // 앞으로 오류난다면 
            				  //nodedata의 위치 업데이트 하기 
            			     }
            			   
            			      //linkdata 넣기
            			      var from = nodehash[pro].key
            			   
            			      var to = nodehash[res[i].subprocess3].key
            			     linkdata.push({"from": from, "to": to})
            			   }
             		   }
        		   }
        	   }
        	   
        	   console.log(temp)
        	   if(temp.size > 0){
       			   current = [...temp];
        		   
        	   }else{
        		   current = []
        	   }
        	   
        	   cou++
           }
           
            // nodehash를 list화하기
            for(var i in nodehash){
            	nodedata.push(nodehash[i])
            }

            
	         load(nodedata, linkdata);
	         if(act){act()}
      }
    
    
    
      function addnodedata() { 

    	  myDiagram.model.commit(function(m) {
          
          	  var select1 = document.getElementById('select1');
              var select2 = document.getElementById('select2');
          
              for(var i in m.Cc){
                    if(m.Cc[i].text == select1.value){
                       var num1 = i
                       var key1 = m.Cc[i].key
                    }
                    if(m.Cc[i].text == select2.value){
                       var num2 = i
                       var key2 = m.Cc[i].key
                    }
              }

              if(key1 == null){
                    alert("선공정을 선택해주세요")
                    return
              }

              if(key2 == null){
                    alert("후공정을 선택해주세요")
                    return
              }

              // 공정 이름이 없다면, 역시 넘겨야 함
              var myworkname = document.getElementById('myworkname');
              
              if(myworkname.value == ""){
                 alert("공정이름이 비어있습니다.");
                 return;
              }

              
              for(var ai in m.Cc){
                  var arr = m.Cc[ai];
                  if(arr["text"] == myworkname.value){
                      alert("공정이름이 중복됩니다.")
                      return;
                  }
              }


              // 그리고 공정 이름이 이미 있는거라면 이것도 넘겨야 함
              // 주의해야 할 사항
              // 순환되는 요소로 추가는 안됨
              // 즉 거꾸로 select2에서 시작해서 select1으로 도착하는 경로가 있으면 이것은 추가 못하게 해야함
              realarr = new Set([key2])

              // 더 많은 num 또는 num 대신 while(realarr.length == before) 등의 구현이 필요할 수도 있으나
              // 일단은 5회로 횟수를 제한하였음 // 추후 고민할 것
              for(num = 0; num <= 5; num++){
                 for(var i in m.Nc){
                    if(realarr.has(m.Nc[i].from)){
                          realarr.add(m.Nc[i].to)
                    }
                 }
                 if(realarr.has(key1)){
                       alert("순환고리를 가지고 있습니다. 순환되지 않도록 공정을 선택해주세요")
                       return
                 }
              }
              
              var nodedata = m.copyNodeData(m.Cc[0]);
              nodedata.text = myworkname.value
              m.addNodeData(nodedata);  // add to model
              var linkdata = {from: m.Cc[num1].key, to: nodedata.key};
              m.addLinkData(linkdata);  // add to model
              var linkdata = {from: nodedata.key, to: m.Cc[num2].key};
              m.addLinkData(linkdata);  // add to model

              poswhile(m.Nc, m.Cc, [m.Cc[0]], {x: 0, y: 0}, [])
              
              // 변환된 위치 set하기
              for(var i in m.Cc){
                  var ypos = Number(m.Cc[i].loc.match(/[0-9]{1,4}$$/gi)[0])
                  var xpos = Number(m.Cc[i].loc.match(/^[0-9]{1,4}/gi)[0])
                  m.set(m.Cc[i], "loc", "0 0");
                  m.set(m.Cc[i], "loc", xpos + " " + ypos);
                  
              }

        })
     }



     function poswhile(posarr, realarr, arr, pos, passedhash){

           // passedhash는 이미 위치를 세팅한게 또 나오면 그 위치의 y좌표는 바꾸지 않도록 하기위함
           // 그리고 x위치는 더 큰거로 바꾸는게 목표임
           console.log(arr)
           for(var i in arr){
                 
                 // arr[i]를 realarr에서 찾아서 위치를 바꿔주기
                 for(var j in realarr){
      
                     if(realarr[j].key == arr[i].key){
      
                         // 먼저 passedhash에 있는거라면, 위치를 위에 써진대로 바꿔주
                         if(arr[i].key in passedhash){

                             var ypos = Number(realarr[j].loc.match(/[0-9]{1,4}$/gi)[0])
                             var xpos = Number(realarr[j].loc.match(/^[0-9]{1,4}/gi)[0])
                             xpos = Math.max(pos.x, xpos);
                             realarr[j].loc = xpos + " " + ypos;  
                             var newpos = {x: xpos + 200, y: ypos}
                             break
 
                         }else{
                             realarr[j].loc = pos.x + " " + pos.y;
                             console.log(realarr[j].loc)  
                             
                             passedhash[arr[i].key] = 1;
                             var newpos = {x: pos.x + 200, y: pos.y}
                             pos.y += 100;
                             break
                         }

                      }
                     
                 }

                 var nextarr = []

                 // 이제 자식을 찾아서 넣어주기
                 for(var j in posarr){
                    if(posarr[j].from == arr[i].key){
                       var to = posarr[j].to;

                       for(var z in realarr){
                             if(realarr[z].key == to){
                               nextarr.push(realarr[z])
                               break
                           }
                       }   
                    }
                 }
                 
                 console.log(realarr)     
                 if(nextarr.length > 0){
                     poswhile(posarr, realarr, nextarr, newpos, passedhash)
                 }                                

           }
     }

     
      

      function changecolor(text, color) {  // define a function named "changeColor" callable by button.onclick
       
          myDiagram.model.commit(function(m) {
              // alternate between lightblue and lightgreen colors

             // 기존 색깔있는것 빼내기
              for(var i in m.Cc){
                    if(m.Cc[i].fill == color){
                       m.set(m.Cc[i], "fill", "white");
                    }
              }
        
              // create a new node in the direction of the spot
              // make the new node a copy of the selected node
              for(var i in m.Cc){
                    if(m.Cc[i].text == text){
                       m.set(m.Cc[i], "fill", color);
                    }
              }
        })
     }


      function addlisten(item){
        item.addEventListener('click',()=>{
            addnodedata()
        })
      }

      function addlisten_sel(item, color){
        item.addEventListener('change',(me)=>{
        	
            changecolor(me.target.value, color)
        })
      }



      // div 관련 함수들
      
      function additem(){
          //var currentitem = this.totalarr[this.countnumber]
          var div = makediv(currentitem.question, {id: "detailcontent"})
          var item = document.getElementById('content_bottom');
        	
          item.appendChild(div);
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


      function inputitem(currentitem){
      	var div = makediv(currentitem.question, {id: "detailcontent"})
    	var item = document.getElementById('content_bottom');
    	item.appendChild(div);
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

       this.countnumber = 1;  // 아래의 this.totalarr의 항목중 하나가 보여질텐데, 보여지는 항목이 몇번인지 표시하는 숫자임
       
       this.countprocess = "";
       
       this.realtag = "";
       this.realdata = {}; // 나중에 공장이 딸기인지 바나나 공장인지 눌러진 데이터 값을 보존하는 변수
       
       this.totalarr = [];
       this.totalanswer = {}
       this.step1list = {}
       this.step2now = ""
       this.step1now = ""
       this.step0now = ""
   	   this.currentitems = []
       
       this.answerlist = {};
       // 재고자산은 다른 템플릿을 사용하는게 나을 것 같아서, 필요한 정보는 localStorage에 저장
       this.content_center = document.getElementById('content_center');
       this.content_bottom = document.getElementById('content_bottom');
       this.content_wrap = document.getElementById('content_wrap');
       this.step1 = document.getElementById('step1');
       this.step0 = document.getElementById('step0');
       this.inventoryfinaltag = "";
       
       this.inventoryfinalprocess = {}
	   var inventoryitems = document.getElementsByName("inventoryitem");

       for(var aa = 0; aa < inventoryitems.length; aa++){
    	   var inventoryitem = inventoryitems[aa];
    	   
    	   inventoryitem.addEventListener('click', (me) => {
               
    		   console.log("처음에서 왔네")
    		   console.log(this.realdata)
    		   if(me.target.value == "1"){
    			   this.content_center.style.display = "block"
             	   this.ajaxmethod("baseinventoryquestion/", this.realdata, (res) => {
             	       
             	       
             	       // 여기서 두개로 쪼개짐
             	       // 이미 공정이 입력되어 있을 경우에는, 입력된 공정을 받아오고 이것을 그려줘야 함
             	       
             	       if(res.question){
             	    	   this.totalarr = res.question;
             	    	   addnodedata2(res.jsonlist);
                           var realhash = make_diagram_hash() 
                           
                    	   this.makingnodetag(realhash);
                           
                           for(var i in realhash){
                        	   for(var j in realhash[i]){
                        		   var data = realhash[i][j];
                        		   break;
                        	   }
                        	   break;
                           }
                           
                		   this.itemmake(data.from, data.to);

             	       }else{
                 	       // 그렇지 않을 경우에는 질문에 대한 itemmake를 할 것
                           this.totalarr = res;                		
                           var nodedata = [
                               {"key":1, "loc":"0 0", "text":"입고창고"},
                               {"key":2, "loc":"200 0", "text":"생산공정"},
                               {"key":3, "loc":"400 0", "text":"출고창고"}
                                ]
                           
                           var linkdata = [
                               {"from":1, "to":2},
                               {"from":2, "to":3}
                                ]

                           load(nodedata, linkdata);
                 	       this.itemmake()
             	       }
             	       
             	       
             	   })
    		   }else{
    			   
    			   this.content_center.style.display = "none"
   					var div = document.getElementById("inventoryprocess");
    				div.style.display = "none"

    			   this.poolmake(this.realdata);
    		   }
    	   })
       }
		   
			/* 여기도 poolmake도 사용하기 해야할 듯, 왜냐하면 현재상태를 끌어와야 하니까.
            var grade = "";
            this.realtag = me.target;
            this.realdata = data;
            this.poolmake(data);
			*/
     

	   
  	   var listmanage = document.getElementById('listmanage');
       
       myDiagram =
         $$(go.Diagram, "myDiagramDiv",
           {
             padding: 20,  // extra space when scrolled all the way
             grid: $$(go.Panel, "Grid",  // a simple 10x10 grid
               $$(go.Shape, "LineH", { stroke: "lightgray", strokeWidth: 0.5 }),
               $$(go.Shape, "LineV", { stroke: "lightgray", strokeWidth: 0.5 })
             ),
             "draggingTool.isGridSnapEnabled": true,
             handlesDragDropForTopLevelParts: true,
             mouseDrop: function(e) {
               // when the selection is dropped in the diagram's background,
               // make sure the selected Parts no longer belong to any Group
               var ok = e.diagram.commandHandler.addTopLevelParts(e.diagram.selection, true);
               if (!ok) e.diagram.currentTool.doCancel();
             },
             commandHandler: $$(DrawCommandHandler),  // support offset copy-and-paste
             "clickCreatingTool.archetypeNodeData": { text: "NEW NODE" },  // create a new node by double-clicking in background
             "PartCreated": function(e) {
               var node = e.subject;  // the newly inserted Node -- now need to snap its location to the grid
               node.location = node.location.copy().snapToGridPoint(e.diagram.grid.gridOrigin, e.diagram.grid.gridCellSize);
               setTimeout(function() {  // and have the user start editing its text
                 e.diagram.commandHandler.editTextBlock();
               }, 20);
             },
             "commandHandler.archetypeGroupData": { isGroup: true, text: "NEW GROUP" },
             "SelectionGrouped": function(e) {
               var group = e.subject;
               setTimeout(function() {  // and have the user start editing its text
                 e.diagram.commandHandler.editTextBlock();
               })
             },
             "LinkRelinked": function(e) {
               // re-spread the connections of other links connected with both old and new nodes
               var oldnode = e.parameter.part;
               oldnode.invalidateConnectedLinks();
               var link = e.subject;
               if (e.diagram.toolManager.linkingTool.isForwards) {
                 link.toNode.invalidateConnectedLinks();
               } else {
                 link.fromNode.invalidateConnectedLinks();
               }
             },
             "undoManager.isEnabled": true
           });


       // Node template

       myDiagram.nodeTemplate =
         $$(go.Node, "Auto",
           {
             click: (e, node) => {
                 var cmd = myDiagram.commandHandler;
                 var text = node.data.text;
                 this.button_selected(text, "step2");
              },

             locationSpot: go.Spot.Center, locationObjectName: "SHAPE",
             desiredSize: new go.Size(120, 60), minSize: new go.Size(40, 40),
             resizable: true, resizeCellSize: new go.Size(20, 20)
           },
           // these Bindings are TwoWay because the DraggingTool and ResizingTool modify the target properties
           new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
           new go.Binding("desiredSize", "size", go.Size.parse).makeTwoWay(go.Size.stringify),
           $$(go.Shape,
             { // the border
               name: "SHAPE", fill: "white",
               portId: "", cursor: "pointer",
               fromLinkable: true, toLinkable: true,
               fromLinkableDuplicates: true, toLinkableDuplicates: true,
               fromSpot: go.Spot.AllSides, toSpot: go.Spot.AllSides
             },
             new go.Binding("figure"),
             new go.Binding("fill"),
             new go.Binding("stroke", "color"),
             new go.Binding("strokeWidth", "thickness"),
             new go.Binding("strokeDashArray", "dash")),
           // this Shape prevents mouse events from reaching the middle of the port
           $$(go.Shape, { width: 100, height: 40, strokeWidth: 0, fill: "transparent" }),
           $$(go.TextBlock,
             { margin: 1, textAlign: "center", overflow: go.TextBlock.OverflowEllipsis, editable: true },
             // this Binding is TwoWay due to the user editing the text with the TextEditingTool
             new go.Binding("text").makeTwoWay(),
             new go.Binding("stroke", "color"))
         );

       myDiagram.nodeTemplate.toolTip =
         $$("ToolTip",  // show some detailed information
           $$(go.Panel, "Vertical",
             { maxSize: new go.Size(200, NaN) },  // limit width but not height
             $$(go.TextBlock,
               { font: "bold 10pt sans-serif", textAlign: "center" },
               new go.Binding("text")),
             $$(go.TextBlock,
               { font: "10pt sans-serif", textAlign: "center" },
               new go.Binding("text", "details"))
           )
         );


       myDiagram.nodeTemplate.contextMenu =
         $$("ContextMenu",
           $$("ContextMenuButton",
             $$(go.Panel, "Horizontal",
               FigureButton("Rectangle"), FigureButton("RoundedRectangle"), FigureButton("Ellipse"), FigureButton("Diamond")
             )
           ),
           $$("ContextMenuButton",
             $$(go.Panel, "Horizontal",
               FigureButton("Parallelogram2"), FigureButton("ManualOperation"), FigureButton("Procedure"), FigureButton("Cylinder1")
             )
           ),
           $$("ContextMenuButton",
             $$(go.Panel, "Horizontal",
               FigureButton("Terminator"), FigureButton("CreateRequest"), FigureButton("Document"), FigureButton("TriangleDown")
             )
           ),
           LightFillButtons(),
           DarkColorButtons(),
           StrokeOptionsButtons()
         );


       // Group template

       myDiagram.groupTemplate =
         $$(go.Group, "Spot",
           {
             layerName: "Background",
             ungroupable: true,
             locationSpot: go.Spot.Center,
             selectionObjectName: "BODY",
             computesBoundsAfterDrag: true,  // allow dragging out of a Group that uses a Placeholder
             handlesDragDropForMembers: true,  // don't need to define handlers on Nodes and Links
             mouseDrop: function(e, grp) {  // add dropped nodes as members of the group
               var ok = grp.addMembers(grp.diagram.selection, true);
               if (!ok) grp.diagram.currentTool.doCancel();
             },
             avoidable: false
           },
           new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
           $$(go.Panel, "Auto",
             { name: "BODY" },
             $$(go.Shape,
               {
                 parameter1: 10,
                 fill: "white", strokeWidth: 2,
                 portId: "", cursor: "pointer",
                 fromLinkable: true, toLinkable: true,
                 fromLinkableDuplicates: true, toLinkableDuplicates: true,
                 fromSpot: go.Spot.AllSides, toSpot: go.Spot.AllSides
               },
               new go.Binding("fill"),
               new go.Binding("stroke", "color"),
               new go.Binding("strokeWidth", "thickness"),
               new go.Binding("strokeDashArray", "dash")),
             $$(go.Placeholder,
               { background: "transparent", margin: 10 })
           ),
           $$(go.TextBlock,
             {
               alignment: go.Spot.Top, alignmentFocus: go.Spot.Bottom,
               font: "bold 12pt sans-serif", editable: true
             },
             new go.Binding("text"),
             new go.Binding("stroke", "color"))
         );


       myDiagram.groupTemplate.contextMenu =
         $$("ContextMenu",
           LightFillButtons(),
           DarkColorButtons(),
           StrokeOptionsButtons()
         );


       // Link template

       myDiagram.linkTemplate =
         $$(go.Link,
           {
             layerName: "Foreground",
             routing: go.Link.AvoidsNodes, corner: 10,
             toShortLength: 4,  // assume arrowhead at "to" end, need to avoid bad appearance when path is thick
             relinkableFrom: true, relinkableTo: true,
             reshapable: true, resegmentable: true
           },
           new go.Binding("fromSpot", "fromSpot", go.Spot.parse),
           new go.Binding("toSpot", "toSpot", go.Spot.parse),
           new go.Binding("fromShortLength", "dir", function(dir) { return dir === 2 ? 4 : 0; }),
           new go.Binding("toShortLength", "dir", function(dir) { return dir >= 1 ? 4 : 0; }),
           new go.Binding("points").makeTwoWay(),  // TwoWay due to user reshaping with LinkReshapingTool
           $$(go.Shape, { strokeWidth: 2 },
             new go.Binding("stroke", "color"),
             new go.Binding("strokeWidth", "thickness"),
             new go.Binding("strokeDashArray", "dash")),
           $$(go.Shape, { fromArrow: "Backward", strokeWidth: 0, scale: 4/3, visible: false },
             new go.Binding("visible", "dir", function(dir) { return dir === 2; }),
             new go.Binding("fill", "color"),
             new go.Binding("scale", "thickness", function(t) { return (2+t)/3; })),
           $$(go.Shape, { toArrow: "Standard", strokeWidth: 0, scale: 4/3 },
             new go.Binding("visible", "dir", function(dir) { return dir >= 1; }),
             new go.Binding("fill", "color"),
             new go.Binding("scale", "thickness", function(t) { return (2+t)/3; })),
           $$(go.TextBlock,
             { alignmentFocus: new go.Spot(0, 1, -4, 0), editable: true },
             new go.Binding("text").makeTwoWay(),  // TwoWay due to user editing with TextEditingTool
             new go.Binding("stroke", "color"))
         );

       myDiagram.linkTemplate.selectionAdornmentTemplate =
         $$(go.Adornment,  // use a special selection Adornment that does not obscure the link path itself
           $$(go.Shape,
             { // this uses a pathPattern with a gap in it, in order to avoid drawing on top of the link path Shape
               isPanelMain: true,
               stroke: "transparent", strokeWidth: 6,
               pathPattern: makeAdornmentPathPattern(2)  // == thickness or strokeWidth
             },
             new go.Binding("pathPattern", "thickness", makeAdornmentPathPattern))
         );



       myDiagram.linkTemplate.contextMenu =
         $$("ContextMenu",
           DarkColorButtons(),
           StrokeOptionsButtons(),
           $$("ContextMenuButton",
             $$(go.Panel, "Horizontal",
               ArrowButton(0), ArrowButton(1), ArrowButton(2)
             )
           ),
           $$("ContextMenuButton",
             $$(go.Panel, "Horizontal",
               $$(go.Panel, "Spot",
                 AllSidesButton(false),
                 SpotButton(go.Spot.Top, false), SpotButton(go.Spot.Left, false), SpotButton(go.Spot.Right, false), SpotButton(go.Spot.Bottom, false)
               ),
               $$(go.Panel, "Spot",
                 { margin: new go.Margin(0, 0, 0, 2) },
                 AllSidesButton(true),
                 SpotButton(go.Spot.Top, true), SpotButton(go.Spot.Left, true), SpotButton(go.Spot.Right, true), SpotButton(go.Spot.Bottom, true)
               )
             )
           )
         );

       var nodedata = [
           {"key":1, "loc":"0 0", "text":"입고창고"},
           {"key":2, "loc":"200 0", "text":"생산공정"},
           {"key":3, "loc":"400 0", "text":"출고창고"}
            ]
       
       var linkdata = [
           {"from":1, "to":2},
           {"from":2, "to":3}
            ]

       load(nodedata, linkdata);

       var myworkbutton = document.getElementById('myworkbutton');
       addlisten(myworkbutton);


       var select1 = document.getElementById('select1');
       console.log(myDiagram.model);
       
       makeselect(myDiagram.model.Cc, select1);
       addlisten_sel(select1, "lightblue");
       var select2 = document.getElementById('select2');
       makeselect(myDiagram.model.Cc, select2);
       addlisten_sel(select2, "lightyellow");
       this.content_center.style.display = "none"
	 //  this.content_center.parentNode.removeChild(this.content_center); 
	   this.content_center_con = 0
       
    }
    
    itemmake(pro1, pro2){

    	// 질문지를 만드는 함수임 // 중요함수임
    	var item = document.getElementById('item');
    	for(var ia = item.childNodes.length - 1; ia >= 0; ia--){
    		item.removeChild(item.childNodes[ia]);
    	}
    	
    	var inventory = "";
    	this.currentitems = [];
    	
    	for(var ia in this.totalarr){
    		   
            var currentitem = this.totalarr[ia]
            var div = this.makediv(currentitem.question, {id: "detailcontent"})
            item.appendChild(div);
            this.currentitems.push(currentitem);

            if(currentitem.inputs){
            		
                var text = this["make" + currentitem.inputs](currentitem.realname)
                var field = document.createElement("div");
            	field.setAttribute("id", currentitem.realname);
            	field.appendChild(text)
                item.appendChild(field);
 
            	if(currentitem.answer.length > 0){

            		if(pro1){
            			// 재고생산 공정인 경우
            			// 공정의 답변이 {문제1: {..., answer: [{공정1, 공정2, }]}} 이런식으로 들어옴
            			// 여기는 현재의 공정에 해당하는 경우만 정답에 추가하는 것임
            			
            			var num = 0
                		for(var ans in currentitem.answer){
                			  
                			var com1 = currentitem.answer[ans].subprocess2;
                			var com2 = currentitem.answer[ans].subprocess3;
                			if(pro1 == com1 && pro2 == com2){	
                				if(num == 0){
                					var input = text.querySelector("input[type=text]")
                					input.value = currentitem.answer[ans].val
                					
                				}else{
                					var div = this["make" + currentitem.inputs + "_add"](currentitem.answer[ans].val)
                					field.appendChild(div);
                				}
                			 }
                				num++
                		}	
            				
            		}else{
            				// 재고공정 이외의 경우
            				// 이외의 답변은 {문제1: {..., answer: [{답변1, 답변2, }]}} 이런식으로 들어옴
            				// 여기는 모든 답변을 정답으로 추가하는 것임
                			var num = 0
                			for(var ans in currentitem.answer){
                				if(num == 0){
                					var input = text.querySelector("input[type=text]")
                					input.value = currentitem.answer[ans].val
                					
                				}else{
                					var div = this["make" + currentitem.inputs + "_add"](currentitem.answer[ans].val)
                					field.appendChild(div);
                				}
                				num++
                			}
            			}
            		}
            	}
            	
            	inventory = currentitem.mainprocess;
    	}

		var inventorytag = document.getElementById("inventory");

    	if(inventory == "재고자산"){
    		inventorytag.style.display = "block";
    	}else{
    		inventorytag.style.display = "none";
    	}
    	
	// 제출하기 버튼 추가하기
        var button = document.createElement("input");
        button.setAttribute('type', "button");
        button.value = "제출하기"

        item.appendChild(button);
        this.additem_submit(button)
        
    }
    
    
    makediv(value, style){
    	
    	
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

    
	listmake = () => {
		
		// 스프링 시큐리티 관련
		var header = $("meta[name='_csrf_header']").attr('content');
		var token = $("meta[name='_csrf']").attr('content');
		
		// ajax 관련
   		$.ajax({
   			type : "POST",
   			url : "/view/basestructurelistmake",
   			beforeSend: function(xhr){
   			  if(token && header) {
   		       // xhr.setRequestHeader(header, token);
   			  } 
   		    },
   		    success : (res) => {
   		    	
   		    	// 가능한 목록을 여기서 받고, listmanage에다가 끼울 것임 

   		    	console.log(res);
   		    	this.totalarr = res;
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
            		var text = res[i].mainprocess + ", " + res[i].val;
                	var div1 = this.makediv(text, {"class": "detailcontent"});
                	listmanage.appendChild(div1);
                	
                	// 각 div1들에게 클릭 이벤트 등록하기
                	this.additem2(div1, res[i]);
            	}
            }
	}
	
	
	

	additem2 = (item, data) => {

		item.addEventListener('click', (me) => {
			
			if(this.realtag){
				this.realtag.style.background = "gray"
			}
			var div = document.getElementById("inventoryprocess");
			div.style.display = "none"
			
			var div = document.getElementsByName("inventoryitem");
			console.log(div)
			div[1].checked = "false"
			div[0].checked = "true"

			
 			this.content_center.style.display = "none"
            console.log("여기를 통과함");
 			
 			console.log(data)
            var grade = "";
            this.realtag = me.target;
            this.realtag.style.background = "blue"
            this.realdata = data;
            this.poolmake(data);
			
        })
    }

	
	makingnodetag(realhash){
		var div = document.getElementById("inventoryprocess");
		div.style.display = "block"
		
		// 기존의 자식이 있으면 날려버리기
		
		for(var i = div.childNodes.length - 1; i >=0; i--){
			div.removeChild(div.childNodes[i]);
		}
		
		var num = 0
		for(var i in realhash){
			
			for(var j in realhash[i]){
				var val = realhash[i][j].from + ", " + realhash[i][j].to
				var div_tem = this.makediv(val, {class: "detailcontent", style: "height: 100%"});
				div.appendChild(div_tem);
				this.additem_node(div_tem, realhash[i][j])
				
				if(num == 0){
					div_tem.style.background = "blue"
					this.inventoryfinaltag = div_tem;
					this.inventoryfinalprocess = realhash[i][j];
				}
				num++
			}
		}
		
	}
	


	
	
	additem_node(item, data){
    	item.addEventListener('click', (me) => {
    		
    		if(this.inventoryfinaltag){
        		this.inventoryfinaltag.style.background = "gray"
    		}
    		this.inventoryfinaltag = me.target
    		this.inventoryfinaltag.style.background = "blue"
            this.inventoryfinalprocess = data;
    		
    		// 정답이 있으면 갈아끼울 것
    		this.itemmake(data['from'], data['to'])
    		
    		
    		
    	}) 	
	}
	
	
    additem_submit = (item) => {

    	item.addEventListener('click', (me) => {
            
         	/////////////////////////////////////////
         	/////////////////////////////////////
         	// 재고자산 생산공정 입력인 경우
         	// 
         	///////////////////////////////////////
         	/////////////////////////////////////////
         	
         	console.log(this.totalarr)
         	console.log(this.realdata)
         	
         	var condition = "1"
         	if(this.totalarr instanceof(Array) == true){
         		condition = this.totalarr[0].subprocess;
         	}
         	
         	
        	if(condition == "1" && this.totalarr instanceof(Array) == true && this.realdata.mainprocess == "재고자산"){
        		// 이 경우에는 공정을 서버에 넘겨서 넣어줘야하는 상황임. 즉 mydiagram의 데이터를 받아야함

            	var realhash = this.make_diagram_hash()

            	var realbackhash = {}
            	for(var ia in realhash){
            		realbackhash[ia] = JSON.stringify(realhash[ia])
            	}
            	
            	 console.log(realhash)
            	 this.ajaxmethod("baseinventoryconfirm/" + this.realdata.subprocess1, realbackhash, (res) => {
            		 this.totalarr = res;
            		 this.makingnodetag(realhash);
            		 this.itemmake();
            	 })
            	 
            	 return
            	 
        	}
         	

        	// 재고자산 생산공정이 아닌경우
         	// 2단계용 질문으로 구성됨
        	var step = "2";
        	
        	var realdata = {}
        	for(var ia in this.totalarr){
        		console.log(123)
        		var name = this.totalarr[ia].realname
            	var tags = document.getElementById(name);
 
        	    var data = {}
        	    var num = 0;
        	    var list = tags.querySelectorAll("input[type=text]")

        	    for(var i = 0 ; i < list.length; i++){
        	    	data[i] = list[i].value;
            	}
        	    
        	    // 220112 이거 수정해야 함
        	    var data_json = JSON.stringify(data)
        	    
                realdata[name] = data_json
        	
        	} 
                console.log(realdata);
                console.log(this.realdata);

            	console.log(this.totalarr)
             	console.log(this.realdata)
                console.log(this.inventoryfinalprocess)
             	/////////////////////////////////////////
             	/////////////////////////////////////
             	// 재고자산 생산공정 최종 답변인 경우
             	// 
             	///////////////////////////////////////
             	/////////////////////////////////////////
            	 var pro1 = this.realdata.val
             	 var pro2 = this.inventoryfinalprocess.from
            	 var pro3 = this.inventoryfinalprocess.to
            	 console.log(this.totalarr)
                if(this.totalarr instanceof(Array) == true && this.realdata.mainprocess == "재고"){
                	console.log("basefinalanswer")
                	this.ajaxmethod("basefinalanswer/" + pro1 + "/" + pro2 + "/" + pro3, realdata, () => alert("입력이 되었습니다."))
                	return
                	
                }else{
                    // 현상태 서버에 입력하기
                    console.log("baseanswer")
            	    this.ajaxmethod("baseanswer/" + this.realdata.mainprocess + "/" + this.realdata.val, realdata, () => alert("입력이 되었습니다."))
                }

           
            
     
        	
        	
        })
    }
	
	poolmake = (stephash) => {
		
		// step0, 1, 2 단계별로 선택된 값이 들어옴
		// 이것을 받아서, 현재 step의 하위 step에 대한 정보를 조회해서 넘겨줌
		// 하위 step이 하나도 없다면 새로 하위 step 작성이 필요한 것임
		
		// 스프링 시큐리티 관련
		var header = $("meta[name='_csrf_header']").attr('content');
		var token = $("meta[name='_csrf']").attr('content');
		
		// ajax 관련
   		$.ajax({

   			type : "POST",
   			data : stephash,
   			url : "/view/basepoolmake",
   			beforeSend: function(xhr){

   			  if(token && header) {
   				  //console.log(header);
   				  //console.log(token);
   	    	      // xhr.setRequestHeader(header, token);
   			  } 
   		    },
   		    success : (res) => {
   		    	
   		    	console.log(res);
                this.totalarr = res;
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
		
		console.log(data);
		
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
   		    	if(act){
   	   				act(res)
   		    	}
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	}
 
	// make + select 등 함수들
    makeselect(val, data){
        
        // option1 ~ option5 이것을 for문 5까지로 수정할 것
  	   var field = document.createElement("select");
  	   field.setAttribute("name", val);
  	   
  	   if(data){
  	  	   for(var j = 1; j <= 5; j++){
  	  		   
  	  		   if(data[j] != ""){
  	  	       	   var option = document.createElement("option");
  	            	option.innerText = data[j];
  	                field.appendChild(option);
  	  		   }else{
  	  			   break
  	  		   }

  	  	   }
  	   }
  	  
 		return field;    	
     }

	
    makeselectplus(val, data){
        
        var div1 = document.createElement("div");
        
        // 먼저는 select를 만들기
    	var field = this.makeselect(data, val);
    	      
    	   // 뒤에 추가버튼 만들기
        var button = document.createElement("input");
        button.setAttribute('type', "button");
        button.value = "추가"
        
        div1.appendChild(field);
        div1.appendChild(button);
        
        // 버튼에 다른 select 추가기능 부여
        
        // 이건 추가로 구현해야함
        //this.additem_plus(button, data, val, div1, button);
        
        return div1;
   	   
     }
	
    maketextplus(val){
        
        var div1 = document.createElement("div");
        
        // 먼저는 text를 만들기
 		var field = document.createElement("input");
		field.setAttribute("type", "text");
    	      
    	   // 뒤에 추가버튼 만들기
        var button = document.createElement("input");
        button.setAttribute('type', "button");
        button.value = "추가"
        
        div1.appendChild(field);
        div1.appendChild(button);
        
        // 버튼에 다른 select 추가기능 부여
        this.additem_textplus(button, val, div1);
        return div1;
        
     }	

    maketextplus_add(val){
    	// 먼저 select의 개수가 최대개수를 초과했는지 확인하고 최대개수를 초과하지 않았으면 추가할 것
 
  	    	// 단어 추가
  	    	var divs = document.createElement("div");
  	    	divs.innerText = ", ";
  	    	
            // 먼저는 text를 만들기
		    var field = document.createElement("input");
	        field.setAttribute("type", "text");
  	    	divs.appendChild(field);
  	    	field.value = val
        	
         	// 삭제 버튼 추가
            var button_remove = document.createElement("input");
            button_remove.setAttribute('type', "button");
            button_remove.value = "X"
            divs.appendChild(button_remove);
            
            
            // 삭제 버튼에 삭제 기능 추가하기
            this.additem_remove(button_remove, divs);
            
            return divs
    }
    
    additem_textplus(item, val, div1){

    	item.addEventListener('click',(me)=>{
        	
        	// 먼저 select의 개수가 최대개수를 초과했는지 확인하고 최대개수를 초과하지 않았으면 추가할 것
        	console.log(val)
            var tags = document.getElementById(val);
        	console.log(tags)
            
      	    if(tags.childNodes.length < 5){

      	    	// 단어 추가
      	    	var divs = document.createElement("div");
      	    	divs.innerText = ", ";
      	    	
                // 먼저는 text를 만들기
 		        var field = document.createElement("input");
		        field.setAttribute("type", "text");
      	    	divs.appendChild(field);
            	
             	// 삭제 버튼 추가
                var button_remove = document.createElement("input");
                button_remove.setAttribute('type', "button");
                button_remove.value = "X"
                divs.appendChild(button_remove);
                tags.appendChild(divs);
                
                // 삭제 버튼에 삭제 기능 추가하기
                this.additem_remove(button_remove, divs);
       	    }else{
      	    	alert("최대 개수가 초과되었습니다.")
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
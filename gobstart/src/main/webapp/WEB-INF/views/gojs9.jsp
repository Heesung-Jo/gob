<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
 <html>
    <head>
       <meta name="_csrf_header" content="${_csrf.headerName}">
       <meta name="_csrf" content="${_csrf.token}">
    <body>

        <div id = "mywork" style = "overflow: hidden">
            <c:forEach var = "q" items = "${processlist}" >
             <div style = "float: left;">
              <input type = "radio"  name = "myworkradio" value = "${q}"> </input>
              ${q}
             </div>
           </c:forEach>
        </div>

     <div>
        <span id = "listmanage" class = "listmanage"></span>
     </div>

      <div style="width: 1300px; display: flex; justify-content: space-between">
         <div id="myDiagramDiv" style="border: solid 1px blue; width:450px; height:600px"></div>
         <div style = "overflow: hidden">
           <div id= "myexplain" style="width: 800px; height: 300px; margin-right: 2px; border: solid 1px blue; overflow: hidden;"></div>
           <div id= "mycontrol" style="width: 800px; height: 300px; margin-right: 2px; border: solid 1px blue; overflow: hidden;"></div>
         </div>
      </div>
 
      <div style="width: 1300px; display: flex; justify-content: space-between">
      </div>
 
 
 
    </body>
 
<style>
 
  table {
    width: 100%;
    border: 1px solid #444444;
    border-collapse: collapse;
  }
  th, td {
    border: 1px solid #444444;
  }
 
 
  .maintext{
      display: inline;
 } 
 
  .maintext div{
      display: inline;
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
 
 
    <script src="/js/go-debug.js"></script>
    <script src="/js/Figures.js"></script>
    <script src = "http://code.jquery.com/jquery-3.4.1.js"></script>

  <script>

  

  
  var $$ = go.GraphObject.make;
  var request;
  
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
  
  
  
class diagram{
    constructor(totalarr){
    	
       this.totalarr = totalarr;
       this.realdist = "";
       this.realdistarr = [];
       
       this.divisionsize_y = 100;
       this.divisionsize_x = 100;
       this.divisions = {};
       this.divisionpos = {};
       this.datapool = [];

       this.width = 200;
       this.height = 100;
       this.textwid = 100;
       
       // 아래쪽 테그 관련한 것들
       // 210505 이 부분을 클릭하면 이제 아작스로 받아오는 것으로 바꿀것
       // 대신에 기존에 아작스로 받아오는 부분은 수정해야함 
       this.myworkradio = document.getElementsByName('myworkradio');
       
       this.myworkbutton = document.getElementById('myworkbutton');
       
       this.diagramselect_pa = document.getElementById('DiagramSelect_pa');
       this.diagramselect_ch = document.getElementById('DiagramSelect_ch');
       this.diagramteamselect = document.getElementById('DiagramTeamSelect');
       this.diagramcheckbox = document.getElementById('Diagramcheckbox');
       this.diagramexplain = document.getElementById('myexplain');
       this.diagramexplaincontrol = document.getElementById('mycontrol');
       
       // 이 아래쪽은 위의 diagramexplain과 관련된 우측의 table과 button에 관한 것들
       this.tablesize = {width : 3, height : 5};
       this.tablearr = {};
       this.selectlabel = {};
       

	   this.table = document.createElement("table"); // div 가 나은것 같으면
       
	   this.table.setAttribute("border", "10");
	   this.maketable();
	   this.diagramexplain.appendChild(this.table); 
	   
       this.tablearr[0][0].innerText = "세부프로세스";
       this.tablearr[0][1].innerText = "설명";
	   this.makelabel(this.tablearr);
	   
	   
	   // 이 아래쪽은 위의 diagramexplain 항목을 선택했을때 나타나는 아래쪽 테이블 관련
       this.table2size = {width : 3, height : 5};
       this.table2arr = {};
	   this.table2 = document.createElement("table"); // div 가 나은것 같으면
       this.diagramexplaincontrol.appendChild(this.table2); 
	   this.table2.setAttribute("border", "10");
	   this.maketable2();
       this.table2arr[0][0].innerText = "통제활동";
       this.table2arr[0][1].innerText = "설명";
	   this.makelabel(this.table2arr);

       this.diagram = new go.Diagram("myDiagramDiv");
       this.Palette = {};

       // 지우거나 추가할때 아래 3개가 함께 고려해서 지우거나 해야한다는 것 기억할 것
       this.nodedata = []
       this.graphdata = []; //210419 추가됨
       this.passeddata = new Set([]);

       
       // 질문서가 될 tag임
       this.maintextdiv = {};
       this.maintextarr = {};
       
       //template 세팅
       this.diagram.nodeTemplate =
          $$(go.Node, "Auto", 
            {
              locationSpot: go.Spot.Center,
              fromSpot: go.Spot.AllSides,
              toSpot: go.Spot.AllSides
            }, $$(go.Shape, { fill: "lightyellow" }),
            {
              click: (e, node) => {
                 var cmd = this.diagram.commandHandler;
                 var data = {}
                 data[node.data.realkey] = node.data.realkey;
           		 this.maintextarr[node.data.realkey] = {}; // 서버에 나중에 넘겨주기 위하여 tag와 연동시켜 둠
                 this.inputtable(data, this.totalarr, node.data, this.tablearr, "processname", "processexplain", this.tablesize.height); // 프로세스 관련 인풋
                 this.inputtable(data, this.totalarr, node.data, this.table2arr, "controlname", "controlexplain", this.table2size.height); // 컨트롤 관련 인풋
              
              },
              
              contextClick: (e, node) => {
                  var cmd = this.diagram.commandHandler;
                  console.log(node.data.realkey);
                  
                  this.diagramselect_ch.value = node.data.realkey;
                  // 여기와 연동되어 서버에서 값 받아오기
            	  var processname = "재무보고";
		          var subprocess = "전표관리";  // 현재는 임의로 세팅해줌
                  var detailprocessname = name;
		
		          var data = {processname: processname, subprocess: subprocess, detailprocessname: node.data.key};
                  this.ajaxmethod(data, this.inputtable);
               }
            },
          new go.Binding("location", "loc", go.Point.parse),
          
            $$(go.Panel, "Table",
            	      { stretch: go.GraphObject.Fill, margin: 0.5 },

            	      $$(go.RowColumnDefinition,
            	        { column: 0, sizing: go.RowColumnDefinition.None, background: "white", separatorStroke: "black" }, new go.Binding("width", "wid_col1")),
              	      $$(go.RowColumnDefinition,
                  	    { column: 1, minimum: 50, background: "white", separatorStroke: "black" }, new go.Binding("width", "wid_col2")),

            	      $$(go.RowColumnDefinition,
            	        { row: 0, sizing: go.RowColumnDefinition.None }),
            	      $$(go.RowColumnDefinition,
            	        { row: 1, separatorStroke: "black" }),

            	      $$(go.TextBlock,
            	        { row: 0, column: 0, stretch: go.GraphObject.Horizontal, margin: 2, textAlign: "center" },
            	        new go.Binding("text", "team")),
            	      $$(go.TextBlock,
            	        { row: 1, column: 0, stretch: go.GraphObject.Fill, margin: 2, textAlign: "center" },
            	        new go.Binding("text", "key")),
              	      $$(go.TextBlock,
                  	        { row: 0, column: 1, stretch: go.GraphObject.Horizontal, margin: 2, textAlign: "center" },
                  	        new go.Binding("text", "risk")),
               	      $$(go.TextBlock,
                  	        { row: 1, column: 1, stretch: go.GraphObject.Fill, margin: 2, textAlign: "center" },
                  	        new go.Binding("text", "control"))

            )
        );

      this.diagram.linkTemplate =
          $$(go.Link, { routing: go.Link.AvoidsNodes}, 
          $$(go.Shape),
          $$(go.Shape, { toArrow: "Standard" })
      );


     
     
 
/*   nodeTemplateMap 기능에 대해서도 알아 둘 필요가 있음 gojs 사이트 참고하면됨
     
     안진/엑셀쪽에 flowchart1.html 받아둔 것 있으니,
     그거 활용하면 앞 뒤로 화살표나 이런것도 모두 추가가 됨
      
      this.diagram.nodeTemplateMap.add("",  // the default category
        $(go.Node, "Table", this.nodeStyle(),
          // the main object is a Panel that surrounds a TextBlock with a rectangular Shape
          $(go.Panel, "Auto",
            $(go.Shape, "Rectangle",
              { fill: "#282c34", stroke: "#00A9C9", strokeWidth: 3.5 },
              new go.Binding("figure", "figure")),
            $(go.TextBlock, this.textStyle(),
              {
                margin: 8,
                maxSize: new go.Size(160, NaN),
                wrap: go.TextBlock.WrapFit,
                editable: true
              },
              new go.Binding("text").makeTwoWay())
          ),
          // four named ports, one on each side:
          this.makePort("T", go.Spot.Top, go.Spot.TopSide, false, true),
          this.makePort("L", go.Spot.Left, go.Spot.LeftSide, true, true),
          this.makePort("R", go.Spot.Right, go.Spot.RightSide, true, true),
          this.makePort("B", go.Spot.Bottom, go.Spot.BottomSide, true, false)
        ));
*/


    }
  

  nodedatapos = (arr) => {
    // 리스트들 순환하면서 팀 위치를 만들 것
   

    // team hash 만들기
    for(var i in arr){
      
      if(this.divisions[arr[i]["team"]]){
        this.divisions[arr[i]["team"]] = 0;
      }else{
        this.divisions[arr[i]["team"]] = 0;
      }

    }

   // team hash에 위치 세팅하기
   var pos = 0;
   for(var i in this.divisions){
      this.divisionpos[i] = pos;
      pos += this.divisionsize_y;
   }


  }

  possetting = (arr) => {
     
     // 팀별로 갯수세기
     var team = {};
     var team_other = {}; // 팀별로 위치를 세팅하기 위해서 만든 것 // 이건 그냥 리턴 값임
     var num = 0;
     var team_current = "";
     var team_start = ""


     for(var i in arr){
         
         if(arr[i].team in team){
            team[arr[i].team].count += 1;

         }else{
            team[arr[i].team] = {count: 1, 가로: 0, 세로: num, before: team_current};

            if(team_current != ""){
              team[team_current]["next"] = arr[i].team;
            }else{
              team_other["team_start"] = arr[i].team;
            }
            num += 1;
         }

         team_current =  arr[i].team;
     }

     // 팀 갯수 분할하기
     var 최초 = Math.ceil(Math.sqrt(Object.keys(arr).length));

     var 가로 = 최초;
     var 세로 = 0;
     for(var i in team){
        
        세로 += Math.ceil(team[i].count/가로);

     }
     
     var 최소 = Math.max(가로, 세로);
     var 결정가로 = 가로;
     var 결정세로 = 세로;
     //세로가 최초보다 클때까지는 가로를 늘려가면서 최적 팀별 위치 쪼개기 

     while(세로 > 최초){
        가로 += 1;
        세로 = 0;
        for(var i in team){

           세로 += Math.ceil(team[i].count/가로);
        }
        
        if(최소 > Math.max(가로, 세로)){
            결정가로 = 가로;
            결정세로 = 세로;
        }

     }
     
     var next = team[team_other["team_start"]];
     team_other["결정가로"] = 결정가로;
     team_other["결정세로"] = 결정세로;

     var num = 0;

     while(next){
         
         next.세로 = num;
         num += Math.ceil(next.count/결정가로);
         

         if(next.next){
            next = team[next.next];
         }else{
            next = "";
         }

     }
     // 210406 아래 함수 nodedatasetting2에서 활용할 것
     // 먼저 이 console부터 보고 시작할 것
     

     
     return {team: team, team_other: team_other}
  


  }
   
  
  possetting2 = (first) => {
    
    var count = 1;
    var co = 0;
    
    console.log(first)
    
    var arr = []
    for(var i in first){
        arr.push(first[i].processname1);
    }
    
    var teamdata = {};
    var passeddata = new Set([]);

    while(count > 0 && co < 10){
     co += 1;
     
     var next = [];
     var temp= {};
     
     for(var i in arr){
         if(this.totalarr[arr[i]].superpro.length > 0){
        	 // 211128 여기 일단은 superpor[0]으로 처리했으나,
        	 // 이거 manytomany로 수정하면서 바꾼 것이라서 전체적으로 수정필요
             passeddata.add(this.totalarr[arr[i]].superpro[0]);
             next.push(this.totalarr[arr[i]].superpro[0]); 
         }
    	 
       /* 예전과 반대로 프로세스데이터 자식관계가 설정되어서 이건 과거코드이고 위에있는 코드로 좀 수정하였음. 다만 다시 사용될 가능성이 있으므로 살려둠	 
       for(var j in this.totalarr[arr[i]].childnodedata){
    	 
          if(passeddata.has(this.totalarr[arr[i]].childnodedata[j]) == false){
             passeddata.add(this.totalarr[arr[i]].childnodedata[j]);
             next.push(this.totalarr[arr[i]].childnodedata[j]) 
          }
          
       }
       */

       // for문 안쪽 연산
       // temp를 통해서 팀별 갯수세기
       var turn = this.totalarr[arr[i]];
       if(turn.teamname in temp){
          temp[turn.teamname] += 1;
       }else{
    	   
          temp[turn.teamname] = 1;
       }

      }
     
      // for문 바깥쪽 시작임  

      // 다음 순환을 위한 세팅하기
       count = next.length;
       arr = next.slice();

       // for문 바깥쪽 연산  
       // 기존의 teamdata와 비교해서 더 높은 카운트 나온팀은 대체하기
      
       
       for(var i in temp){
           if(i in teamdata){
             
             if(teamdata[i] < temp[i]){
                teamdata[i] = temp[i];
             }

           }else{
             teamdata[i] = temp[i];
           }
       }
     }

    
     var count = 1;
     var realteamdata = {}
     for(var i in teamdata){
        var temp = [];
        for(var j = 1; j <= teamdata[i]; j++){
           temp.push(count)
           count += 1;
        }
        realteamdata[i] = temp;
     }

     this.realteamdata = realteamdata;
     
   }






   distcal = (realarr, teamarr) => {
      
      var dist = 0;
      for(var i in teamarr){
        // 나중에 이 부분이 여러개인 것 중에 이 전 계층인 것으로 고르는 것으로 변형 필요
        // 이 전 계층이 여러개이면 그 중에 하나만 선택하는 것도 필요
         var before = this.totalarr[teamarr[i]].before[0]; 
         var widthpos = this.totalarr[before].widthpos;
         dist += (widthpos - realarr[i]) * (widthpos - realarr[i]);
      }
      return dist;


   }
  
  
  
  
  
  nodedatasetting = (pos) => {
   // 그럼 위의 것이 나온다고 생각하면 됨
   
   /*
    this.diagram.add(
    $(go.Part, "Vertical",
      $(go.Node, "Auto", {location: "0 0"}),
      $(go.TextBlock, {text: "통제활동", font: '15px serif', margin: 2 }),
    )) 
   */

   var realarr = []
   


   //팀 세팅
   /* 팀 그림은 딱 고정되도록 canvas로 그리는게 좋을 듯
   var team =  {key : "회계팀", hei: 100, loc: "-150 0", fig: "Rectangle", color: "white"}
   realarr.push(team);
   var team =  {key : "자금팀", hei: 100, loc: "-150 100", fig: "Rectangle", color: "white"}
   realarr.push(team);
   */
   
   var arr = {} // 서버에서 받을 배열, 현재는 있다고 가정
   var shape = [{shape : "Rectangle", wid : 50, hei : 50}, {shape : "Decision", wid : 70, hei : 50}, 
                {shape : "Cylinder1", wid : 50, hei : 50}, {shape : "SquareArrow", wid : 50, hei : 50, angle: 90}]

   for(var i = 0; i < 4; i++){
      // sublistloop를 가져다 쓰는 것이 바탕이 되야함
      // 기본 그림
      // 지금은 임의로 내가 위치를 세팅 시켰는데, 서버에서 프로세스 배열이 넘어오면
      // 이런식으로 세팅할 것(아래 3문장 참고)
      //var y = this.divisionpos[arr["team"]]
      //var x = this.divisions[arr["team"]] * this.divisionsize_x;
      //this.divisions[arr["team"]] += 1;      

      var x = pos;
      var y = 70 * i;
      var obj = {key : "취득" + i,  fig: shape[i].shape, wid: shape[i].wid,
                 hei: shape[i].hei, angle: shape[i].angle, color: "white", loc: x + " " + y}
      

      // 부모 넣어주기
      if(i > 0){
        var before = i - 1;
        obj.parent = "취득" + before; 
      }
      this.nodedata.push(obj);
      
      // 통제활동이 있으면 추가할 것
      if(1 == 1){  // 나중에 조건 집어넣을 것
         this.pic_control(x, y)
      }

      // erp가 있으면 추가할 것
      if(1 == 1){  // 나중에 조건 집어넣을 것
         this.pic_erp(x, y)
      }



     }
     
   }


  nodedatasetting2 = (first) => {
   // 그럼 위의 것이 나온다고 생각하면 됨
   
   var temp = this.possetting(this.totalarr);
   var team = temp.team;
   var team_other = temp.team_other;

   // return 된 team의 구조
   // {team_start: "영업팀"
   // 영업팀: {count: 3, 가로: 0, 세로: 0, before: "", next: "회계팀"}
   // 회계팀: {count: 1, 가로: 0, 세로: 2, before: "영업팀"}   }

   var realarr = []
   
   var arr = []
   for(var i in first){
       arr.push(first[i].processname1);
   }   

   var shape = [{shape : "Rectangle", wid : 50, hei : 50}, {shape : "Decision", wid : 70, hei : 50}, 
                {shape : "Cylinder1", wid : 50, hei : 50}, {shape : "SquareArrow", wid : 50, hei : 50, angle: 90}]

   var count = 1;
   var co = 0;
   while(count > 0 && co < 10){
    co += 1;
    
    var next = [];

    for(var i in arr){
      // sublistloop를 가져다 쓰는 것이 바탕이 되야함
      // 기본 그림
      // 지금은 임의로 내가 위치를 세팅 시켰는데, 서버에서 프로세스 배열이 넘어오면
      // 이런식으로 세팅할 것(아래 3문장 참고)
      //var y = this.divisionpos[arr["team"]]
      //var x = this.divisions[arr["team"]] * this.divisionsize_x;
      //this.divisions[arr["team"]] += 1;      
      
      next = next.concat(this.totalarr[arr[i]].next);
      
      var turn = this.totalarr[arr[i]];
        
      
      // 위치결정
      var x = team[turn.team]["가로"] * this.width + 50;
      var y = team[turn.team]["세로"] * this.height + 50;

      // 다음 위치 배정하기      
      team[turn.team]["가로"] += 1;
      if(team[turn.team]["가로"] >= team_other["결정가로"]){
        team[turn.team]["가로"] = 0;
        team[turn.team]["세로"] += 1;
      }


      var obj = {team: turn.team, key : turn.detailprocessname,  fig: turn.shape, wid: turn.detailprocessname.length * 15, 
                 hei: 50, angle: shape[i].angle, color: "white", loc: x + " " + y,
                 parent: turn.before, realkey: turn.detailprocessname, }
      

      this.nodedata.push(obj);

 


      }

      count = next.length;
      arr = next.slice();
      
    } 
     
   }

  
  nodedatasetting_func(first){
	  
      var shape = [{shape : "Rectangle", wid : 100, hei : 50}, {shape : "Decision", wid : 100, hei : 50}, 
           {shape : "Cylinder1", wid : 100, hei : 50}, {shape : "SquareArrow", wid : 100, hei : 50, angle: 90}]

	  var arr = []
	   for(var i in first){
		      
		   this.whilefunc2(null, first[i].processname1, 0, 0, shape);
	   }

	  console.log(this.graphdata)
  }

  
  whilefunc(parentname, childname, current_x, current_y, shape){
	  
	  var turn = this.totalarr[childname];

	  // 위치결정
      var x = current_x * this.width + 50;
      var y = current_y * this.height + 50;

      var leng1 = turn.processname1.length 
      var leng2 = Math.max(turn.risk.length, turn.controlname1.length)
      
          var obj = {risk: turn.risk, control: turn.controlname1, team: turn.teamname, key : turn.processname1, 
    	          wid: (leng1 + leng2) * 15, wid_col1: leng1 * 15, wid_col2: leng2 * 15, hei: 50, angle: 0, color: "white", loc: x + " " + y,
                 parent: turn.before, realkey: turn.detailprocessname, stretch: go.GraphObject.Vertical}

          this.nodedata.push(obj);
          
      
      if(parentname){
          var obj2 = {from: parentname, to: turn.processname1}   
          this.graphdata.push(obj2); 	  
      }
      if(turn.superpro){
    	 
    	 // 다음턴으로 넘기기
    	 current_y++;
    	 for(var k in turn.superpro){
             this.whilefunc(turn.processname1, turn.superpro[k], current_x, current_y);  
             current_x++;
    	 }

    	 current_x--;
      }

  }  
  
  whilefunc2(parentname, childname, current_x, current_y, shape){
	  
	  var turn = this.totalarr[childname];

	  // 팀의 경우에는 정규식인 경우가 있으므로 
 	  var re = /(?<=(\^|\@)\{)[가-힣]+(?=\}(\^|\@))/g;
      var optionarr = turn.teamname.match(re)
      
      if(optionarr){
    	 var teamname = turn.processoption[optionarr[0]].resultval; 
      }else{
    	  teamname = turn.teamname;
      }

      console.log(parentname)
      
      teamname = teamname.replace("^{", "");
      teamname = teamname.replace("@{", "");
      teamname = teamname.replace("}^", "");
      teamname = teamname.replace("}@", "");

      
      // 컨트롤과 프로세스를 나누어서 표현해야함

	  // 먼저 프로세스 부분
      
      if(turn.processname1){
          var text = turn.processname1;
          text = text.replace("^{", "");
    	  text = text.replace("@{", "");
    	  text = text.replace("}^", "");
    	  text = text.replace("}@", "");
    	  // 위치결정
          var x = current_x * this.width + 50;
          var y = current_y * this.height + 50;
          current_y++;
          
          var leng1 = text.length 
          var leng2 = 3 // 리스크란 단어 길이로 바꿈 Math.max(turn.risk.length, turn.controlname1.length)

		
          
          
    	  var obj = {team: teamname, key : text, 
    	          wid: (leng1 + leng2) * 15, wid_col1: leng1 * 15, wid_col2: leng2 * 15, hei: 50, angle: 0, color: "white", loc: x + " " + y,
                 parent: turn.before, realkey: turn.processname1, stretch: go.GraphObject.Vertical}

          this.nodedata.push(obj);

          if(parentname){
              var obj2 = {from: parentname, to: text}   
              this.graphdata.push(obj2); 	  
          }
          
          parentname = text;
      }

      // 컨트롤 부분
      if(turn.controlname1){
    	  
          var text2 = turn.controlname1;
          text2 = text2.replace("^{", "");
    	  text2 = text2.replace("@{", "");
    	  text2 = text2.replace("}^", "");
    	  text2 = text2.replace("}@", "");
    	  // 위치결정
          var x = current_x * this.width + 50;
          var y = current_y * this.height + 50;

          var leng1 = text.length 
          var leng2 = 3 // 리스크란 단어 길이로 바꿈 

    	  var obj = {risk: "리스크", control: "통제", team: teamname, key : text2, 
    	          wid: (leng1 + leng2) * 15, wid_col1: leng1 * 15, wid_col2: leng2 * 15, hei: 50, angle: 0, color: "white", loc: x + " " + y,
                 parent: turn.before, realkey: turn.processname1, stretch: go.GraphObject.Vertical}

          this.nodedata.push(obj);

          if(parentname){
              var obj2 = {from: parentname, to: text2}   
              this.graphdata.push(obj2); 	  
          }

      }

      
      if(turn.superpro){
    	 
    	 // 다음턴으로 넘기기
    	 current_y++;
    	 for(var k in turn.superpro){
    		 
    		 var processname_next = "";
    		 if(turn.controlname1){
    			 processname_next = text2;
    		 }else{
    			 processname_next = text;
    		 }
    		 
             this.whilefunc2(processname_next, turn.superpro[k], current_x, current_y);  
             current_x++;
    	 }

    	 current_x--;
      }

  }
  
  
  
  
  
  
  
  nodedatasetting_graph = (first) => {
   // 그럼 위의 것이 나온다고 생각하면 됨
   
   var realarr = []
   var arr = []
   for(var i in first){
	   arr.push(first[i].processname1);
   }

   var shape = [{shape : "Rectangle", wid : 50, hei : 50}, {shape : "Decision", wid : 70, hei : 50}, 
                {shape : "Cylinder1", wid : 50, hei : 50}, {shape : "SquareArrow", wid : 50, hei : 50, angle: 90}]

   var count = 1;
   var current = 1;
   var co = 0;
   while(count > 0 && co < 10){
    co += 1;
    
    var next = [];

    for(var i in arr){
      // sublistloop를 가져다 쓰는 것이 바탕이 되야함
      // 기본 그림
      // 지금은 임의로 내가 위치를 세팅 시켰는데, 서버에서 프로세스 배열이 넘어오면
      // 이런식으로 세팅할 것(아래 3문장 참고)
      //var y = this.divisionpos[arr["team"]]
      //var x = this.divisions[arr["team"]] * this.divisionsize_x;
      //this.divisions[arr["team"]] += 1;      
       if(this.totalarr[arr[i]].superpro.length > 0){
      	 // 211128 여기 일단은 superpor[0]으로 처리했으나,
      	 // 이거 manytomany로 수정하면서 바꾼 것이라서 전체적으로 수정필요
    	   
    	   next.push(this.totalarr[arr[i]].superpro[0]) 
       }
       
 
      var turn = this.totalarr[arr[i]];
        
      
      // 위치결정
      var x = 1 * this.width + 50;
      var y = current * this.height + 50;

      // 다음 위치 배정하기      
      current += 1;

      var obj = {team: turn.team, key : turn.processname1, fig: "Rectangle", wid: turn.processname1.length * 15, 
                 hei: 50, angle: shape[i].angle, color: "white", loc: x + " " + y,
                 parent: turn.before, realkey: turn.detailprocessname, stretch: go.GraphObject.Vertical}
      
      var obj2 = [];
      
      if(turn.superpro){
    	  // 211128 이것도 turn.superpro[0]를 전체를 커버하도록 바꿔야함
         var temp = {from: turn.processname1, to: turn.superpro[0]}   
         obj2.push(temp);     
      }

     

      this.nodedata.push(obj);
      this.graphdata = this.graphdata.concat(obj2); 
      
      
      // 부모 넣어주기
      if(i > 0){
        var before = i - 1;
        //obj.parent = "취득" + before; 
      }
  


      }

      count = next.length;
      arr = next.slice();
      
    } 


     
   }

 
  
  
  nodedatasetting_graph2 = (first) => {
	   // 그럼 위의 것이 나온다고 생각하면 됨
	   
	   var passeddata = new Set([]);
	   var realarr = []
	   var arr = [first.processname1];
	   this.datapool = {}
	   
	   // 그룹 집어넣기


	   var shape = [{shape : "Rectangle", wid : 50, hei : 50}, {shape : "Decision", wid : 70, hei : 50}, 
	                {shape : "Cylinder1", wid : 50, hei : 50}, {shape : "SquareArrow", wid : 50, hei : 50, angle: 90}]

	   var count = 1;
	   var co = 0;
	   while(count > 0 && co < 20){
	    
	    
	    var next = [];

	    for(var i in arr){
	     
	      for(var j in this.totalarr[arr[i]].childnodedata){
	         if(passeddata.has(this.totalarr[arr[i]].childnodedata[j]) == false){
	            passeddata.add(this.totalarr[arr[i]].childnodedata[j]);
	            next.push(this.totalarr[arr[i]].childnodedata[j]) 
	         }
	      }

	     var turn = this.totalarr[arr[i]];
	     this.datapool[turn.processname1] = turn.processname1;
	      
         // 위치결정
 
          var size = 0
	      for(var i1 = 1; i1 < 5; i1++){
	    	  if(turn["processname" + i1]){
	    		  
	    		  alert(turn["processname" + i1])
	    		  size += 1;
	    		  co += 1;
	    	      turn.heightpos = co;  
	    	      var x = turn.widthpos * this.width + 50;
	    	      var y = turn.heightpos * this.height + 50;

	    		  var obj = {team: turn.team, group: arr[i], key : turn["processname" + i1],  fig: "Rectangle", wid: this.textwid,  //turn.name.length * 15
	 	                 hei: 50, angle: shape[i].angle, color: "white", loc: x + " " + y,
	 	                 parent: turn.parentnodedata, realkey: turn.processname1, stretch: go.GraphObject.Vertical}
	    	      this.nodedata.push(obj);
	    		  
	    	  }
	      }

         if(size > 1){
             // 만약에 processname이 여러개가 있다면      
     	     this.nodedata.push({"key" : arr[i], "isGroup" : true, "text" : arr[i], "horiz" : true })
         }
	      
	      var obj2 = [];
	      for(var j in turn.next){
	         var temp = {from: i,to: turn.childnodedata[j]}   
	         obj2.push(temp);     
	      }

	      this.graphdata = this.graphdata.concat(obj2); 

	      }

	      count = next.length;
	      arr = next.slice();
	    } 


	     
	   }
  
  
  
  
  
  
  
  pic_erp = (x, y) => {
     // erp 그림 추가할 것

  }
  
  pic_control = (x, y) => {
      // 통제활동 그리기

      var x = x + 70 ;
      
      var obj = {wid: 15, hei: 15, font : '0px serif',  fig: "Triangle", color: "lightgreen", loc: x + " " + y}
      this.nodedata.push(obj);

      var x = x + 20;
      var obj = {wid: 15, hei: 15, font : '0px serif', fig: "Triangle", color: "darkred", loc: x + " " + y}
      this.nodedata.push(obj);

      var y = y + 16;
      var x = x - 15
      var obj = {wid: 30, hei: 10,stroke: null, key: "통제활동", font : '5px serif', color: "white", loc: x + " " + y}
      this.nodedata.push(obj);

  }
  
  
  picture = (opt) => {
    
    if(opt == "tree"){
       this.diagram.model = new go.TreeModel(this.nodedata);
    }else if(opt == "graph"){
       this.diagram.model = new go.GraphLinksModel(this.nodedata, this.graphdata);
    }

  }

  picture2 = () => {

  
  }



// ajax 관련

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
   				
   		    	// 211015 어떻게 처리할 것인지 고민할 것
   		    	// 211015
   		    	// res는 있는데, 그림이 안 그려졌음
   		    	console.log(res);
   		    	console.log(res.processjson);
   		    	if(act){
   	   				act(res.processjson)
   		    	}
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	}

	listmake = (name) => {
		
		
		// 스프링 시큐리티 관련
		var header = $("meta[name='_csrf_header']").attr('content');
		var token = $("meta[name='_csrf']").attr('content');
		
		console.log(name);
		
		// ajax 관련
   		$.ajax({
   			type : "POST",
   			url : "/view/listmake_flowchart",
   			beforeSend: function(xhr){
   			  if(token && header) {
   				  //console.log(header);
   				  //console.log(token);
   		       // xhr.setRequestHeader(header, token);
   			  } 
   		    },
   		    success : (res) => {
   		    	
   		    	// 가능한 목록을 여기서 받고, listmanage에다가 끼울 것임 
   		    	console.log(res);
   		    	
   		    	var listmanage = document.getElementById('listmanage');
   		    	
                for(var i in res){
                	var text = res[i];
                	text = text.replace("^{", "");
                	text = text.replace("@{", "");
                	text = text.replace("}^", "");
                	text = text.replace("}@", "");
                	var div1 = this.makediv(text, {"class": "detailcontent"});
                	listmanage.appendChild(div1);
                	
                	// 각 div1들에게 클릭 이벤트 등록하기
                	this.additem2(div1, res[i]);
                }
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	}	
	
	
	poolmake = (name) => {
		
		
		// 스프링 시큐리티 관련
		var header = $("meta[name='_csrf_header']").attr('content');
		var token = $("meta[name='_csrf']").attr('content');
		
		console.log(name);
		
		// ajax 관련
   		$.ajax({
   			type : "POST",
   			data : name,
   			url : "/view/poolmake/" + name,
   			beforeSend: function(xhr){
   			  if(token && header) {
   				  //console.log(header);
   				  //console.log(token);
   		       // xhr.setRequestHeader(header, token);
   			  } 
   		    },
   		    success : (res) => {
   		    	
   		    	console.log(res);

                this.start(res.processjson);
                this.datapool = res;
   				
 
   			},
            error: function (jqXHR, textStatus, errorThrown)
            {
                   console.log(errorThrown + " " + textStatus);
            }
   		})		
	}	
	
// tag 관련

     //^^ viex에 관한 함수
    maketable = () => {
    	
        // processlist 반영하기 
        for(var i = 0; i < this.tablesize.height;i++){
    	    this.tablearr[i] = {}
    	    var subdiv = this.maketrtd(this.tablearr[i]);
     		this.table.appendChild(subdiv)
    	}
        
    }

    maketable2 = () => {
        // processlist 반영하기 
    	for(var i = 0; i < this.table2size.height;i++){
    	    this.table2arr[i] = {}
    	    var subdiv = this.maketrtd(this.table2arr[i]);
     		this.table2.appendChild(subdiv)
    	}
    }
    
    //
    // 여기서부터 문장작업
	//
	//
	
    makesentence(key, data, parameter){
		
		var text = data[key][parameter]; 
		
		var re = /[\^\@]\{[가-힣0-9]+\}[\^\@]/g;
		var textarr = text.split(re)
		var re = /(?<=(\^|\@)\{)[가-힣0-9]+(?=\}(\^|\@))/g;
		var optionarr = text.match(re)

		this.maintextdiv = document.createElement("div");
		this.maintextdiv.setAttribute("class", "maintext");
		
		if(optionarr){
			// 정상적인 경우
			// 순서가 엉망이 되어서, 재귀함수로 처리함
			this.nextloop(key, optionarr, textarr, data, 0);
		}else{
			// 옵션이 전혀없는 경우에는 바로 내용 띄울 것
    		var div1 = this.makediv(textarr[0]);
			this.maintextdiv.appendChild(div1);
		}
		
	}
    
    
    nextloop(key, optionarr, textarr, data, i){
		
		// makediv 만들고, 그 다음 maketext, makeselect 등 만들것
		var div1 = this.makediv(textarr[i]);
		
		this.maintextdiv.appendChild(div1);
		
		
		if(i < optionarr.length){
			var val = optionarr[i]
			
			// select인지 text 등인지로 구분받아서, 함수실행
			
			var opt = data[key]['processoption'][val]["resultval"]
			
			var div2 = this.makediv(opt, {style: "color: red"})  // this['make' + opt](data[key]['processoption'][val], val);
			
			this.maintextarr[key][val] = div2;
			this.maintextdiv.appendChild(div2);
		}

    	
		if(i + 1 < textarr.length){
			var i1 = i + 1;
			this.nextloop(key, optionarr, textarr, data, i1);
		}
		
		
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


    makeselect(data, val){
       
       // option1 ~ option5 이것을 for문 5까지로 수정할 것
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
    
    
    makeselectplus(data, val){
       
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
       this.additem_plus(button, data, val, div1, button);
       
       return div1;
  	   
    }
    
    additem_plus(item, data, val, div1, button){

    	item.addEventListener('click',(me)=>{
        	
        	// 먼저 select의 개수가 최대개수를 초과했는지 확인하고 최대개수를 초과하지 않았으면 추가할 것

            var tags = document.getElementsByName(val);
            var num = 0;
      	    for(var j = 1; j <= 5; j++){
     		   if(data['option' + j] != ""){
     			   num ++
      		   }else{
     			   break
     		   }
       	    }
            
      	    if(tags.length < num){

      	    	// 단어 추가
      	    	var divs = document.createElement("div");
      	    	divs.innerText = ", ";
      	    	
            	// select 추가
      	    	var field = this.makeselect(data, val);
      	    	divs.appendChild(field);
            	
             	// 삭제 버튼 추가
                var button_remove = document.createElement("input");
                button_remove.setAttribute('type', "button");
                button_remove.value = "X"
                divs.appendChild(button_remove);
                div1.insertBefore(divs, button);
                
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
    
    
    maketext(value){
    	
 		var field = document.createElement("input");
		field.setAttribute("type", "text");
		//field.setAttribute("name", data);
		field.setAttribute("value", "");
		
		return field;    	
    }
	
	//
	//
	// 문장관련 끝
	//
	changewordtable(){
		
		console.log(this.managearr)
		
		for(var i in this.managefirsttext){
			var text = this.managefirsttext[i];
			console.log(text)
			
			for(var j in this.managearr){
				text = text.replace("@{" + j + "}@", this.managearr[j].value)
				this.manageinnertext[i].innerText = text;
			}
		}	
		
	}
	
    inputtable = (arr, data, node, tablearr, parameter1, parameter2, size) => {

    	
    	// 먼저 테이블 지우기
    	for(var i = 1; i < size; i++){
    		tablearr[i][0].innerText = "";
    		tablearr[i][1].innerText = "";
    	}
    	
    	// 테이블 다시 채우기
    	
        var rowval = Math.min(arr.length, this.tablesize.height - 1);
    	
        if(data == null){
        	data = arr
        }
        console.log(123)
        console.log(arr)
        
        var r = 0;    
    	for(var i in arr){
                r += 1;
                
                for(var num = 1; num <=5; num++){
                 	if(parameter1 + num in data[i]){
                		if(data[i][parameter1 + num] != ""){
                            this.makesentence(i, data, parameter1 + num);
                            tablearr[r][0].appendChild(this.maintextdiv);
 
                            this.makesentence(i, data, parameter2 + num);
                            tablearr[r][1].appendChild(this.maintextdiv);
                		}
                	}
                }
               	
                //this.additem5(this.tablearr[r][2], data[i]); 현재는 역할이 없는 것 같음
                if(r > rowval){
                	break;
                }
         }
    	
    }

    inputtable2 = (arr) => {

        var rowval = Math.min(arr.length, this.tablesize.height - 1);
        var r = 0;    
                 r += 1;
                try{
                   this.table2arr[r][0].innerText = arr.controlname;
                   this.table2arr[r][1].innerText = arr.controlexplain;
                }catch{
                   
                }
         
    }

    maketrtd = (arr) => {
       
     	var div = document.createElement("tr")

     	div.style = "height : 20px";

     	for(var i = 0; i < this.tablesize.width;i++){
    	   var subdiv = document.createElement("td");

    	   arr[i] = subdiv;
    	   if(i == 0){
        	   subdiv.setAttribute("width","30%");
    	   }else if(i == 1){
    		   subdiv.setAttribute("width","60%");
    	   }else if(i == 2){
    		   subdiv.setAttribute("width","10%");
    	   }
    	   div.appendChild(subdiv);
     	}
    	return div
    }  
    
    makelabel = (item) => {

    	item[0][2].innerText = "선택";
        
        for(var i = 1; i <= this.tablesize.height - 1; i++){
           // 라디오 버튼을 테이브 앞단에 둬, 제목열 선택할 수 있게할 것
           this.selectlabel[i] = document.createElement("input")
           this.selectlabel[i].setAttribute('type', "radio");
           this.selectlabel[i].setAttribute('name', "subject");
           
           item[i][2].appendChild(this.selectlabel[i])   
        }
    }

    
    
    additem2 = (item, text) => {
        item.addEventListener('click',(me)=>{
            
        	console.log(me.target.innerText)
        	this.poolmake(text);
        })
    }
    
    additem3 = (item) => {

    	item.addEventListener('click',(me)=>{
             
             var arr_return = {}
             var real_return = {}
             // maintextarr는 tag를 그대로 들고 있기때문에, 서버로 넘기기 전에 이것을 값으로 전환함

             this.maintextresult = {}
             for(var i in this.maintextarr){
            	 this.maintextresult[i] = {};
            	
            	 for(var j in this.maintextarr[i]){
            		 if(this.maintextarr[i][j].tagName == "DIV"){
                         // selectplus 값이 여러개 들어오기 때문에, 이렇게 나누어졌음
                         var tags = document.getElementsByName(j);
                         var arr = []
                         tags.forEach((elem, index) => {
                        	  arr.push(elem.value);
                         })
                         
                         // 211202 나중에 arr이 값이 같으면 안되니까 검증하는 문구 추가해야함
             			 this.totalarr[i]['processoption'][j]['result_value'] = arr;
                        // 211202 또한 서버에서 result_val과 관련하여 arr도 받아야 하므로, 서버쪽도 함께 수정이 이루어져야 함 
            		 }else{
            			 // select나 text의 경우
                		 this.maintextresult[i][j] = this.maintextarr[i][j].value;
                		 this.totalarr[i]['processoption'][j]['result_value'] = this.maintextarr[i][j].value 
            		 }
            	 }
            	 
            	 arr_return =  this.totalarr[i];
            	 
            	 // processoption 배열로 전환해서 넘기기
            	 var temp = {}
            	 var num = 0
            	 for(var ia in arr_return['processoption']){
            	 	 for(var ib in arr_return['processoption'][ia]){
            			 real_return['processoption[' + num + '].' + ib] = arr_return['processoption'][ia][ib];
            		 }
                     num += 1
            	 }    
            	 
             }
             
             console.log(real_return);
             //this.ajaxmethod("maintext", real_return)
        })

    }

    additem4 = (item, item2) => {
        item.addEventListener('click',() => {
        	  console.log(this.Palette.model.nodeDataArray);
        	  var temp = this.Palette.model.nodeDataArray[0] 
        	  var obj = {team: turn.team, key : item2.innerText,  shape: temp.shape, wid: temp.wid, 
                  hei: temp.hei, color: temp.color, type: temp.type,
                  realkey: temp.realkey};
        	 
        	  this.Palette.model = new go.TreeModel([obj])
              
        })

    }    

    additem5 = (item, arr) => {
        item.addEventListener('click',(me)=>{
             console.log("click");
             this.inputtable2(arr);
        })
    }


    addlisten = (item) => {
        item.addEventListener('click',()=>{
             
        	this.myworkradio.forEach((node) => {
            	    if(node.checked)  {
            	       console.log(node.value);
   		               console.log(this.totalarr);
            	       var data = {subprocess: node.value};
                       this.ajaxmethod(data, this.start);
                	    
            	    }
         	  }) 
   
             
             
        })
    }

    // 211022 possetting2, nodedatasetting_graph2 등 플로우차트까지 하지 않고, 함수를 쉽게 바꿀것. 복잡한 것은 gojs 거기서할 것임
    // 211022 gojo_work에서 업무용 선택으로 생각했던 것 이것저것 할 것임. 알았지?
    
    start = (data) => {
        
    	console.log(data)
    	// totalarr 세팅하기 나중에 shape 등은 서버에서 세팅되어야 함
    	var totalarr = {}
    	for(var i in data){
            if(i != "child" && i != "parent"){
            	totalarr[i] = data[i];
            	totalarr[i].shape = "Rectangle";
            	totalarr[i].type = 1; 
            }
    	}
    	
    	console.log(totalarr)
    	
    	this.totalarr = totalarr;
    	
    	// 시작점 찾기
    	var pos = 1
    	var first = []
        for(var i in this.totalarr){
         	
        	if(this.totalarr[i].subpro.length == 0){
        		this.totalarr[i].widthpos = pos++;  
        		first.push(this.totalarr[i]);
        		break
         	}
        }    	
    	
        this.nodedata = []
        this.passeddata =  new Set([]);
        this.graphdata = [];

        this.diagram.model.nodeDataArray = [];
        this.nodedatasetting_func(first);
        
        this.picture("graph");
    	
    }
    
    // div에 관한 것
    
  


// 복붙한 함수
     animateFadeDown(e) {
        var diagram = e.diagram;
        var animation = new go.Animation();
        animation.isViewportUnconstrained = true; // So Diagram positioning rules let the animation start off-screen
        animation.easing = go.Animation.EaseOutExpo;
        animation.duration = 900;
        // Fade "down", in other words, fade in from above
        animation.add(diagram, 'position', diagram.position.copy().offset(0, 200), diagram.position);
        animation.add(diagram, 'opacity', 0, 1);
        animation.start();
      }

      nodeStyle() {
        return [
          // The Node.location comes from the "loc" property of the node data,
          // converted by the Point.parse static method.
          // If the Node.location is changed, it updates the "loc" property of the node data,
          // converting back using the Point.stringify static method.
          new go.Binding("location", "loc", go.Point.parse).makeTwoWay(go.Point.stringify),
          {
            // the Node.location is at the center of each node
            locationSpot: go.Spot.Center
          }
        ];
      }

      textStyle() {
        return {
          font: "bold 11pt Lato, Helvetica, Arial, sans-serif",
          stroke: "#F8F8F8"
        }
      }


      makePort = (name, align, spot, output, input) => {
        //console.log(this.nodedata)
        var horizontal = align.equals(go.Spot.Top) || align.equals(go.Spot.Bottom);
        // the port is basically just a transparent rectangle that stretches along the side of the node,
        // and becomes colored when the mouse passes over it
        return $$(go.Shape,
          {
            fill: "transparent",  // changed to a color in the mouseEnter event handler
            strokeWidth: 0,  // no stroke
            width: horizontal ? NaN : 8,  // if not stretching horizontally, just 8 wide
            height: !horizontal ? NaN : 8,  // if not stretching vertically, just 8 tall
            alignment: align,  // align the port on the main Shape
            stretch: (horizontal ? go.GraphObject.Horizontal : go.GraphObject.Vertical),
            portId: name,  // declare this object to be a "port"
            fromSpot: spot,  // declare where links may connect at this port
            fromLinkable: output,  // declare whether the user may draw links from here
            toSpot: spot,  // declare where links may connect at this port
            toLinkable: input,  // declare whether the user may draw links to here
            cursor: "pointer",  // show a different cursor to indicate potential link point
            mouseEnter: function(e, port) {  // the PORT argument will be this Shape
              if (!e.diagram.isReadOnly) port.fill = "rgba(255,0,255,0.5)";
            },
            mouseLeave: function(e, port) {
              port.fill = "transparent";
            }
          });
      }

}
  

  
//shape 관련 : Circle, Ellipse, Rectangle



  // 예제
  var nodeDataArray = [
    { key: "Alpha", color: "lightblue", fig: "Rectangle", loc: "0 0" },
    { key: "Beta", parent: "Alpha", color: "white", fig: "Ellipse", loc: "250 40"},  // note the "parent" property
    { key: "Gamma", parent: "Alpha", color: "white" , fig: "Ellipse", loc: "100 0"},
    { key: "Delta", parent: "Alpha", color: "white" , fig: "Ellipse", loc: "150 30"}
  ];
  
/*
  var datasetting = {
   계약체결: { name: "계약체결", next: ["주문하기", "전표작성"], before: "", team: "영업팀", shape: "Rectangle" },
   주문하기: { name: "주문하기", next: ["입고하기"], before: "계약체결", team: "영업팀", shape: "Rectangle" },  // note the "parent" property
   입고하기: { name: "입고하기", next: [], before: "주문하기", team: "영업팀", shape: "Rectangle" },  // note the "parent" property
   전표작성: { name: "전표작성", next: ["전표승인"], before: "계약체결", team: "회계팀", shape: "Rectangle" },
   전표승인: { name: "전표승인", next: ["결재하기"], before: "전표작성", team: "회계팀", shape: "Rectangle" },
   결재하기: { name: "결재하기", next: [], before: "전표승인", team: "자금팀", shape: "Rectangle" },
  };
*/
 
  var datasetting = {
      "전표 접수": {widthpos: 1, detailprocessname: "전표 접수", next: ["전표 작성"], before: [], team: "회계팀", shape: "Rectangle", type: 1 },
      "전표 작성": { detailprocessname: "전표 작성", next: ["전표 승인 권한 부여"], before: ["전표 접수"], team: "영업팀", shape: "Rectangle", type: 1 },  
      "전표 승인 권한 부여" : { detailprocessname: "전표 승인 권한 부여", next: [], before: ["전표 작성"], team: "회계팀", shape: "Rectangle", type: 1 },  // note the "parent" property
  };
 


  window.onload = function(){
     
	 // diagram 관련 세팅 
	 var diagram1 = new diagram(datasetting);
     //diagram1.nodedatasetting(0);
     diagram1.listmake();
     diagram1.poolmake("인사계획서 작성");
     
  /*   
     console.log(diagram1.totalarr)
     // 데이타 세팅
     // 1. 서버에서 관련 데이터 풀 받아오기
     diagram1.poolmake("전표관리");
     
     // 2. 현재는 표준 플로우차트 열이 없어서 임의로 세팅함
     
     diagram1.possetting2(datasetting["전표 접수"]);
     diagram1.possetting3(datasetting["전표 접수"]);
     diagram1.nodedatasetting_graph2(datasetting["전표 접수"]);
     //diagram1.nodedatasetting_graph(datasetting, datasetting["전표 접수"]);
     
     diagram1.picture("graph");
*/
     //diagram1.picture2();

    // ajax 관련 세팅 
    var request = createRequest(request);
 	request.onreadystatechange = function (event){
		if(request.readyState ==4){
			if (request.status == 200){
    			//console.log(request.response)
    			
			}
		}
	}


  }




 
  </script>
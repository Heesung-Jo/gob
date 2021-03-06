<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

 <html>
    <head>

    <body>
       <div id="myDiagramDiv" style = "border: solid 1px blue; width:400px;  height:400px"></div>



    </body>
 
    <script src="/js/go-debug.js"></script>
    <script src="/js/Figures.js"></script>

  <script>
  
  var $ = go.GraphObject.make;

class diagram{
    constructor(i){
       this.divisionsize_y = 100;
       this.divisionsize_x = 100;
       this.divisions = {};
       this.divisionpos = {};

       this.diagram = new go.Diagram("myDiagramDiv");
       this.nodedata = []
       this.diagram.nodeTemplate =
          $(go.Node, "Auto", new go.Binding("location", "loc", go.Point.parse),
          $(go.Shape,new go.Binding("stroke", "stroke"), new go.Binding("width", "wid"), 
            new go.Binding("angle", "angle"), new go.Binding("height", "hei"), new go.Binding("figure", "fig"), new go.Binding("fill", "color")),
          $(go.TextBlock, { margin: 5}, new go.Binding("stretch", "stretch"), 
             new go.Binding("text", "key"), new go.Binding("font", "font")),

        );

      this.diagram.linkTemplate =
          $(go.Link, { routing: go.Link.AvoidsNodes}, 
          $(go.Shape),
          $(go.Shape, { toArrow: "Standard" })
      );


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
     var teampos = {}; // 팀별로 위치를 세팅하기 위해서 만든 것 // 이건 그냥 리턴 값임
     for(var i in arr){
         if(arr[i].team in team){
            team[arr[i].team] += 1;
         }else{
            team[arr[i].team] = 1;
         } 
     }

     // 팀 갯수 분할하기
     var 최초 = Math.ceil(Math.sqrt(arr.length));
     var 가로 = 최초;
     var 세로 = 0;
     for(var i in team){
        세로 += Math.ceil(team[i]/가로);
     }
     
     var 최소 = Math.max(가로, 세로);
     var 결정가로 = 가로;
     var 결정세로 = 세로;
     //세로가 최초보다 클때까지는 가로를 늘려가면서 최적 팀별 위치 쪼개기  
     while(세로 > 최초){
        가로 += 1
        세로 = 0;
        for(var i in team){
           세로 += Math.ceil(team[i]/가로);
        }
        
        if(최소 > Math.max(가로, 세로)){
            결정가로 = 가로;
            결정세로 = 세로;
        }

     }

     // 210406 아래 함수 nodedatasetting2에서 활용할 것
     return {team: team, teampos: teampos, 가로: 결정가로, 세로: 결정세로}
  


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


  nodedatasetting2 = (totalarr, first) => {
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

   var count = 1;
   while(count > 0){
    for(var i in arr){
      // sublistloop를 가져다 쓰는 것이 바탕이 되야함
      // 기본 그림
      // 지금은 임의로 내가 위치를 세팅 시켰는데, 서버에서 프로세스 배열이 넘어오면
      // 이런식으로 세팅할 것(아래 3문장 참고)
      //var y = this.divisionpos[arr["team"]]
      //var x = this.divisions[arr["team"]] * this.divisionsize_x;
      //this.divisions[arr["team"]] += 1;      

      var x = pos;
      var y = 70 * i;
      
      // 위치결정
      // 1순위 : 팀, 2순위: 부모위치

      var loc = 
      var obj = {key : i,  fig: arr[i].shape, wid: arr[i].name.length * 10, 
                 hei: 50, angle: shape[i].angle, color: "white", loc: x + " " + y}
      

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
  
  
  picture = () => {
    this.diagram.model = new go.TreeModel(this.nodedata);
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
  

  var datasetting = {
   계약체결: { name: "계약체결", next: ["주문하기", "전표작성"], before: [], team: "영업팀", shape: "Rectangle" },
   주문하기: { name: "주문하기", next: ["주문하기"], before: ["계약체결"], team: "영업팀", shape: "Rectangle" },  // note the "parent" property
   전표작성: { name: "전표작성", next: ["결재하기"], before: ["계약체결"], team: "회계팀", shape: "Rectangle" },
   결재하기: { name: "결재하기", next: [], before: ["전표작성"], team: "영업팀", shape: "Rectangle" },
  };
 



  window.onload = function(){
     var diagram1 = new diagram();
     diagram1.nodedatasetting(0);
     diagram1.picture();

 

  }




 

 /* diagram.nodeTemplate =
    $(go.Node, "Auto",
      new go.Binding("location", "loc", go.Point.parse),
      $(go.Shape, "Ellipse", { fill: "white" }),
      $(go.TextBlock,
        new go.Binding("text", "key"))
    );

  diagram.linkTemplate =
    $(go.Link,
      { routing: go.Link.Orthogonal, corner: 5 },
      $(go.Shape));

  var nodeDataArray = [
    { key: "Alpha", loc: "0 60" },
    { key: "Beta", loc: "100 15" },
    { key: "Gamma", loc: "200 0" },
    { key: "Delta", loc: "200 30" },
    { key: "Epsilon", loc: "100 90" },
    { key: "Zeta", loc: "200 60" },
    { key: "Eta", loc: "200 90" },
    { key: "Theta", loc: "200 120" }
  ];
  var linkDataArray = [
    { from: "Alpha", to: "Beta" },
    { from: "Beta", to: "Gamma" },
    { from: "Beta", to: "Delta" },
    { from: "Alpha", to: "Epsilon" },
    { from: "Epsilon", to: "Zeta" },
    { from: "Epsilon", to: "Eta" },
    { from: "Epsilon", to: "Theta" }
  ];
  diagram.model = new go.GraphLinksModel(nodeDataArray, linkDataArray);

 */
  </script>
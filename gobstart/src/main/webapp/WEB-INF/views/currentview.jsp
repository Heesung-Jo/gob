<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<html>
<head>
       <meta name="_csrf_header" content="${_csrf.headerName}">
       <meta name="_csrf" content="${_csrf.token}">
  
 
</head>

<style>

table {
    border: 1px solid #444444;
    border-collapse: collapse;
    width: 50%;
   
  }
  
table th {
  border: 1px solid #444444;
  font-weight: bold;
  background: #dcdcd1;
  width: 100px;

  }

table td {
    border: 1px solid #444444;
    background: white;
    height: 25px;
    width: 100px;
  }

</style>

<body>

              <c:set var="name" value="완성" />
            
              <table>
                  <tr>
                    <th>업무종류</th>
                    <th>진행단계</th>
                  </tr>
              
              <c:forEach var = "item" items = "${currentarr}" >
                 <tr>
                    <td>${item.key}</td>
                    <td>${item.value}</td>
                 </tr>
                 
                 <c:if test="${item.value eq '미완성'}">
                     <c:set var="name" value="미완성" />
                 </c:if>
              </c:forEach>
              
              </table>
              <c:if test="${name eq '완성'}">
                    <input type ="submit" value = "확정하기" onClick = "ajaxmethod()"/>
              </c:if>
 
</body>
</html>

    <script src = "http://code.jquery.com/jquery-3.4.1.js"></script>


<script>


function ajaxmethod(){
	
	// 스프링 시큐리티 관련
	console.log(123)
	var header = $("meta[name='_csrf_header']").attr('content');
	var token = $("meta[name='_csrf']").attr('content');
	
		$.ajax({
			type : "POST",
			url : "/view/currentview_confirm",
			data : {},
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
                alert(res['결과']);
                if(res['결과'] == "다음 단계로 넘어갔습니다."){
                	location.href= "/view/loginSuccess";	
                }

			},
        error: function (jqXHR, textStatus, errorThrown)
        {
               console.log(errorThrown + " " + textStatus);
        }
		})		
}

/*
<li><a href="Scoping">Scoping</a></li>
<li><a href="basemapping">각종 매핑</a></li>
<li><a href="basestructure">기본계층 만들기</a></li>
<li><a href="basequestion">기본질문지</a></li>
<li><a href="gojs_work">상세질문지</a></li>
<li><a href="gojs9">플로우차트</a></li>
<li><a href="explanation">이해하기</a></li>
*/


</script>
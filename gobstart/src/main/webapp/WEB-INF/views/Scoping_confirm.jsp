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
    width: 100%;
    border: 1px solid #444444;
    border-collapse: collapse;
  }
  th, td {
    border: 1px solid #444444;
  }

</style>



<body>

        <c:set var="name" value="완성" />

        <table>
          <tr>
            <c:forEach var = "item" items = "${parameter}" >
               <td>${item.value}</td>
            </c:forEach>
          </tr>     
        
          <c:forEach var = "pro" items = "${scoping}" >
             <tr>
                <c:forEach var = "item" items = "${parameter}" >
                   <td>${pro[item.key]}</td>
                </c:forEach>
             </tr>
          </c:forEach>
        </table>

              
        <input type = "button" value = "확정하기"  onClick = "ajaxmethod('확정')"/>
        <input type = "button" value = "반려하기"  onClick = "ajaxmethod('반려')"/>        
 
</body>
</html>

    <script src = "http://code.jquery.com/jquery-3.4.1.js"></script>


<script>


window.onload = () => {
	
}

function ajaxmethod(data){
	
	// 스프링 시큐리티 관련
	console.log(data)
	var header = $("meta[name='_csrf_header']").attr('content');
	var token = $("meta[name='_csrf']").attr('content');
	
		$.ajax({
			type : "POST",
			url : "/view/scoping_confirm_submit",
			data : {data: data},
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

			},
        error: function (jqXHR, textStatus, errorThrown)
        {
               console.log(errorThrown + " " + textStatus);
        }
	})		
}

</script>
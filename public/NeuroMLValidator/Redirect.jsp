<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="org.neuroml.validator.validation.*"%>
<!--------

File:      Redirect.jsp
Author:    Padraig Gleeson

           This file has been developed as part of the neuroConstruct project
           This work has been funded by the Medical Research Council

---------->
<html>
    <head>

        
<%
    String mainUrl = "http://www.NeuroML.org";
    StringBuffer newUrl = new StringBuffer(mainUrl);
    
    StringBuffer info = new StringBuffer("<h2>Warning! This webpage will automatically redirect you to the new NeuroML server at: "+ mainUrl+"</h2>");
    
    
    Enumeration names = request.getParameterNames();
    
    String uri = request.getRequestURI();
    newUrl.append(uri+"/");
    
    
    boolean firstParam = true;
    
    while (names.hasMoreElements())
    {
        String nextName = (String)names.nextElement();
        String nextVal = request.getParameterValues(nextName)[0];
        info.append("<p>Parameter name: "+ nextName+ ", value: "+ nextVal+"</p>");
        if (firstParam)
        {
            newUrl.append("?");
        }
        else
            newUrl.append("&");
        
        newUrl.append(nextName+"="+nextVal);
        
       
    }
    
    
    response.sendRedirect(newUrl.toString());
    

%>
        <title>Redirecting to: <%=newUrl%></title>
</head>
    <body>
    
        <%=info%>


        <p>&nbsp;</p>
        <p>&nbsp;</p>
        <p>&nbsp;</p>

      
  
        
    </body>
</html>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="org.neuroml.validator.validation.*"%>
<!--------

File:      Validation.jsp
Author:    Padraig Gleeson

           This file has been developed as part of the neuroConstruct project
           This work has been funded by the Medical Research Council

---------->
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="application.css" />    
<script type="text/javascript" src="http://spike.la.asu.edu/NeuroMLValidator/public/javascripts/jquery-1.7.1.min.js"></script>
  <script type="text/javascript" src="http://spike.la.asu.edu/NeuroMLValidator/public/javascripts/jquery.dropotron-1.0.js"></script>
<script type="text/javascript">
var j = jQuery.noConflict();
      j(function() {
          j('#menu > ul').dropotron({
              mode: 'fade',
              globalOffsetY: 11,
              offsetY: -15
          });
      });
  </script>
        <title>Validate NeuroML file</title>
    </head>
        <%GeneralUtils.setCurrentPageRef("validation");%>
    <body>
<div id="wrapper">
        <%@ include file="header.jsp" %>
<%
    String defaultText = "&lt;?xml version=\"1.0\" encoding=\"UTF-8\"?&gt;\n&lt;info&gt;Paste the XML file contents here&lt;/info&gt";
    String suggestedText = new String(defaultText);
    
    String fileName = null;
    String content = null;
    
    XMLFile fileToView = null;
    
    //out.println("Info sent: ");
    Enumeration names = request.getParameterNames();
    
    
    while (names.hasMoreElements())
    {
        String nextName = (String)names.nextElement();
        //out.println("Name: "+ nextName+ ", value: "+ request.getParameterValues(nextName)[0]);
       
        if (nextName.equals(Parameters.LOCAL_FILE))
        {
            fileName = request.getParameterValues(nextName)[0];
            fileToView = new XMLFile();
            
            String fullPath = application.getRealPath(fileName);
            
            if (fullPath==null)
            {
                fullPath = GeneralProperties.getTempLocalPath()+fileName;
            }
                
            fileToView.setXMLFile(fullPath);
            
            //out.println("<p>Viewing file: "+application.getRealPath(fileName)+"</p>");
        }       
        
        if (nextName.equals(Parameters.PASTED_FILE))
        {
            content = request.getParameterValues(nextName)[0];
            //out.println("Found content: "+content);
            content = URLDecoder.decode(content, "UTF-8");
            //out.println("Found content: "+content);
            fileToView = new XMLFile();
            fileToView.setXMLContent(content);
        }
    }
    
    if (fileToView!=null)
    {
        suggestedText = fileToView.toHtmlSafeString();
    }
%>
<div class="overflowcontent">
        <h1>Validate NeuroML files</h1>
        
        <p>This page allows you to validate files against the NeuroML <a href="http://www.neuroml.org/specifications.php">specifications</a>.
        Examples of valid NeuroML files can be found <a href="Samples.php">here</a>.</p>
        
        <p><b>The current version of the specification is: v<%=GeneralProperties.getCurrentSchemaVersion()%> 
        (<a href="ViewNeuroMLFile.jsp?localFile=NeuroMLFiles/Schemata/v<%=GeneralProperties.getCurrentSchemaVersion()%>/RELEASE_NOTES&amp;<%=Parameters.VIEW_FORMAT%>=plaintext">Release notes</a>)</b></p>
        
        
      
        <form name ="myform" action="ValidationResults.jsp" method="post">  <!--enctype='multipart/form-data'-->
            <textarea name ="<%=Parameters.PASTED_FILE%>" rows="20" cols="100" onclick="if (document.myform.<%=Parameters.PASTED_FILE%>.value.indexOf('Paste the XML file contents here') >= 0) {document.myform.<%=Parameters.PASTED_FILE%>.value=''};"><%=suggestedText%></textarea>
            <br />
          <!--  <br />
            <u>or</u> upload a file: <input type="file" name="xmlfile" size="70"> http://forums.codecharge.com/posts.php?post_id=44078
            <br />-->
            <br />
            <!-- Bit of a hack...-->
            <input type="submit" value="Validate against current (v<%=GeneralProperties.getCurrentSchemaVersion()%>) schemas" name="<% out.println(Parameters.ONLY_USE_SCHEMA + "=v"+GeneralProperties.getCurrentSchemaVersion() ); %>"/>
            
            <input type="submit" value="Validate against all NeuroML Schemas"  />
        </form>
        
  
        <br />
  
        
       <!-- This would be useful too, just didn't have time to look at it.
            
        <h3>Validate by entry of file</h3>
      
        <form action="ValidationResults.jsp" method="post">
            Text of file:
            <input type="file" name="<%=Parameters.SENT_FILE%>" />
            <br />
            <input type="submit" value="Submit" />
        </form>
      
        <br />
        <br />
        -->

        <p>&nbsp;</p>
        <p>&nbsp;</p>
        <p>&nbsp;</p>
       <%@ include file="footer.jsp" %>
      </div></div>
      
       
        </div></div>
    </body>
</html>

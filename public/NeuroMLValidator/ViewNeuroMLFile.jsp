<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="org.neuroml.validator.validation.*"%>

<!--------

File:      ViewNeuroMLFile.jsp
Author:    Padraig Gleeson

           This file has been developed as part of the neuroConstruct project
           This work has been funded by the Medical Research Council

---------->

<%
    String fileName = null;
    String content = null;
    
    XMLFile fileToView = null;
    
    //out.println("Info sent: ");
    Enumeration names = request.getParameterNames();
    
    boolean viewAsXML = true;
    
    boolean pastedFile = false;
    
    
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
           
            
            //out.println("<p>Viewing the file: "+fullPath+"</p>");
        }       
        
        else if (nextName.equals(Parameters.PASTED_FILE))
        {
            content = request.getParameterValues(nextName)[0];
            //out.println("Found content: "+content);
            content = URLDecoder.decode(content, "UTF-8");
            
            //out.println("Now content: "+content);
            fileToView = new XMLFile();
            fileToView.setXMLContent(content);
            
            pastedFile = true;
            
        }
        else if (nextName.equals(Parameters.VIEW_FORMAT))
        {
            if (request.getParameterValues(nextName)[0].equals("plaintext"))
                viewAsXML = false;
        }
    }

%>


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
        
        <title>Viewing XML file<% if(fileName!=null) out.println(": "+fileName); %></title>
        
        <%GeneralUtils.setCurrentPageRef("viewfile:"+fileName);%>
    </head>
    <body>
    
    <div id="wrapper">
        <%@ include file="header.jsp" %>
<div class="overflowcontent">
        <%  if (fileName!=null)
            {
                if (viewAsXML)
                {
                    out.println("<p>Viewing XML file: <b>"+fileName+"</b></p>"); 
                    out.println("<p><a href=\""+fileName+"\">Download this file</a></p>");   
                }
                else
                {
                    out.println("<p>Viewing file: <b>"+fileName+"</b></p>");     
                    out.println("<p><a href=\""+fileName+"\">Download this file</a></p>");  
                }
            }
        
        %>

        
  
<% 
            String validateJsp = "ValidationResults.jsp";
            String fullPath = application.getRealPath(GeneralProperties.getSchemataDir());
            
            if (fullPath==null)
            {
                fullPath = GeneralProperties.getTempLocalPath()+GeneralProperties.getSchemataDir();
            }
            File schemataDir = new File(fullPath);

            File[] subDirs = schemataDir.listFiles();
            
            if(fileName!=null && viewAsXML)
            {
                String basicLink = validateJsp + "?" + Parameters.LOCAL_FILE + "=" + fileName;
            

                String newLink = basicLink + "&"+Parameters.ONLY_USE_SCHEMA + "=v"+GeneralProperties.getCurrentSchemaVersion();
                out.println("<a href=\""+newLink+"\">Validate this file against current (v"+GeneralProperties.getCurrentSchemaVersion()+") Schema</a><br/>");

                out.println("<a href=\""+basicLink+"\">Validate this file against all Schemata</a><br/>");
/*
                for(int i=0;i<subDirs.length;i++)
                {
                    if (subDirs[i].isDirectory() && !subDirs[i].getName().equals("CVS")&& !subDirs[i].getName().equals("old"))
                    {
                        String schemaCategory = subDirs[i].getName();
                        String newLink = basicLink + "&"+Parameters.ONLY_USE_SCHEMA + "="+schemaCategory;
                        out.println("<a href=\""+newLink+"\">Validate this file against <b>"+schemaCategory+"</b> Schemata</a><br/>");
                    }
                }*/
            }
        
            
            if(content!=null)
            {
                //basicLink = validateJsp + "?" + Parameters.PASTED_FILE + "=" + URLEncoder.encode(content);
                                
                out.println("<p><form action=\"ValidationResults.jsp\" method=\"post\"> \n"+
                            "<input type=\"hidden\" name=\""+Parameters.PASTED_FILE+"\" \n"+
                            "value=\""+URLEncoder.encode(content, "UTF-8")+"\" /> \n"+
                            " <input type=\"submit\" value=\"Validate this file against all Schemata\"/></form></b></p>");

                for(int i=0;i<subDirs.length;i++)
                {
                    if (subDirs[i].isDirectory() && !subDirs[i].getName().equals("CVS")&& !subDirs[i].getName().equals("old"))
                    {
                        String schemaCategory = subDirs[i].getName();
                        //String newLink = basicLink + "&"+Parameters.ONLY_USE_SCHEMA + "="+schemaCategory;

                        out.println("<p><form action=\"ValidationResults.jsp\" method=\"post\"> \n"+
                        "<input type=\"hidden\" name=\""+Parameters.PASTED_FILE+"\" \n"+
                        "value=\""+URLEncoder.encode(content, "UTF-8")+"\" /> \n"+
                        "<input type=\"hidden\" name=\""+Parameters.ONLY_USE_SCHEMA+"\" \n"+
                        "value=\""+schemaCategory+"\" /> \n"+
                        " <input type=\"submit\" value=\"Validate this file against "+schemaCategory+" Schemata\"/></form></b></p>");                    }
                }
            }
    


        if(fileName!=null && viewAsXML)
        {
            out.println("<p><b><a href=\"Validation.jsp?" + Parameters.LOCAL_FILE + "=" 
                    + fileName+"\">Edit this file and revalidate it</a></b></p>");
        }
        if(content!=null)
        {
           String encodedFile = URLEncoder.encode(content, "UTF-8");
           
           String paramsOrigFile = Parameters.PASTED_FILE
                       +"="+encodedFile;
           
           
            out.println("<p><form action=\"Validation.jsp\" method=\"post\"> \n"+
                        "<input type=\"hidden\" name=\""+Parameters.PASTED_FILE+"\" \n"+
                        "value=\""+encodedFile+"\" /> \n"+
                        " <input type=\"submit\" value=\"Edit this file and revalidate it\"/></form></b></p>");
        }
            
        boolean includeNeuroMLLinks = false;
        
        if (fileName!=null && fileName.indexOf("Examples")>=0)
        {
            includeNeuroMLLinks = true;
        }
        if (pastedFile) includeNeuroMLLinks = true;

%>

        <table border =0 bgcolor="#F3F3F3" width ="100%" cellpadding=5 style="font-family: system">
            <tr><td><p><% 
                        
  
            out.println(fileToView.toHTMLString(includeNeuroMLLinks, viewAsXML));
 
                    
                        
                        
                    %></p>
                </td>
            </tr>
        </table>
<%@ include file="footer.jsp" %>
      </div></div>
      
        
</div></div>
    </body>
</html>

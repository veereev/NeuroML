<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="org.neuroml.validator.validation.*"%>
<%
    String fileName = null;
    String content = null;
    
    XMLFile fileToTransform = null;
    
    File xslLocalFile = null;
    String xslReference = null;
    
    Enumeration names = request.getParameterNames();
    
    String paramsOrigFile = null;    
    
    while (names.hasMoreElements())
    {
        String nextName = (String)names.nextElement();
        //out.println("Info sent: "+nextName+": "+ request.getParameterValues(nextName)[0]);
       
        if (nextName.equals(Parameters.LOCAL_FILE))
        {
            fileName = request.getParameterValues(nextName)[0];
            fileToTransform = new XMLFile();
            String fullPath = application.getRealPath(fileName);
            
            if (fullPath==null)
            {
                fullPath = GeneralProperties.getTempLocalPath()+fileName;
            }
                
            fileToTransform.setXMLFile(fullPath);
            
            
            paramsOrigFile = Parameters.LOCAL_FILE +"="+request.getParameterValues(nextName)[0];
           
        }       
        else if (nextName.equals(Parameters.PASTED_FILE))
        {
            content = request.getParameterValues(nextName)[0];
            fileToTransform = new XMLFile();
            fileToTransform.setXMLContent(URLDecoder.decode(content, "UTF-8"));
            
           paramsOrigFile = Parameters.PASTED_FILE
                       +"="+URLEncoder.encode(request.getParameterValues(nextName)[0], "UTF-8");
        }  
        
        if (nextName.equals(Parameters.XSL_FILE))
        {
            xslReference = request.getParameterValues(nextName)[0];
            
            String fullPath = application.getRealPath(xslReference);
            
            if (fullPath==null)
            {
                fullPath = GeneralProperties.getTempLocalPath()+xslReference;
            }
            
            xslLocalFile = new File(fullPath);
        }
        
    }
    
    long startTime = System.currentTimeMillis();
    String trans = fileToTransform.transform(xslLocalFile);
    long endTime = System.currentTimeMillis();
    double seconds = (endTime - startTime)/1000d;


    if (xslLocalFile.getName().indexOf("X3D.xsl")>0)
    {
        response.setContentType("application/x3d" );
        response.setHeader( "Content-Disposition", "attachment; filename=net.x3d" );
        out.clearBuffer();
        out.println(trans);
        out.flush();
        return;
    }

%>

<!--------

File:      Transform.jsp
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
        <title>Transforming XML file<% if(fileName!=null) out.println(": "+fileName); %> using XSL file: 
        <%=xslReference%></title>
        <%GeneralUtils.setCurrentPageRef("validation");%>
    </head>
    <body>
    
    <div id="wrapper">
        <%@ include file="header.jsp" %>

<div class="overflowcontent">


        <p>Transforming XML file<% if(fileName!=null) out.println("<b>: "+fileName+"</b>"); %> using XSL file:<b> 
        <%=xslReference%></b></p>
        
        <p><a href="ViewNeuroMLFile.jsp?<%=paramsOrigFile%>">View original file before transform</a></p>
        
        
        <p>
        <table border =0 bgcolor="#F3F3F3" cellpadding="5" width=100%>
        <!--<table border =0 bgcolor="#FFFFFF" cellpadding="5" style="font-family: system;">-->
            <tr>
                <td>
                    <p>
                    <%
                    
                    if (fileName!=null)
                    {
                        out.println("<h3>Converting the file: "+fileName.substring(fileName.lastIndexOf(System.getProperty("file.separator"))+1)+"</h3>");  

                    }
                    %>
                    
                    <%
                    if (xslReference.indexOf("XSD_Readable.xsl")>=0)
                    {
                    %>
                    <p>Note: this representation of the contents of the XSD file is intended as a quick reference only. 
                    <br/>
                    ** <a href="ViewNeuroMLFile.jsp?<%=paramsOrigFile%>">The original *.xsd file</a> should be consulted if there
                    is any doubt regarding data types **<br/>
                    </p>
                    There is also the option to view this file in <a href="Transform.jsp?<%=paramsOrigFile +"&"
                                                                + Parameters.XSL_FILE+"="+  Parameters.XSD_TO_RNG_FILE%>">Relax NG format</a>. <br/>
                                                                Note this representation is for
                        reference only (for those who prefer that format). The XSD should be used for final validation.
                    <br/>
                    <%
                    }
                    %>

                    <!-- Start of transformed file -->
                    
                    <% 
                    if (xslReference.indexOf("HTML")>0 || xslReference.indexOf("Readable")>0)
                    {
                            // Output from Readables is already HTML...
                        out.println(trans);
                        
                    }
                    else if (xslReference.equals(Parameters.XSD_TO_RNG_FILE))
                    {
                        // An XML file...
                        
                        XMLFile fileToView = new XMLFile();
                        fileToView.setXMLContent(trans);
                        
                        
                        out.println(fileToView.toHTMLString(false, true));
                        
                    }
                    else
                    {
                        
                        out.println(HTMLUtils.formatPlainText(trans));
                    }
                    %>
                        
                        
                    <!-- End of transformed file -->
                    </p>
                    <br/>
                </td>
            </tr>
        </table>
        </p>
        
        <p>Time to transform file: <%=seconds%> secs</p>
       <%@ include file="footer.jsp" %>       
      </div></div>


</div></div>
    </body>
</html>

<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>
<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="org.neuroml.validator.validation.*"%>

<!--------

File:      ValidationResults.jsp
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
        <title>Validation results</title></head>
        <%GeneralUtils.setCurrentPageRef("validation");%>
    <body> 
    <div id="wrapper">
        <%@include file="header.jsp"%>

   <div class="overflowcontent">     
        <h1>Validation of NeuroML file</h1>
 
<%
    NeuroMLFile validator = new NeuroMLFile();
    
    
    Enumeration headers = request.getHeaderNames();
    
    while (headers.hasMoreElements())
    {
       String nextHeader = (String)headers.nextElement();
       
       //out.println("Name: "+ nextHeader+ ", value: "+ request.getHeader(nextHeader)+"<br/>");
    }
    
    Enumeration names = request.getParameterNames();
    
    String localFileParams = null;   
    String pastedFileContents = null;   
    
    String useOnlySchemaCategory = null;
    
    while (names.hasMoreElements())
    {
       String nextName = (String)names.nextElement();
       
        //out.println("Name: "+ nextName+ ", value: "+ request.getParameterValues(nextName)[0]+"<br/>");
       
       if (nextName.equals(Parameters.PASTED_FILE))
       {
           String pastedStuff = request.getParameterValues(nextName)[0];
           String decodedContent = URLDecoder.decode(pastedStuff, "UTF-8");
           
           validator.setXMLContent(decodedContent);
           
           // ensures it is encoded...
           pastedFileContents = URLEncoder.encode(decodedContent, "UTF-8");
           //String encodedFile = request.getParameterValues(nextName)[0];
           
            out.println("<p><form action=\"ViewNeuroMLFile.jsp\" method=\"post\"> \n"+
                        "<input type=\"hidden\" name=\""+Parameters.PASTED_FILE+"\" \n"+
                        "value=\""+pastedFileContents+"\" /> \n"+
                        " <input type=\"submit\" value=\"View original file being validated\"/></form></p>");
            
       }
       
       if (nextName.equals(Parameters.LOCAL_FILE))
       {
           String fileName= request.getParameterValues(nextName)[0];
           String fullPath = application.getRealPath(fileName);
            
            if (fullPath==null)
            {
                fullPath = GeneralProperties.getTempLocalPath()+fileName;
            }
           
           validator.setXMLFile(fullPath);
           
           localFileParams = Parameters.LOCAL_FILE
                   +"="+request.getParameterValues(nextName)[0];
           
            out.println("<p><a href=\"ViewNeuroMLFile.jsp?"+localFileParams+"\">View original file: <b>"
            +request.getParameterValues(nextName)[0]+"</b> being validated</a></p>");
       }
       if (nextName.startsWith(Parameters.ONLY_USE_SCHEMA))
       {
            if (nextName.equals(Parameters.ONLY_USE_SCHEMA))
            {
                useOnlySchemaCategory = request.getParameterValues(nextName)[0].trim();
            }
            else
            {
                useOnlySchemaCategory = nextName.substring(nextName.indexOf("=")+1).trim();
            }
            
       }
             
    }
    

%>
        
        
        <h3>Results of validation</h3>
        
<%
    out.println("<table frame=\"box\" rules=\"all\" align=\"center\" width=800>\n" +
                "<tr>\n" +
                "<th width=200>Test name</th><th>Description</th><th width = 150>Result</th>");
    
    String wellFormedness = validator.getWellFormedness();

    if (wellFormedness!=null)
    {
        out.println("<tr><td>&nbsp;Well formed XML file</td>"+
                    "<td>Check if this file is a correctly formatted XML file (This is essential for further validation)</td>"
                    +"<td align=\"center\">"+HTMLUtils.getTestResult(wellFormedness.equals(XMLFile.WELL_FORMED)));

        if(!wellFormedness.equals(XMLFile.WELL_FORMED))
        {
            out.println("&nbsp;&nbsp;<a href=\"Error.jsp?"+Parameters.ERROR_STRING+"="
                +URLEncoder.encode(wellFormedness, "UTF-8")+"\">More...</a>");
        }

        out.println("</td></tr>");


        out.println("</table>");    

        String fileName= GeneralProperties.getSchemataDir();
        String fullPath = application.getRealPath(fileName);

        if (fullPath==null)
        {
            fullPath = GeneralProperties.getTempLocalPath()+fileName;
        }
        
        File schemataDir = new File(fullPath);


        SimpleFileFilter xsdFileFilter = new SimpleFileFilter(new String[]{"xsd"}, "XSD files", false);

        File[] subDirs = schemataDir.listFiles();
        
        for(int i=0;i<subDirs.length;i++)
        {
            if (subDirs[i].isDirectory() && 
                    !subDirs[i].getName().equals("old") &&
                    !subDirs[i].getName().equals("CVS") &&  
                    !subDirs[i].getName().equals("BrainML") && 
                    !subDirs[i].getName().equals("UniProt") &&
                    (useOnlySchemaCategory==null || subDirs[i].getName().equalsIgnoreCase(useOnlySchemaCategory)))
            {

                out.println("<br/>");  

                out.println("<p class=\"h1\">Schema category: <b>"+subDirs[i].getName()+"</b></p>");     

                File readme = new File(subDirs[i], "README");

                if (readme.exists())
                {
                    try
                    {
                        //FileReader fr = new 


                        out.println("<p class=\"comment\">");

                        Reader in = new FileReader(readme);
                        LineNumberReader reader = new LineNumberReader(in);
                        String nextLine = null;
                        while ( (nextLine = reader.readLine()) != null)
                        {
                            out.println( nextLine);
                        }

                        File relNotesFile = new File(subDirs[i], "RELEASE_NOTES");
                        if (relNotesFile.exists())
                        {
                            out.println("&nbsp;&nbsp;<a href=\"ViewNeuroMLFile.jsp?"
                                        +Parameters.LOCAL_FILE+"="+GeneralProperties.getSchemataDir() + "/"
                                            + subDirs[i].getName()+ "/RELEASE_NOTES&"+Parameters.VIEW_FORMAT+"=plaintext\">Release notes</a>");
                        }

                    out.println("</p>");
                    }
                    catch(Exception e)
                    {
                        // ignore...
                    }
                } 
                
                File level3File = new File(new File(subDirs[i], "Level3"), "NeuroML_Level3_"+subDirs[i].getName()+".xsd");
                String overallResult = validator.validate(level3File);

                if(!overallResult.equals(XMLFile.VALID))
                {
                    out.println("<p><span style=\"color:red;\"><b>File has failed all of the validity tests below. For more details <a href=\"Error.jsp?"+Parameters.ERROR_STRING+"="
                        +URLEncoder.encode(overallResult, "UTF-8")+"\">click here</a>.</b></span></p>");
                }



                File[] schemaFiles = subDirs[i].listFiles();

                schemaFiles = GeneralUtils.reorderAlphabetically(schemaFiles, true);

                if(schemaFiles.length==0)
                {
                    out.println("<p>No Schema files found in this category</p>");

                }
                else
                {

                    out.println("<table frame=\"box\" rules=\"all\" align=\"centre\" width=800 cellpadding=\"3\">\n" +
                                    "<tr>\n" +
                                    "<th width=180>XML Schema</th><th>Links</th><th width = 130>Result</th>");

                    for(int j=0;j<schemaFiles.length;j++)
                    {

                        // the case where there' just a single level folder

                        if (!schemaFiles[j].isDirectory() && 
                            schemaFiles[j].getName().endsWith(".xsd") && 
                            !schemaFiles[j].getName().toLowerCase().equals("readme"))
                        {
                            String localPath = GeneralProperties.getSchemataDir() + "/"
                                            + subDirs[i].getName()+ "/" 
                                            +schemaFiles[j].getName();

                            String result = validator.validate(schemaFiles[j]);

                            out.println("<tr frame=\"box\"><td>&nbsp;<b>"+schemaFiles[j].getName()+"</b>&nbsp;&nbsp;<br/>(<a href=\"Transform.jsp?"
                                + Parameters.LOCAL_FILE+"="+  localPath +"&"
                                                                    + Parameters.XSL_FILE+"="+  Parameters.XSD_READABLE_FILE   +"\""
                                                                + ">HTML</a>&nbsp;<a href=\"ViewNeuroMLFile.jsp?"
                                        +Parameters.LOCAL_FILE+"="+localPath+"\">XML</a>)</td>"
                                        +"<td>&nbsp;&nbsp;"
                                        +"</td>"
                                    +"<td align=\"center\">"+HTMLUtils.getTestResult(result.equals(XMLFile.VALID)));

                            if(!result.equals(XMLFile.VALID))
                            {
                                out.println("&nbsp;&nbsp;<a href=\"Error.jsp?"+Parameters.ERROR_STRING+"="
                                    +URLEncoder.encode(result, "UTF-8")+"\">More...</a>");
                            }
                            out.println("</td></tr>");
                        }
                        else if (schemaFiles[j].isDirectory() && 
                                (!schemaFiles[j].getName().equals("old") || GeneralProperties.debug()) && 
                                !schemaFiles[j].getName().equals("CVS") &&
                                !schemaFiles[j].getName().equals("BrainML") && 
                                !schemaFiles[j].getName().equals("UniProt"))
                        {
                            out.println("<tr class=\"footer2\" style=\"font-size: 100%\"><td colspan=\"3\">&nbsp;&nbsp;<b>"+schemaFiles[j].getName()+"</b></td></tr>");


                            File[] subFolderFiles = schemaFiles[j].listFiles(xsdFileFilter);

                            subFolderFiles = GeneralUtils.reorderAlphabetically(subFolderFiles, true);

                            if(subFolderFiles==null || subFolderFiles.length==0)
                            {
                                out.println("<p>No Schema files found in this sub category</p>");
                            }
                            for(int k=0;k<subFolderFiles.length;k++)
                            {

                                if (!subFolderFiles[k].isDirectory()  && subFolderFiles[k].getName().endsWith(".xsd"))
                                {   

                                    String localPath = GeneralProperties.getSchemataDir() + "/"
                                            + subDirs[i].getName()+ "/" 
                                            +schemaFiles[j].getName()+ "/" 
                                            +subFolderFiles[k].getName();

                                    String result = validator.validate(subFolderFiles[k]);

                                    out.println("<tr><td width=\"300\">&nbsp;<b>"+subFolderFiles[k].getName()+"</b>" +
                                        "&nbsp;&nbsp;(<a href=\"Transform.jsp?"+ Parameters.LOCAL_FILE+"="+  localPath +"&"
                                                                + Parameters.XSL_FILE+"="+  Parameters.XSD_READABLE_FILE   +"\""
                                                                + ">HTML</a>, <a href=\"ViewNeuroMLFile.jsp?"
                                        +Parameters.LOCAL_FILE+"="+localPath+"\">XML</a>)</td>"
                                        +"<td><table border=0>");

                                    if (result.equals(XMLFile.VALID))
                                    {
                                        SimpleFileFilter xslFileFilter = new SimpleFileFilter(new String[]{".xsl"}, "XSL files", false);

                                        String schemaName = subFolderFiles[k].getName().substring(0,subFolderFiles[k].getName().lastIndexOf("."));

                                        File[] transformFiles = schemaFiles[j].listFiles(xslFileFilter);

                                        for(int l=0;l<transformFiles.length;l++)
                                        {

                                            String fullName = transformFiles[l].getName();

                                            String localXSLFile = GeneralProperties.getSchemataDir() + "/"
                                                + subDirs[i].getName()+ "/" 
                                                +schemaFiles[j].getName()+ "/" 
                                                +fullName;

                                            //System.out.println("looking at: "+ fullName);

                                            String partialName = fullName.substring(0, fullName.lastIndexOf("."));

                                            if (partialName.startsWith(schemaName))
                                            {
                                                String simName = partialName.substring(partialName.lastIndexOf("_")+1);
                                                String more = "";

                                                if (simName.equals("X3D"))
                                                {
                                                    more = "&nbsp;&nbsp;<a href = \"X3DSupport.jsp\">More...</a>";
                                                }
                                                // @todo: Replace this with better check for L2 bio cells... 
                                                if (!(simName.equals("X3D") && 
                                                        localFileParams!=null && 
                                                        localFileParams.indexOf("ChannelML")>0 && 
                                                        localFileParams.indexOf("Pyramidal")<0))
                                                {
                                                    if (localFileParams!=null)
                                                    {
                                                        out.println("<tr><td><b><a href=\"Transform.jsp?"+localFileParams+"&"
                                                                    + Parameters.XSL_FILE+"="+localXSLFile+"\""
                                                                    + ">Convert NeuroML to "+simName+" format</a> "+more+"</b></td>");
                                                    }

                                                    if (pastedFileContents!=null)
                                                     {
                                                        out.println("<p><form action=\"Transform.jsp\" method=\"post\"> \n"+
                                                        "<input type=\"hidden\" name=\""+Parameters.PASTED_FILE+"\" \n"+
                                                        "value=\""+pastedFileContents+"\" /> \n"+
                                                        "<input type=\"hidden\" name=\""+Parameters.XSL_FILE+"\" \n"+
                                                        "value=\""+localXSLFile+"\" /> \n"+
                                                        " <input type=\"submit\" value=\"Convert NeuroML to "+simName+" format\"/></form>"+more+"</p>");
                                                    }
                                                }




                                            }
                                            else
                                            {
                                               // out.println(partialName+ " != "+schemaName);
                                            }
                                        }
                                    }

                                    out.println("</td></tr></table></td>");

                                    out.println("<td align=\"center\">"+HTMLUtils.getTestResult(result.equals(XMLFile.VALID)));

                                    if(!result.equals(XMLFile.VALID))
                                    {
                                        out.println("&nbsp;&nbsp;<a href=\"Error.jsp?"+Parameters.ERROR_STRING+"="
                                            +URLEncoder.encode(result, "UTF-8")+"\">More...</a>");
                                    }
                                    out.println("</td></tr>");
                                }
                            }
                        }
                    }
                    out.println("</table>");
                }

            }
        }
    }
    else
    {
        out.println("&nbsp;&nbsp;<p>Error processing input!!!</p><p>localFileParams: "+localFileParams+"</p>" +
            "<p>pastedFileContents: "+pastedFileContents+"</p>");
    }

%>
        <%@include file="footer.jsp" %>
     
   </div>    </div>

        
</div></div>
    </body>
</html>

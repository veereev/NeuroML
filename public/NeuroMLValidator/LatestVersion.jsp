<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.neuroml.validator.utils.*"%>
<%
/*
File:      LatestVersion.jsp
Author:    Padraig Gleeson

           This file has been developed as part of the neuroConstruct project
           This work has been funded by the Medical Research Council
*/
    String currVerFull = GeneralProperties.getCurrentSchemaVersion();
    
    out.print(currVerFull);
%>
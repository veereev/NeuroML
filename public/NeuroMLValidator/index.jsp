<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="org.neuroml.validator.utils.*"%>
<%@page import="org.neuroml.validator.validation.*"%>

<!--------

File:      index.jsp
Author:    Padraig Gleeson

           This file has been developed as part of the neuroConstruct project
           This work has been funded by the Medical Research Council

---------->

<html  xmlns="http://www.w3.org/1999/xhtml">
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
        
        <title>Validation of NeuroML/MorphML/ChannelML files</title>
        <%GeneralUtils.setCurrentPageRef("index");%>
    </head>
    <body>
 <div id="wrapper">
        <%@ include file="header.jsp" %>
        
<%
        String currVer = GeneralProperties.getCurrentVersionShort();
        String currVerFull = GeneralProperties.getCurrentSchemaVersion();
        if (GeneralProperties.debug()) out.print("<h1>DEBUG MODE!!!!<h1><h1>DEBUG MODE!!!!<h1><h1>DEBUG MODE!!!!<h1><h1>DEBUG MODE!!!!<h1>");
%>
        <div class="overflowcontent">
        <h1>Validate and transform NeuroML files</h1>
        
        <p><a href="http://neuroml.sourceforge.net/">
            NeuroML</a> is an international initiative to facilitate greater interoperability between compuational 
            neuroscience tools by producing standardised descriptions of elements common to many software packages used for visualising, 
            simulating and analysing neuronal systems. </p>
            
        <p>The current approach uses <a href="http://www.w3schools.com/schema/default.asp">XML Schemas</a> 
            to define the specification. A very good introduction to XML and reference guide can be found <a href="http://www.w3schools.com/xml/default.asp">here</a>.</p>
        
        <p  align="center"><b><span style="color:red">Note: To find out more about the current activities in the NeuroML project please see the    
        <a href="http://sourceforge.net/mail/?group_id=136437">mailing lists</a></span></b></p>
       
        
        <p  align="center"><b>The current version of the specification is: v<%=currVerFull%> 
        (June 2009, <a href="ViewNeuroMLFile.jsp?localFile=NeuroMLFiles/Schemata/v<%=currVerFull%>/RELEASE_NOTES&<%=Parameters.VIEW_FORMAT%>=plaintext">Release notes</a>)</b></p>
        
        <br/>
        There are three Levels of compliance to the NeuroML standards:
        <ul>
            <li style="padding:5px ; margin-left: 10px"><a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level1">Level 1</a> 
        is focused on the anatomical aspects of the cells. This consists of a schema for metadata, 
        <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Metadata">Metadata_v<%=currVer%>.xsd</a> (which can be also used to describe 
        elements at any subsequent level), and the main MorphML schema, <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=MorphML">MorphML_v<%=currVer%>.xsd</a>. 
        Valid morphology files can be mapped to <a href="http://www.neuron.yale.edu/neuron/">NEURON</a> or <a href="http://www.genesis-sim.org/GENESIS/">GENESIS</a> format.</li>
        
            <li style="padding:5px ; margin-left: 10px"> <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level2">Level 2</a> adds the ability
            to include information on the biophysical properties of cells (specific capacitance, axial resistance, location and density of 
            membrane conductances, etc.) <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Biophysics">Biophysics_v<%=currVer%>.xsd</a>,
            and on the properties of specific channel and synaptic mechanisms, <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=ChannelML">ChannelML_v<%=currVer%>.xsd</a>. 
            <a href="Samples.jsp">Examples</a> are given for valid ChannelML files which can be mapped to 
            scripts for the <a href="http://www.neuron.yale.edu/neuron/">NEURON</a> and <a href="http://www.genesis-sim.org/GENESIS/">GENESIS</a> 
            simulators.
            
            Any Level 1 or Level 2 XML file to will be compliant to <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level2">NeuroML_Level2_v<%=currVer%>.xsd</a></li>
        
            <li style="padding:5px ; margin-left: 10px"> <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=Level3">Level 3</a> allows 
            specification of cell placement and network connectivity. The core of this is specified in <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=NetworkML">NetworkML_v<%=currVer%>.xsd</a></li>
        </ul>
        
        <br/>
        
        The best way to get to understand the structure of the standards is to look at the source XML of the <a href="Samples.jsp">examples</a>. Some of these are:
    
        <ul> 
            <li style="padding:5px ; margin-left: 10px"><b><a href="ViewNeuroMLFile.jsp?localFile=NeuroMLFiles/Examples/MorphML/CablesIncluded.xml">CablesIncluded.xml</a></b>
            <a href="Transform.jsp?<%=Parameters.LOCAL_FILE%>=NeuroMLFiles/Examples/MorphML/CablesIncluded.xml&<%=Parameters.XSL_FILE%>=NeuroMLFiles/Schemata/v<%=currVerFull%>/Level3/NeuroML_Level3_v<%=currVer%>_HTML.xsl">(HTML)</a>
            is an example of a cell with soma and dendrites specified in <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=MorphML">MorphML</a></li>
            <li style="padding:5px ; margin-left: 10px"><b><a href="ViewNeuroMLFile.jsp?localFile=NeuroMLFiles/Examples/ChannelML/NaChannel_HH.xml">NaChannel_HH.xml</a></b>
            <a href="Transform.jsp?<%=Parameters.LOCAL_FILE%>=NeuroMLFiles/Examples/ChannelML/NaChannel_HH.xml&<%=Parameters.XSL_FILE%>=NeuroMLFiles/Schemata/v<%=currVerFull%>/Level3/NeuroML_Level3_v<%=currVer%>_HTML.xsl">(HTML)</a>
            is a <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=ChannelML">ChannelML</a> example of a sodium channel based on the Hodgkin Huxley squid model.</li>
            <li style="padding:5px ; margin-left: 10px"><b><a href="ViewNeuroMLFile.jsp?localFile=NeuroMLFiles/Examples/NetworkML/CompleteNetwork.xml">CompleteNetwork.xml</a></b>
            <a href="Transform.jsp?<%=Parameters.LOCAL_FILE%>=NeuroMLFiles/Examples/NetworkML/CompleteNetwork.xml&<%=Parameters.XSL_FILE%>=NeuroMLFiles/Schemata/v<%=currVerFull%>/Level3/NeuroML_Level3_v<%=currVer%>_HTML.xsl">(HTML)</a>
            is a description of a full network model including cell, synaptic mechanisms and network connections (in <a href="Latest.jsp?<%=Parameters.SPEC_PART%>=NetworkML">NetworkML</a>).</li>
            
        </ul>
        
      <%@ include file="footer.jsp" %>
</div></div>
        
</div></div>
    </body>
</html>

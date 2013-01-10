<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mml="http://morphml.org/morphml/schema"
    xmlns:meta="http://morphml.org/metadata/schema"
    xmlns:nml="http://morphml.org/neuroml/schema"
    xmlns:bio="http://morphml.org/biophysics/schema" >
    
    <xsl:import href="ChannelML_v1.1_Readable.xsl"/>

<!--

    This file is used to convert v1.1 MorphML files to a "neuroscientist friendly" view
    Note this doesn't by any means include all of the information present in the file, it just 
    summarises the notes, etc. embedded in the file and gives a summary of segment numbers, etc.
    
    This file has been developed as part of the neuroConstruct project
    
    Funding for this work has been received from the Medical Research Council
    
    Author: Padraig Gleeson
    Copyright 2006 Department of Physiology, UCL
    
-->

<xsl:output method="html" indent="yes" />



<!--Main Level 1 template-->

<xsl:template match="/mml:morphml">
<h3>NeuroML v1.1 Level 1 file</h3>

<xsl:if test="count(/mml:morphml/meta:notes) &gt; 0">
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">General notes</xsl:with-param>
        <xsl:with-param name="value"><xsl:value-of select="/mml:morphml/meta:notes"/></xsl:with-param>
     </xsl:call-template>
</table>
</xsl:if>

<xsl:apply-templates  select="/mml:morphml/mml:cells"/>

<br/>

</xsl:template>
<!--End Main template-->



<!--Main Level 2 template-->

<xsl:template match="/nml:neuroml">
<h3>NeuroML v1.1 Level 2 file</h3>

<xsl:if test="count(/nml:neuroml/meta:notes) &gt; 0">
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">General notes</xsl:with-param>
        <xsl:with-param name="value"><xsl:value-of select="/nml:neuroml/meta:notes"/></xsl:with-param>
     </xsl:call-template>
</table>
</xsl:if>

<xsl:apply-templates  select="/nml:neuroml/nml:cells"/>

<br/>

</xsl:template>
<!--End Main template-->





<xsl:template match="nml:cell|mml:cell">
<h3>Cell: <xsl:value-of select="@name"/></h3>


<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
<xsl:call-template name="tableRow">
        <xsl:with-param name="name">Name</xsl:with-param>
        <xsl:with-param name="value"><xsl:value-of select="@name"/></xsl:with-param>
</xsl:call-template>



<xsl:if test="count(meta:notes) &gt; 0">
<xsl:call-template name="tableRow">
        <xsl:with-param name="name">Description</xsl:with-param>
        <xsl:with-param name="comment">As described in the NeuroML file</xsl:with-param>
        <xsl:with-param name="value"><xsl:value-of select="meta:notes"/></xsl:with-param>
</xsl:call-template>
</xsl:if>




<xsl:if test="count(meta:publication) &gt; 0">
    <xsl:for-each select="meta:publication">
        <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Referenced publication</xsl:with-param>
                <xsl:with-param name="value"><xsl:value-of select="meta:fullTitle"/>
                
                &lt;a href="<xsl:value-of select="meta:pubmedRef"/>"&gt;Pubmed&lt;/a&gt;
                </xsl:with-param>
        </xsl:call-template>
    </xsl:for-each>
</xsl:if>


<xsl:if test="count(meta:neuronDBref) &gt; 0">
    <xsl:for-each select="meta:neuronDBref">
        <xsl:call-template name="tableRow">
                <xsl:with-param name="name">Reference in NeuronDB</xsl:with-param>
                <xsl:with-param name="value">
                
                &lt;a href="<xsl:value-of select="meta:uri"/>"&gt;<xsl:value-of select="meta:modelName"/>&lt;/a&gt;
                </xsl:with-param>
        </xsl:call-template>
    </xsl:for-each>
</xsl:if>




<xsl:call-template name="tableRow">
        <xsl:with-param name="name">Total number of segments</xsl:with-param>
        <xsl:with-param name="value"><xsl:value-of select="count(mml:segments/mml:segment)"/></xsl:with-param>
</xsl:call-template>

<xsl:call-template name="tableRow">
        <xsl:with-param name="name">Total number of cables</xsl:with-param>
        <xsl:with-param name="value"><xsl:value-of select="count(mml:cables/mml:cable)"/>
        with <xsl:value-of select="count(mml:cables/mml:cable[meta:group='soma_group'])"/> soma cable(s),
        <xsl:value-of select="count(mml:cables/mml:cable[meta:group='dendrite_group'])"/> dendritic cable(s)
        and <xsl:value-of select="count(mml:cables/mml:cable[meta:group='axon_group'])"/> axonal cable(s)
        </xsl:with-param>
</xsl:call-template>

<!--
<xsl:variable  name="groupsShown">,,,</xsl:variable>

<xsl:for-each select="mml:cables/mml:cable/meta:group">

<xsl:variable  name="tempGroupsShown">'''<xsl:value-of select="$groupsShown"/> <xsl:value-of select="."/></xsl:variable>



    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Group: <xsl:value-of select="."/>real <xsl:value-of select="$groupsShown"/> temp: <xsl:value-of select="$tempGroupsShown"/></xsl:with-param>
        <xsl:with-param name="value">Contains: 
        
        <xsl:variable  name="group"><xsl:value-of select="."/></xsl:variable>
        
        <xsl:for-each select="../../../mml:cables/mml:cable[meta:group=$group]"><xsl:value-of select="@name"/>, </xsl:for-each>
        
        </xsl:with-param>
    </xsl:call-template>
    
    
    <xsl:variable  name="groupsShown"><xsl:value-of select="$tempGroupsShown"/></xsl:variable>

</xsl:for-each>-->

</table>

<xsl:apply-templates  select="nml:biophysics"/>



</xsl:template>


<xsl:template match="nml:biophysics">


<table frame="box" rules="all" align="centre" cellpadding="4">

<h3>Biophysical properties</h3>



    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">Unit system of biophysical entities</xsl:with-param>
        <xsl:with-param name="comment">This can be either <b>SI Units</b> or <b>Physiological Units</b></xsl:with-param>
        <xsl:with-param name="value"><xsl:value-of select="@units"/></xsl:with-param>
     </xsl:call-template>
     
     
     <xsl:apply-templates  select="bio:mechanism"/>
     
</table> <!-- round off table...-->
</xsl:template>

<xsl:template match="bio:mechanism">

    <xsl:variable name="xmlFileUnitSystem"><xsl:value-of select="../@units"/></xsl:variable>   
    
    <xsl:choose>
    <xsl:when test="@type='Initial Membrane Potential'">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Initial Membrane Potential</xsl:with-param>
            <xsl:with-param name="comment">This quantity is often required for computational simulations and specifies the potential
                difference across the membrane at the start of the simulation. This is an optional field</xsl:with-param>
            <xsl:with-param name="value"><xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                                <xsl:with-param name="quantity">Voltage</xsl:with-param>
                                <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                        </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:when>
    
    <xsl:when test="@type='Specific Capacitance'">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Specific Capacitance</xsl:with-param>
            <xsl:with-param name="comment">This is the capacitance per unit area of the membrane</xsl:with-param>
            <xsl:with-param name="value"><xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                                <xsl:with-param name="quantity">Specific Capacitance</xsl:with-param>
                                <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                        </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:when>
    
    <xsl:when test="@type='Specific Axial Resistance'">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Specific Axial Resistance</xsl:with-param>
            <xsl:with-param name="comment">This is the resistance per unit length along a dendrite</xsl:with-param>
            <xsl:with-param name="value"><xsl:value-of select="@value"/> <xsl:call-template name="getUnitsInSystem">
                                <xsl:with-param name="quantity">Specific Resistance</xsl:with-param>
                                <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                        </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:when>
    
    
    
    <xsl:when test="@type='Membrane Conductance'">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Membrane Conductance</xsl:with-param>
            <xsl:with-param name="comment">An active membrane conductance</xsl:with-param>
            <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt; present on group 
            &lt;b&gt;<xsl:value-of select="bio:group"/>&lt;/b&gt; with density <xsl:value-of select="@value"/>
            
            
            <xsl:call-template name="getUnitsInSystem">
                                <xsl:with-param name="quantity">Conductance Density</xsl:with-param>
                                <xsl:with-param name="xmlFileUnitSystem"><xsl:value-of select="$xmlFileUnitSystem"/></xsl:with-param>
                        </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:when>
    
    
    <xsl:when test="@type='Potential Synaptic Connection Location'">
        <xsl:call-template name="tableRow">
            <xsl:with-param name="name">Potential Synapse Location</xsl:with-param>
            <xsl:with-param name="comment">Cables are possible locations of synaptic endpoints of this type</xsl:with-param>
            <xsl:with-param name="value">Synaptic mechanism &lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt; can be present on group 
            &lt;b&gt;<xsl:value-of select="bio:group"/>&lt;/b&gt;</xsl:with-param>
        </xsl:call-template>
            
            
    </xsl:when>
    
    
    
    </xsl:choose>

</xsl:template>








</xsl:stylesheet>

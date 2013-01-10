<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:cml="http://morphml.org/channelml/schema"
    xmlns:meta="http://morphml.org/metadata/schema" 
    xmlns:net="http://morphml.org/networkml/schema" >

    <xsl:import href="../ReadableUtils.xsl"/>
    
<!--

    This file is used to convert v1.3 NetworkML files to a "neuroscientist friendly" HTML view
    This file is taken from the neuroConstruct source code
    
    This file has been developed as part of the neuroConstruct project
    
    Funding for this work has been received from the Medical Research Council
    
    Author: Padraig Gleeson
    Copyright 2006 Department of Physiology, UCL
    
-->

<xsl:output method="html" indent="yes" />



<!--Main template-->


<xsl:template match="/net:networkml">
<h3>NetworkML v1.3 file</h3>

<xsl:if test="count(/net:networkml/meta:notes) &gt; 0">
<table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name">General notes</xsl:with-param>
        <xsl:with-param name="comment">Notes present in NetworkML file</xsl:with-param>
        <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="/net:networkml/meta:notes"/>&lt;/b&gt;</xsl:with-param>
     </xsl:call-template>
</table>
</xsl:if>

<br/>

<xsl:apply-templates  select="net:populations"/>
<xsl:apply-templates  select="net:projections"/>

</xsl:template>

<!--End Main template-->


<xsl:template match="net:populations">
<h3>Populations:</h3>
        <xsl:for-each select="net:population">
            
            <xsl:element name="a">
                <xsl:attribute name="name">Population_<xsl:value-of select="@name"/></xsl:attribute>
            </xsl:element>
            
            <table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
            
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Name</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
                </xsl:call-template> 
                
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Cell Type</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="net:cell_type"/>&lt;/b&gt;</xsl:with-param>
                </xsl:call-template> 
                
                <xsl:apply-templates  select="net:instances"/>
                 
                 
            </table>
<br/>
        </xsl:for-each>
</xsl:template>


<xsl:template match="net:instances">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name"><xsl:value-of select="count(net:instance)"/> Instances</xsl:with-param>
        <xsl:with-param name="value">
            <xsl:for-each select="net:instance">&lt;p&gt;&lt;b&gt;Instance <xsl:value-of select="@id"/>: (<xsl:value-of select="net:location/@x"/>, <xsl:value-of select="net:location/@y"/>, <xsl:value-of select="net:location/@z"/>)
            &lt;/b&gt;&lt;/p&gt;</xsl:for-each></xsl:with-param>
    </xsl:call-template> 
    
</xsl:template>


<xsl:template match="net:projections">
<h3>Projections:</h3>
        <xsl:for-each select="net:projection">
            
            <table frame="box" rules="all" align="centre" cellpadding="4" width ="100%">
            
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Projection</xsl:with-param>
                    <xsl:with-param name="value">&lt;b&gt;<xsl:value-of select="@name"/>&lt;/b&gt;</xsl:with-param>
                </xsl:call-template>     
        
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">From:</xsl:with-param>
                    <xsl:with-param name="value">&lt;a href="#Population_<xsl:value-of select="net:from"/>"&gt; &lt;b&gt;<xsl:value-of select="net:from"/>&lt;/b&gt;&lt;/a&gt; </xsl:with-param>
                </xsl:call-template>          
   
                <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">To:</xsl:with-param>
                    <xsl:with-param name="value">&lt;a href="#Population_<xsl:value-of select="net:to"/>"&gt; &lt;b&gt;<xsl:value-of select="net:to"/>&lt;/b&gt;&lt;/a&gt;</xsl:with-param>
                </xsl:call-template> 
                
                <xsl:apply-templates  select="net:synapse_props"/>
                <xsl:apply-templates  select="net:connections"/>
                                
            </table>
        <br/>
        </xsl:for-each>
</xsl:template>



<xsl:template match="net:synapse_props">
    
                   <xsl:call-template name="tableRow">
                    <xsl:with-param name="name">Synaptic properties</xsl:with-param>
                    <xsl:with-param name="value">&lt;p&gt;&lt;b&gt;Type: <xsl:value-of select="net:synapse_type"/>&lt;/b&gt;&lt;/p&gt;
                    &lt;p&gt;&lt;b&gt;Delay: <xsl:value-of select="net:delay"/>&lt;/b&gt;&lt;/p&gt;
                    &lt;p&gt;&lt;b&gt;Weight: <xsl:value-of select="net:weight"/>&lt;/b&gt;&lt;/p&gt;
                    &lt;p&gt;&lt;b&gt;Threshold: <xsl:value-of select="net:threshold"/>&lt;/b&gt;&lt;/p&gt;</xsl:with-param>
                    
                   
                </xsl:call-template>     
</xsl:template>


<xsl:template match="net:connections">
<xsl:if test="count(net:connection) &gt; 0">
    <xsl:call-template name="tableRow">
        <xsl:with-param name="name"><xsl:value-of select="count(net:connection)"/> connection instance(s):</xsl:with-param>
        <xsl:with-param name="value">
            <xsl:for-each select="net:connection">
                    &lt;p&gt;&lt;b&gt;From segment <xsl:value-of select="net:source/@segment_id"/> on source cell <xsl:value-of select="net:source/@cell_id"/>
                    to segment <xsl:value-of select="net:target/@segment_id"/> on source cell <xsl:value-of select="net:target/@cell_id"/>&lt;/b&gt;&lt;/p&gt;
            </xsl:for-each>
        </xsl:with-param>
                </xsl:call-template>     
                </xsl:if>
</xsl:template>







</xsl:stylesheet>

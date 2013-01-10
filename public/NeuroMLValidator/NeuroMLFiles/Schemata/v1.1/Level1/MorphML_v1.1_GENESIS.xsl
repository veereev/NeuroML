<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:mml="http://morphml.org/morphml/schema">

<!--
    This file is used to convert MorphML files to GENESIS readcell format *.p files

    This file has been developed as part of the neuroConstruct project
    
    Funding for this work has been received from the Medical Research Council
    
    Author: Padraig Gleeson
    Copyright 2006 Department of Physiology, UCL
    
-->

<xsl:output method="text" indent="yes" />

<!--Main template-->
<xsl:template match="/mml:morphml">

<!--Some tests to ensure this MorphML file is really for a single compartmentalized neuron-->

<xsl:if test="count(/mml:morphml/mml:cells/mml:cell) !=1">
<xsl:text>******************************************************************************************
//  NOTE!! There should be one and only one /morphml/cells/cell in this MorphML file!! 
//  Only the first cell found will be converted.
******************************************************************************************

</xsl:text>
</xsl:if>


<xsl:if test="count(/mml:morphml/mml:features) &gt; 0">
<xsl:text>******************************************************************************************
//  NOTE!! There is a /morphml/features node in this MorphML file, however all information there will be ignored!!
******************************************************************************************

</xsl:text>
</xsl:if>


<xsl:if test="count(/mml:morphml/mml:cells/mml:cell/mml:cellBody) &gt; 0">
<xsl:text>******************************************************************************************
//  NOTE!! There is a cellBody element included in the cell in this file. This element is ignored in this conversion
******************************************************************************************

</xsl:text>
</xsl:if>


<xsl:if test="count(/mml:morphml/mml:cells/mml:cell/mml:freePoints) &gt; 0">
<xsl:text>******************************************************************************************
//  NOTE!! There is a freePoints element included in the cell in this file. This element is ignored in this conversion
******************************************************************************************

</xsl:text>
</xsl:if>


<xsl:if test="count(/mml:morphml/mml:cells/mml:cell/mml:spines) &gt; 0">
<xsl:text>******************************************************************************************
//  NOTE!! There is a spines element included in the cell in this file. This element is ignored in this conversion
******************************************************************************************

</xsl:text>
</xsl:if>



<!-- End of tests-->



<xsl:text>//  This is a GENESIS representation of the morphological components of a single cell from a MorphML file

</xsl:text>




<!--Optional name and notes-->
<xsl:apply-templates select="mml:notes"/>

<!--The basic stuff for GENESIS readcell files-->
<xsl:text>
*absolute
*cartesian
*asymmetric

</xsl:text>

<!-- Only do the first cell! A/c to W3C the first node is 1!! -->
<xsl:apply-templates select="/mml:morphml/mml:cells/mml:cell[1]"/>

</xsl:template>
<!--End Main template-->



<xsl:template match="/mml:morphml/mml:name">
<xsl:text>//  Name       : <xsl:value-of select="/mml:morphml/mml:name"/></xsl:text>
<xsl:text>
</xsl:text>
</xsl:template>


<xsl:template match="/mml:morphml/mml:notes">
<xsl:text>//  Description: </xsl:text><xsl:value-of select="/mml:morphml/mml:notes"/>
<xsl:text>
</xsl:text>
</xsl:template>



<!--Main Cell template-->
<xsl:template match="/mml:morphml/mml:cells/mml:cell">
   

    <xsl:apply-templates select="@name"/>    
    <xsl:apply-templates select="mml:notes"/>
    
    
    <xsl:text>
*compt /library/compartment
    </xsl:text>
    
    <xsl:choose>
        <xsl:when test="count(/mml:morphml/mml:cells/mml:cell/mml:segments/mml:segment/@parent) &lt;
                        count(/mml:morphml/mml:cells/mml:cell/mml:segments/mml:segment) -1">
<xsl:text>******************************************************************************************
//  NOTE!! There are more than 2 segments with no parent! Only the root segment should be parentless
******************************************************************************************


</xsl:text>
    </xsl:when>
    <xsl:otherwise>
        <xsl:apply-templates select="mml:segments"/>
    </xsl:otherwise>
</xsl:choose>
    
</xsl:template>
<!--End Main Cell template-->





<xsl:template match="/mml:morphml/mml:cells/mml:cell/@name">
<xsl:text>//  Cell Name       : </xsl:text><xsl:value-of select="/mml:morphml/mml:cells/mml:cell/@name"/>
<xsl:text>
</xsl:text>
</xsl:template>


<xsl:template match="/mml:morphml/mml:cells/mml:cell/mml:notes">
<xsl:text>//  Cell Description: </xsl:text><xsl:value-of select="/mml:morphml/mml:cells/mml:cell/mml:notes"/>
<xsl:text>
</xsl:text>
</xsl:template>


<xsl:template match="mml:segments">

<xsl:for-each select="mml:segment">
//  Adding compartment for Segment: <xsl:value-of select="@name"/> ID: <xsl:value-of select="@id"/>
<xsl:text>
</xsl:text>
    
    
        <xsl:variable name="segmentPrefix">Segment</xsl:variable>

        <xsl:variable name="startComp">
            <xsl:if test="count(@name) &gt; 0"><xsl:value-of select="@name"/></xsl:if>
            <xsl:if test="count(@name) = 0"><xsl:value-of select="$segmentPrefix"/><xsl:value-of select="@id"/></xsl:if>
        </xsl:variable>        
       

        
        <xsl:variable name="parentComp">
        <xsl:if test="count(@parent) = 1">
            <xsl:variable name="parent">
                <xsl:value-of select="@parent"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="count(//mml:segment[@id=$parent]) &gt; 0  and count(//mml:segment[@id=$parent]/@name) &gt; 0">
                   <xsl:value-of select="//mml:segment[@id=$parent]/@name"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$segmentPrefix"/><xsl:value-of select="@parent"/>
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:if>
        <xsl:if test="count(@parent) = 0">none</xsl:if>
        </xsl:variable>
        
        <!--If the first segment's endPoint = section start point-->
        <xsl:variable name="sphericalSegment">
            <xsl:choose>
                <xsl:when test="mml:distal/@x = mml:proximal/@x and 
                      mml:distal/@y = mml:proximal/@y and 
                      mml:distal/@z = mml:proximal/@z and
                      mml:distal/@diameter = mml:proximal/@diameter">yes</xsl:when>
                <xsl:otherwise>no</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>        
        
        <!--If the segment has its own (as opposed to parent's) start point -->
        <xsl:variable name="ownProximalPoint">
            <xsl:choose>
                <xsl:when test="count(mml:proximal) &gt; 0">yes</xsl:when>
                <xsl:otherwise>no</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="$sphericalSegment='yes'">
*spherical
        </xsl:if>
        
        <xsl:if test="$ownProximalPoint='yes' and $sphericalSegment='no'">
*double_endpoint
</xsl:if>  

        
        
        
        <xsl:value-of select="$startComp"/><xsl:text>  </xsl:text>
        <xsl:value-of select="$parentComp"/><xsl:text>   </xsl:text>
        <xsl:if test="$ownProximalPoint='yes' and $sphericalSegment='no'">
            <xsl:value-of select="mml:proximal/@x"/><xsl:text>   </xsl:text>
            <xsl:value-of select="mml:proximal/@y"/><xsl:text>   </xsl:text>
            <xsl:value-of select="mml:proximal/@z"/><xsl:text>   </xsl:text>
        </xsl:if>
        <xsl:value-of select="mml:distal/@x"/><xsl:text>   </xsl:text>
        <xsl:value-of select="mml:distal/@y"/><xsl:text>   </xsl:text>
        <xsl:value-of select="mml:distal/@z"/><xsl:text>   </xsl:text>
        <xsl:value-of select="mml:distal/@diameter"/><xsl:text>
</xsl:text>      
        
<xsl:if test="$sphericalSegment='yes'">*cylindrical
</xsl:if>  
<xsl:if test="$ownProximalPoint='yes' and $sphericalSegment='no'">*double_endpoint_off
</xsl:if>  
        
</xsl:for-each>

</xsl:template>



</xsl:stylesheet>

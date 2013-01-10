<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:nml="http://morphml.org/neuroml/schema"
xmlns:mml="http://morphml.org/morphml/schema">

<!--
    This file is used to convert MorphML files to NEURON template files
    Author: Padraig Gleeson
-->

<xsl:output method="text" indent="yes" />

<!--Main template-->
<xsl:template match="/">
<!--Some tests to ensure this MorphML file is really for a single compartmentalized neuron-->

<xsl:if test="count(/mml:morphml/mml:cells/mml:cell) =0 and 
                count(/nml:neuroml/nml:cells/nml:cell) =0">
<xsl:text>//******************************************************************************************
//  NOTE!! No cells/cell element has been found. This does not seem to be a NeuroML Level 2 file 
// containing a neuronal morphology. Files containing MorphML components or ChannelML components 
// (or both) can be Level 2 compliant
//******************************************************************************************

</xsl:text>
</xsl:if>

<xsl:if test="count(/mml:morphml/mml:cells/mml:cell) >1 or 
                count(/nml:neuroml/nml:cells/nml:cell) >1">
<xsl:text>******************************************************************************************
//  NOTE!! There should be one and only one cells/cell element in this NeuroML file!! 
//  Only the first cell found will be converted.
******************************************************************************************

</xsl:text>
</xsl:if>


<xsl:if test="count(/nml:neuroml/mml:features) &gt; 0">
<xsl:text>//******************************************************************************************
//  NOTE!! There is a /morphml/features node in this MorphML file, however all information there will be ignored!!
//******************************************************************************************

</xsl:text>
</xsl:if>


<xsl:if test="count(/nml:neuroml/nml:cells/nml:cell/mml:cellBody) &gt; 0">
<xsl:text>//******************************************************************************************
//  NOTE!! There is a cellBody element included in the cell in this file. This element is ignored in this conversion
//******************************************************************************************

</xsl:text>
</xsl:if>


<xsl:if test="count(/nml:neuroml/nml:cells/nml:cell/mml:freePoints) &gt; 0">
<xsl:text>//******************************************************************************************
//  NOTE!! There is a freePoints element included in the cell in this file. This element is ignored in this conversion
//******************************************************************************************

</xsl:text>
</xsl:if>


<xsl:if test="count(/mml:morphml/mml:cells/mml:cell/mml:spines) &gt; 0">
<xsl:text>//******************************************************************************************
//  NOTE!! There is a spines element included in the cell in this file. This element is ignored in this conversion
//******************************************************************************************

</xsl:text>
</xsl:if>



<!-- End of tests-->



<xsl:text>//  This is a NEURON representation of the morphological components of a single cell described in a NeuroML file
// NOTE: This file only converts the anatomical details, not any channel placement information

</xsl:text>


<!--Optional name and notes-->
<xsl:apply-templates select="@name"/>
<xsl:apply-templates select="/mml:morphml/mml:notes"/>

<!-- One or the other...-->
<xsl:apply-templates select="/mml:morphml"/>

<xsl:apply-templates select="/nml:neuroml"/>

</xsl:template>
<!--End Main template-->



<xsl:template match="/mml:morphml/@name">
<xsl:text>//  MorphML file       : <xsl:value-of select="/mml:morphml/@name"/></xsl:text>
<xsl:text>

</xsl:text>
</xsl:template>

<xsl:template match="/mml:morphml/mml:notes">
<xsl:text>//  Description: </xsl:text><xsl:value-of select="/mml:morphml/mml:notes"/>
<xsl:text>

</xsl:text>
</xsl:template>


<xsl:template match="/mml:morphml">
<!-- Only do the first cell! A/c to W3C the first node is 1!! -->
<xsl:apply-templates select="mml:cells/mml:cell[1]"/>
</xsl:template>

<xsl:template match="/nml:neuroml">
<!-- Only do the first cell! A/c to W3C the first node is 1!! -->
<xsl:apply-templates select="nml:cells/nml:cell[1]"/>
</xsl:template>


<!--Main Cell template MML-->
<xsl:template match="mml:cells/mml:cell">
    <xsl:variable name="cellName">
        <xsl:if test="count(@name) &gt; 0"><xsl:value-of select="@name"/></xsl:if>
        <xsl:if test="count(@name) = 0">GeneratedMorphMLCell</xsl:if>
    </xsl:variable>
//  Cell name: <xsl:value-of select="$cellName"/>
    <xsl:text>

</xsl:text>

<xsl:apply-templates select="/mml:morphml/mml:cells/mml:cell/mml:notes"/>
    
    <xsl:choose>
    <xsl:when test="count(/mml:morphml/mml:cells/mml:cell/mml:segments/mml:segment/@parent) &lt;
                        count(/mml:morphml/mml:cells/mml:cell/mml:segments/mml:segment) -1">
<xsl:text>//******************************************************************************************
//  NOTE!! There are more than 2 segments with no parent! Only the root segment should be parentless
//******************************************************************************************


</xsl:text>
    </xsl:when>
    <xsl:otherwise>
    
    <!--The basic stuff for NEURON templates-->
begintemplate <xsl:value-of select="$cellName"/>

    public init, shape
    public all

    objref all
    
    proc init() {
    shape()
    }

    
    <xsl:choose>
    <xsl:when test="count(/mml:morphml/mml:cells/mml:cell/mml:cables/mml:cable) = 0">
        <xsl:text>//******************************************************************************************
        //  There are no cables/sections specified! Each segment will be treated as an individual section.
        //  Ideally the morphology should be optimised into unbranched sections before being run in NEURON
        //******************************************************************************************

        
        <xsl:apply-templates select="mml:segments"/>

        </xsl:text>
    </xsl:when>
    <xsl:otherwise>

        <!--Sections have been found. Check to make sure all segments have a valid section!-->

        <xsl:if test="count(/mml:morphml/mml:cells/mml:cell/mml:segments/mml:segment/@cable) != 
            count(/mml:morphml/mml:cells/mml:cell/mml:segments/mml:segment)">
            <xsl:text>
            //******************************************************************************************
            //  Not every segment is specified as having a section/cable!! 
            //  Only the segments specifying a valid cable will be included!
            //******************************************************************************************

            </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="mml:cables"/>
    
    </xsl:otherwise>
    </xsl:choose>


endtemplate <xsl:value-of select="$cellName"/>

</xsl:otherwise>
</xsl:choose>

    
</xsl:template>
<!--End Main Cell template-->





<!--Main Cell template NML-->
<xsl:template match="nml:cells/nml:cell">
    <xsl:variable name="cellName">
        <xsl:if test="count(@name) &gt; 0"><xsl:value-of select="@name"/></xsl:if>
        <xsl:if test="count(@name) = 0">GeneratedMorphMLCell</xsl:if>
    </xsl:variable>
//  Cell name: <xsl:value-of select="$cellName"/>
    <xsl:text>

</xsl:text>

<xsl:apply-templates select="/nml:neuroml/nml:cells/nml:cell/mml:notes"/>
    
    <xsl:choose>
    <xsl:when test="count(/nml:neuroml/nml:cells/nml:cell/mml:segments/mml:segment/@parent) &lt;
                        count(/nml:neuroml/nml:cells/nml:cell/mml:segments/mml:segment) -1">
<xsl:text>//******************************************************************************************
//  NOTE!! There are more than 2 segments with no parent! Only the root segment should be parentless
//******************************************************************************************


</xsl:text>
    </xsl:when>
    <xsl:otherwise>
    
    <!--The basic stuff for NEURON templates-->
begintemplate <xsl:value-of select="$cellName"/>

    public init, shape
    public all

    objref all
    
    proc init() {
    shape()
    }

    
    <xsl:choose>
    <xsl:when test="count(/nml:neuroml/nml:cells/nml:cell/mml:cables/mml:cable) = 0">
        <xsl:text>//******************************************************************************************
        //  There are no cables/sections specified! Each segment will be treated as an individual section.
        //  Ideally the morphology should be optimised into unbranched sections before being run in NEURON
        //******************************************************************************************

        
        <xsl:apply-templates select="mml:segments"/>

        </xsl:text>
    </xsl:when>
    <xsl:otherwise>

        <!--Sections have been found. Check to make sure all segments have a valid section!-->

        <xsl:if test="count(/nml:neuroml/nml:cells/nml:cell/mml:segments/mml:segment/@cable) != 
            count(/nml:neuroml/nml:cells/nml:cell/mml:segments/mml:segment)">
            <xsl:text>
            //******************************************************************************************
            //  Not every segment is specified as having a section/cable!! 
            //  Only the segments specifying a valid cable will be included!
            //******************************************************************************************

            </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="mml:cables"/>
    
    </xsl:otherwise>
    </xsl:choose>


endtemplate <xsl:value-of select="$cellName"/>

</xsl:otherwise>
</xsl:choose>

    
</xsl:template>
<!--End Main Cell template-->



<xsl:template match="/nml:neuroml/nml:cells/nml:cell/mml:notes">
<xsl:text>//  Cell Description: </xsl:text><xsl:value-of select="/nml:neuroml/nml:cells/nml:cell/mml:notes"/>
<xsl:text>
</xsl:text>
</xsl:template>


<xsl:template match="mml:cables">

    <xsl:variable name="sectionPrefix">Section</xsl:variable>
    <xsl:variable name="segmentPrefix">Segment</xsl:variable>

    <text>//  Creating Sections
    </text>
    <xsl:for-each select="mml:cable">

    <xsl:variable name="sectionName">
        <xsl:if test="count(@name) &gt; 0"><xsl:value-of select="@name"/></xsl:if>
        <xsl:if test="count(@name) = 0"><xsl:value-of select="$sectionPrefix"/><xsl:value-of select="@id"/></xsl:if>
    </xsl:variable>  
    
    <text>
    create </text><xsl:value-of select="$sectionName"/>
    <text>
    public <xsl:value-of select="$sectionName"/>
    </text>
    
    
    </xsl:for-each>
    
    proc shape(){
    <xsl:for-each select="mml:cable">
        <xsl:variable name="sectionName">
            <xsl:if test="count(@name) &gt; 0"><xsl:value-of select="@name"/></xsl:if>
            <xsl:if test="count(@name) = 0"><xsl:value-of select="$sectionPrefix"/><xsl:value-of select="@id"/></xsl:if>
        </xsl:variable>      
        <xsl:variable name="sectionId"><xsl:value-of select="@id"/></xsl:variable>   
        //  Adding Section: <xsl:value-of select="$sectionName"/>, ID: <xsl:value-of select="$sectionId"/> to cell
        <xsl:value-of select="$sectionName"/><text>{
            pt3dclear()</text>
            <xsl:apply-templates select="../../mml:segments/mml:segment[@cable=$sectionId]"/>
        }
    <!--Back to looking in the section...-->
    <xsl:variable name="parentSection">
        <xsl:choose>
            <xsl:when test="count(../../mml:segments/mml:segment[@cable=$sectionId]) &gt; 0 and
                      count(../../mml:segments/mml:segment[@cable=$sectionId][1]/@parent) = 1">   
                <xsl:variable name="parentSegmentId">
                    <xsl:value-of select="../../mml:segments/mml:segment[@cable=$sectionId][1]/@parent"/>
                </xsl:variable>
                <xsl:variable name="parentSectionId">
                    <xsl:value-of select="../../mml:segments/mml:segment[@id=$parentSegmentId][1]/@cable"/>
                </xsl:variable>
                <xsl:value-of select="../../mml:cables/mml:cable[@id=$parentSectionId]/@name"/>
            </xsl:when>
            <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
    </xsl:variable>
    <text>    // Parent section of <xsl:value-of select="$sectionName"/> is: <xsl:value-of select="$parentSection"/>
    </text>
    <xsl:variable name="fractAlongParentSection">
        <xsl:if test="count(mml:fractAlongParent) &gt; 0">(<xsl:value-of select="mml:fractAlongParent"/>) 
        </xsl:if>
        <xsl:if test="count(mml:fractAlongParent) = 0">(1)</xsl:if>
    </xsl:variable>   
    
    
    <xsl:if test="$parentSection !='none'">
        connect <xsl:value-of select="$sectionName"/>(0), <xsl:value-of select="$parentSection"/><xsl:value-of select="$fractAlongParentSection"/>
<xsl:text>
</xsl:text>
    </xsl:if>
    <text>
        // Finished section: <xsl:value-of select="$sectionName"/> </text>
    <xsl:text>
</xsl:text>
 
</xsl:for-each>

    }// end shape()
</xsl:template>



<xsl:template match="mml:segments">
// Creating one Section for each segment...

    <xsl:variable name="sectionPrefix">Section</xsl:variable>
    <xsl:variable name="segmentPrefix">Segment</xsl:variable>

    <xsl:for-each select="mml:segment">

    <xsl:variable name="sectionName">
        <xsl:if test="count(@name) &gt; 0"><xsl:value-of select="@name"/>_section</xsl:if>
        <xsl:if test="count(@name) = 0"><xsl:value-of select="$sectionPrefix"/><xsl:value-of select="@id"/></xsl:if>
    </xsl:variable>  
    
    <text>
    create </text><xsl:value-of select="$sectionName"/>
    <text>
    public <xsl:value-of select="$sectionName"/>
    </text>

    </xsl:for-each>
        
    proc shape(){    
    <xsl:for-each select="mml:segment">
        <xsl:variable name="sectionName">
            <xsl:if test="count(@name) &gt; 0"><xsl:value-of select="@name"/>_section</xsl:if>
            <xsl:if test="count(@name) = 0"><xsl:value-of select="$sectionPrefix"/><xsl:value-of select="@id"/></xsl:if>
        </xsl:variable>  
                
        //  Adding Section: <xsl:value-of select="$sectionName"/>, ID: <xsl:value-of select="@id"/> to cell
        <xsl:value-of select="$sectionName"/><text>{
        pt3dclear()</text>

        <xsl:apply-templates select="."/>
        }
        <xsl:variable name="parentSection">
            <xsl:choose>
                <xsl:when test="count(@parent) &gt; 0">   
                    <xsl:variable name="parentSegmentId">
                        <xsl:value-of select="@parent"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="count(../../mml:segments/mml:segment[@id = $parentSegmentId]/@name) 
                                &gt; 0"><xsl:value-of select="../../mml:segments/mml:segment[@id = $parentSegmentId]/@name"/>_section</xsl:when>
                        <xsl:otherwise><xsl:value-of select="$sectionPrefix"/><xsl:value-of select="$parentSegmentId"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>none</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

    <text>// Parent section of <xsl:value-of select="$sectionName"/> is: 
    </text><xsl:value-of select="$parentSection"/><text>
    
    </text>
    
    <xsl:if test="$parentSection !='none'">    
    connect <xsl:value-of select="$sectionName"/>(0), <xsl:value-of select="$parentSection"/>(1)
    
    </xsl:if>
    
    <text>// Finished section: <xsl:value-of select="$sectionName"/></text>
 
    </xsl:for-each>
    }
    

    
</xsl:template>


<xsl:template match="mml:segment">
        <xsl:variable name="parentId"><xsl:value-of select="@parent"/></xsl:variable>  
        
        <!--If the first segment's endPoint = section start point-->
        <xsl:variable name="sphericalSection">
            <xsl:choose>
                <xsl:when test="mml:proximal/@x = mml:distal/@x and
                                mml:proximal/@y = mml:distal/@y and
                                mml:proximal/@z = mml:distal/@z and
                                mml:proximal/@diameter = @distal/@diameter">yes</xsl:when>
                <xsl:otherwise>no</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="string($sphericalSection)='yes'">
        <text>
        // Note: this section has a spherical segment, so a cylinder of the same surface area 
        // parallel to the y-axis is created instead</text>
        </xsl:if>  

        <xsl:if test="count(mml:proximal) &gt; 0">
            <text>
            pt3dadd(</text>
            <xsl:value-of select="mml:proximal/@x"/><text>, </text>
            <xsl:choose>
                <xsl:when test="string($sphericalSection)='no'">
                    <xsl:value-of select="mml:proximal/@y"/><text>, </text>
                </xsl:when>
                <xsl:otherwise>
                    <!--Shift the endPoints along the y axis to create a cylinder with the same surface area-->
                    <xsl:value-of select="number(mml:proximal/@y) - (number(mml:proximal/@diameter) div 2)"/><text>, </text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="mml:proximal/@z"/><text>, </text>
            <xsl:value-of select="mml:proximal/@diameter"/>) // proximal point of segment <xsl:value-of select="@name"/><xsl:text>
            </xsl:text>  
        </xsl:if>
        <xsl:variable name="segInSameSecAsParent">
        <xsl:value-of select="string(@cable = //mml:segment[string(@id)=string($parentId)]/@cable)"/>
        </xsl:variable>        
        <xsl:if test="count(mml:proximal) = 0 and ($segInSameSecAsParent='false')">
            <text>    // Note: there is no proximal point in segment: <xsl:value-of select="@name"/>, and it's in a different section than the parent
        pt3dadd(</text>
                <xsl:value-of select="//mml:segment[string(@id)=string($parentId)]/mml:distal/@x"/><text>, </text>
                <xsl:value-of select="//mml:segment[string(@id)=string($parentId)]/mml:distal/@y"/><text>, </text>
                <xsl:value-of select="//mml:segment[string(@id)=string($parentId)]/mml:distal/@z"/><text>, </text>
                <xsl:value-of select="//mml:segment[string(@id)=string($parentId)]/mml:distal/@diameter"/>) // distal point of segment <xsl:value-of select="//mml:segment[string(@id)=string($parentId)]/@name"/><xsl:text></xsl:text> 
        </xsl:if>
        <text>pt3dadd(</text>
        <xsl:value-of select="mml:distal/@x"/><text>, </text>
        <xsl:choose>
            <!--If spherical and first segment-->
            <xsl:when test="string($sphericalSection)='yes'">
                <!--Shift the endPoints along the y axis to create a cylinder with the same surface area-->
                <xsl:value-of select="number(mml:distal/@y) + (number(mml:distal/@diameter) div 2)"/><text>, </text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="mml:distal/@y"/><text>, </text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="mml:distal/@z"/><text>, </text>
        <xsl:value-of select="mml:distal/@diameter"/>) // distal point of segment <xsl:value-of select="@name"/><xsl:text>
            </xsl:text> 
         <!--end pt3dadd-->
</xsl:template>



</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:cml="http://morphml.org/channelml/schema">

<!--

    This file is used to convert ChannelML files to NEURON KS Channel Builder files
    NOTE: Not all cases allowable in the new ChannelML spec are implemented in this yet.
    
    This file has been developed as part of the neuroConstruct project
    
    Funding for this work has been received from the Medical Research Council
    
    Author: Padraig Gleeson
    Copyright 2006 Department of Physiology, UCL
    
-->

<xsl:output method="text" indent="yes" />

<xsl:variable name="xmlFileUnitSystem"><xsl:value-of select="/cml:channelml/@units"/></xsl:variable>   

<!--Main template-->

<xsl:template match="/cml:channelml">
<xsl:text>//  This is a NEURON Channel Builder file generated from a ChannelML file (preliminary version!)
//
//  NOTE: Not all cases allowable in the new ChannelML spec are implemented in this yet,
//  it's mostly just the Adk form of the channels that's supported. The mod file mapping
//  is the more flexible format.
//
//  It assumes the ChannelML file contains only a single conductance

</xsl:text>
// Unit system of ChannelML file: <xsl:value-of select="$xmlFileUnitSystem"/>

<xsl:apply-templates select ="cml:ion"/>

<xsl:if test="count(//cml:generic_equation_hh) &gt; 0">

//   ***********************************************************************
//     Note: Generic forms of the rate equations are not yet supported in
//     the mapping to Channel Builder. Use the mod file mapping instead.
//     Let me know (p.gleeson -at- ucl.ac.uk) if you need them...
//   ***********************************************************************

</xsl:if>
<!-- Only do the first channel -->
<xsl:apply-templates select ="cml:channel_type"/>

<xsl:if test="count(cml:ion_concentration) &gt; 0">

//   ***********************************************************************
//     Note: ion concentrations are not supported in the first version of
//     this mapping to Channel Builder. Use the mod file mapping instead.
//   ***********************************************************************

</xsl:if>

</xsl:template>
<!--End Main template-->


<xsl:template match="cml:ion">
{ ion_register("<xsl:value-of select="@name"/>", <xsl:value-of select="@charge"/>) }</xsl:template>

<xsl:template match="cml:channel_type">
objref ks, ksvec, ksgate, ksstates, kstransitions, tobj
{
  ksvec = new Vector()
  ksstates = new List()
  kstransitions = new List()
  ks = new KSChan(0)
}

<xsl:variable name="ionname"><xsl:value-of select="cml:current_voltage_relation/cml:ohmic/@ion"/></xsl:variable>   

{
  ks.name("<xsl:value-of select="@name"/>")
  ks.ion("<xsl:value-of select="cml:current_voltage_relation/cml:ohmic/@ion"/>")
  ks.iv_type(0)
  ks.gmax(<xsl:call-template name="convert">
            <xsl:with-param name="value" select="cml:current_voltage_relation/cml:ohmic/cml:conductance/@default_gmax"/>
            <xsl:with-param name="quantity">Conductance Density</xsl:with-param>
          </xsl:call-template>)
          
  ks.erev(<xsl:call-template name="convert">
            <xsl:with-param name="value" select="/cml:channelml/cml:ion[@name=$ionname]/@default_erev"/>
            <xsl:with-param name="quantity">Voltage</xsl:with-param>
            </xsl:call-template>)
}


<xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate">
// Adding information for gate: <xsl:value-of select="cml:state/@name"/>

{
  ksstates.append(ks.add_hhstate("<xsl:value-of select="cml:state/@name"/>"))
  ksgate = ksstates.object(0).gate
  ksgate.power(<xsl:value-of select="@power"/>)
  kstransitions.append(ks.trans(ksstates.object(0), ksstates.object(0)))
}
{
<xsl:for-each select="cml:state/cml:transition">
  tobj = kstransitions.object(0)
  tobj.type(0)
  <xsl:for-each select="cml:voltage_gate/cml:alpha/cml:parameterised_hh">   
  // Function type = <xsl:value-of select="@type"/>, A = <xsl:value-of select="cml:parameter[@name='A']/@value"/>, k = <xsl:value-of select="cml:parameter[@name='k']/@value"/>, d = <xsl:value-of select="cml:parameter[@name='d']/@value"/>
  tobj.set_f(0, <xsl:call-template name="getFunctionForm"><xsl:with-param name="stringFunctionName"
                select="@type" /></xsl:call-template>, ksvec.c.append(<xsl:value-of 
                select="cml:parameter[@name='A']/@value"/>, <xsl:value-of 
                select="cml:parameter[@name='k']/@value"/>, <xsl:value-of 
                select="cml:parameter[@name='d']/@value"/>))
  </xsl:for-each>
  <xsl:for-each select="cml:voltage_gate/cml:beta/cml:parameterised_hh">    
  // Function type = <xsl:value-of select="@type"/>, A = <xsl:value-of select="cml:parameter[@name='A']/@value"/>, k = <xsl:value-of select="cml:parameter[@name='k']/@value"/>, d = <xsl:value-of select="cml:parameter[@name='d']/@value"/>
  tobj.set_f(1, <xsl:call-template name="getFunctionForm"><xsl:with-param name="stringFunctionName"
                select="@type" /></xsl:call-template>, ksvec.c.append(<xsl:value-of 
                select="cml:parameter[@name='A']/@value"/>, <xsl:value-of 
                select="cml:parameter[@name='k']/@value"/>, <xsl:value-of 
                select="cml:parameter[@name='d']/@value"/>))
  </xsl:for-each>
</xsl:for-each>
}
{ ksstates.remove_all  kstransitions.remove_all }    
</xsl:for-each>

{objref ks, ksvec, ksgate, ksstates, kstransitions, tobj}

</xsl:template>


<!-- Function to return 2 for exponential, 4 for sigmoid, 3 for linoid-->
<xsl:template name="getFunctionForm">
    <xsl:param name="stringFunctionName" />
    <xsl:choose>
        <xsl:when test="$stringFunctionName = 'exponential'">2</xsl:when>
        <xsl:when test="$stringFunctionName = 'sigmoid'">4</xsl:when>
        <xsl:when test="$stringFunctionName = 'linoid'">3</xsl:when>       
    </xsl:choose>
</xsl:template>



<!-- Function to get value converted to proper units. Note: this doesn't yet deal with the 
        rate equation parameters!!-->
<xsl:template name="convert">
    <xsl:param name="value" />
    <xsl:param name="quantity" />
    <xsl:choose> 
        <xsl:when test="$xmlFileUnitSystem  = 'Physiological Units'">
            <xsl:choose>
                <xsl:when test="$quantity = 'Conductance Density'"><xsl:value-of select="number($value div 1000)"/></xsl:when>
                <xsl:when test="$quantity = 'Voltage'"><xsl:value-of select="$value"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="number($value)"/></xsl:otherwise>
            </xsl:choose>
        </xsl:when>           
        <xsl:when test="$xmlFileUnitSystem  = 'SI Units'">
            <xsl:choose>
                <xsl:when test="$quantity = 'Conductance Density'"><xsl:value-of select="number($value div 10000)"/></xsl:when>
                <xsl:when test="$quantity = 'Voltage'"><xsl:value-of select="number($value * 1000)"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="number($value)"/></xsl:otherwise>
            </xsl:choose>
        </xsl:when>   
        <xsl:when test="$xmlFileUnitSystem  = 'SI Units'">si</xsl:when>   
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>

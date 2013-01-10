<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:meta="http://morphml.org/metadata/schema" 
    xmlns:cml="http://morphml.org/channelml/schema">

<!--

    This file is used to convert v1.1 ChannelML files to NEURON mod files

    This file has been developed as part of the neuroConstruct project
    
    Funding for this work has been received from the Medical Research Council
    
    Author: Padraig Gleeson
    Copyright 2006 Department of Physiology, UCL
    
-->

<xsl:output method="text" indent="yes" />

<xsl:variable name="xmlFileUnitSystem"><xsl:value-of select="/cml:channelml/@units"/></xsl:variable>   

<!--Main template-->

<xsl:template match="/cml:channelml">
?  This is a NEURON mod file generated from a v1.1 ChannelML file

?  Unit system of ChannelML file: <xsl:value-of select="$xmlFileUnitSystem"/><xsl:text>
</xsl:text>
<xsl:if test="count(meta:notes) &gt; 0">

COMMENT
    <xsl:value-of select="meta:notes"/>
ENDCOMMENT
</xsl:if>
<!-- Only do the first channel -->
<xsl:apply-templates  select="cml:channel_type"/>

<!-- Do the ion concentrations if there -->
<xsl:apply-templates  select="cml:ion_concentration"/>

<!-- Do a synapse if there -->
<xsl:apply-templates  select="cml:synapse_type"/>

</xsl:template>
<!--End Main template-->

<xsl:template match="cml:channel_type">
TITLE Channel: <xsl:value-of select="@name"/>

<xsl:if test="count(meta:notes) &gt; 0">

COMMENT
    <xsl:value-of select="meta:notes"/>
ENDCOMMENT
</xsl:if>

UNITS {
    (mA) = (milliamp)
    (mV) = (millivolt)
    (S) = (siemens)
    (um) = (micrometer)
    (molar) = (1/liter)
    (mM) = (millimolar)
    (l) = (liter)
}

<xsl:variable name="nonSpecificCurrent">
    <xsl:choose>
        <xsl:when test="cml:current_voltage_relation/cml:ohmic/@ion='non_specific'">yes</xsl:when>
        <xsl:otherwise>no</xsl:otherwise>
    </xsl:choose>
</xsl:variable>
<!-- Whether there is a voltage and concentration depemnence in the channel-->
<xsl:variable name="voltConcDependence">
    <xsl:choose>
        <xsl:when test="count(//cml:voltage_conc_gate) &gt; 0">yes</xsl:when>
        <xsl:otherwise>no</xsl:otherwise>
    </xsl:choose>
</xsl:variable>
    
NEURON {
    SUFFIX <xsl:value-of select="@name"/>
    
    <xsl:for-each select="/cml:channelml/cml:ion[@name!='non_specific']">
        <xsl:choose>
            <xsl:when test ="@role='RateDependence'">
    USEION <xsl:value-of select="@name"/> READ <xsl:value-of select="@name"/>i VALENCE <xsl:value-of select="@charge"/> ? internal concentration of ion is read
            </xsl:when>
            <xsl:when test ="@role='ConcVaries'">
    USEION <xsl:value-of select="@name"/> READ i<xsl:value-of select="@name"/> WRITE <xsl:value-of select="@name"/>i VALENCE <xsl:value-of select="@charge"/> ? outgoing current of ion is read, internal concentration is written
            </xsl:when>
            <xsl:otherwise>
    USEION <xsl:value-of select="@name"/> READ e<xsl:value-of select="@name"/> WRITE i<xsl:value-of select="@name"/> VALENCE <xsl:value-of select="@charge"/> ? reversal potential of ion is read, outgoing current is written
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:for-each>
    
    <xsl:if test="string($nonSpecificCurrent)='yes'">
    ? A non specific current is present
    RANGE e
    NONSPECIFIC_CURRENT i
    </xsl:if>
    RANGE gmax, gion
    <xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate">
    RANGE <xsl:value-of select="cml:state/@name"/>inf, <xsl:value-of select="cml:state/@name"/>tau
    </xsl:for-each>
}

PARAMETER { 
    gmax = <xsl:call-template name="convert">
            <xsl:with-param name="value" select="cml:current_voltage_relation/cml:ohmic/cml:conductance/@default_gmax"/>
            <xsl:with-param name="quantity">Conductance Density</xsl:with-param>
          </xsl:call-template> (S/cm2) 
    <xsl:if test="string($nonSpecificCurrent)='yes'">
    e = <xsl:call-template name="convert">
            <xsl:with-param name="value" select="/cml:channelml/cml:ion[@name='non_specific']/@default_erev"/>
            <xsl:with-param name="quantity">Voltage</xsl:with-param>
            </xsl:call-template> (mV)
    </xsl:if>
}



ASSIGNED {
    v (mV)
    <xsl:choose>
        <xsl:when test="string($nonSpecificCurrent)='yes'">    
    i (mA/cm2)
        </xsl:when>
        <xsl:otherwise>
    celsius (degC)
    <xsl:for-each select="/cml:channelml/cml:ion[@name!='non_specific']">
        <xsl:choose>
            <xsl:when test ="@role='RateDependence'">
    ? The internal concentration of ion: <xsl:value-of select="@name"/> is used in the rate equations...
    <xsl:value-of select="@name"/>i (mM)           
            </xsl:when>
            <xsl:when test ="@role='ConcVaries'">
            ? Error!! ion: <xsl:value-of select="@name"/> with role="ConcVaries" shouldn't be in a channel_type...
            </xsl:when>
            <xsl:otherwise>
    ? Reversal potential of <xsl:value-of select="@name"/>
    e<xsl:value-of select="@name"/> (mV)
    ? The outward flow of ion: <xsl:value-of select="@name"/> calculated by rate equations...
    i<xsl:value-of select="@name"/> (mA/cm2)
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>
    gion (S/cm2)
    <xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate">
<xsl:value-of select="cml:state/@name"/>inf<xsl:text>
    </xsl:text><xsl:value-of select="cml:state/@name"/>tau (ms)<xsl:text>
    </xsl:text></xsl:for-each>
        </xsl:otherwise>
        </xsl:choose>
}

BREAKPOINT {
    <xsl:choose>
        <xsl:when test="string($nonSpecificCurrent)='yes'">
    i = gmax*(v - e) 
        </xsl:when>
        <xsl:otherwise>
    <xsl:choose><xsl:when test="$voltConcDependence='yes'">SOLVE states METHOD derivimplicit</xsl:when> <!-- Needed for concentration dependence-->
    <xsl:when test="count(cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate) &gt; 0">SOLVE states METHOD cnexp</xsl:when> <!-- When it's not a nonSpecificCurrent but there are no gates, this statement is not needed-->
    </xsl:choose>
    
    gion = gmax<xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate">*((<xsl:value-of select="cml:state/@fraction"/>*<xsl:value-of select="cml:state/@name"/>)^<xsl:value-of select="@power"/>)</xsl:for-each>
    
            <xsl:for-each select="/cml:channelml/cml:ion">
                <xsl:if test ="count(@role) = 0 or @role='Transmitted'">
    i<xsl:value-of select="@name"/> = gion*(v - e<xsl:value-of select="@name"/>)
                </xsl:if>
            </xsl:for-each>
        </xsl:otherwise>
        </xsl:choose>
}
    
<xsl:if test="count(cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate) &gt; 0">
INITIAL {
    <xsl:variable name="ionname"><xsl:value-of select="cml:current_voltage_relation/cml:ohmic/@ion"/></xsl:variable>  
    <xsl:variable name="defaultErev"><xsl:call-template name="convert">
        <xsl:with-param name="value" select="/cml:channelml/cml:ion[@name=$ionname]/@default_erev"/>
        <xsl:with-param name="quantity">Voltage</xsl:with-param>
        </xsl:call-template>
    </xsl:variable>
    <xsl:for-each select="/cml:channelml/cml:ion">
    <xsl:if test ="count(@role) = 0 or @role='Transmitted'">e<xsl:value-of select="@name"/> = <xsl:value-of select="$defaultErev"/><xsl:text>
        </xsl:text>
            </xsl:if>
        </xsl:for-each>
        
        <xsl:choose>
            <xsl:when test="$voltConcDependence='yes'">
    settables(v,cai)
    </xsl:when>
            <xsl:otherwise>
    rates(v)
    </xsl:otherwise>
        </xsl:choose>
    
    <xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate">
    <xsl:value-of select="cml:state/@name"/> = <xsl:value-of select="cml:state/@name"/>inf<xsl:text>
    </xsl:text></xsl:for-each>
}
    
STATE {
    <xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate">
    <xsl:value-of select="cml:state/@name"/><xsl:text>
    </xsl:text>
    </xsl:for-each>
}

DERIVATIVE states {
    <xsl:choose>
        <xsl:when test="$voltConcDependence='yes'">settables(v,cai)
    </xsl:when>
        <xsl:otherwise>rates(v)
    </xsl:otherwise>
    </xsl:choose>
    <xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate">
    <xsl:value-of select="cml:state/@name"/>' = (<xsl:value-of select="cml:state/@name"/>inf - <xsl:value-of select="cml:state/@name"/>)/<xsl:value-of select="cml:state/@name"/>tau<xsl:text>
    </xsl:text></xsl:for-each>
}

<xsl:choose>
        <xsl:when test="$voltConcDependence='yes'">PROCEDURE settables(v(mV), cai(mM)) { </xsl:when>
        <xsl:otherwise>PROCEDURE rates(v(mV)) { </xsl:otherwise>
    </xsl:choose> 
    
    ? Note, not all of these may be used, depending on the form of rate equations
    LOCAL  alpha, beta, A, B, k, d, tau, inf, temp_adj<xsl:for-each select='cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate/cml:state/cml:transition/cml:voltage_conc_gate/cml:conc_dependence'
    >, <xsl:value-of select="@variable_name"/> </xsl:for-each>
    
    <xsl:variable name="numGates"><xsl:value-of select="count(cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate)"/></xsl:variable>
    <xsl:if test="$voltConcDependence='no'">? May be too many table points and too wide a range...
    TABLE <xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate"><xsl:value-of 
    select="cml:state/@name"/>inf, <xsl:value-of select="cml:state/@name"/>tau<xsl:if test="position() &lt; number($numGates)">,</xsl:if> </xsl:for-each> DEPEND celsius FROM -100 TO 100 WITH 400</xsl:if>
    
    
    UNITSOFF
    <xsl:choose>
        <xsl:when test="count(cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:q10_settings) &gt; 0">
    ? There is a Q10 factor which will alter the tau of the gates 
    temp_adj = <xsl:value-of select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:q10_settings/@q10_factor"
    />^((celsius - <xsl:value-of select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:q10_settings/@experimental_temp"/>)/10)
        </xsl:when>
        <xsl:otherwise>
    temp_adj = 1
        </xsl:otherwise>
    </xsl:choose>
    
    <xsl:if test="count(cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:offset) &gt; 0">
    ? There is a voltage offset of <xsl:value-of select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:offset/@value"/>. This will shift the dependency of the rate equations 
    v = v - (<xsl:call-template name="convert">
            <xsl:with-param name="value" select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:rate_adjustments/cml:offset/@value"/>
            <xsl:with-param name="quantity">Voltage</xsl:with-param>
            </xsl:call-template>)<xsl:text>
    </xsl:text>          
    </xsl:if>
    
    
    <xsl:for-each select="cml:current_voltage_relation/cml:ohmic/cml:conductance/cml:gate">
        <xsl:for-each select='cml:state/cml:transition/cml:voltage_conc_gate/cml:conc_dependence'>
    ? Gate depends on the concentration of <xsl:value-of select="@ion"/><xsl:text>
    </xsl:text>   
    <xsl:value-of select="@variable_name"/> = <xsl:value-of select="@ion"/>i ? In NEURON, the variable for the concentration  of <xsl:value-of select="@ion"/> is <xsl:value-of select="@ion"/>i
    </xsl:for-each>
        
    ?      ***  Adding rate equations for gate: <xsl:value-of select="cml:state/@name"/>  ***<xsl:text>
        </xsl:text>   
    <xsl:for-each select='cml:state/cml:transition/cml:voltage_gate/* | 
                          cml:state/cml:transition/cml:voltage_conc_gate/*'>
        
        <xsl:if  test="name()!='conc_dependence'">
            <xsl:choose>
                <xsl:when  test="count(cml:parameterised_hh) &gt; 0">
    ? Found a parameterised form of rate equation for <xsl:value-of select="name()"/>, using expression: <xsl:value-of select="cml:parameterised_hh/@expr" /><xsl:text>
    </xsl:text>   
    
                    <xsl:for-each select="cml:parameterised_hh/cml:parameter">
    <xsl:value-of select="@name"/> = <xsl:value-of select="@value"/><xsl:text>
    </xsl:text>
                    </xsl:for-each>
    
                    <xsl:if test="$xmlFileUnitSystem  = 'SI Units'">
    ? Unit system in ChannelML file is SI units, therefore need to 
    ? convert these to NEURON quanities...
                        <xsl:choose>
                            <xsl:when test="string(name()) = 'alpha' or string(name()) = 'beta'">
    A = A * <xsl:call-template name="convert">
                <xsl:with-param name="value">1</xsl:with-param>
                <xsl:with-param name="quantity">InvTime</xsl:with-param>
            </xsl:call-template>   ? 1/ms
                            </xsl:when>
                            <xsl:when test="string(name()) = 'tau'">
    A = A * <xsl:call-template name="convert">
            <xsl:with-param name="value">1</xsl:with-param>
            <xsl:with-param name="quantity">Time</xsl:with-param>
        </xsl:call-template>   ? ms
                            </xsl:when>
                            <xsl:when test="string(name()) = 'inf'">
    A = A   ? Dimensionless
                            </xsl:when>
                        </xsl:choose>
    k = k * <xsl:call-template name="convert">
            <xsl:with-param name="value">1</xsl:with-param>
            <xsl:with-param name="quantity">InvVoltage</xsl:with-param>
          </xsl:call-template>   ? mV
    d = d * <xsl:call-template name="convert">
            <xsl:with-param name="value">1</xsl:with-param>
            <xsl:with-param name="quantity">Voltage</xsl:with-param>
          </xsl:call-template>   ? mV
          
                    </xsl:if>
    B = 1/k<xsl:text> 
    
    </xsl:text>
                    <xsl:choose>
                        <xsl:when test="cml:parameterised_hh/@type='exponential'">
    <xsl:value-of select="name()"/> = A * exp((v - d) / B)<xsl:text>
    
    </xsl:text>
                        </xsl:when>
                        <xsl:when test="cml:parameterised_hh/@type='sigmoid'">
    <xsl:value-of select="name()"/> = A / (exp((v - d) / B) + 1)<xsl:text>
    
    </xsl:text>
                        </xsl:when>
                        <xsl:when test="cml:parameterised_hh/@type='linoid'">
    <xsl:value-of select="name()"/> = A * vtrap((v - d), B)<xsl:text>
    
    </xsl:text>
                        </xsl:when>
                    </xsl:choose>
    
    
                </xsl:when>
                <xsl:when test="count(cml:generic_equation_hh) &gt; 0">
    ? Found a generic form of rate equation for <xsl:value-of select="name()"/>, using expression: <xsl:value-of select="cml:generic_equation_hh/@expr" /><xsl:text>
                    </xsl:text>  
                    <xsl:if test="string($xmlFileUnitSystem) = 'SI Units'">
    ? Note: Equation (and all ChannelML file values) in <xsl:value-of select="$xmlFileUnitSystem"/> so need to convert v first...<xsl:text>
    </xsl:text>
    v = v * <xsl:call-template name="convert">
                <xsl:with-param name="value">1</xsl:with-param>
                <xsl:with-param name="quantity">InvVoltage</xsl:with-param>
            </xsl:call-template>   ? temporarily set v to units of equation...<xsl:text>
            
    </xsl:text>
                        <xsl:if test="(name()='tau' or name()='inf') and 
                      (contains(string(cml:generic_equation_hh/@expr), 'alpha') or
                       contains(string(cml:generic_equation_hh/@expr), 'beta'))">
    ? Equation depends on alpha/beta, so converting them too...
    alpha = alpha * <xsl:call-template name="convert">
                        <xsl:with-param name="value">1</xsl:with-param>
                        <xsl:with-param name="quantity">Time</xsl:with-param>
                    </xsl:call-template>  
    beta = beta * <xsl:call-template name="convert">
                        <xsl:with-param name="value">1</xsl:with-param>
                        <xsl:with-param name="quantity">Time</xsl:with-param>   
                    </xsl:call-template>     
                        </xsl:if>
                    </xsl:if>
                    
    <xsl:call-template name="formatExpression">
        <xsl:with-param name="variable">
            <xsl:value-of select="name()"/>
        </xsl:with-param>
        <xsl:with-param name="oldExpression">
            <xsl:value-of select="cml:generic_equation_hh/@expr" />
        </xsl:with-param>
    </xsl:call-template>
    <xsl:if test="string($xmlFileUnitSystem) = 'SI Units'">
        
        <xsl:if test="name()='alpha' or name()='beta'">
    ? Set correct units of <xsl:value-of select="name()"/> for NEURON<xsl:text>
    </xsl:text>    
    <xsl:value-of select="name()"/> = <xsl:value-of select="name()"/> * <xsl:call-template name="convert">
                            <xsl:with-param name="value">1</xsl:with-param>
                            <xsl:with-param name="quantity">InvTime</xsl:with-param>
                        </xsl:call-template>
        </xsl:if>  
                                      
        <xsl:if test="name()='tau'">
    ? Set correct units of <xsl:value-of select="name()"/> for NEURON<xsl:text>
    </xsl:text>
    <xsl:value-of select="name()"/> = <xsl:value-of select="name()"/> * <xsl:call-template name="convert">
                    <xsl:with-param name="value">1</xsl:with-param>
                    <xsl:with-param name="quantity">Time</xsl:with-param>
                </xsl:call-template>
        </xsl:if> 
    
    v = v * <xsl:call-template name="convert">
                <xsl:with-param name="value">1</xsl:with-param>
                <xsl:with-param name="quantity">Voltage</xsl:with-param>
            </xsl:call-template>   ? reset v
        <xsl:if test="(name()='tau' or name()='inf') and 
                      (contains(string(cml:generic_equation_hh/@expr), 'alpha') or
                       contains(string(cml:generic_equation_hh/@expr), 'beta'))">
    alpha = alpha * <xsl:call-template name="convert">
                        <xsl:with-param name="value">1</xsl:with-param>
                        <xsl:with-param name="quantity">InvTime</xsl:with-param>
                    </xsl:call-template>  ? resetting alpha
    beta = beta * <xsl:call-template name="convert">
                        <xsl:with-param name="value">1</xsl:with-param>
                        <xsl:with-param name="quantity">InvTime</xsl:with-param>   
                    </xsl:call-template>  ? resetting beta
        </xsl:if>
    </xsl:if>      <xsl:text>
    </xsl:text>  
           
            </xsl:when>
            <xsl:otherwise>
    ? ERROR: Unrecognised form of the rate equation for <xsl:value-of select="name()"/>
            
            </xsl:otherwise>
        </xsl:choose>
                
       <xsl:if test="name()='tau'">
    <xsl:value-of select="../../../@name"/>tau = tau/temp_adj<xsl:text>
    </xsl:text>   
       </xsl:if>    
                   
       <xsl:if test="name()='inf'">
    <xsl:value-of select="../../../@name"/>inf = inf<xsl:text>
    </xsl:text>   
       </xsl:if>
      </xsl:if>
    </xsl:for-each>
    
    <!-- Finishing off the alpha & beta to tau & inf conversion... -->

         
        <xsl:if test="count(cml:state/cml:transition/cml:voltage_gate/cml:tau)=0">
    <xsl:value-of select="cml:state/@name"/>tau = 1/(temp_adj*(alpha + beta))<xsl:text>
    </xsl:text>
       </xsl:if>       
         
       <xsl:if test="count(cml:state/cml:transition/cml:voltage_gate/cml:inf)=0">
    <xsl:value-of select="cml:state/@name"/>inf = alpha/(alpha + beta)<xsl:text>
    </xsl:text>
       </xsl:if>    
       
    
    ?     *** Finished rate equations for gate: <xsl:value-of select="cml:state/@name"/> ***

    </xsl:for-each>
}

FUNCTION vtrap(VminV0, B) {
    if (fabs(VminV0/B) &lt; 1e-6) {
    vtrap = (1 + VminV0/B/2)
}else{
    vtrap = (VminV0 / B) /(1 - exp((-1 *VminV0)/B))
    }
}

UNITSON


</xsl:if>

</xsl:template> <!--end of <xsl:template match="cml:channel_type">-->


<xsl:template match="cml:ion_concentration">
<!-- Based on Louise Whiteley's implementation of this while on rotation in the Silver Lab-->
? Creating ion concentration

TITLE Channel: <xsl:value-of select="@name"/>

<xsl:if test="count(meta:notes) &gt; 0">

COMMENT
    <xsl:value-of select="meta:notes"/>
ENDCOMMENT
</xsl:if>

UNITS {
    (mV) = (millivolt)
    (mA) = (milliamp)
    (um) = (micrometer)
    (l) = (liter)
    (molar) = (1/liter)
    (mM) = (millimolar)
}

    
NEURON {
    SUFFIX <xsl:value-of select="@name"/>
    
    <xsl:for-each select="/cml:channelml/cml:ion[@name!='non_specific']">
    USEION <xsl:value-of select="@name"/> READ i<xsl:value-of select="@name"/> WRITE <xsl:value-of select="@name"/>i VALENCE <xsl:value-of select="@charge"/>
  
    </xsl:for-each>
    
    <xsl:variable name="ionused"><xsl:value-of select="cml:ion_species"/></xsl:variable>
    <xsl:variable name="valency"><xsl:value-of select="/cml:channelml/cml:ion[@name=$ionused]/@charge"/></xsl:variable>
    
    RANGE <xsl:value-of select="$ionused"/>i
    
    RANGE rest_conc, tau, F, thickness
    
    GLOBAL volume, surf_area, total_current

}

ASSIGNED {

    i<xsl:value-of select="$ionused"/> (mA/cm2)
    diam (um)
}

INITIAL {
    LOCAL shell_inner_diam

    <xsl:value-of select="$ionused"/>i = rest_conc
    shell_inner_diam = diam - (2*thickness)
    
    volume = (diam*diam*diam)*3.14159/6 - (shell_inner_diam*shell_inner_diam*shell_inner_diam)*3.14159/6
    
    surf_area = (diam*diam)*3.14159

}

PARAMETER {

    rest_conc = <xsl:call-template name="convert">
                    <xsl:with-param name="value"><xsl:value-of select="cml:decaying_pool_model/cml:resting_conc"/></xsl:with-param>
              <xsl:with-param name="quantity">Concentration</xsl:with-param>
          </xsl:call-template> (mM)
    tau = <xsl:call-template name="convert">
              <xsl:with-param name="value"><xsl:value-of select="cml:decaying_pool_model/cml:decay_constant"/></xsl:with-param>
              <xsl:with-param name="quantity">Time</xsl:with-param>
          </xsl:call-template> (ms)
    F = 96494 (C)
    thickness = <xsl:call-template name="convert">
                    <xsl:with-param name="value"><xsl:value-of select="cml:decaying_pool_model/cml:pool_volume_info/cml:shell_thickness"/></xsl:with-param>
                    <xsl:with-param name="quantity">Length</xsl:with-param>
                </xsl:call-template> (um)	
                
    volume
    total_current
    surf_area
}

STATE {

    <xsl:value-of select="$ionused"/>i (mM)

}

BREAKPOINT {

    SOLVE conc METHOD derivimplicit

}

DERIVATIVE conc {
    LOCAL thickness_cm, surf_area_cm2, volume_cm3 ? Note, normally dimensions are in um, but curr dens is in mA/cm2, etc
    
    thickness_cm = thickness *(1e-4)
    surf_area_cm2 = surf_area * 1e-8
    volume_cm3 = volume * 1e-12
    
    total_current = i<xsl:value-of select="$ionused"/> * surf_area_cm2


    <xsl:value-of select="$ionused"/>i' =  ((-1 * total_current)/(<xsl:value-of select="$valency"/> * F * volume_cm3)) - ((<xsl:value-of select="$ionused"/>i - rest_conc)/tau)

}

</xsl:template>  <!--<xsl:template match="cml:ion_concentration">-->


<!-- Function to get value converted to proper units.-->
<xsl:template name="convert">
    <xsl:param name="value" />
    <xsl:param name="quantity" />
    <xsl:choose> 
        <xsl:when test="$xmlFileUnitSystem  = 'Physiological Units'">
            <xsl:choose>
                <xsl:when test="$quantity = 'Conductance Density'"><xsl:value-of select="number($value div 1000)"/></xsl:when>
                <xsl:when test="$quantity = 'Conductance'"><xsl:value-of select="number($value * 1000)"/></xsl:when>
                <xsl:when test="$quantity = 'Voltage'"><xsl:value-of select="$value"/></xsl:when> <!-- same -->
                <xsl:when test="$quantity = 'InvVoltage'"><xsl:value-of select="$value"/></xsl:when> <!-- same -->
                <xsl:when test="$quantity = 'Time'"><xsl:value-of select="number($value)"/></xsl:when> <!-- same -->
                <xsl:when test="$quantity = 'Length'"><xsl:value-of select="number($value * 10000)"/></xsl:when> <!-- same -->
                <xsl:when test="$quantity = 'InvTime'"><xsl:value-of select="number($value)"/></xsl:when> <!-- same --> 

                <xsl:otherwise><xsl:value-of select="number($value)"/></xsl:otherwise>
            </xsl:choose>
        </xsl:when>           
        <xsl:when test="$xmlFileUnitSystem  = 'SI Units'">
            <xsl:choose>
                <xsl:when test="$quantity = 'Conductance Density'"><xsl:value-of select="number($value div 10000)"/></xsl:when>
                <xsl:when test="$quantity = 'Conductance'"><xsl:value-of select="number($value * 1000000)"/></xsl:when>
                <xsl:when test="$quantity = 'Voltage'"><xsl:value-of select="number($value * 1000)"/></xsl:when>
                <xsl:when test="$quantity = 'InvVoltage'"><xsl:value-of select="$value div 1000"/></xsl:when>
                <xsl:when test="$quantity = 'Length'"><xsl:value-of select="number($value * 1000000)"/></xsl:when>
                <xsl:when test="$quantity = 'Time'"><xsl:value-of select="number($value * 1000)"/></xsl:when>
                <xsl:when test="$quantity = 'InvTime'"><xsl:value-of select="number($value div 1000)"/></xsl:when>
                <xsl:when test="$quantity = 'Concentration'"><xsl:value-of select="number($value)"/></xsl:when>

                <xsl:otherwise><xsl:value-of select="number($value)"/></xsl:otherwise>
            </xsl:choose>
        </xsl:when>   
    </xsl:choose>
</xsl:template>



<xsl:template match="cml:synapse_type">
? Creating synaptic mechanism, based on NEURON source impl of Exp2Syn

TITLE Channel: <xsl:value-of select="@name"/>

<xsl:if test="count(meta:notes) &gt; 0">

COMMENT
    <xsl:value-of select="meta:notes"/>
ENDCOMMENT
</xsl:if>

UNITS {
	(nA) = (nanoamp)
	(mV) = (millivolt)
	(uS) = (microsiemens)
}

    
NEURON {
    POINT_PROCESS <xsl:value-of select="@name"/>
    <xsl:if test="count(cml:doub_exp_syn)>0">
    <!--Note: as this is only supported model so far, mod file willl be pretty empty if count(doub_exp_syn)=0 -->
    RANGE tau1, tau2, e, gmax
    </xsl:if>
    RANGE i
    NONSPECIFIC_CURRENT i
    RANGE g
    GLOBAL total

}

PARAMETER {
<xsl:if test="count(cml:doub_exp_syn)>0">
	tau1 = <xsl:call-template name="convert">
              <xsl:with-param name="value"><xsl:value-of select="cml:doub_exp_syn/@rise_time"/></xsl:with-param>
              <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template> (ms) &lt;1e-9,1e9&gt;
	tau2 = <xsl:call-template name="convert">
              <xsl:with-param name="value"><xsl:value-of select="cml:doub_exp_syn/@decay_time"/></xsl:with-param>
              <xsl:with-param name="quantity">Time</xsl:with-param></xsl:call-template> (ms) &lt;1e-9,1e9&gt;
	e = <xsl:call-template name="convert">
              <xsl:with-param name="value"><xsl:value-of select="cml:doub_exp_syn/@reversal_potential"/></xsl:with-param>
              <xsl:with-param name="quantity">Voltage</xsl:with-param></xsl:call-template>	(mV)
	gmax = <xsl:call-template name="convert">
              <xsl:with-param name="value"><xsl:value-of select="cml:doub_exp_syn/@max_conductance"/></xsl:with-param>
              <xsl:with-param name="quantity">Conductance</xsl:with-param></xsl:call-template><xsl:text>
    </xsl:text>
</xsl:if>   
}


ASSIGNED {
	v (mV)
	i (nA)
	g (uS)
	factor
	total (uS)
}

<xsl:if test="count(cml:doub_exp_syn)>0">
STATE {
	A (uS)
	B (uS)
}

INITIAL {
	LOCAL tp
	total = 0
	if (tau1/tau2 > .9999) {
		tau1 = .9999*tau2
	}
	A = 0
	B = 0
	tp = (tau1*tau2)/(tau2 - tau1) * log(tau2/tau1)
	factor = -exp(-tp/tau1) + exp(-tp/tau2)
	factor = 1/factor
}
</xsl:if>

BREAKPOINT {
	SOLVE state METHOD cnexp
	<xsl:if test="count(cml:doub_exp_syn)>0">g = gmax * (B - A)</xsl:if>
	i = g*(v - e)
}

DERIVATIVE state {
	<xsl:if test="count(cml:doub_exp_syn)>0">A' = -A/tau1
	B' = -B/tau2</xsl:if> <!--Again a very empty expression without a doub_exp_syn... -->
}

NET_RECEIVE(weight (uS)) {
	<xsl:if test="count(cml:doub_exp_syn)>0">state_discontinuity(A, A + weight*factor)
	state_discontinuity(B, B + weight*factor)
	total = total+weight</xsl:if>
}

</xsl:template>  <!--<xsl:template match="cml:synapse_type">-->


<!-- Function to try to format the rate expression to something this simulator is a bit happier with-->
<xsl:template name="formatExpression">
    <xsl:param name="variable" />
    <xsl:param name="oldExpression" />
    <xsl:choose>
        <xsl:when test="contains($oldExpression, '?')">
    <!-- Expression contains a condition!!-->
    <xsl:variable name="ifTrue"><xsl:value-of select="substring-before(substring-after($oldExpression,'?'), ':')"/></xsl:variable>
    <xsl:variable name="ifFalse"><xsl:value-of select="substring-after($oldExpression,':')"/></xsl:variable>
    
    if (<xsl:value-of select="substring-before($oldExpression,'?')"/>) {<xsl:text>
        </xsl:text><xsl:value-of select="$variable"/> = <xsl:value-of select="$ifTrue"/>
    } else {<xsl:text>
        </xsl:text><xsl:value-of select="$variable"/> = <xsl:value-of select="$ifFalse"/>
    }</xsl:when>
        <xsl:otherwise>
    <xsl:value-of select="$variable"/> = <xsl:value-of select="$oldExpression"/><xsl:text>
        </xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


</xsl:stylesheet>

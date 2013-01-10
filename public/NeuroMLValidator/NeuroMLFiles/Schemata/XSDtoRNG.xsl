<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:rng="http://relaxng.org/ns/structure/1.0"
            xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
            exclude-result-prefixes="xs"
            version="1.0">
                
<!--

    This file can be used to convert the NeuroML XSD Schema files to Relax NG format
    
    Author: Nicolas Debeissat
    
-->
            
            <xsl:output indent="yes" method="xml"/>
            <xsl:preserve-space elements="*"/>
            
            <xsl:template match="/xs:schema[@targetNamespace]">
                        <!--<?xml-stylesheet type="text/xsl" href="../RNGtoHTMLform_standalone.xsl"?>-->
                        <rng:grammar>
                                    <xsl:for-each select="namespace::*">
                                                <xsl:if test="local-name() != 'xs'">
                                                            <xsl:copy/>
                                                </xsl:if>
                                    </xsl:for-each>
                                    <xsl:attribute name="ns"><xsl:value-of select="@targetNamespace"/></xsl:attribute>
                                    <xsl:attribute name="datatypeLibrary">http://www.w3.org/2001/XMLSchema-datatypes</xsl:attribute>
                                    <xsl:apply-templates/>
                        </rng:grammar>
            </xsl:template> 
            
            <xsl:template match="comment()">
                        <xsl:copy/>
            </xsl:template>
            
            <xsl:template match="xs:annotation">
                        <a:documentation>
                                    <xsl:apply-templates/>
                        </a:documentation>
            </xsl:template>
            
            <xsl:template match="xs:documentation">
                        <xsl:copy-of select="child::text()"/>
            </xsl:template>
            
            <xsl:template match="xs:appinfo">
                        <xsl:copy-of select="child::node()"/>
            </xsl:template>
            
            <xsl:template match="xs:complexType[@name]|xs:simpleType[@name]|xs:group[@name]">
                        <!-- the schemas may be included several times, so it needs a combine attribute
                                     (the attributes are inversed :-) at the transformation) -->
                        <rng:define combine="choice" name="{@name}">
                                    <xsl:apply-templates/>
                        </rng:define>
            </xsl:template>
            
            <xsl:template match="xs:attribute[@name]">
                        <xsl:call-template name="occurencies"/>
            </xsl:template>
            
            
            <xsl:template match="xs:attribute[@name]" mode="content">
                        <rng:attribute name="{@name}">
                                    <!-- there can be no type attribute to <xs:attribute>, in this case, the type is defined in 
                                    a <xs:simpleType> or a <xs:complexType> inside -->
                                    <xsl:choose>
                                                <xsl:when test="@type">
                                                            <xsl:call-template name="type">
                                                                        <xsl:with-param name="type" select="@type"/>
                                                            </xsl:call-template>                                                            
                                                </xsl:when>
                                                <xsl:otherwise>
                                                            <xsl:apply-templates/>
                                                </xsl:otherwise>
                                    </xsl:choose>
                        </rng:attribute>
            </xsl:template>
            
            
            <!-- the <xs:simpleType> and <xs:complexType without type attribute are ignored -->
            <xsl:template match="xs:sequence|xs:complexContent|xs:simpleType|xs:complexType">
                        <xsl:apply-templates/>
            </xsl:template>
            
            <xsl:template match="xs:extension[@base]">
                        <xsl:call-template name="type">
                                    <xsl:with-param name="type" select="@base"/>
                        </xsl:call-template>
            </xsl:template>
            
            <xsl:template match="xs:any ">
                        <xsl:call-template name="occurencies"/>
            </xsl:template>
            
            <xsl:template match="xs:any " mode="content">
                        <rng:element>
                                    <rng:anyName/>
                                    <rng:text/>
                        </rng:element>
            </xsl:template>
            
            <xsl:template match="xs:choice">
                        <rng:choice>
                                    <xsl:apply-templates/>
                        </rng:choice>
            </xsl:template>
            
            <xsl:template match="xs:element[@name]">
                        <!-- case of root element -->
                        <xsl:choose>
                                    <xsl:when test="parent::xs:schema">
                                                <rng:start combine="choice">
                                                            <rng:ref name="{@name}"/>
                                                </rng:start>
                                                <rng:define combine="choice" name="{@name}">
                                                            <xsl:apply-templates select="current()" mode="content"/>
                                                </rng:define>
                                    </xsl:when>
                                    <xsl:otherwise>
                                                <xsl:call-template name="occurencies"/>  
                                    </xsl:otherwise>
                        </xsl:choose>
            </xsl:template>
            
            <xsl:template match="xs:element" mode="content">
                        <rng:element name="{@name}">
                                    <xsl:choose>
                                                <xsl:when test="@type">
                                                            <xsl:call-template name="type">
                                                                        <xsl:with-param name="type" select="@type"/>
                                                            </xsl:call-template>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                            <xsl:apply-templates/>
                                                </xsl:otherwise>
                                    </xsl:choose>
                        </rng:element>
            </xsl:template>            
            
            <xsl:template match="xs:restriction[@base]">
                        <xsl:choose>
                                    <xsl:when test="xs:enumeration[@value]">
                                                <rng:choice>
                                                            <xsl:apply-templates/>
                                                </rng:choice>
                                    </xsl:when>
                                    <xsl:otherwise>                                                
                                                <xsl:call-template name="type">
                                                            <xsl:with-param name="type" select="@base"/>
                                                </xsl:call-template>
                                    </xsl:otherwise>
                        </xsl:choose>
            </xsl:template>
            
            <xsl:template match="xs:minInclusive[@value]">
                        <rng:param name="minInclusive"><xsl:value-of select="@value"/></rng:param>
            </xsl:template>
            
            <xsl:template match="xs:minExclusive[@value]">
                        <rng:param name="minExclusive"><xsl:value-of select="@value"/></rng:param>
            </xsl:template>
            
            <xsl:template match="xs:maxInclusive[@value]">
                        <rng:param name="maxInclusive"><xsl:value-of select="@value"/></rng:param>
            </xsl:template>
            
            <xsl:template match="xs:maxExclusive[@value]">
                        <rng:param name="maxExclusive"><xsl:value-of select="@value"/></rng:param>
            </xsl:template>
            
            <xsl:template match="xs:enumeration[@value]">
                        <rng:value><xsl:value-of select="@value"/></rng:value>
                        <xsl:apply-templates/>
            </xsl:template>
            
            <xsl:template match="xs:all">
                        <rng:interleave>
                                    <xsl:for-each select="child::text()[normalize-space(.)] | child::*">
                                                <rng:optional>
                                                            <xsl:apply-templates select="current()"/>
                                                </rng:optional>
                                    </xsl:for-each>
                        </rng:interleave>
            </xsl:template>
            
            <xsl:template match="xs:group[@ref]">
                        <xsl:call-template name="occurencies"/>
            </xsl:template>
            
            <xsl:template match="xs:group[@ref]" mode="content">
                        <xsl:call-template name="type">
                                    <xsl:with-param name="type" select="@ref"/>
                        </xsl:call-template>
            </xsl:template>
            
            <xsl:template match="xs:import[@schemaLocation][@namespace]">
                        <xsl:variable name="schemaLocation" select="substring-before(@schemaLocation,'.xsd')"/>
                        <rng:include href="{$schemaLocation}.rng" ns="{@namespace}"/>
            </xsl:template>
            
            <xsl:template name="occurencies">
                        <xsl:choose>
                                    <xsl:when test="@use and @use='optional'">
                                                <rng:optional>
                                                            <xsl:call-template name="default"/>
                                                            <xsl:apply-templates select="current()" mode="content"/>
                                                </rng:optional>
                                    </xsl:when>
                                    <xsl:when test="@maxOccurs and @maxOccurs='unbounded'">
                                                <xsl:choose>
                                                            <xsl:when test="@minOccurs and @minOccurs='0'">
                                                                        <rng:zeroOrMore>
                                                                                    <xsl:call-template name="default"/>
                                                                                    <xsl:apply-templates select="current()" mode="content"/>
                                                                        </rng:zeroOrMore>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                        <rng:oneOrMore>
                                                                                    <xsl:call-template name="default"/>
                                                                                    <xsl:apply-templates select="current()" mode="content"/>
                                                                        </rng:oneOrMore>
                                                            </xsl:otherwise>
                                                </xsl:choose>
                                    </xsl:when>
                                    <xsl:when test="@minOccurs and @minOccurs='0'">
                                                <rng:optional>
                                                            <xsl:call-template name="default"/>
                                                            <xsl:apply-templates select="current()" mode="content"/>
                                                </rng:optional>                                                
                                    </xsl:when>
                                    <!-- here minOccurs is present but not = 0 -->
                                    <xsl:when test="@minOccurs">
                                                <xsl:call-template name="loopUntilZero">
                                                            <xsl:with-param name="nbLoops" select="@minOccurs"/>
                                                </xsl:call-template>
                                    </xsl:when>
                                    <xsl:otherwise>
                                                <xsl:call-template name="default"/>
                                                <xsl:apply-templates select="current()" mode="content"/>
                                    </xsl:otherwise>
                        </xsl:choose>
            </xsl:template>
            
            <xsl:template name="default">
                        <xsl:if test="@default">
                                    <a:documentation>
                                                default value is : <xsl:value-of select="@default"/>
                                    </a:documentation>
                        </xsl:if>
            </xsl:template>
            
            <xsl:template name="loopUntilZero">
                        <xsl:param name="nbLoops"/>
                        <xsl:if test="$nbLoops > 0">
                                    <xsl:call-template name="default"/>
                                    <xsl:apply-templates select="current()" mode="content"/>
                                    <xsl:call-template name="loopUntilZero">
                                                <xsl:with-param name="nbLoops" select="$nbLoops - 1"/>
                                    </xsl:call-template>
                        </xsl:if>
            </xsl:template>
            
            <xsl:template name="type">
                        <xsl:param name="type"/>                        
                        <xsl:choose>
                                    <xsl:when test="contains($type,'anyType')">
                                                <rng:data type="string">
                                                            <xsl:apply-templates/>
                                                </rng:data>
                                    </xsl:when>
                                    <xsl:when test="starts-with($type,'xs:')">
                                                <rng:data type="{substring-after($type,':')}">
                                                            <xsl:apply-templates/>
                                                </rng:data>
                                    </xsl:when>
                                    <xsl:otherwise>
                                                <xsl:choose>
                                                            <xsl:when test="contains($type,':')">
                                                                        <rng:ref name="{substring-after($type,':')}"/>
                                                                        <xsl:apply-templates/>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                        <rng:ref name="{$type}"/>
                                                                        <xsl:apply-templates/>
                                                            </xsl:otherwise>
                                                </xsl:choose>
                                    </xsl:otherwise>
                        </xsl:choose>
            </xsl:template>
            <!-- <xsl:when test="/xs:schema/xs:complexType[@name=$type]|/xs:schema/xs:simpleType[@name=$type]"> -->
</xsl:stylesheet>
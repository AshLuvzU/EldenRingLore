<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">

    <xsl:output method="text" omit-xml-declaration="yes"/>
 
 <!-- ebb: This is designed to read the EldenDialog-Structured.xml and output
text files for corpus analysis. Change this as you decide to carve up the
source XML in your own new ways! 
 -->
    
 <xsl:template match="/">
     <xsl:apply-templates select="//scene[@type='boss-fight']"/>
 
 </xsl:template>
    
    <xsl:template match="scene">
        <xsl:variable name="apos">'</xsl:variable>
        <xsl:variable name="filename" as="xs:string" 
            select="parent::character/@name ! replace(., ' ', '_') ! replace(., ',', '') ! replace(., $apos, '') || '-scene-' || @block || '-' || position()"/>
        <xsl:result-document href="boss-fight-dialog-text/{$filename}.txt" method="text" indent="yes">
     
     <xsl:apply-templates select=".//text[@lang='en']"/>
     
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="text">
       <xsl:if test="matches(., '^\w+')"> 
        <xsl:sequence select="normalize-space(.)"/><xsl:text>&#10;</xsl:text></xsl:if>
    </xsl:template>
 

</xsl:stylesheet>

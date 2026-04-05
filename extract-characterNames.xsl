<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:template match="/">
        <xsl:variable name="characterNames-with-repeats" as="xs:string+" select="//map//string[@key='name_en'] ! substring-before(., ' dialog')"/>
        <xsl:variable name="characterNames-deduped" as="xs:string+" select="$characterNames-with-repeats => distinct-values()"/>
        <xsl:result-document method="xml" href="characterNames.xml">
         <xml>
             <meta resp="ebb">This file is a output of character names pulled from the Elden Dialog lore script.
             We have prepared two lists: 
             <list type="meta">
              <item>The first numbered list with <code>@type</code> of <value>"full-with-repeats"</value>
                  because we found at least one 
             represented more than once in the source EldenDialog.json.</item>
                 <item>The second numbered list with <code>@type</code> of <value>"distinct-values"</value> simply
                 removes the duplicates.</item>
             </list>
             </meta>
            <list type="full-with-repeats">
                <xsl:for-each select="$characterNames-with-repeats">
                    <item num="{position()}"><xsl:value-of select="current()"/></item>
                </xsl:for-each>
            </list>
             <list type="deduped">
                 <xsl:for-each select="$characterNames-deduped">
                 <item num="{position()}"><xsl:value-of select="current()"/></item>
                 </xsl:for-each>
             </list>
         </xml>  
        </xsl:result-document>
        
        
    </xsl:template>
    
</xsl:stylesheet>
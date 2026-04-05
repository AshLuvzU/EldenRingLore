<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://www.w3.org/2005/xpath-functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:digit="https://newtfire.org"
    exclude-result-prefixes="xs digit"
    version="3.0">

    <xsl:output method="xml" indent="yes"/>
    
    <!-- ============================================================
         ROOT TEMPLATE: ebb: So we started by just simply transforming the JSON to XML.
         That XML script has giant strings in it that we can actually parse to get 
         data from the game and organize the dialog into scenes! 
         This template is the one that matches on the document node of our simple XML output.
         We're going to fire a bunch of XSL string processing functions and named templates 
         starting here. 
         ============================================================ -->
    <xsl:template match="/">
        <xsl:result-document href="EldenDialog-Structured.xml" method="xml" indent="yes">
            <!-- This stores the result document -->
            <dialog>
                <xsl:comment>
                    Elden Ring dialog corpus XML.
                    Source: EldenDialog.json, via json-to-xml() intermediate.
                    Utterances grouped into scenes by block ID
                    (floor(utterance-id div 1000) * 1000).
                    Scene @type derived from $classifications lookup table;
                    absence of @type indicates an unclassified scene.
                    Line boundaries marked with lb/ (after TEI) at voice-
                    performance pause points, aligned across lang="en" and lang="jp".
                    Cut NPCs and special entries preserved without modification.
                </xsl:comment>
                <xsl:apply-templates select="//map[@key='dialog']/map"/>
            </dialog>
        </xsl:result-document>
    </xsl:template>
    

    <!-- ============================================================
         CLASSIFICATION LOOKUP TABLE
         
         @type values: "boss-fight" | "npc-conversation"
         
         Characters with no entry here will produce <scene> elements
         with no @type at all — intentionally unclassified.
         
         For characters with MIXED scene types (e.g. pre-fight NPC
         conversation + battle cries), use child <block> elements.
         The @group value is floor(utterance-id div 1000), which is
         how we key the scene grouping throughout this stylesheet.
         
         ASHTON: please review and extend based on your game knowledge,
         especially the TODO entries for Rennala and Gurranq, and any
         NPCs not yet listed below.
         ============================================================ -->
    <xsl:variable name="classifications">

        <!-- Pure boss-fight characters: every scene is a boss fight -->
        <char name="Maliketh, the Black Blade"         type="boss-fight"/>
        <char name="Malenia, Blade of Miquella"        type="boss-fight"/>
        <char name="Margit, the Fell Omen"             type="boss-fight"/>
        <char name="Morgott, the Omen King"            type="boss-fight"/>
        <char name="Rykard, Lord of Blasphemy"         type="boss-fight"/>
        <char name="Godfrey, First Elden Lord"         type="boss-fight"/>
        <char name="Godrick the Grafted"               type="boss-fight"/>

        <!-- Mixed character: pre-fight NPC dialog (block-group 2014)
             then live battle incantation (block-group 2099).           -->
        <char name="Mohg, Lord of Blood">
            <block group="2014" type="npc-conversation"/>
            <block group="2099" type="boss-fight"/>
        </char>

        <!-- Rennala appears TWICE in the source data: once as a post-
             defeat NPC (she resets attributes at the Academy), and once
             as a boss. 
             FOR ASHTON: can you identify the correct block-group values
             from the source and replace the TODO strings below? -->
        <char name="Rennala, Queen of the Full Moon">
            <block group="TODO-npc"  type="npc-conversation"/>
            <block group="TODO-boss" type="boss-fight"/>
        </char>

        <!-- Gurranq is primarily an NPC but attacks the player during
             certain quest stages. 
             FOR ASHTON: Determine whether a boss-fight
             block exists and add a <block> child if so.                 -->
        <char name="Gurranq, Beast Clergyman"          type="npc-conversation"/>

        <!-- NPC conversationalists (extend as needed) -->
        <char name="Melina"                            type="npc-conversation"/>
        <char name="Ranni the Witch"                   type="npc-conversation"/>
        <char name="Blaidd the Half-Wolf"              type="npc-conversation"/>
        <char name="Sorceress Sellen"                  type="npc-conversation"/>
        <char name="Preceptor Seluvis"                 type="npc-conversation"/>
        <char name="Patches"                           type="npc-conversation"/>
        <char name="Fia, Deathbed Companion"           type="npc-conversation"/>
        <char name="White Mask Varré"                  type="npc-conversation"/>
        <char name="Millicent"                         type="npc-conversation"/>
        <char name="Sage Gowry"                        type="npc-conversation"/>
        <char name="Finger Reader Enia"                type="npc-conversation"/>
        <char name="Finger Reader Crone"               type="npc-conversation"/>
        <char name="Alexander, Warrior Jar"            type="npc-conversation"/>
        <char name="Miriel, Pastor of Vows"            type="npc-conversation"/>
        <char name="Brother Corhyn"                    type="npc-conversation"/>
        <char name="Sir Gideon Ofnir, the All-Knowing" type="npc-conversation"/>
        <char name="Smithing Master Hewg"              type="npc-conversation"/>
        <char name="Smithing Master Iji"               type="npc-conversation"/>
        <char name="Nepheli Loux, Warrior"             type="npc-conversation"/>
        <char name="Demi-Human Boc"                    type="npc-conversation"/>
        <char name="D, Hunter of the Dead"             type="npc-conversation"/>
        <char name="Knight Diallos"                    type="npc-conversation"/>
        <char name="Dung Eater"                        type="npc-conversation"/>
        <char name="Sorcerer Rogier"                   type="npc-conversation"/>
        <char name="Knight Bernahl"                    type="npc-conversation"/>
        <char name="Tanith, Volcano Manor Proprietress" type="npc-conversation"/>
        <char name="Yura, Hunter of Bloody Fingers"    type="npc-conversation"/>
        <char name="Kenneth Haight, Limgrave Heir"     type="npc-conversation"/>
        <char name="Irina of Morne"                    type="npc-conversation"/>
        <char name="Castellan Edgar"                   type="npc-conversation"/>
        <char name="Castellan Jerren"                  type="npc-conversation"/>
        <char name="Rya the Scout"                     type="npc-conversation"/>
        <char name="Gatekeeper Gostoc"                 type="npc-conversation"/>
        <char name="Latenna the Albinauric"            type="npc-conversation"/>
        <char name="Old Albus"                         type="npc-conversation"/>
        <char name="Asimi, Silver Tear"                type="npc-conversation"/>
        <char name="Jar-Bairn"                         type="npc-conversation"/>
        <char name="Merchant Kalé"                     type="npc-conversation"/>
        <char name="Nomadic Merchant"                  type="npc-conversation"/>
        <char name="Blackguard"                        type="npc-conversation"/>
        <char name="Sorcerer Thops"                    type="npc-conversation"/>
        <char name="The Noble Goldmask"                type="npc-conversation"/>

        <!-- Characters intentionally left unclassified (no entry):
             Narator, Ghost, Stage Directions, Unknown NPC 221,
             Unknown NPC 2029, End of Game Dialog + Extra Morgott,
             Guilbert the Redeemer (cut npc),
             Omenhunter Shanehaight (cut npc),
             Reeling Rico, Aurelia's Sister, Heartbroken Maiden,
             Knight of Rykard                           -->
    </xsl:variable>


    <!-- ============================================================
         FUNCTION: digit:get-scene-type
         
         Returns the @type string for a given character name and
         block-group integer, or empty string if unclassified.
         
         $char-name   : cleaned character name (no trailing " dialog")
         $block-group : floor(utterance-id div 1000) as xs:integer
         ============================================================ -->
    <xsl:function name="digit:get-scene-type" as="xs:string">
        <xsl:param name="char-name"   as="xs:string"/>
        <xsl:param name="block-group" as="xs:integer"/>
        <xsl:variable name="entry" select="$classifications/*[@name = $char-name]"/>
        <!-- ebb: NOTE: WE had to dodge a namespace issue here! 
            we're using  the wildcard `*` for calling on the child <char> element,
            We could also call a specific element w/ QName() (the qualified name). Our element is on a
            special digit:namespaced tree so we could reach for it with digit:char.
            
            NOTE: we're using the wildcard `*` rather than `char` here 
            for calling on the child <char> element because xpath-default-namespace 
            is set to the XPath functions namespace that came with the source XML pulled from JSON!
            Our xpath-default-namespace applies to XPath path expressions, so an unprefixed `char` 
            in XPath would look for {http://www.w3.org/2005/xpath-functions}char — which doesn't exist! 
     
            It doesn't exist because. . . .The <char> elements in $classifications are constructed in our functions
            with no namespace at all, so `*` (which ignores namespace) is the best way to retrieve them.
             Alternatively we could suppress xpath-default-namespace locally,
            but `*` with an attribute predicate is simpler and equally precise.
            
            We had to debug this when we couldn't reach the <char> elements we were constructing, and realized
            the usual thing with XSLT: when you get no output and your nodes should be there, (drumroll..)
            "IT'S ALWAYS A NAMESPACE ISSUE". :-)
        -->
        <xsl:choose>
            <!-- Character not in lookup table: no classification -->
            <xsl:when test="not($entry)">
                <xsl:value-of select="''"/>
            </xsl:when>
            <!-- Simple case: character-level @type, all scenes same type -->
            <xsl:when test="$entry/@type">
                <xsl:value-of select="$entry/@type"/>
            </xsl:when>
            <!-- Complex case: look up by block group number -->
            <xsl:when test="$entry/block">
                <xsl:variable name="matched"
                    select="$entry/block[@group = string($block-group)]/@type"/>
                <xsl:value-of select="($matched, '')[1]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>


    <!-- ============================================================
         FUNCTION: digit:clean-name
         So, XSLT can have functions like Python does. XSLT also has
         named templates you can call, and this XSLT will use one of each
         for use in special processing of string data from the Elden Lore source data.
        
         This function just strips the trailing " dialog" suffix from raw name_en values.
 
         Note: "End of Game Dialog + Extra Morgott dialog" is handled
         correctly because substring-before() is case-sensitive —
         the mid-string capital-D "Dialog" is not matched. (Yay!)
         ============================================================ -->
    <xsl:function name="digit:clean-name" as="xs:string">
        <xsl:param name="raw" as="xs:string"/>
        <xsl:value-of select="
            if (contains($raw, ' dialog'))
            then substring-before($raw, ' dialog')
            else $raw"/>
        <!-- ebb: Just geeking out here: If we were doing this "if test" in Python the same logic
            would look like this:
                     raw = whatever-Stuff-We-Pulled-from-SomeOtherFunction
                     raw.split(' dialog')[0] if ' dialog' in raw else raw  
        -->
    </xsl:function>


    <!-- ============================================================
         NAMED TEMPLATE: render-text 
         TURNS OUT WE DON'T NEED THIS, because the <br> markers in the source document
         are breaking with each new scene. But in case we ever DO need it, in case we see
         line breaks within the spoken lines, this little named template can handle them! 
         
         (This is kind of like an XSLT function. We name a template and call it
         from within a template that's processing in document order-and you pretty much
         send variables here that we defined by processing a node in the XML tree:
         They get sent to a named template as <xsl:param> (parameters) for fine-tuned processing.
         
         This rocesses a raw dialog text string (from info_en or info_jp)
         and outputs character data with <lb/> milestone elements in
         place of the source <br/> markup.
         
         The source encodes line boundaries as the literal string
         <br/> (originally HTML in the game engine, passed through
         JSON as &lt;br/&gt; and resolved to literal angle brackets
         in the XPath string value). Double <br/><br/> sequences at
         the start and end of each segment are stripped first.
         
         <lb/> borrows its name from the TEI "line beginning" element,
         appropriate here as a prosodic/performance boundary marker
         aligning with voice-acted pause points in both languages.
         ============================================================ -->
    <xsl:template name="render-text">
        <xsl:param name="text" as="xs:string"/>
        <!-- Strip leading and trailing <br/> sequences with surrounding whitespace -->
        <xsl:variable name="trimmed-tail"
            select="replace($text,  '(\s*&lt;br/&gt;\s*)+$', '')"/>
        <xsl:variable name="trimmed"
            select="replace($trimmed-tail, '^(\s*&lt;br/&gt;\s*)+', '')"/>
        <!-- Replace one or more consecutive <br/> with a single <lb/> element.
             Consecutive doubles are collapsed intentionally — they mark the same
             pause point regardless of how many the source encodes.              -->
        <xsl:analyze-string select="$trimmed" regex="(\s*&lt;br/&gt;\s*)+">
            <xsl:matching-substring>
                <lb/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>


    <!-- ============================================================
         CHARACTER TEMPLATE
         
         Here's another named template. It processes one character entry:
         a <map> child of map[@key='dialog']
         with string children keyed on name_en, id, info_en, info_jp.
         
         Here's what this does: See if you can read the regex inside it! 
           1. We pick up the string for info_en to extract its sequences of IDs and texts
           2. Then we process info_jp the same way.
           3. Build an intermediate sequence of <utterance> nodes carrying both
              language strings and a pre-computed block-group key
           4. Group <utt> nodes by block-group into <scene> elements
           5. Render each utterance with <text lang="en|jp"> children,
              calling render-text to insert <lb/> elements
         ============================================================ -->
    <xsl:template match="map[@key='dialog']/map">
        <xsl:variable name="raw-name"  select="string[@key='name_en']"/>
        <xsl:variable name="char-name" select="digit:clean-name($raw-name)"/>
        <xsl:variable name="char-id"   select="string[@key='id']"/>
        <xsl:variable name="info-en"   select="string[@key='info_en']"/>
        <xsl:variable name="info-jp"   select="string[@key='info_jp']"/>

        <!-- Parse EN: IDs (the English values) as a sequence of strings, texts as a parallel sequence.
             analyze-string captures each [NNNNN] group value.
             tokenize splits on [NNNNN]\s* markers; position() gt 1 skips the
             empty string that precedes the very first marker.               -->
        <xsl:variable name="ids-en" as="xs:string*"
            select="analyze-string($info-en, '\[(\d+)\]')//group[@nr='1']/string()"/>
        <xsl:variable name="texts-en" as="xs:string*"
            select="tokenize($info-en, '\[\d+\]\s*')[position() gt 1]"/>

        <!-- Parse JP: IDs (the Japanese values) in the same way. THe JP: IDs should match EN positionally
             but we use index-of() for safety because their values aren't the same, just super close.-->
        <xsl:variable name="ids-jp" as="xs:string*"
            select="analyze-string($info-jp, '\[(\d+)\]')//group[@nr='1']/string()"/>
        <xsl:variable name="texts-jp" as="xs:string*"
            select="tokenize($info-jp, '\[\d+\]\s*')[position() gt 1]"/>

        <!-- Build intermediate utterance nodes for grouping.
             NOTE: We're trying organize utterances by scene, because the high end their value divided by 100 
             (e.g. [1100000] => 110 vs. [1300020] => 130  associate them with specific scenes.
  
             So! Each <utterance> stores the following attributes:
               @id          : the FMG utterance ID from the source
               @block-group : floor(id div 1000) — the scene grouping key
               @en          : raw English text string (lb/ not yet inserted)
               @jp          : raw Japanese text string (matched by ID)
               @note        : "dummyText" if the utterance is the dummy stub at the start of the file  -->
        <xsl:variable name="utterances">
            <xsl:for-each select="1 to count($ids-en)">
                <xsl:variable name="pos"    select="."/>
                <xsl:variable name="id"     select="$ids-en[$pos]"/>
                <xsl:variable name="jp-pos" select="index-of($ids-jp, $id)[1]"/>
                <utterance id="{$id}"
                     block-group="{floor(xs:integer($id) div 1000)}"
                     en="{normalize-space($texts-en[$pos])}"
                     jp="{if ($jp-pos) then normalize-space($texts-jp[$jp-pos]) else ''}">
                    <xsl:if test="starts-with(normalize-space($texts-en[$pos]), '(dummyText)')">
                        <xsl:attribute name="note">dummyText</xsl:attribute>
                    </xsl:if>
                </utterance>
            </xsl:for-each>
        </xsl:variable>

        <!--Here we output the <character> element, grouping utterances by their @block-group into scenes -->
        <character id="{$char-id}" name="{$char-name}">
            <xsl:for-each-group select="$utterances/*" group-by="@block-group">
                <xsl:sort select="xs:integer(current-grouping-key())"/>
                <!-- block attribute: the actual lowest ID in this group (more readable
                     than the raw grouping key) -->
                <xsl:variable name="block-id"
                    select="xs:integer(current-grouping-key()) * 1000"/>
                <xsl:variable name="scene-type"
                    select="digit:get-scene-type($char-name, xs:integer(current-grouping-key()))"/>
                <scene block="{$block-id}">
                    <!-- @type only emitted when we have a classification -->
                    <xsl:if test="$scene-type != ''">
                        <xsl:attribute name="type" select="$scene-type"/>
                    </xsl:if>
                    <xsl:for-each select="current-group()">
                        <xsl:sort select="xs:integer(@id)"/>
                        <utterance id="{@id}">
                            <xsl:if test="@note">
                                <xsl:attribute name="note" select="@note"/>
                            </xsl:if>
                            <text lang="en">
                                <xsl:call-template name="render-text">
                                    <xsl:with-param name="text" select="string(@en)"/>
                                </xsl:call-template>
                            </text>
                            <text lang="jp">
                                <xsl:call-template name="render-text">
                                    <xsl:with-param name="text" select="string(@jp)"/>
                                </xsl:call-template>
                            </text>
                        </utterance>
                    </xsl:for-each>
                </scene>
            </xsl:for-each-group>
        </character>

    </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="1.0">

  <!-- 'add', 'choice|unclear', 'supplied' elements in diplomatic transcription? -->

  <xsl:strip-space elements="*"/>
  <xsl:output method="html"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>
          <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        </title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
        <script src="../../Coding/Scripts/mss.js"></script>
        <link rel="stylesheet" type="text/css" href="../../Coding/Stylesheets/mss.css"/>
      </head>
      <body>
        <h1 id="#top">
          <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        </h1>
        <div id="page-menu">
          Contents:
          <ul>
            <li><a href="#header-information">header information</a></li>
            <li><a href="#diplomatic-transcription">diplomatic transcription</a></li>
            <li><a href="#undiplomatic-transcription">undiplomatic transcription</a></li>
          </ul>
        </div>
        <hr/><hr/>
        <div id="header-information">
          <h2>Header information</h2>
          <a href="#top">Back to top</a>
          <xsl:apply-templates select="tei:TEI/tei:teiHeader"/>
        </div>    
        <hr/><hr/>
        <div id="diplomatic-transcription">
          <h2>Diplomatic transcription</h2>
          <a href="#top">Back to top</a>
          <xsl:apply-templates select="tei:TEI/tei:text/tei:body" mode="diplomatic"/>
        </div>
        <hr/><hr/>
        <div id="undiplomatic-transcription">
          <h2>Undiplomatic transcription</h2>
          <a href="#top">Back to top</a>
          <xsl:apply-templates select="tei:TEI/tei:text/tei:body" mode="edited"/>
        </div>
        <hr/><hr/>
        <!--
        <p>
          <button id="clear-slips-button">Clear slips</button>
        </p>
        <table id="slips-table" border="1">
          <thead>
            <tr><th>Form</th><th>Abbreviations</th></tr>
          </thead>
          <tbody></tbody>
        </table>
        -->
        <!--
        <div id="abstract">
          <xsl:apply-templates select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:notesStmt/tei:note/tei:p"/>
        </div>
        
        
        -->
        
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="tei:teiHeader">
    <h3>Authors:</h3>
    <ul>
      <xsl:apply-templates select="tei:fileDesc/tei:titleStmt/tei:respStmt"/>
    </ul>
    <h3>Abstract:</h3>
    <xsl:apply-templates select="tei:fileDesc/tei:notesStmt/tei:note[1]"/>
    <h3>Manuscript:</h3>
    <xsl:apply-templates select="tei:fileDesc/tei:sourceDesc/tei:msDesc"/>
    <h3>Language:</h3>
    <xsl:apply-templates select="tei:profileDesc/tei:langUsage"/>
    <h3>Keywords:</h3>
    <ul>
      <xsl:for-each select="tei:profileDesc/tei:textClass/tei:keywords/tei:term">
        <li>
          <xsl:value-of select="."/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>
  
  <xsl:template match="tei:respStmt">
    <li>
      <xsl:value-of select="tei:name"/>
      <xsl:text>: </xsl:text>
      <xsl:for-each select="tei:resp">
        <xsl:value-of select="."/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </li>
  </xsl:template>
  
  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend = 'italic']">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  
  <xsl:template match="tei:msDesc">
    <p>
      <xsl:text>ID: </xsl:text>
      <xsl:value-of select="tei:msIdentifier/tei:repository"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="tei:msIdentifier/tei:idno"/>
    </p>
    <p>
      <xsl:apply-templates select="tei:msContents/tei:summary"/>
      <ul>
        <xsl:apply-templates select="tei:msContents/tei:msItem"/>
      </ul>
    </p>
    <p>
      <xsl:apply-templates select="tei:history/tei:provenance"/>
    </p>
  </xsl:template>
  
  <xsl:template match="tei:msItem">
    <li>
      <xsl:value-of select="tei:locus"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="tei:title"/>
    </li>
  </xsl:template>
  
  <xsl:template match="tei:body" mode="diplomatic">
      <xsl:apply-templates select="tei:div" mode="diplomatic"/>
  </xsl:template>

  <xsl:template match="tei:div" mode="diplomatic">
    <xsl:variable name="link" select="@corresp"/>
    <h4>
      <xsl:text>Text </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="//tei:msItem[@xml:id=$link]/tei:title"/> <!-- MM: check this path -->
    </h4>
    <xsl:apply-templates mode="diplomatic"/>
  </xsl:template>
  
  
  
  <xsl:template mode="diplomatic" match="tei:lb"> <!-- MM: line breaks inside words? -->
    <sub>
      <br id="{generate-id()}_dip"/>
      <xsl:value-of select="@n"/>
      <xsl:text>. </xsl:text>
    </sub>
  </xsl:template>
  
  <xsl:template mode="diplomatic" match="tei:pb">
    <h4>
      <xsl:text>Page </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>: </xsl:text>
    </h4>
  </xsl:template>
  
  
  <xsl:template mode="diplomatic" match="tei:name">
    <span class="name">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:attribute name="data-type">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>
  
  
  <xsl:template mode="diplomatic" match="tei:w"> <!-- remember type="data" -->
    <xsl:choose>
      <xsl:when test="child::tei:w">
        <span class="compound">
          <xsl:attribute name="id">
            <xsl:value-of select="generate-id()"/>
          </xsl:attribute>
          <xsl:apply-templates mode="diplomatic"/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <span class="word">
          <xsl:attribute name="id">
            <xsl:value-of select="generate-id()"/>
          </xsl:attribute>
          <xsl:attribute name="data-headword">
            <xsl:value-of select="@lemma"/>
          </xsl:attribute>
          <xsl:attribute name="data-dil">
            <xsl:value-of select="@lemmaRef"/>
          </xsl:attribute>
          <xsl:attribute name="data-pos">
            <xsl:value-of select="@ana"/>
          </xsl:attribute>
          <xsl:apply-templates mode="diplomatic"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
    
    
      <!--
      <xsl:attribute name="title">
        <xsl:choose>
          <xsl:when test="ancestor::tei:name">
            <xsl:value-of select="@lemma"/>
            <xsl:text> [</xsl:text>
            <xsl:value-of select="ancestor::tei:name/@type"/>
            <xsl:text> name]</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@lemma"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>: </xsl:text>
        <xsl:value-of select="@ana"/>
        <xsl:text> </xsl:text>
        <xsl:if test="@source">
          <xsl:text>(from </xsl:text>
          <xsl:value-of select="@source"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
        <xsl:text>&#10;</xsl:text>
        <xsl:variable name="commonDiv" select="ancestor::tei:div[1]/@corresp"/>
        <xsl:variable name="hand">
          <xsl:choose>
            <xsl:when test="ancestor::tei:add">
              <xsl:value-of select="ancestor::tei:add/@resp"/>
            </xsl:when>
            <xsl:when test="ancestor::tei:div[1]//tei:handShift and preceding::tei:handShift[1]/ancestor::tei:div[@resp]/@corresp = $commonDiv">
              <xsl:value-of select="preceding::tei:handShift[1]/@new"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="ancestor::tei:div[1]/@resp"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="document('../../Transcribing/corpus.xml')/tei:teiCorpus/tei:teiHeader/tei:profileDesc/tei:handNotes/tei:handNote[@xml:id=$hand]/tei:forename"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="document('../../Transcribing/corpus.xml')/tei:teiCorpus/tei:teiHeader/tei:profileDesc/tei:handNotes/tei:handNote[@xml:id=$hand]/tei:surname"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="substring($hand, 5)"/>
        <xsl:text>); </xsl:text>
        <xsl:for-each select="descendant::tei:handShift">
          <xsl:variable name="new" select="@new"/>
          <xsl:value-of select="document('../../Transcribing/corpus.xml')/tei:teiCorpus/tei:teiHeader/tei:profileDesc/tei:handNotes/tei:handNote[@xml:id=$new]/tei:forename"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="document('../../Transcribing/corpus.xml')/tei:teiCorpus/tei:teiHeader/tei:profileDesc/tei:handNotes/tei:handNote[@xml:id=$new]/tei:surname"/>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="substring($new, 5)"/>
          <xsl:text>); </xsl:text>  
        </xsl:for-each>
        <xsl:text>&#10;</xsl:text>
        <xsl:text> </xsl:text>
        <xsl:for-each select="descendant::*[@reason='interp_obscure'] | ancestor::*[@reason='interp_obscure']"> 
          <xsl:choose>
            <xsl:when test="ancestor::tei:w and not(descendant::tei:w)">
              <xsl:text xml:space="preserve">- some characters within this word remain unexplained.&#10;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text xml:space="preserve">- the interpretation of this word, or its context, is doubtful</xsl:text>
              <xsl:if
                test="descendant::tei:unclear[@cert = 'medium' or 'low' or 'unknown']//tei:w[not(count(preceding::*) = $wordPOS)] or descendant::tei:w[@lemma = 'UNKNOWN' and not(count(preceding::*) = $wordPOS)] or descendant::tei:w[descendant::tei:abbr[not(@cert = 'high')] and not(count(preceding::*) = $wordPOS)]">
                <xsl:text>; there is a particular issue with</xsl:text>
                <xsl:if
                  test="descendant::tei:unclear[@cert = 'medium' or 'low' or 'unknown']//tei:w[count(preceding::*) = $wordPOS] or descendant::tei:w[@lemma = 'UNKNOWN' and count(preceding::*) = $wordPOS] or self::*/descendant::tei:w[descendant::tei:abbr[not(@cert = 'high')] and count(preceding::*) = $wordPOS]">
                  <xsl:text xml:space="preserve"> this word and</xsl:text>
                </xsl:if>
                <xsl:for-each
                  select="descendant::tei:unclear//tei:w[not(ancestor::tei:w) and not(count(preceding::*) = $wordPOS)] | descendant::tei:w[@lemma = 'UNKNOWN' and not(count(preceding::*) = $wordPOS)] | descendant::tei:w[descendant::tei:abbr[not(@cert = 'high')] and not(count(preceding::*) = $wordPOS)]">
                  <xsl:text> "</xsl:text>
                  <xsl:value-of select="self::*"/>
                  <xsl:text>" </xsl:text>
                </xsl:for-each>
              </xsl:if>
              <xsl:text>&#10;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="descendant::*[@reason='char'] | ancestor::*[@reason='char']">
          <xsl:text xml:space="preserve">- a key character in this word ("</xsl:text>
          <xsl:value-of select="text()"/>
          <xsl:text xml:space="preserve">") is ambiguous.&#10;</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="descendant::*[@reason='text_obscure'] | ancestor::*[@reason='text_obscure']">
          <xsl:choose>
            <xsl:when
              test="@reason = 'text_obscure' and descendant::tei:w[not(descendant::tei:w)]">
              <xsl:text xml:space="preserve">- this word is difficult to decipher &#10;</xsl:text>
            </xsl:when>
            <xsl:when
              test="@reason = 'text_obscure' and ancestor::tei:w[not(descendant::tei:w)]">
              <xsl:text xml:space="preserve">- parts of this word are difficult to decipher &#10;</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="descendant::*[@reason='abbrv'] | ancestor::*[@reason='abbrv']">
          <xsl:text xml:space="preserve">- this reading involves one or more abbreviations </xsl:text>
          <xsl:if test="descendant::tei:abbr[not(@cert = 'high')]">
            <xsl:text>("</xsl:text>
            <xsl:for-each select="descendant::tei:abbr[not(@cert = 'high')]">
              <xsl:text> </xsl:text>
              <xsl:value-of select="self::*"/>
              <xsl:text> </xsl:text>
            </xsl:for-each>
            <xsl:text>") </xsl:text>
          </xsl:if>
          <xsl:text xml:space="preserve">that cannot be expanded with certainty &#10;</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="descendant::*[@reason='damage'] | ancestor::*[@reason='damage']">
          <xsl:text xml:space="preserve">- loss of vellum; some characters are lost and may have been supplied by an editor</xsl:text>
          <xsl:if
            test="descendant::*[@reason = 'damage']/@resp or ancestor::*[@reason = 'damage']/@resp">
            <xsl:text>(</xsl:text>
            <xsl:choose>
              <xsl:when test="ancestor::*[@reason = 'damage']/@resp">
                <xsl:value-of select="ancestor::*[@reason = 'damage']/@resp"
                />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of
                  select="descendant::*[@reason = 'damage']/@resp"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>)</xsl:text>
          </xsl:if>
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="descendant::*[@reason='met'] | ancestor::*[@reason='met']">
          <xsl:text xml:space="preserve">- this word is part of a metrically irregular line&#10;</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="descendant::*[@reason='fold'] | ancestor::*[@reason='fold']">
          <xsl:text xml:space="preserve">- the page edge is folded in the digital image; more text may be discernible by examining the manuscript in person &#10;</xsl:text>
        </xsl:for-each>
      </xsl:attribute>
      -->
      
      
  </xsl:template>


<!--
  <xsl:variable name="problem">
    
      <xsl:if
        test="descendant::tei:abbr[not(@cert = 'high')] and not(ancestor::tei:unclear[@reason = 'abbrv'])">
        <xsl:text xml:space="preserve">- this reading involves one or more abbreviations </xsl:text>
        <xsl:text>("</xsl:text>
        <xsl:for-each select="descendant::tei:abbr[not(@cert = 'high')]">
          <xsl:text> </xsl:text>
          <xsl:value-of select="self::*"/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
        <xsl:text>") </xsl:text>
        <xsl:text xml:space="preserve">that cannot be expanded with certainty &#10;</xsl:text>
      </xsl:if>
      <xsl:if test="ancestor::tei:corr">
        <xsl:variable name="alt" select="ancestor::tei:choice/tei:sic"/>
        <xsl:text xml:space="preserve">- this is </xsl:text>
        <xsl:choose>
          <xsl:when
            test="count(ancestor::tei:choice/tei:sic/descendant::tei:w[not(descendant::tei:w)]) &lt; count(ancestor::tei:choice/tei:corr/descendant::tei:w[not(descendant::tei:w)])">
            <xsl:text>part of an</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>an</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> editorial emendation (from </xsl:text>
        <xsl:value-of select="ancestor::tei:corr/@resp"/>
        <xsl:text>) of the manuscript reading ("</xsl:text>
        <xsl:value-of select="$alt"/>
        <xsl:text>")&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="ancestor::tei:choice[descendant::tei:unclear]">
        <xsl:variable name="selfID" select="@n"/>
        <xsl:variable name="choiceID" select="ancestor::tei:unclear[parent::tei:choice]/@n"/>
        <xsl:variable name="altChoice"
          select="ancestor::tei:choice/tei:unclear[not(@n = $choiceID)]//tei:w[@n = $selfID]"/>
        <xsl:text xml:space="preserve">- there is a possible alternative to this reading ("</xsl:text>
        <xsl:value-of select="$altChoice"/>
        <xsl:text>"), </xsl:text>
        <xsl:value-of select="$altChoice/@ana"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="ancestor::tei:supplied">
        <xsl:text xml:space="preserve">- this word has been supplied by an editor (</xsl:text>
        <xsl:value-of select="ancestor::tei:supplied/@resp"/>
        <xsl:text>) &#10;</xsl:text>
      </xsl:if>
      <xsl:if test="descendant::tei:supplied">
        <xsl:text xml:space="preserve">- some characters have been supplied by an editor (</xsl:text>
        <xsl:value-of select="descendant::tei:supplied/@resp"/>
        <xsl:text>)&#10;</xsl:text>
      </xsl:if>
      
    <xsl:if test="@xml:lang">
      <xsl:text xml:space="preserve">- this word is in a language other than Gaelic &#10;</xsl:text>
    </xsl:if>
    
      <xsl:if test="ancestor::tei:del">
        <xsl:text xml:space="preserve">- this word has been deleted by </xsl:text>
        <xsl:value-of select="key('hands', ancestor::tei:del/@resp)/tei:forename"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="key('hands', ancestor::tei:del/@resp)/tei:surname"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="key('hands', ancestor::tei:del/@resp)/@xml:id"/>
        <xsl:text>)&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="descendant::tei:del">
        <xsl:for-each select="descendant::tei:del">
          <xsl:text xml:space="preserve">- characters have been deleted by </xsl:text>
          
          <xsl:value-of select="key('hands', @resp)/tei:forename"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="key('hands', @resp)/tei:surname"/>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="key('hands', @resp)/@xml:id"/>
          
          <xsl:text>)&#10;</xsl:text>
        </xsl:for-each>
      </xsl:if>
      <xsl:if test="ancestor::tei:add[@type = 'insertion']">
        <xsl:text xml:space="preserve">- this word has been added by </xsl:text>
        
        <xsl:value-of
          select="key('hands', ancestor::tei:add[@type = 'insertion']/@resp)/tei:forename"/>
        <xsl:text> </xsl:text>
        <xsl:value-of
          select="key('hands', ancestor::tei:add[@type = 'insertion']/@resp)/tei:surname"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of
          select="key('hands', ancestor::tei:add[@type = 'insertion']/@resp)/@xml:id"/>
         
        <xsl:text>)&#10;</xsl:text>
      </xsl:if>
      <xsl:if test="descendant::tei:add[@type = 'insertion']">
        <xsl:for-each select="descendant::tei:add[@type = 'insertion']">
          <xsl:text xml:space="preserve">- characters have been added by </xsl:text>
          
          <xsl:value-of select="key('hands', @resp)/tei:forename"/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="key('hands', @resp)/tei:surname"/>
          <xsl:text> (</xsl:text>
          <xsl:value-of select="key('hands', @resp)/@xml:id"/>
          
          <xsl:text>)&#10;</xsl:text>
        </xsl:for-each>
      </xsl:if>
     
    <xsl:if test="@source">  
      <xsl:text xml:space="preserve">- this word cannot be identified with an existing dictionary headword, but it may be related to "</xsl:text>
      <xsl:value-of select="@source"/>
      <xsl:text xml:space="preserve">".&#10;</xsl:text>
    </xsl:if>
  </xsl:variable>
-->

  <xsl:template mode="diplomatic" match="tei:abbr">
    <span class="abbreviation">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>


  <xsl:template mode="diplomatic" match="tei:g">
    <!--
    <xsl:variable name="comWord"
      select="count(ancestor::tei:w[not(descendant::tei:w)]/preceding::tei:w[not(descendant::tei:w)])"/>
    <xsl:variable name="position"
      select="count(preceding::tei:g[ancestor::tei:w[not(descendant::tei:w) and count(preceding::tei:w[not(descendant::tei:w)]) = $comWord]])"/>
      -->
    <!-- <i id="l{$position}" cert="{ancestor::tei:abbr/@cert}"> -->
    <span class="abbreviation-glyph">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>
  
  
  
  
  
  <xsl:template match="tei:body" mode="edited">
    <div style="color:red;">
      <xsl:apply-templates mode="edited"/>
    </div>
  </xsl:template>
  


</xsl:stylesheet>

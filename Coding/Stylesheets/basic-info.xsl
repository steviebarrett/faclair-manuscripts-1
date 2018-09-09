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
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"/>
        <script src="../../Coding/Scripts/mss.js"/>
        <link rel="stylesheet" type="text/css" href="../../Coding/Stylesheets/mss.css"/>
      </head>
      <body>
        <div id="left-panel">
          <h1 id="#top">
            <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
          </h1>
          <div id="page-menu"> Contents: <ul>
              <li><a href="#header-information">header information</a></li>
              <li><a href="#diplomatic-transcription">diplomatic transcription</a></li>
              <li><a href="#undiplomatic-transcription">undiplomatic transcription</a></li>
            </ul>
          </div>
          <hr/>
          <hr/>
          <div id="header-information">
            <h2>Header information</h2>
            <a href="#top">Back to top</a>
            <xsl:apply-templates select="tei:TEI/tei:teiHeader"/>
          </div>
          <hr/>
          <hr/>
          <div id="diplomatic-transcription">
            <h2>Diplomatic transcription</h2>
            <a href="#top">Back to top</a>
            <xsl:apply-templates select="tei:TEI/tei:text/tei:body" mode="diplomatic"/>
          </div>
          <hr/>
          <hr/>
          <!--
          <div id="undiplomatic-transcription">
            <h2>Undiplomatic transcription</h2>
            <a href="#top">Back to top</a>
            <xsl:apply-templates select="tei:TEI/tei:text/tei:body" mode="edited"/>
          </div>
          -->
          <hr/>
          <hr/>
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
        </div>
        <div id="right-panel">Word info goes here</div>
        <script>
          <xsl:for-each select="document('../../Transcribing/corpus.xml')/tei:teiCorpus/tei:teiHeader/tei:encodingDesc/tei:charDecl/tei:glyph">
            <xsl:text>var glyph_</xsl:text>
            <xsl:value-of select="@xml:id"/>
            <xsl:text>={</xsl:text>
            <xsl:text>url:"</xsl:text>
            <xsl:value-of select="@corresp"/>
            <xsl:text>",name:"</xsl:text>
            <xsl:value-of select="tei:glyphName"/>
            <xsl:text>",description:"</xsl:text>
            <xsl:value-of select="normalize-space(translate(tei:note, '&quot;', ''))"/>
            <xsl:text>"};&#10;</xsl:text>            
          </xsl:for-each>
          <xsl:for-each select="document('../../Transcribing/corpus.xml')/tei:teiCorpus/tei:teiHeader/tei:encodingDesc/tei:classDecl/tei:taxonomy[@xml:id='POS']/tei:gloss">
            <xsl:text>var pos_</xsl:text>
            <xsl:value-of select="@xml:id"/>
            <xsl:text>='</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>';&#10;</xsl:text>            
          </xsl:for-each>
        </script>
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
      <xsl:value-of select="//tei:msItem[@xml:id = $link]/tei:title"/>
      <!-- MM: check this path -->
    </h4>
    <xsl:apply-templates mode="diplomatic"/>
  </xsl:template>



  <xsl:template mode="diplomatic" match="tei:lb">
    <!-- MM: line breaks inside words? -->
    <br id="{generate-id()}_dip" data-number="{@n}"/>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:pb">
    <h4>
      <xsl:text>Page </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>: </xsl:text>
    </h4>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:name[not(ancestor::tei:name)]">
    <span class="name chunk">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:attribute name="data-nametype">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="count(child::tei:w | child::tei:name) = 1">
          <xsl:attribute name="data-headword">
            <xsl:value-of select="tei:w/@lemma"/>
          </xsl:attribute>
          <xsl:attribute name="data-pos">
            <xsl:value-of select="tei:w/@ana"/>
          </xsl:attribute>
          <xsl:attribute name="data-edil">
            <xsl:value-of select="tei:w/@lemmaRef"/>
          </xsl:attribute>
          <xsl:value-of select="child::*[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="diplomatic"/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:name">
    <span class="name">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:attribute name="data-nametype">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="count(child::tei:w | child::tei:name) = 1">
          <xsl:attribute name="data-headword">
            <xsl:value-of select="tei:w/@lemma"/>
          </xsl:attribute>
          <xsl:attribute name="data-edil">
            <xsl:value-of select="tei:w/@lemmaRef"/>
          </xsl:attribute>
          <xsl:value-of select="child::*[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="diplomatic"/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:w[not(ancestor::tei:w or ancestor::tei:name)]">
    <span class="chunk">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:attribute name="data-headword">
        <xsl:value-of select="@lemma"/>
      </xsl:attribute>
      <xsl:attribute name="data-pos">
        <xsl:value-of select="@ana"/>
      </xsl:attribute>
      <xsl:attribute name="data-edil">
        <xsl:value-of select="@lemmaRef"/>
      </xsl:attribute>
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:w">
    <span class="word">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:attribute name="data-headword">
        <xsl:value-of select="@lemma"/>
      </xsl:attribute>
      <xsl:attribute name="data-pos">
        <xsl:value-of select="@ana"/>
      </xsl:attribute>
      <xsl:attribute name="data-edil">
        <xsl:value-of select="@lemmaRef"/>
      </xsl:attribute>
      <xsl:apply-templates mode="diplomatic"/>
    </span>
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
    <span class="glyph">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:attribute name="data-glyphref">
        <xsl:value-of select="@ref"/>
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

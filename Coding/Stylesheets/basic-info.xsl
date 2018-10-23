<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="html"/>

  <xsl:template match="/">
    <html data-docid="{tei:TEI/@xml:id}">
      <head>
        <title>
          <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        </title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"/>
        <script src="../../Coding/Scripts/mss.js"/>
        <script src="../../Coding/Scripts/comments.js"/>
        <script src="/js/bpopup.min.js"/>
        <link rel="stylesheet" type="text/css" href="../../Coding/Stylesheets/mss.css"/>
      </head>
      <body>
        <div id="left-panel">
          <h1 id="top">
            <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
          </h1>
          <div id="page-menu"> Contents: <ul>
              <li><a href="#" id="showHeader">header information</a></li>
              <li><a href="#" id="showDiplomatic">diplomatic transcription</a></li>
              <li><a href="#" id="showSemiDiplomatic">semi-diplomatic transcription</a></li>
            </ul>
          </div>
          <hr/>
          <hr/>
          <div id="headerInformation">
            <h2>Header information</h2>
            <xsl:apply-templates select="tei:TEI/tei:teiHeader"/>
          </div>
          <hr/>
          <hr/>
          <div id="diplomaticTranscription">
            <h2>Diplomatic transcription</h2>
            <xsl:apply-templates select="tei:TEI/tei:text/tei:body" mode="diplomatic"/>
          </div>
          <hr/>
          <hr/>
          <div id="semiDiplomaticTranscription">
            <h2>Semi-diplomatic transcription</h2>
            <xsl:apply-templates select="tei:TEI/tei:text/tei:body" mode="semi-diplomatic"/>
          </div>
          <hr/>
          <hr/>
        </div>
        <div id="right-panel">
        </div>
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
  
  <!-- DIPLOMATIC MODE -->

  <xsl:template match="tei:body" mode="diplomatic">
    <xsl:apply-templates mode="diplomatic"/>
  </xsl:template>

  <xsl:template match="tei:div" mode="diplomatic">
    <div style="color: gray; font-size: small; margin-top: 20px;">
      <xsl:text>[start of text </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>] </xsl:text>
      <a href="#" class="addComment" title="Leave comment on this text" data-s="div" data-n="{@n}">[+]</a>
      <div class="commentForm" id="cf__div__{@n}">
        <select>
          <option value="">-- Select a user --</option>
          <option value="et">Eystein</option>
          <option value="mm">Martina</option>
          <option value="wg">Willie</option>
        </select>
        <textarea rows="7" cols="40"></textarea><br/><br/>
        <button class="saveComment">save</button>
        <button class="cancelComment">cancel</button>
      </div>
      <xsl:text> </xsl:text>
      <a href="#" class="viewComment greyedOut" title="View comments on this text" data-s="div" data-n="{@n}">[?]</a>
    </div>
    <xsl:apply-templates mode="diplomatic"/>
    <div style="color: gray; font-size: small; margin-top: 20px;">
      <xsl:text>[end of text </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>]</xsl:text>
    </div>
  </xsl:template>

  <!-- Marginal notes - Added by SB-->
  <xsl:template match="tei:seg[@type='margNote']" mode="diplomatic">
    <xsl:text> </xsl:text>
    <a href="#" class="marginaLNoteLink" data-id="{@xml:id}">m</a>
    <div class="marginalNote" id="{@xml:id}">
      <xsl:apply-templates mode="diplomatic"/>
    </div>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:pb">
    <div style="color: gray; font-size: small; margin-top: 20px;">
      <xsl:text>[start of page </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>]</xsl:text>
    </div>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:lb">
    <!-- MM: line breaks inside words? -->
    <!--
    <a href="#" class="addComment" title="Leave comment on this line">[+]</a>
    <a href="#" class="viewComment" title="View comments on this line">[?]</a>
    -->
    <span class="lineBreak" data-number="{@n}" id="{concat('line_',@xml:id)}">
      <br id="{generate-id()}_dip" data-number="{@n}"/>
    </span>
    <a href="#" class="addComment" title="Leave comment on this line" data-s="lb" data-n="{@xml:id}">[+]</a>
    <div class="commentForm" id="{concat('cf__lb__',@xml:id)}">
      <select>
        <option value="">-- Select a user --</option>
        <option value="et">Eystein</option>
        <option value="mm">Martina</option>
        <option value="wg">Willie</option>
      </select><br/><br/>
      <textarea rows="7" cols="40"></textarea><br/><br/>
      <button class="saveComment">save</button>
      <button class="cancelComment">cancel</button>
    </div>
    <xsl:text> </xsl:text>
    <a href="#" class="viewComment greyedOut" title="View comments on this line" data-s="lb" data-n="{@xml:id}">[?]</a>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:name[not(ancestor::tei:name)]"> <!-- a name which is NOT part of a larger name -->
    <span class="word name chunk">
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
          <xsl:apply-templates mode="diplomatic"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="diplomatic"/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:name"> <!-- a name which IS part of a larger name -->
    <span class="word name">
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

  <xsl:template mode="diplomatic" match="tei:w[not(ancestor::tei:w or ancestor::tei:name)]"> <!-- a word which is NOT part of a larger word or name -->
    <span class="word chunk">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:if test="count(child::tei:w | child::tei:name) = 0"> <!-- a syntactically simple word -->
        <xsl:attribute name="data-headword">
          <xsl:value-of select="@lemma"/>
        </xsl:attribute>
        <xsl:attribute name="data-pos">
          <xsl:value-of select="@ana"/>
        </xsl:attribute>
        <xsl:attribute name="data-edil">
          <xsl:value-of select="@lemmaRef"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:w"> <!-- a word which IS part of a larger word or name -->
    <span class="word">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:if test="count(child::tei:w) != 0">  <!-- a compound word - added by SB - to be revised by MM -->
        <xsl:attribute name="data-compound">
          <xsl:value-of select="1"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="count(child::tei:w | child::tei:name) = 0"> <!-- a syntactically simple word -->
        <xsl:attribute name="data-headword">
          <xsl:value-of select="@lemma"/>
        </xsl:attribute>
        <xsl:attribute name="data-pos">
          <xsl:value-of select="@ana"/>
        </xsl:attribute>
        <xsl:attribute name="data-edil">
          <xsl:value-of select="@lemmaRef"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

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

  <xsl:template mode="diplomatic" match="tei:space">
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:unclear">
    <span class="unclear" data-cert="{@cert}" data-reason="{@reason}">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>
  
  <xsl:template mode="diplomatic" match="tei:del">
    <span class="deletion" data-hand="{@resp}">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:add">
    <span class="addition" data-hand="{@resp}" data-place="{@place}" data-type="{@type}">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:supplied">
    <span class="supplied">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>
  
  <xsl:template mode="diplomatic" match="tei:choice">  <!-- this needs work cf. lines 1249-53 of BoD -->
    <xsl:apply-templates mode="diplomatic" select="tei:corr"/>
  </xsl:template>

  <!-- SEMI-DIPLOMATIC -->

  <xsl:template match="tei:body" mode="semi-diplomatic">
    <xsl:apply-templates select="tei:div" mode="semi-diplomatic"/>
  </xsl:template>
    
  <xsl:template match="tei:div" mode="semi-diplomatic">
    <div style="color: gray; font-size: small; margin-top: 20px;">
      <xsl:text>[start of text </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>] </xsl:text>
    </div>
    <xsl:apply-templates mode="semi-diplomatic"/>
    <div style="color: gray; font-size: small; margin-top: 20px;">
      <xsl:text>[end of text </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>]</xsl:text>
    </div>
  </xsl:template>

  <xsl:template mode="semi-diplomatic" match="tei:name[not(ancestor::tei:name)]"> <!-- a name which is NOT part of a larger name -->
    <span class="word name chunk">
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
          <xsl:apply-templates mode="semi-diplomatic"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="semi-diplomatic"/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:name"> <!-- a name which IS part of a larger name -->
    <span class="word name">
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
          <xsl:apply-templates mode="semi-diplomatic"/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:w[not(ancestor::tei:w or ancestor::tei:name)]"> <!-- a word which is NOT part of a larger word or name -->
    <span class="word chunk">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:if test="count(child::tei:w | child::tei:name) = 0"> <!-- a syntactically simple word -->
        <xsl:attribute name="data-headword">
          <xsl:value-of select="@lemma"/>
        </xsl:attribute>
        <xsl:attribute name="data-pos">
          <xsl:value-of select="@ana"/>
        </xsl:attribute>
        <xsl:attribute name="data-edil">
          <xsl:value-of select="@lemmaRef"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="semi-diplomatic"/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:w"> <!-- a word which IS part of a larger word or name -->
    <span class="word">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:if test="count(child::tei:w | child::tei:name) = 0"> <!-- a syntactically simple word -->
        <xsl:attribute name="data-headword">
          <xsl:value-of select="@lemma"/>
        </xsl:attribute>
        <xsl:attribute name="data-pos">
          <xsl:value-of select="@ana"/>
        </xsl:attribute>
        <xsl:attribute name="data-edil">
          <xsl:value-of select="@lemmaRef"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="semi-diplomatic"/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

<!-- 
  <xsl:template match="tei:w | tei:name" mode="semi-diplomatic">
    <xsl:text> </xsl:text>
    <xsl:apply-templates mode="semi-diplomatic"/>
    <xsl:text> </xsl:text>
  </xsl:template>
  -->


</xsl:stylesheet>

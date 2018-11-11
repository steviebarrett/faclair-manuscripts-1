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
          <div id="headerInformation">
            <h2>Header information</h2>
            <xsl:apply-templates select="tei:TEI/tei:teiHeader"/>
          </div>
          <div id="diplomaticTranscription">
            <h2>Diplomatic transcription</h2>
            <xsl:apply-templates select="tei:TEI/tei:text/tei:body" mode="diplomatic"/>
          </div>
          <div id="semiDiplomaticTranscription">
            <h2>Semi-diplomatic transcription</h2>
            <xsl:apply-templates select="tei:TEI/tei:text/tei:body" mode="semi-diplomatic"/>
          </div>
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
            <xsl:value-of select="normalize-space(translate(tei:note, '&quot;', '%'))"/>
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
      <xsl:text>: </xsl:text>
      <xsl:value-of select="@type"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@resp"/>
      <xsl:text>] </xsl:text>
      <a href="#" class="addComment" title="Leave comment on this text" data-s="div" data-n="{@n}">[+]</a>
      <div class="commentForm" id="cf__div__{@n}">
        <xsl:call-template name="commentForm"/>
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
  
  <xsl:template name="commentForm">
    <select>
      <option value="">-- Select a user --</option>
      <option value="et">Eystein</option>
      <option value="mm">Martina</option>
      <option value="wg">Willie</option>
    </select>
    <textarea rows="7" cols="40"></textarea><br/><br/>
    <button class="saveComment">save</button>
    <button class="cancelComment">cancel</button>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:pb">
    <div style="color: gray; font-size: small; margin-top: 20px;">
      <xsl:text>[start of page </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>]</xsl:text>
    </div>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:lb">
    <span class="lineBreak" data-number="{@n}" id="{concat('line_',@xml:id)}">
      <br/>
      <a href="#" class="addComment" title="Leave comment on this line" data-s="lb" data-n="{@xml:id}">[+]</a>
      <div class="commentForm" id="{concat('cf__lb__',@xml:id)}">
        <xsl:call-template name="commentForm"/>
      </div>
      <xsl:text> </xsl:text>
      <a href="#" class="viewComment greyedOut" title="View comments on this line" data-s="lb" data-n="{@xml:id}">[?]</a>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:name[not(ancestor::tei:name)]"> <!-- a name which is NOT part of a larger name -->
    <span class="name chunk syntagm">
      <xsl:attribute name="data-nametype">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:name"> <!-- a name which IS part of a larger name -->
    <span class="name syntagm">
      <xsl:attribute name="data-nametype">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:w[not(ancestor::tei:w or ancestor::tei:name)]"> <!-- a word which is NOT part of a larger word or name -->
    <span class="word chunk syntagm">
      <xsl:if test="count(tei:w) = 0"> <!-- a syntactically simple word -->
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
    <span class="word syntagm">
      <xsl:if test="count(tei:w) = 0"> <!-- a syntactically simple word -->
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
  
  <xsl:template mode="diplomatic" match="tei:date">
    <span class="syntagm">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:g">
    <xsl:choose>
      <xsl:when test="starts-with(@ref,'l')"> <!-- ligature -->
        <span class="ligature">
          <xsl:attribute name="data-glyphref">
            <xsl:value-of select="@ref"/>
          </xsl:attribute>
          <xsl:apply-templates mode="diplomatic"/>
        </span>
      </xsl:when>
      <xsl:otherwise> <!-- expansion -->
        <span class="expansion">
          <xsl:attribute name="data-glyphref">
            <xsl:value-of select="@ref"/>
          </xsl:attribute>
          <xsl:apply-templates mode="diplomatic"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:space">
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template mode="diplomatic" match="tei:pc">
    <span class="punct">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:unclear[@reason='damage']">
    <span class="damagedDiplo">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>
  
  <xsl:template mode="diplomatic" match="tei:unclear[@reason='text_obscure']">
    <span class="obscureTextDiplo">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>
  
  <xsl:template mode="diplomatic" match="tei:del">
    <span class="deletion" data-hand="{@resp}">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:add">
    <xsl:choose>
      <xsl:when test="@place='above'">
        <span class="addition above" data-hand="{@resp}" data-place="{@place}"  data-type="{@type}">
          <xsl:apply-templates mode="diplomatic"/>
        </span>
      </xsl:when>
      <xsl:when test="@place='below'">
        <span class="addition below" data-hand="{@resp}" data-place="{@place}"  data-type="{@type}">
          <xsl:apply-templates mode="diplomatic"/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <span class="addition" data-hand="{@resp}" data-place="{@place}" data-type="{@type}">
          <xsl:apply-templates mode="diplomatic"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:supplied">
    <span class="suppliedDiplo">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>
  
  <xsl:template mode="diplomatic" match="tei:choice">
    <span class="correction">
      <xsl:attribute name="title">
        <xsl:text>Probably: </xsl:text>
        <xsl:apply-templates select="tei:corr" mode="diplomatic"/>
      </xsl:attribute>
      <xsl:apply-templates mode="diplomatic" select="tei:sic"/>
    </span>
  </xsl:template>

  <!-- ignore notes in diplomatic edition - Added by SB -->
  <xsl:template mode="diplomatic" match="tei:note"/>
  
  <!-- Marginal notes - Added by SB-->
  <xsl:template match="tei:seg[@type='margNote']" mode="diplomatic">
    <xsl:text> </xsl:text>
    <a href="#" class="marginaLNoteLink" data-id="{@xml:id}">m</a>
    <div class="marginalNote" id="{@xml:id}">
      <xsl:apply-templates mode="diplomatic"/>
    </div>
  </xsl:template>

  <!-- SEMI-DIPLOMATIC -->

  <xsl:template match="tei:body" mode="semi-diplomatic">
    <xsl:apply-templates select="tei:div" mode="semi-diplomatic"/>
  </xsl:template>
    
  <xsl:template match="tei:div" mode="semi-diplomatic">
    <div style="color: gray; font-size: small; margin-top: 20px;">
      <xsl:text>[start of text </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="@type"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="@resp"/>
      <xsl:text>] </xsl:text>
    </div>
    <xsl:apply-templates mode="semi-diplomatic"/>
    <div style="color: gray; font-size: small; margin-top: 20px;">
      <xsl:text>[end of text </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>]</xsl:text>
    </div>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:p">
    <p>
      <xsl:apply-templates mode="semi-diplomatic"/>
    </p>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:name[not(ancestor::tei:name)]"> <!-- a name which is NOT part of a larger name -->
    <span class="name chunk syntagm">
      <xsl:attribute name="data-nametype">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates mode="semi-diplomatic"/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:name"> <!-- a name which IS part of a larger name -->
    <span class="name syntagm">
      <xsl:attribute name="data-nametype">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:apply-templates mode="semi-diplomatic"/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:w[not(ancestor::tei:w or ancestor::tei:name)]"> <!-- a word which is NOT part of a larger word or name -->
    <span class="word chunk syntagm">
      <xsl:if test="count(tei:w) = 0"> <!-- a syntactically simple word -->
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
    <span class="word syntagm">
      <xsl:if test="count(tei:w) = 0"> <!-- a syntactically simple word -->
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
  
  <xsl:template mode="semi-diplomatic" match="tei:date">
    <span class="syntagm">
      <xsl:apply-templates mode="semi-diplomatic"/>
    </span>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:g">
    <xsl:choose>
      <xsl:when test="starts-with(@ref,'l')">
        <span class="ligature">
          <xsl:attribute name="data-glyphref">
            <xsl:value-of select="@ref"/>
          </xsl:attribute>
          <xsl:apply-templates mode="semi-diplomatic"/>
        </span>
      </xsl:when>
      <xsl:otherwise>
        <span class="expansion">
          <xsl:attribute name="data-glyphref">
            <xsl:value-of select="@ref"/>
          </xsl:attribute>
          <xsl:apply-templates mode="semi-diplomatic"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="semi-diplomatic" match="tei:del">
    <span class="deletion" data-hand="{@resp}">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:add">
    <span class="addition" data-hand="{@resp}" data-place="{@place}" data-type="{@type}">
      <xsl:apply-templates mode="semi-diplomatic"/>
    </span>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:choice">
    <span class="correction">
      <xsl:attribute name="title">
        <xsl:text>Corrected from: </xsl:text>
        <xsl:apply-templates select="tei:sic" mode="semi-diplomatic"/>
      </xsl:attribute>
      <xsl:apply-templates mode="semi-diplomatic" select="tei:corr"/>
    </span>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:note">
    <a href="#" title="{.}">[*]</a>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:lg">
    <p>
      <xsl:apply-templates mode="semi-diplomatic"/>
    </p>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:l">
    <xsl:apply-templates mode="semi-diplomatic"/>
    <br/>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:supplied">
    <span class="suppliedSemi">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates mode="semi-diplomatic"/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:unclear[@reason='damage']">
    <span class="damagedSemi">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates mode="diplomatic"/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:unclear[@reason='text_obscure']">
    <span class="obscureTextSemi">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates mode="diplomatic"/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:pb">
    <span style="color: gray; font-size: small; font-family: Helvetica;">
      <xsl:text> [p. </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>] </xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:lb">
    <span style="color: gray; font-size: small; font-family: Helvetica;">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>) </xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template mode="semi-diplomatic" match="tei:pc">
    <span class="punct">
      <xsl:text> </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>
  

</xsl:stylesheet>

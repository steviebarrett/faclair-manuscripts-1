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
        <script src="https://cdnjs.cloudflare.com/ajax/libs/bPopup/0.11.0/jquery.bpopup.min.js"/>
        <link rel="stylesheet" type="text/css" href="../../Coding/Stylesheets/mss.css"/>
      </head>
      <body>
        <div id="leftPanel">
          <h1 id="top">
            <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
          </h1>
          <div id="pageMenu"> Contents: <ul>
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
          <p></p>
          <p></p>
        </div>
        <div id="rightPanel">
          <!--
          <h1 id="headword"></h1>
          <ul id="syntaxInfo"></ul>
          <p id="expansionInfo" style="display:none;">
            Contains the following scribal expansions and ligatures:
            <ul id="expansionList"></ul>
          </p>
          <p id="damagedInfo"></p>
          <p id="deletionInfo"></p>
          <p id="additionInfo"></p>
          -->
        </div>
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

  <!--
    <xsl:template match="tei:div/tei:div" mode="diplomatic">
      <xsl:apply-templates mode="diplomatic"/>
    </xsl:template>
  -->

  <xsl:template match="tei:div" mode="diplomatic">
    <div class="text" data-hand="{@hand}" data-n="{@n}" data-corresp="{@corresp}" data-type="{@type}" data-ms="{substring(/tei:TEI/@xml:id,2)}">
      <h1 class="textHeader">
        <xsl:text>[start of </xsl:text>
        <a href="#" class="textLink">
          <xsl:text>Text </xsl:text>
          <xsl:value-of select="@n"/>
        </a>
        <xsl:text>] </xsl:text>
        <a href="#" class="addComment" title="Leave comment on this text" data-s="div" data-n="{@n}">[+]</a>
        <div class="commentForm" id="cf__div__{@n}">
          <xsl:call-template name="commentForm"/>
        </div>
        <xsl:text> </xsl:text>
        <a href="#" class="viewComment greyedOut" title="View comments on this text" data-s="div" data-n="{@n}">[?]</a>
      </h1>
      <xsl:apply-templates mode="diplomatic"/>
      <h1 class="textFooter">
        <xsl:text>[end of Text </xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>]</xsl:text>
      </h1>
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
      <xsl:text>[start of </xsl:text>
      <xsl:choose>      <!-- SB: added to handle instances where there is no image link for the MSS page -->
        <xsl:when test="@facs">
          <a href="#" class="page" data-facs="{@facs}">
            <xsl:text>page </xsl:text>
            <xsl:value-of select="@n"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>page </xsl:text>
          <xsl:value-of select="@n"/>
        </xsl:otherwise>  <!-- // -->
      </xsl:choose>
      <xsl:text>]</xsl:text>
    </div>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:handShift">
    <span class="handshift" data-hand="{@new}">[hs]</span>
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

  <xsl:template mode="diplomatic" match="tei:cb">
    <div style="color: gray; font-size: small; margin-top: 20px;">
      <xsl:text>[start of column </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>]</xsl:text>
    </div>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:lg">
    <xsl:apply-templates mode="diplomatic"/>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:l">
    <xsl:apply-templates mode="diplomatic"/>
    <!-- <span style="color: gray;"> / </span> -->
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
        <xsl:choose>
          <xsl:when test="@xml:lang">
            <xsl:attribute name="xml:lang">
              <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="data-headword">
              <xsl:value-of select="@lemma"/>
            </xsl:attribute>
            <xsl:attribute name="data-pos">
              <xsl:value-of select="@pos"/>
            </xsl:attribute>
            <xsl:attribute name="data-edil">
              <xsl:value-of select="@lemmaRef"/>
            </xsl:attribute>
            <xsl:attribute name="data-lemmasl">
              <xsl:value-of select="@lemmaSL"/>
            </xsl:attribute>
            <xsl:attribute name="data-slipref">
              <xsl:value-of select="@slipRef"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:w"> <!-- a word which IS part of a larger word or name -->
    <span class="word syntagm">
      <xsl:if test="count(tei:w) = 0"> <!-- a syntactically simple word -->
        <xsl:choose>
          <xsl:when test="@xml:lang">
            <xsl:attribute name="xml:lang">
              <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="data-headword">
              <xsl:value-of select="@lemma"/>
            </xsl:attribute>
            <xsl:attribute name="data-pos">
              <xsl:value-of select="@pos"/>
            </xsl:attribute>
            <xsl:attribute name="data-edil">
              <xsl:value-of select="@lemmaRef"/>
            </xsl:attribute>
            <xsl:attribute name="data-lemmasl">
              <xsl:value-of select="@lemmaSL"/>
            </xsl:attribute>
            <xsl:attribute name="data-slipref">
              <xsl:value-of select="@slipRef"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:date | tei:c | tei:num">
    <span class="chunk syntagm">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:g">
    <xsl:choose>
      <xsl:when test="starts-with(@ref,'l')"> <!-- ligature -->
        <xsl:choose>
          <xsl:when test="@corresp">  <!-- SB: added to handle corresp attributes in glyphs -->
            <span class="ligature corresp-{@corresp}" data-corresp="{@corresp}" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates mode="diplomatic"/>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <span class="ligature" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates mode="diplomatic"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="../@cert"> <!-- expansion -->
        <xsl:choose>
          <xsl:when test="@corresp">  <!-- SB: added to handle corresp attributes in glyphs -->
            <span class="expansion corresp-{@corresp}" data-corresp="{@corresp}" data-cert="{../@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates mode="diplomatic"/>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <span class="expansion" data-cert="{../@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates mode="diplomatic"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise> <!-- weird expansion -->
        <xsl:variable name="corresp" select="@corresp"/>
        <span class="expansion" data-cert="{preceding::tei:abbr[@corresp=$corresp]/@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
          <xsl:apply-templates mode="diplomatic"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:space">
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:pc[not(ancestor::tei:w)]">
    <span class="punct">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:unclear[@reason='damage']">
    <span class="unclearDamageDiplo" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:attribute name="data-add">
        <xsl:apply-templates mode="diplomatic"/>
      </xsl:attribute>
      <xsl:text>[...]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:unclear[@reason='text_obscure']">
    <span class="unclearTextObscureDiplo" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:unclear[@reason='char']">
    <span class="unclearCharDiplo" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:unclear[@reason='interp_obscure']">
    <span class="unclearInterpObscureDiplo" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:del">
    <span class="deletionDiplo" data-hand="{@hand}">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:add[@type='gloss']">
    <span class="gloss" data-hand="{@hand}" data-place="{@place}">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:add[@type='insertion']">
    <span class="insertion" data-hand="{@hand}" data-place="{@place}">
      <xsl:apply-templates mode="diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:supplied">
    <span class="suppliedDiplo">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates mode="diplomatic"/>
      <xsl:text>]</xsl:text>
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

  <xsl:template match="tei:gap" mode="diplomatic">
    <span class="gapDamageDiplo" data-extent="{@extent}" data-unit="{@unit}" data-resp="{@resp}">
      <xsl:text>[...]</xsl:text>
    </span>
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
        <xsl:attribute name="data-lemmasl">
          <xsl:value-of select="@lemmaSL"/>
        </xsl:attribute>
        <xsl:attribute name="data-slipref">
          <xsl:value-of select="@slipRef"/>
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
        <xsl:attribute name="data-lemmasl">
          <xsl:value-of select="@lemmaSL"/>
        </xsl:attribute>
        <xsl:attribute name="data-slipref">
          <xsl:value-of select="@slipRef"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="semi-diplomatic"/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template mode="semi-diplomatic" match="tei:date | tei:c | tei:num">
    <span class="syntagm">
      <xsl:apply-templates mode="semi-diplomatic"/>
    </span>
  </xsl:template>

  <xsl:template mode="semi-diplomatic" match="tei:g">
    <xsl:choose>
      <xsl:when test="starts-with(@ref,'l')"> <!-- ligature -->
        <xsl:choose>
          <xsl:when test="@corresp">  <!-- SB: added to handle corresp attributes in glyphs -->
            <span class="ligature corresp-{@corresp}" data-corresp="{@corresp}" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates mode="semi-diplomatic"/>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <span class="ligature" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates mode="semi-diplomatic"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="../@cert"> <!-- expansion -->
        <xsl:choose>
          <xsl:when test="@corresp">  <!-- SB: added to handle corresp attributes in glyphs -->
            <span class="expansion corresp-{@corresp}" data-corresp="{@corresp}" data-cert="{../@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates mode="semi-diplomatic"/>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <span class="expansion" data-cert="{../@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates mode="semi-diplomatic"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise> <!-- weird expansion -->
        <xsl:variable name="corresp" select="@corresp"/>
        <span class="expansion" data-cert="{preceding::tei:abbr[@corresp=$corresp]/@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
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

  <xsl:template mode="semi-diplomatic" match="tei:cb">
    <span style="color: gray; font-size: small; font-family: Helvetica;">
      <xsl:text> [col. </xsl:text>
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

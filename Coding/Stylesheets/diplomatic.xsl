<?xml version="1.0" encoding="UTF-8"?>
<!-- 
This transformation is called by viewTranscription.php
It creates a diplomatic MS view. 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="html"/>

  <xsl:template match="/">
    <div data-docid="{tei:TEI/@xml:id}" data-diplo="yes">
      <!-- <span class="pageBreak"><small class="text-muted">[toggle <a href="#" id="commentToggle">comments</a>]</small></span> -->
      <xsl:apply-templates select="tei:TEI/tei:text/tei:body/tei:div"/>
    </div>
  </xsl:template>

  <xsl:template match="tei:div"> 
    <!--
    <div class="text" data-hand="{@hand}" data-n="{@n}" data-corresp="{@corresp}" data-type="{@type}" data-ms="{substring(/tei:TEI/@xml:id,2)}"> 
      <div class="textAnchor">
        <button type="button" data-toggle="modal" data-target="#commentForm" class="addComment" title="Leave comment on this text" data-s="div" data-n="{@n}">+</button>
        <xsl:text> </xsl:text>
        <button type="button" class="viewComment greyedOut" title="View comments on this text" data-s="div" data-n="{@n}">?</button>
        <xsl:text> </xsl:text>
        <small class="text-muted">[start of <span title="{concat(@type,' ',@corresp)}">Text <xsl:value-of select="@n"/></span>]</small>
        <small class="text-muted" title="{tei:p/tei:handShift/@new}">[hs]</small>
      </div>
      -->
      <xsl:apply-templates/>
    <!--
      <div class="textAnchor"><small class="text-muted">[end of Text <xsl:value-of select="@n"/>]</small></div>
    </div>
    -->
  </xsl:template>

  <xsl:template match="tei:pb"> <!-- page breaks represented as <br> and a link to the image -->
    <span class="pageAnchor">
      <br/>
      <small class="text-muted">[start of page 
        <xsl:choose>
          <xsl:when test="@facs">
            <a href="#" class="page" data-facs="{@facs}">
              <xsl:value-of select="@n"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@n"/>
          </xsl:otherwise>
        </xsl:choose>]
      </small>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:w/tei:handShift"> <!-- e.g. MS1.4r.11 -->
    <span class="handshift" data-hand="{@new}" title="{@new}"><small class="text-muted">[beg. <xsl:value-of select="@new"/>]</small></span>
  </xsl:template>
  
  <xsl:template match="tei:lb">
    <span class="lineBreak" data-number="{@n}" id="{concat('line_',@xml:id)}">
      <br/>
      <!--
      <button type="button" data-toggle="modal" data-target="#commentForm" class="addComment" title="Leave comment on this line" data-s="lb" data-n="{@xml:id}">+</button>
      <xsl:text> </xsl:text>
      <button type="button" class="viewComment greyedOut" title="View comments on this line" data-s="lb" data-n="{@xml:id}">?</button>
      <xsl:text> </xsl:text>
      -->
    </span>
  </xsl:template>

  <xsl:template match="tei:cb">
    <br/>
    <span class="pageAnchor">
      <small class="text-muted">[start of column <xsl:value-of select="@n"/>]</small>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:lg|tei:l|tei:p|tei:note"> <!-- ignore verse, paragraphs and notes in diplo view -->
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:space">
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:pc">
    <span class="punct">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>

  <xsl:template match="tei:date | tei:c | tei:num">
    <span class="chunk">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:name[not(ancestor::tei:name) and count(tei:w|tei:name)=1]"> 
    <span class="word chunk syntagm name">
      <xsl:call-template name="addNameAttributes"/>
      <xsl:for-each select="tei:w">
        <xsl:call-template name="addWordAttributes"/>
        <xsl:apply-templates/>
      </xsl:for-each>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:name[not(ancestor::tei:name) and count(tei:w|tei:name)>1]"> 
    <span class="chunk syntagm name">
      <xsl:call-template name="addNameAttributes"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:name[ancestor::tei:name and count(tei:w|tei:name)=1]"> 
    <span class="word syntagm name">
      <xsl:call-template name="addNameAttributes"/>
      <xsl:for-each select="tei:w">
        <xsl:call-template name="addWordAttributes"/>
        <xsl:apply-templates/>
      </xsl:for-each>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:name[ancestor::tei:name and count(tei:w|tei:name)>1]"> 
    <span class="syntagm name">
      <xsl:call-template name="addNameAttributes"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:w[not(ancestor::tei:w) and not(descendant::tei:w)]"> 
    <span class="word chunk syntagm">
      <xsl:call-template name="addWordAttributes"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:w[not(ancestor::tei:w) and descendant::tei:w]"> 
    <span class="chunk syntagm">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:w[ancestor::tei:w and not(descendant::tei:w)]"> 
    <span class="word syntagm">
      <xsl:call-template name="addWordAttributes"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:w">  <!-- a word which IS part of a larger word and also contains smaller words -->
    <span class="syntagm">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template name="addNameAttributes">
    <xsl:if test="@type">
      <xsl:attribute name="data-nametype">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@corresp">
      <xsl:attribute name="data-corresp">
        <xsl:value-of select="@corresp"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="addWordAttributes">
    <xsl:if test="@xml:lang">
      <xsl:attribute name="xml:lang">
        <xsl:value-of select="@xml:lang"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@lemma">
      <xsl:attribute name="data-lemma">
        <xsl:value-of select="@lemma"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@lemmaRef">
      <xsl:attribute name="data-lemmaRef">
        <xsl:value-of select="@lemmaRef"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@pos">
      <xsl:attribute name="data-pos">
        <xsl:value-of select="@pos"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@source">
      <xsl:attribute name="data-source">
        <xsl:value-of select="@source"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@lemmaSL">
      <xsl:attribute name="data-lemmaSL">
        <xsl:value-of select="@lemmaSL"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@slipRef">
      <xsl:attribute name="data-slipRef">
        <xsl:value-of select="@sslipRef"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:g[starts-with(@ref, 'g') and ../@cert]">
    <span class="expansion" data-cert="{../@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:g[starts-with(@ref,'l')]">
    <span class="ligature" data-glyphref="{@ref}" id="{generate-id(.)}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

<!-- bits of this may need to be reinserted, for discontinuities
  <xsl:template match="tei:g">
    <xsl:choose>
      <xsl:when test="starts-with(@ref,'l')"> 
        <xsl:choose>
          <xsl:when test="@corresp">   
            <span class="ligature corresp-{@corresp}" data-corresp="{@corresp}" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates/>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <span class="ligature" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:when test="../@cert">  
        <xsl:choose>
          <xsl:when test="@corresp">   
            <span class="expansion corresp-{@corresp}" data-corresp="{@corresp}" data-cert="{../@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates/>
            </span>
          </xsl:when>
          <xsl:otherwise>
            <span class="expansion" data-cert="{../@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
              <xsl:apply-templates/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>  
        <xsl:variable name="corresp" select="@corresp"/>
        <span class="expansion" data-cert="{preceding::tei:abbr[@corresp=$corresp]/@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  -->

  <xsl:template match="tei:unclear[@reason='damage']"> <!-- e.g. MS1.85r.17 -->
    <span class="unclearDamage" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:unclear[@reason='text_obscure']"> <!-- ??? -->
    <span class="unclearTextObscure" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:unclear[@reason='char']"> <!-- ??? -->
    <span class="unclearChar" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:unclear[@reason='interp_obscure']"> <!-- ??? -->
    <span class="unclearInterpObscure" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:del"> <!-- e.g.MS1.3r.19,  -->
    <span class="deletion" data-hand="{@hand}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:add[@type='gloss']">
    <span class="gloss" data-hand="{@hand}" data-place="{@place}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:add[@type='insertion']"> <!-- e.g. MS1.3r.17 -->
    <span class="insertion" data-hand="{@hand}" data-place="{@place}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:choice"> <!-- editorial emendations e.g. MS1.4r.2 ro/do NOT PERFECT YET-->
    <span class="sic" data-resp="{tei:corr/@resp}" data-alt="{tei:corr/.}"> 
      <xsl:apply-templates select="tei:sic"/>
    </span>
  </xsl:template>

  <!-- ignore notes in diplomatic edition -->
  <xsl:template match="tei:note"/>

  <!-- Marginal notes - Added by SB-->
  <xsl:template match="tei:seg[@type='margNote']">
    <xsl:text> </xsl:text>
    <a href="#" class="marginalNoteLink" data-id="{@xml:id}">m</a>
    <div class="marginalNote" id="{@xml:id}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:seg[@type='cfe']"> <!-- no idea what this means -->
    <span>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:gap[@unit='folio']"> <!-- needs work -->
    <br/>
    <span class="missingFolio" data-quantity="{@quantity}" data-unit="{@unit}" data-resp="{@resp}">
      <small class="text-muted">
      <xsl:text> [</xsl:text><xsl:value-of select="@quantity"></xsl:value-of><xsl:text> missing folio(s)] </xsl:text>
      </small>
    </span>
  </xsl:template>

  <xsl:template match="tei:gap[@unit='chars']"> <!-- needs work -->
    <span class="missingChars" data-quantity="{@quantity}" data-unit="{@unit}" data-resp="{@resp}">
      <xsl:text>[..] </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:head/tei:title"/>
  
  <xsl:template match="tei:anchor">
    <xsl:variable name="target" select="@copyOf"/>
    <span class="pageBreak">
      <br/>
      <small class="text-muted">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="@comment"/>
        <xsl:text>]</xsl:text>
      </small>
    </span>
    <xsl:apply-templates select="document(concat('../../Transcribing/Transcriptions/transcription',@source,'.xml'))/descendant::tei:div[@corresp=$target]"/>
  </xsl:template>
  
  <xsl:template match="tei:supplied"> <!-- editorial insertions e.g. MS1.3r.20 mor[maer], MS1.5r.25 [a] -->
    <span class="supplied" data-resp="{@resp}">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>

</xsl:stylesheet>

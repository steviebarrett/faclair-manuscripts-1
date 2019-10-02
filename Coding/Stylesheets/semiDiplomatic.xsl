<?xml version="1.0" encoding="UTF-8"?>
<!-- 
This transformation is called by viewTranscription.php
It creates a semi-diplomatic MS view. 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="html"/>

  <xsl:template match="/">
    <div data-docid="{tei:TEI/@xml:id}"> <!-- MM: do we still need this attribute? -->
      <xsl:apply-templates select="tei:TEI/tei:text/tei:body/tei:div"/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:div"> <!-- MM: check ALL of this with SB -->
    <div class="text" data-hand="{@hand}" data-n="{@n}" data-corresp="{@corresp}" data-type="{@type}" data-ms="{substring(/tei:TEI/@xml:id,2)}"> 
      <div><small class="text-muted">[start of Text <xsl:value-of select="@n"/>]</small></div>
      <button type="button" data-toggle="modal" data-target="#commentForm" class="addComment" title="Leave comment on this text" data-s="div" data-n="{@n}">[+]</button>
      <xsl:text> </xsl:text>
      <a href="#" class="viewComment greyedOut" title="View comments on this text" data-s="div" data-n="{@n}">[?]</a>
      <xsl:apply-templates/>
      <div><small class="text-muted">[end of Text <xsl:value-of select="@n"/>]</small></div>
    </div>
  </xsl:template>

  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:name[not(ancestor::tei:name)]"> <!-- a name which is NOT part of a larger name -->
    <span class="name chunk syntagm">
      <xsl:attribute name="data-nametype">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:attribute name="data-corresp">
        <xsl:value-of select="@corresp"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:name"> <!-- a name which IS part of a larger name -->
    <span class="name syntagm">
      <xsl:attribute name="data-nametype">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:attribute name="data-corresp">
        <xsl:value-of select="@corresp"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:w[not(ancestor::tei:w or ancestor::tei:name)]"> <!-- a word which is NOT part of a larger word or name -->
    <span class="word chunk syntagm">
      <xsl:if test="count(tei:w) = 0"> <!-- a syntactically simple word -->
        <xsl:call-template name="addAttributes"/>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template name="addAttributes">
    <xsl:attribute name="data-headword">
      <xsl:value-of select="@lemmaRef"/>
    </xsl:attribute>
    <!--
    <xsl:attribute name="data-hand">
      <xsl:value-of select="preceding::tei:handShift[1]/@new"/>
    </xsl:attribute>
    -->
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
  </xsl:template>

  <!-- Added by SB to handle compound verbs -->
  <xsl:template match="tei:w[contains(@pos, 'verb') and descendant::tei:w]">
    <xsl:call-template name="compound-verb"/>
  </xsl:template>

  <xsl:template name="compound-verb" match="tei:w">
    <xsl:if test="@pos = 'verb' and @lemmaRef != 'http://www.dil.ie/29104'">  <!-- checks for POS and copula -->
      <xsl:text> </xsl:text>  <!-- only adds a space before a verb that is not the copula -->
    </xsl:if>
    <span class="word chunk syntagm">
      <xsl:if test="count(tei:w) = 0"> <!-- a syntactically simple word -->
        <xsl:call-template name="addAttributes"/>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
    <xsl:if test="@pos = 'verb'">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- Added by SB to handle bottom level words (no word division) -->
  <xsl:template match="tei:w[ancestor::tei:w and not(descendant::tei:w)]">
    <span class="word chunk syntagm">
      <xsl:if test="count(tei:w) = 0"> <!-- a syntactically simple word -->
        <xsl:call-template name="addAttributes"/>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:w"> <!-- a word which IS part of a larger word or name -->
    <span class="word syntagm">
      <xsl:if test="count(tei:w) = 0"> <!-- a syntactically simple word -->
        <xsl:call-template name="addAttributes"/>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:date | tei:c | tei:num">
    <span class="syntagm">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:g">
    <xsl:choose>
      <xsl:when test="starts-with(@ref,'l')"> <!-- ligature -->
        <xsl:choose>
          <xsl:when test="@corresp">  <!-- SB: added to handle corresp attributes in glyphs -->
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
      <xsl:when test="../@cert"> <!-- expansion -->
        <xsl:choose>
          <xsl:when test="@corresp">  <!-- SB: added to handle corresp attributes in glyphs -->
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
      <xsl:otherwise> <!-- weird expansion -->
        <xsl:variable name="corresp" select="@corresp"/>
        <span class="expansion" data-cert="{preceding::tei:abbr[@corresp=$corresp]/@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:handShift">
    <span class="handshift" data-hand="{@new}"></span>
  </xsl:template>

  <xsl:template match="tei:del">
    <span class="deletion" data-hand="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:add">
    <span class="addition" data-hand="{@resp}" data-place="{@place}" data-type="{@type}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:add[@type='insertion']">
    <span class="insertion" data-hand="{@hand}" data-place="{@place}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:choice">
    <span class="correction">
      <xsl:attribute name="title">
        <xsl:text>Corrected from: </xsl:text>
        <xsl:apply-templates select="tei:sic"/>
      </xsl:attribute>
      <xsl:apply-templates select="tei:corr"/>
    </span>
  </xsl:template>

  <xsl:template match="tei:note">
    <a href="#" title="{.}">[*]</a>
  </xsl:template>

  <xsl:template match="tei:lg">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:l">
    <xsl:apply-templates/>
    <br/>
  </xsl:template>

  <xsl:template match="tei:supplied">
    <span class="suppliedSemi">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:unclear[@reason='damage']">
    <span class="damagedSemi">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:unclear[@reason='text_obscure']">
    <span class="obscureTextSemi">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:pb">
    <span style="color: gray; font-size: small; font-family: Helvetica;">
      <xsl:text> [p. </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>] </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:cb">
    <span style="color: gray; font-size: small; font-family: Helvetica;">
      <xsl:text> [col. </xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>] </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:lb">
    <span style="color: gray; font-size: small; font-family: Helvetica;">
      <xsl:text> (</xsl:text>
      <xsl:value-of select="@n"/>
      <xsl:text>) </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:pc">
    <span class="punct">
      <xsl:text> </xsl:text>
      <xsl:value-of select="."/>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:gap" >
    <span class="gapDamageDiplo" data-quantity="{@quantity}" data-unit="{@unit}" data-resp="{@resp}">
      <xsl:text> [</xsl:text><xsl:value-of select="@quantity"></xsl:value-of><xsl:text> missing folio(s)] </xsl:text>
    </span>
  </xsl:template>


</xsl:stylesheet>

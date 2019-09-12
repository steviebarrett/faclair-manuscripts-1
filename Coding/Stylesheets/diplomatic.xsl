<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="html"/>

  <xsl:template match="/">
    <div data-docid="{tei:TEI/@xml:id}">
      <xsl:apply-templates select="tei:TEI/tei:text/tei:body/tei:div"/>
    </div>
  </xsl:template>

  <xsl:template match="tei:div">
    <div class="text" data-hand="{@hand}" data-n="{@n}" data-corresp="{@corresp}" data-type="{@type}" data-ms="{substring(/tei:TEI/@xml:id,2)}"> 
      <div><small class="text-muted">[start of Text <xsl:value-of select="@n"/>]</small></div>
      <button type="button" data-toggle="modal" data-target="#commentForm" class="addComment" title="Leave comment on this text" data-s="div" data-n="{@n}">[+]</button>
      <xsl:text> </xsl:text>
      <a href="#" class="viewComment greyedOut" title="View comments on this text" data-s="div" data-n="{@n}">[?]</a>
      <xsl:apply-templates/>
      <div><small class="text-muted">[end of Text <xsl:value-of select="@n"/>]</small></div>
    </div>
  </xsl:template>

  <xsl:template match="tei:pb">
      <div>
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
      </div>
  </xsl:template>

  <xsl:template match="tei:handShift">
    <span class="handshift" data-hand="{@new}"><small class="text-muted">[hs]</small></span>
  </xsl:template>
  
  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="tei:lb">
    <span class="lineBreak" data-number="{@n}" id="{concat('line_',@xml:id)}">
      <br/>
      <button type="button" data-toggle="modal" data-target="#commentForm" class="addComment" title="Leave comment on this line" data-s="lb" data-n="{@xml:id}">[+]</button>
      <xsl:text> </xsl:text>
      <a href="#" class="viewComment greyedOut" title="View comments on this line" data-s="lb" data-n="{@xml:id}">[?]</a>
      <xsl:text> </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:cb">
    <div>
      <small class="text-muted">[start of column <xsl:value-of select="@n"/>]</small>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:lg">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:l">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:name[not(ancestor::tei:name)]">  <!-- a name which is NOT part of a larger name -->
    <span class="name chunk syntagm">
      <xsl:attribute name="data-nametype">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:attribute name="data-corresp">
        <xsl:value-of select="@corresp"/>
      </xsl:attribute>
      <!--
      <xsl:attribute name="data-hand">
        <xsl:value-of select="preceding::tei:handShift[1]/@new"/>
      </xsl:attribute>
      -->
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:name">  <!-- a name which IS part of a larger name -->
    <span class="name syntagm">
      <xsl:attribute name="data-nametype">
        <xsl:value-of select="@type"/>
      </xsl:attribute>
      <xsl:attribute name="data-corresp">
        <xsl:value-of select="@corresp"/>
      </xsl:attribute>
      <!--
      <xsl:attribute name="data-hand">
        <xsl:value-of select="preceding::tei:handShift[1]/@new"/>
      </xsl:attribute>
      -->
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:w[not(ancestor::tei:w or ancestor::tei:name)]">  <!-- a word which is NOT part of a larger word or name -->
    <span class="word chunk syntagm">
      <!--
      <xsl:attribute name="data-hand">
        <xsl:value-of select="preceding::tei:handShift[1]/@new"/>
      </xsl:attribute>
      -->
      <xsl:if test="count(tei:w) = 0">  <!-- a syntactically simple word -->
        <xsl:choose>
          <xsl:when test="@xml:lang">
            <xsl:attribute name="xml:lang">
              <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="addWordAttributes"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:w">  <!-- a word which IS part of a larger word or name -->
    <!--
    <xsl:variable name="wordref" select="generate-id()"/>  SB added to handle headword search results
    <a id="{$wordref}"></a>
    -->
    <span class="word syntagm">
      <!--
      <xsl:attribute name="data-wordref">  SB added to handle headword search results
        <xsl:value-of select="$wordref"/>
      </xsl:attribute>
      -->
      <xsl:if test="count(tei:w) = 0">  <!-- a syntactically simple word -->
        <xsl:choose>
          <xsl:when test="@xml:lang">
            <xsl:attribute name="xml:lang">
              <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="addWordAttributes"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template name="addWordAttributes">
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
  
  <xsl:template match="tei:date | tei:c | tei:num">
    <span class="chunk syntagm">
      <!--      
      <xsl:attribute name="data-hand">
        <xsl:value-of select="preceding::tei:handShift[1]/@new"/>
      </xsl:attribute>
     -->
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <!--
    <xsl:template match="tei:div/tei:div">
      <xsl:apply-templates/>
    </xsl:template>
  -->

  <xsl:template match="tei:g">
    <xsl:choose>
      <xsl:when test="starts-with(@ref,'l')">  <!-- ligature -->
        <xsl:choose>
          <xsl:when test="@corresp">   <!-- SB: added to handle corresp attributes in glyphs (non-continuous abbreviations) -->
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
      <xsl:when test="../@cert">  <!-- expansion -->
        <xsl:choose>
          <xsl:when test="@corresp">   <!-- SB: added to handle corresp attributes in glyphs -->
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
      <xsl:otherwise>  <!-- weird expansion -->
        <xsl:variable name="corresp" select="@corresp"/>
        <span class="expansion" data-cert="{preceding::tei:abbr[@corresp=$corresp]/@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
          <xsl:apply-templates/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="tei:space">
    <xsl:text> </xsl:text>
  </xsl:template>


  <xsl:template match="tei:pc[not(ancestor::tei:w)]">
    <span class="punct">
      <xsl:value-of select="."/>
    </span>
  </xsl:template>

  <xsl:template match="tei:unclear[@reason='damage']">
    <span class="unclearDamage" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:attribute name="data-add">
        <xsl:apply-templates/>
      </xsl:attribute>
      <xsl:text>[...]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:unclear[@reason='text_obscure']">
    <span class="unclearTextObscure" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:unclear[@reason='char']">
    <span class="unclearChar" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:unclear[@reason='interp_obscure']">
    <span class="unclearInterpObscure" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:del">
    <span class="deletion" data-hand="{@hand}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:add[@type='gloss']">
    <span class="gloss" data-hand="{@hand}" data-place="{@place}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:add[@type='insertion']">
    <span class="insertion" data-hand="{@hand}" data-place="{@place}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:supplied">
    <span class="supplied">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>]</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:choice">
    <span class="correction">
      <xsl:attribute name="title">
        <xsl:text>Probably: </xsl:text>
        <xsl:apply-templates select="tei:corr"/>
      </xsl:attribute>
      <xsl:apply-templates select="tei:sic"/>
    </span>
  </xsl:template>

  <!-- ignore notes in diplomatic edition - Added by SB -->
  <xsl:template match="tei:note"/>

  <!-- Marginal notes - Added by SB-->
  <xsl:template match="tei:seg[@type='margNote']">
    <xsl:text> </xsl:text>
    <a href="#" class="marginalNoteLink" data-id="{@xml:id}">m</a>
    <div class="marginalNote" id="{@xml:id}">
      <xsl:apply-templates/>
    </div>
  </xsl:template>

  <xsl:template match="tei:gap">
    <span class="gapDamage" data-quantity="{@quantity}" data-unit="{@unit}" data-resp="{@resp}">
      <xsl:text> [</xsl:text><xsl:value-of select="@quantity"></xsl:value-of><xsl:text> missing folio(s)] </xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="tei:head/tei:title">
    <xsl:text> </xsl:text>
    <strong>
      <xsl:apply-templates/>
    </strong>
    <xsl:text> </xsl:text>
  </xsl:template>

</xsl:stylesheet>

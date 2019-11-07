<?xml version="1.0" encoding="UTF-8"?>
<!-- 
This transformation is called by viewTranscription.php
It creates a semi-diplomatic MS view. 
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="html"/>

  <xsl:template match="/">
    <div data-docid="{tei:TEI/@xml:id}" data-diplo="no"> <!-- redundant attributes? -->
      <xsl:apply-templates select="tei:TEI/tei:text/tei:body/tei:div"/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:div"> 
    <div class="text" data-hand="{@hand}" data-n="{@n}" data-corresp="{@corresp}" data-type="{@type}" data-ms="{substring(/tei:TEI/@xml:id,2)}"> 
      <div class="textAnchor">
        <button type="button" data-toggle="modal" data-target="#commentForm" class="addComment" title="Leave comment on this text" data-s="div" data-n="{@n}">+</button>
        <xsl:text> </xsl:text>
        <button type="button" data-toggle="modal" data-target="#viewCommentDiv" class="viewComment greyedOut" title="View comments on this text" data-s="div" data-n="{@n}">?</button>
        <xsl:text> </xsl:text>
        <small class="text-muted">[start of <span title="{concat(@type,' ',@corresp)}">Text <xsl:value-of select="@n"/></span>]</small>
      </div>
    <xsl:apply-templates/>
      <div class="textAnchor"><small class="text-muted">[end of Text <xsl:value-of select="@n"/>]</small></div>
    </div>
  </xsl:template>
 
  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
  <xsl:template match="tei:handShift">  <!-- e.g. MS1.4r.11 -->
    <span class="handShift" data-new="{@new}">
      <small class="text-muted">[hs]</small>
    </span>
  </xsl:template>

  <xsl:template match="tei:name[not(ancestor::tei:name) and count(tei:w|tei:name)=1 and count(tei:w/tei:w)>1]"> <!-- Dubhghaill -->
    <xsl:text> </xsl:text>
    <span class="chunk syntagm name">
      <xsl:apply-templates select="tei:w/tei:w"/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:name[not(ancestor::tei:name) and count(tei:w|tei:name)=1 and count(tei:w/tei:w)=0]"> <!-- Drostan -->
    <xsl:text> </xsl:text>
    <span class="word chunk syntagm name">
      <xsl:call-template name="addNameAttributes"/>
      <xsl:for-each select="tei:w">
        <xsl:call-template name="addWordAttributes"/>
        <xsl:apply-templates/>
      </xsl:for-each>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:name[not(ancestor::tei:name) and count(tei:w|tei:name)>1]"> <!-- Calum cille -->
    <xsl:text> </xsl:text>
    <span class="chunk syntagm name">
      <xsl:call-template name="addNameAttributes"/>
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:name[ancestor::tei:name and count(tei:w|tei:name)=1]"> 
    <xsl:text> </xsl:text>
    <span class="word syntagm name">
      <xsl:call-template name="addNameAttributes"/>
      <xsl:for-each select="tei:w">
        <xsl:call-template name="addWordAttributes"/>
        <xsl:apply-templates/>
      </xsl:for-each>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:name[ancestor::tei:name and count(tei:w|tei:name)>1]"> 
    <xsl:text> </xsl:text>
    <span class="syntagm name">
      <xsl:call-template name="addNameAttributes"/>
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:w[not(ancestor::tei:w) and not(ancestor::tei:name) and not(descendant::tei:w)]"> 
    <xsl:text> </xsl:text>
    <span class="word chunk syntagm">
      <xsl:call-template name="addWordAttributes"/>
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:w[not(ancestor::tei:w) and not(ancestor::tei:name) and descendant::tei:w]"> 
    <xsl:text> </xsl:text>
    <span class="chunk syntagm">
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:w[@pos='verb' and not(@lemmaRef='http://www.dil.ie/29104') and (ancestor::tei:w or ancestor::tei:name) and not(descendant::tei:w)]">
    <xsl:text> </xsl:text>
    <span class="word syntagm">
      <xsl:call-template name="addWordAttributes"/>
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:w[(not(@pos='verb') or @lemmaRef='http://www.dil.ie/29104') and ancestor::tei:name and not(ancestor::tei:w) and not(descendant::tei:w)]"> 
    <xsl:text> </xsl:text>
    <span class="word syntagm apple">
      <xsl:call-template name="addWordAttributes"/>
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:w[(not(@pos='verb') or @lemmaRef='http://www.dil.ie/29104') and ancestor::tei:w and not(descendant::tei:w)]"> 
    <span class="word syntagm banana">
      <xsl:call-template name="addWordAttributes"/>
      <xsl:apply-templates/>
    </span>
  </xsl:template> <!-- Calum cille vs Drostan vs Dubhghaill? -->
  
  <xsl:template match="tei:w">  <!-- a word which IS part of a larger word and also contains smaller words -->
    <xsl:text> </xsl:text>
    <span class="syntagm">
      <xsl:apply-templates/>
    </span>
    <xsl:text> </xsl:text>
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
        <xsl:value-of select="@slipRef"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@corresp">
      <xsl:attribute name="data-corresp">
        <xsl:value-of select="@corresp"/>
      </xsl:attribute>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:c | tei:date | tei:num | tei:seg[@type='fragment'] | tei:pc">
    <span class="chunk syntagm word characterString">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:g[starts-with(@ref, 'g') and ../@cert]">
    <span class="expansion" data-cert="{../@cert}" data-glyphref="{@ref}" id="{generate-id(.)}">
      <xsl:if test="@corresp">
        <xsl:variable name="corresp" select="@corresp"/>
        <xsl:if test="preceding::tei:g[@corresp=$corresp]">
          <xsl:attribute name="data-copy">
            <xsl:text>true</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <xsl:attribute name="data-corresp">
          <xsl:value-of select="@corresp"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:g[starts-with(@ref,'l')]">
    <span class="ligature" data-glyphref="{@ref}" id="{generate-id(.)}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:del">
    <span class="deletion" data-hand="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:add[@type='insertion']">
    <span class="insertion" data-hand="{@hand}" data-place="{@place}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:choice"> <!-- editorial emendations e.g. MS1.4r.2 ro/do -->
    <span class="sic" data-resp="{tei:corr/@resp}" data-alt="{tei:sic}">
      <xsl:apply-templates select="tei:corr"/>
    </span>
  </xsl:template>

  <xsl:template match="tei:note">
    <a href="#" title="{normalize-space(.)}">[*]</a>
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


<!--
  <xsl:template match="tei:supplied[tei:w]">   editorial insertions containing words e.g. T1.5r.25 [a] 
    <span class="supplied" data-resp="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
-->

  <xsl:template match="tei:supplied">  <!-- editorial insertions as parts of words e.g. T1.3r.20 mor[maer] -->
    <span class="suppliedSemi" data-resp="{@resp}"> 
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:unclear[@reason='damage']">
    <span class="unclearDamageSemi" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:unclear[@reason='text_obscure']"> <!-- e.g. MS6.2r.1 [t] -->
    <span class="unclearTextObscureSemi" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="tei:unclear[@reason='char']"> <!-- MS6.2r.7 [i] -->
    <span class="unclearCharSemi" data-cert="{@cert}" data-resp="{@resp}">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="tei:pb">
    <span class="pageBreak" data-n="{@n}">
      <small class="text-muted">
        <xsl:text>[p.</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>]</xsl:text>
      </small>
    </span>
  </xsl:template>

  <xsl:template match="tei:cb">
    <span class="columnBreak" data-n="{@n}">
      <small class="text-muted">
        <xsl:text>[col.</xsl:text>
        <xsl:value-of select="@n"/>
        <xsl:text>]</xsl:text>
      </small>
    </span>
  </xsl:template>

  <xsl:template match="tei:lb">
    <span class="lineBreak lineBreakSemi" data-n="{@n}"/>
  </xsl:template>

  <xsl:template match="tei:gap[@reason='damage' and @unit='chars']">
    <xsl:text> </xsl:text>
    <span class="syntagm gapDamageCharsSemi" data-toggle="tooltip" title="Damage: {@quantity} characters ({@resp})">
      <xsl:text>[...]</xsl:text>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:gap[@reason='text_obscure' and @unit='chars']">
    <xsl:text> </xsl:text>
    <span class="syntagm gapDamageCharsSemi" data-toggle="tooltip" title="Obscured: {@quantity} characters ({@resp})">
      <xsl:text>[...]</xsl:text>
    </span>
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="tei:gap[@unit='folio']" >
    <span class="gapDamageDiplo" data-quantity="{@quantity}" data-unit="{@unit}" data-resp="{@resp}">
      <xsl:text> [</xsl:text><xsl:value-of select="@quantity"></xsl:value-of><xsl:text> missing folio(s)] </xsl:text>
    </span>
  </xsl:template>

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
  
  <xsl:template match="tei:seg[@type='cfe']"> <!-- no idea what this means -->
    <span class="syntagm">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="1.0">

  <xsl:strip-space elements="*"/>
  <xsl:output method="html"/>

  <xsl:template match="/">
    <html>
      <head>
        <title>
          <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        </title>
      </head>
      <body>
        <h1>
          <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        </h1>
        <div id="abstract">
          <xsl:apply-templates select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:notesStmt/tei:note/tei:p"/>
        </div>
        <div id="edited">
          <xsl:apply-templates select="tei:TEI/tei:text/tei:body" mode="edited"/>
        </div>
        <div id="diplomatic">
          <xsl:apply-templates select="tei:TEI/tei:text/tei:body" mode="diplomatic"/>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:body" mode="edited">
    <div style="color:red;">
      <xsl:apply-templates mode="edited"/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:body" mode="diplomatic">
      <xsl:apply-templates select="tei:div"/>
  </xsl:template>

  <xsl:template match="tei:div">
    
    <xsl:variable name="link" select="@corresp"/>
    <h2>
      <xsl:value-of select="@n"/>
      <xsl:text>. </xsl:text>
      <xsl:value-of select="//tei:msItem[@xml:id=$link]/tei:title"/> <!-- MM: check this path -->
    </h2>
    <xsl:apply-templates mode="diplomatic"/>
  </xsl:template>

  <xsl:template mode="diplomatic" match="tei:w[not(descendant::tei:w)]"> <!-- remember type="data" -->
    <span class="diplomatic-word">
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
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
        <xsl:value-of select="count(preceding::*)"/>
        
        
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
    
    

  
  
  


</xsl:stylesheet>

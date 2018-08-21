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
      <xsl:apply-templates/>
    </div>
  </xsl:template>
  
  <xsl:template match="tei:body" mode="diplomatic">
      <xsl:apply-templates select="tei:div"/>
  </xsl:template>

  <xsl:template match="tei:div">
    <xsl:value-of select="@n"/>
    <h2>
      <xsl:value-of select="tei:msItem[@xml:id=@corresp]/tei:title"/>
    </h2>
    <xsl:apply-templates/>
  </xsl:template>



</xsl:stylesheet>

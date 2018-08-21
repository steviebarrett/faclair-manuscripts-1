<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="1.0">

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
        <div id="diplomatic">
          <xsl:apply-templates select="tei:TEI/tei:text/tei:body"/>
        </div>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:body">
    <xsl:apply-templates/>
  </xsl:template>



</xsl:stylesheet>

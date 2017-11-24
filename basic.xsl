<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet  xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="1.0">
  
  <xsl:output method="html" />
  
  <xsl:template match="/">
    <html>
      <head>
        <title>
          <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        </title>
      </head>
      <body>
        <xsl:apply-templates select="tei:TEI/tei:text/tei:body"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="tei:body">
    <xsl:apply-templates/>
  </xsl:template>
  
</xsl:stylesheet>
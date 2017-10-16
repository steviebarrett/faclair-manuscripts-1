<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  version="1.0">
  
  <xsl:output method="html" />
  
  <xsl:template match="/">
    <html>
      <head><title>...</title></head>
      <body>
        <xsl:apply-templates select="descendant::lg"/>
      </body>
    </html>
  </xsl:template>
  
  <xsl:template match="lg">
    <p>
      <xsl:value-of select="@n"/><br/>
      <xsl:apply-templates select="descendant::l"/>
    </p>
  </xsl:template>
  
  <xsl:template match="l">
    <xsl:apply-templates/>
    <br/>
  </xsl:template>
  
  <xsl:template match="abbr">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>
  
  <xsl:template match="choice">
    <span>
      <xsl:attribute name="title">
        <xsl:value-of select="corr"/>
      </xsl:attribute>
      <xsl:apply-templates select="sic"/>
    </span>
  </xsl:template>
  
</xsl:stylesheet>
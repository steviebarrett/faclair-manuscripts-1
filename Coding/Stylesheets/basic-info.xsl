<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:tei="http://www.tei-c.org/ns/1.0"
	exclude-result-prefixes="xs"
	version="1.0">
  
  <xsl:template match="/">
    <h1>
      <xsl:value-of select="tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
    </h1>
  </xsl:template>
  
  
	
</xsl:stylesheet>
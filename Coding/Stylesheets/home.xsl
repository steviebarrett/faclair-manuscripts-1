<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	exclude-result-prefixes="xs"
	version="2.0">
	
	<xsl:output method="html"/>
	
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				</title>
			</head>
			<body>
			  <h1><xsl:value-of select="tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h1>
			  <ul>
			    <xsl:apply-templates select="tei:teiCorpus/tei:TEI"/>
			  </ul>
			  
			  
			</body>
		</html>
		
		
	</xsl:template>
  
  <xsl:template match="tei:TEI">
    <li>
      Yes.
      <!-- <xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:title"/> -->
    </li>
  </xsl:template>
	
</xsl:stylesheet>
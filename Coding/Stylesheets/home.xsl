<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:tei="http://www.tei-c.org/ns/1.0" 
	xmlns:xi="http://www.w3.org/2001/XInclude"
	exclude-result-prefixes="xs"
	version="1.0">
	
	<xsl:output method="html"/>
	
	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				</title>
			  <style>
			    body {font-family: Helvetica; font-size: 12pt;}
			  </style>
			</head>
			<body>
			  <h1><xsl:value-of select="tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/></h1>
			  <ul>
			    <xsl:apply-templates select="tei:teiCorpus/xi:include"/>
			  </ul>
			  <p>
			    <a href="../Coding/Scripts/search.php" target="_new">Headword search</a>
			  </p>
			</body>
		</html>
	</xsl:template>
  
  <xsl:template match="xi:include">
    <li>
      <a href="{@href}" target="_blank">
        <xsl:value-of select="document(@href)/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
      </a>
    </li>
  </xsl:template>
  
  
  
	
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.0">
	
	<xsl:output method="html"/>
	
	<xsl:template match="/">
	<html>
		<head>
			<h1>FnaG MSS Corpus Stats</h1>
		</head>
		<body>
			<table>
				<tr><td>Number of Words in Corpus:</td><td><xsl:value-of select="count(//tei:w[not(descendant::tei:w) and not(@xml:lang)])"/></td></tr>
				<tr><td>Number of Individual Headwords in Corpus:</td><td><xsl:value-of select="count(//tei:w[not(descendant::tei:w) and not(@lemmaRef = preceding::tei:w/@lemmaRef)])"/></td></tr>
			</table>
		</body>
	</html>
	</xsl:template>
	
</xsl:stylesheet>
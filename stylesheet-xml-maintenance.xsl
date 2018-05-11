<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="3.0">
	<xsl:output method="xml" version="1.0"
		encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="//tei:abbr[descendant::tei:g[@ref='g8' and text()='r'] and //text()='ar']/*">
		<xsl:text>&lt;g ref=&quot;g8&quot;&gt;ar&lt;/g&gt;</xsl:text>
	</xsl:template>

</xsl:stylesheet>
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
			<xsl:if test="tei:w[not(descendant::tei:w) and @lemmaRef]">
				<xsl:if test="contains(@lemmaRef, 'dil.ie')">
					<xsl:attribute name="lemmaED"><xsl:value-of select="@lemma"/></xsl:attribute>
					<xsl:attribute name="lemmaRefED"><xsl:value-of select="@lemmaRef"/></xsl:attribute>
				</xsl:if>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
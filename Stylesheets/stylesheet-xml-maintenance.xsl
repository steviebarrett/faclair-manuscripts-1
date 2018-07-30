<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="3.0">
	<xsl:output method="xml" version="1.0"
		encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="//tei:w[not(descendant::tei:w)]">
		<xsl:choose>
			<xsl:when test="contains(@lemmaRef, 'dil.ie') and not(@lemmaED)">
			<xsl:copy>
				<xsl:attribute name="lemmaED">
					<xsl:value-of select="@lemma"/>
				</xsl:attribute>
				<xsl:attribute name="lemmaRefED">
					<xsl:value-of select="@lemmaRef"/>
				</xsl:attribute>
				<xsl:apply-templates select="node()|@*"/>
			</xsl:copy>
		</xsl:when>
		<xsl:when test="contains(@lemmaRef, 'faclair.com') and not(@lemmaDW)">
			<xsl:copy>
				<xsl:attribute name="lemmaDW">
					<xsl:value-of select="@lemma"/>
				</xsl:attribute>
				<xsl:attribute name="lemmaRefDW">
					<xsl:value-of select="@lemmaRef"/>
				</xsl:attribute>
				<xsl:apply-templates select="node()|@*"/>
			</xsl:copy>
		</xsl:when>
			<xsl:otherwise>
				<xsl:copy>
					<xsl:apply-templates select="node()|@*"/>
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>	

</xsl:stylesheet>
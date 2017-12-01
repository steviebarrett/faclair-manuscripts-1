<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.0">

	<xsl:output method="html"/>

	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				</title>
			</head>
			<body>
				<xsl:apply-templates select="descendant::tei:lg"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="tei:lg">
		<p>
			<xsl:value-of select="@n"/>
			<br/>
			<xsl:apply-templates select="descendant::tei:l"/>
		</p>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:apply-templates/>
		<br/>
	</xsl:template>

	<xsl:template match="tei:abbr/tei:g">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:choice">
		<span>
			<xsl:attribute name="title">
				<xsl:value-of select="tei:corr"/>
			</xsl:attribute>
			<xsl:apply-templates select="tei:sic"/>
		</span>
	</xsl:template>

	<xsl:template match="tei:del">
		<del rend="strikethrough">
			<xsl:apply-templates/>
		</del>
	</xsl:template>

	<xsl:template match="tei:space">
		<xsl:text> </xsl:text><xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:supplied">
		[<a title="{@resp}"><xsl:apply-templates/></a>]
	</xsl:template>

	<xsl:template match="tei:unclear">
		<a title="{@reason}">{<xsl:apply-templates/>}</a>
	</xsl:template>
	
	<xsl:template match="tei:gap">
		{<xsl:value-of select="@extent"/>, <xsl:value-of select="@reason"/>} 
	</xsl:template>

	<xsl:template match="tei:w">
		<a href="{@lemmaRef}" title="Lemma: {@lemma}; {@ana}" style="text-decoration:none; color:#000000"><xsl:apply-templates/></a>
	</xsl:template>

</xsl:stylesheet>

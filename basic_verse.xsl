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

	<xsl:template match="tei:abbr">
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

	<xsl:template match="tei:supplied">[<xsl:apply-templates/>]</xsl:template>

	<xsl:template match="tei:w">
		<a href="{@lemmaRef}" style="text-decoration:none; color:#000000"><xsl:apply-templates/></a>
	</xsl:template>


</xsl:stylesheet>

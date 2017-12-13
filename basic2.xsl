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
				<xsl:apply-templates select="descendant::tei:div1"/>
			</body>
		</html>
	</xsl:template>
	
	<xsl:template match="//*[@cert]">
		<xsl:choose>
			<xsl:when test="@cert = 'low'">
				<mark style="color:ff9f80">
					<xsl:apply-templates/>
				</mark>
			</xsl:when>
			<xsl:otherwise>
				<a style="text-decoration:none; color:#000000">
					<xsl:apply-templates/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:p//tei:lb">
			<br/>
			<xsl:value-of select="@n"/>
			<xsl:text>. </xsl:text>
			<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:lg//tei:lb">
		<xsl:apply-templates/>
	</xsl:template>

<xsl:template match="tei:w/tei:lb">
	<xsl:apply-templates>&#10;</xsl:apply-templates>
</xsl:template>

	<xsl:template match="tei:pb">
		<br/>
		<hr align="left" width="40%"/>
		<p align="left">
			<b>
				<xsl:value-of select="@n"/>
				<xsl:text>: </xsl:text>
				<xsl:value-of select="ancestor::tei:div1/@resp"/>
			</b>
		</p>
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
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:supplied">
		<xsl:choose>
			<xsl:when test="@cert = 'low'">
				<a href="{ancestor::*[@lemmaRef][1]/@lemmaRef}"
					title="{ancestor::*[@lemma][1]/@lemma}; {ancestor::*[@ana][1]/@ana}.&#010;Supp. by: {/g/@resp}."
					style="text-decoration:none; color:#ff0000">
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{ancestor::*[@lemmaRef][1]/@lemmaRef}"
					title="{ancestor::*[@lemma][1]/@lemma}; {ancestor::*[@ana][1]/@ana}.&#010;Supp. by: {/g/@resp}."
					style="text-decoration:none; color:#000000">
					<xsl:apply-templates/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:choose>
			<xsl:when test="@cert = 'low'">
				<a href="{ancestor::*[@lemmaRef][1]/@lemmaRef}"
					title="{ancestor::*[@lemma][1]/@lemma}; {ancestor::*[@ana][1]/@ana}.&#010;{@reason}&#010;Interp. by: {/g/@resp}."
					style="text-decoration:none; color:#ff0000">
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{ancestor::*[@lemmaRef][1]/@lemmaRef}"
					title="{ancestor::*[@lemma][1]/@lemma}; {ancestor::*[@ana][1]/@ana}.&#010;Interp by: {/g/@resp}."
					style="text-decoration:none; color:#000000">
					<xsl:apply-templates/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:gap">
		<xsl:choose>
			<xsl:when test="@extent = 'unknown'">
				<sup>{<xsl:value-of select="concat(@extent, ' extent')"/>, <xsl:value-of
						select="@reason"/>}</sup>
			</xsl:when>
			<xsl:otherwise>
				<sup>{<xsl:value-of select="@extent"/>, <xsl:value-of select="@reason"/>}</sup>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:w">
		<a href="{@lemmaRef}" title="{@lemma}; {@ana}" style="text-decoration:none; color:#000000">
			<xsl:apply-templates/>
		</a>
	</xsl:template>

	<xsl:template match="tei:abbr">
		<xsl:choose>
			<xsl:when test="@cert = 'low'">
				<a href="{ancestor::*[@lemmaRef][1]/@lemmaRef}"
					title="{ancestor::*[@lemma][1]/@lemma}; {ancestor::*[@ana][1]/@ana}."
					style="text-decoration:none; color:#ff0000">
					<xsl:apply-templates/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{ancestor::*[@lemmaRef][1]/@lemmaRef}"
					title="{ancestor::*[@lemma][1]/@lemma}; {ancestor::*[@ana][1]/@ana}.&#010;Abbr: {/g/@ref}."
					style="text-decoration:none; color:#000000">
					<xsl:apply-templates/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:g">
		<i>
			<a href="{ancestor::*[@lemmaRef][1]/@lemmaRef}"
				title="Lemma: '{ancestor::*[@lemma][1]/@lemma}', {ancestor::*[@ana][1]/@ana}.&#010;Abbr: {@ref}."
				style="text-decoration:none; color:#000000">
				<xsl:apply-templates/>
			</a>
		</i>
	</xsl:template>

	<xsl:template match="tei:lg">
		<p style="margin-left:20px">
			<xsl:value-of select="@n"/>. <br/>
			<xsl:apply-templates select="descendant::tei:l"/>
		</p>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:apply-templates/>
		<br/>
	</xsl:template>

</xsl:stylesheet>

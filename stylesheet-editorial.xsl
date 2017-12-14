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
				<h1>Transcription 9: NLS Adv. MS 72.1.50</h1>
				<xsl:apply-templates select="descendant::tei:body"/>
			</body>
			<backmatter> 
			<h1>Notes</h1>
				<xsl:for-each select="//tei:note[@type='fn']">
					<xsl:value-of select="@n"/>. <xsl:value-of select="tei:p"/><br/>
				</xsl:for-each>
			</backmatter>
		</html>
	</xsl:template>

	<xsl:template match="tei:pb">
		<br/>
		<hr align="left" width="40%"/>
		<p align="left">
			<xsl:choose>
				<xsl:when test="ancestor::tei:div//tei:handShift">
					<b><xsl:value-of select="@n"/>: <xsl:value-of select="preceding::tei:handShift/@new"/></b>
				</xsl:when>
				<xsl:otherwise>
					<b><xsl:value-of select="@n"/>: <xsl:value-of select="ancestor::tei:div/@resp"/></b>
				</xsl:otherwise>
			</xsl:choose>
		</p>
	</xsl:template>

	<xsl:template match="tei:p//tei:lb">
		<br/>
		<xsl:value-of select="@n"/>
		<xsl:text>. </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="//tei:div[@type = 'verse']//tei:lb">
		<sub><a title="MS line break" href="#" onclick="return false;"  style="text-decoration:none; color:#000000"><xsl:value-of select="@n"/></a>. </sub>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:lg">
		<p style="margin-left:20px">
			<br/>
			<xsl:apply-templates select="descendant::tei:l"/>
		</p>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:apply-templates/>
		<br/>
	</xsl:template>

	<xsl:template match="tei:w">
		<xsl:choose>
			<xsl:when test="not(@lemma)">
				<xsl:choose>
					<xsl:when test="ancestor::tei:name[@type='personal']">
						<a title="Personal name" style="text-decoration:none; color:#000000">
							<xsl:apply-templates /></a>&#160;
					</xsl:when>
					<xsl:when test="ancestor::tei:name[@type='place']">
						<a title="Placename" style="text-decoration:none; color:#000000">
							<xsl:apply-templates/></a>&#160;
					</xsl:when>
					<xsl:when test="@xml:lang">
						<a title="Language = '{@xml:lang}'" style="text-decoration:none; color:#000000">
							<xsl:apply-templates/></a>&#160;
					</xsl:when>
					<xsl:otherwise><mark><a title="{@ana}; lemma unavailable" style="text-decoration:none; color:#000000">
						<xsl:apply-templates/></a></mark>&#160;</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@lemma = 'UNKNOWN'">
				<mark><a title="{@ana}; lemma unknown" style="text-decoration:none; color:#000000">
					<xsl:apply-templates/></a></mark>&#160;</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="ancestor::tei:name[@type='personal']">
						<a href="{@lemmaRef}" title="'{@lemma}'; {@ana} (personal name)" style="text-decoration:none; color:#000000">
							<xsl:apply-templates/></a>&#160;
					</xsl:when>
					<xsl:when test="ancestor::tei:name[@type='place']">
						<a href="{@lemmaRef}" title="'{@lemma}'; {@ana} (placename)" style="text-decoration:none; color:#000000">
							<xsl:apply-templates/></a>&#160;
					</xsl:when>
					<xsl:otherwise><a href="{@lemmaRef}" title="'{@lemma}'; {@ana}" style="text-decoration:none; color:#000000">
						<xsl:apply-templates/></a>&#160;</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:supplied">
		<xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="tei:g">
		<i><xsl:apply-templates/></i>
	</xsl:template>

	<xsl:template match="tei:abbr[@cert = 'low']/tei:g">
		<mark><i><xsl:apply-templates/></i></mark>
	</xsl:template>
	
	<xsl:template match="tei:unclear">
	<xsl:choose>
		<xsl:when test="/@cert='low'">
			<xsl:text>{</xsl:text><mark><xsl:apply-templates/></mark><xsl:text>}</xsl:text></xsl:when>
		<xsl:otherwise>
			<xsl:text>{</xsl:text><xsl:apply-templates/><xsl:text>}</xsl:text>
		</xsl:otherwise>
	</xsl:choose>	
	</xsl:template>

	<xsl:template match="tei:gap">
		<xsl:choose>
			<xsl:when test="@extent = 'unknown'">
				<a title="{concat(@extent, ' extent')}, {@reason}" href="#" onclick="return false;" style="text-decoration:none; color:#000000"><sub><b><i>-gap-</i></b></sub></a>
			</xsl:when>
			<xsl:otherwise>
				<a title="{@extent}, {@reason}" href="#" onclick="return false;" style="text-decoration:none; color:#000000"><sub><b><i>-gap-</i></b></sub></a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:choice[//tei:w]">
		<xsl:choose>
			<xsl:when test="child::tei:abbr or child::tei:unclear or child::tei:seg">
				<xsl:apply-templates select="child::*[@n='1']"/>
				<sub>
					<b>
						<i>
							<a title="Or, {child::*[@n='2']}" href="{child::*[@n='2']/@lemmaRef}" style="text-decoration:none; color:#000000">alt </a>
						</i>
					</b>
				</sub>
			</xsl:when>
			<xsl:when test="child::tei:sic and child::tei:corr">
				<xsl:apply-templates select="tei:corr"/>
				<sub>
					<b>
						<i>
							<xsl:choose>
								<xsl:when test="child::tei:sic/tei:w/@lemmaRef"><a href="{child::tei:sic/tei:w/@lemmaRef}" title="MS: {child::tei:sic/tei:w}" style="text-decoration:none; color:#000000">alt </a></xsl:when>
								<xsl:when test="child::tei:sic/tei:w[not(@lemmaRef)]"><a title="MS: {child::tei:sic/tei:w}" style="text-decoration:none; color:#000000">alt </a></xsl:when>
							</xsl:choose>
						</i>
					</b>
				</sub>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="tei:note[@resp='#EPT']">
		<sup><b><xsl:value-of select="@n"/></b></sup>
	</xsl:template>

</xsl:stylesheet>

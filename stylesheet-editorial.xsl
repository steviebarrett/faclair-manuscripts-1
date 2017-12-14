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
				<xsl:apply-templates select="descendant::tei:body"/>
			</body>
			<backmatter> </backmatter>
		</html>
	</xsl:template>

	<xsl:template match="tei:pb">
		<br/>
		<hr align="left" width="40%"/>
		<p align="left">
			<b>
				<xsl:value-of select="@n"/>
			</b>
		</p>
	</xsl:template>

	<xsl:template
		match="//tei:p//tei:lb | //tei:w//tei:lb | //tei:name//tei:lb | //tei:unclear//tei:lb | //tei:abbr//tei:lb | //tei:choice//tei:lb">
		<br/>
		<xsl:value-of select="@n"/>
		<xsl:text>. </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="//tei:div[@type = 'verse']//tei:lb">
		<sub><xsl:value-of select="@n"/>. </sub>
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
				<a title="{@ana}; lemma unavailable" style="text-decoration:none; color:#000000">
					<xsl:apply-templates/></a>&#160; </xsl:when>
			<xsl:when test="@lemma = 'UNKNOWN'">
				<a title="{@ana}; lemma unknown" style="text-decoration:none; color:#000000">
					<xsl:apply-templates/></a>&#160; </xsl:when>
			<xsl:otherwise>
				<a href="{@lemmaRef}" title="'{@lemma}'; {@ana}"
					style="text-decoration:none; color:#000000">
					<xsl:apply-templates/></a>&#160; </xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:supplied/tei:w">
		<xsl:choose>
			<xsl:when test="not(@lemma)"> [<a
					title="{@ana}; lemma unavailable.&#010;Supp. by {parent::tei:supplied/@resp}"
					style="text-decoration:none; color:#000000"><xsl:apply-templates/></a>]&#160; </xsl:when>
			<xsl:when test="@lemma = 'UNKNOWN'"> [<a
					title="{@ana}; lemma unknown.&#010;Supp. by {parent::tei:supplied/@resp}."
					style="text-decoration:none; color:#000000"><xsl:apply-templates/></a>]&#160; </xsl:when>
			<xsl:otherwise> [<a href="{@lemmaRef}"
					title="'{@lemma}'; {@ana}&#010;Supp. by {parent::tei:supplied/@resp}."
					style="text-decoration:none; color:#000000"><xsl:apply-templates/></a>]&#160;
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:w/tei:supplied">
		<xsl:choose>
			<xsl:when test="@cert = 'low'"> [<a href="{parent::tei:w/@lemmaRef}"
					title="'{parent::tei:w/@lemma}'; {parent::tei:w/@ana}&#010;Supp. by {@resp}"
					style="text-decoration:none; color:#ff9f80"><xsl:apply-templates/></a>] </xsl:when>
			<xsl:when test="parent::tei:w[not(@lemma)]"> [<a
					title="{parent::tei:w/@ana}; lemma unknown&#010;Supp. by {@resp}"
					style="text-decoration:none; color:#000000"><xsl:apply-templates/></a>] </xsl:when>
			<xsl:when test="parent::tei:w[not(@lemma)] and @cert = 'low'"> [<a
					title="{parent::tei:w/@ana}; lemma unknown&#010;Supp. by {@resp}"
					style="text-decoration:none; color:#ff9f80"><xsl:apply-templates/></a>] </xsl:when>
			<xsl:otherwise> [<a href="{parent::tei:w/@lemmaRef}"
					title="'{parent::tei:w/@lemma}'; {parent::tei:w/@ana}&#010;Supp. by {@resp}"
					style="text-decoration:none; color:#000000"><xsl:apply-templates/></a>]
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:g">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:abbr[@cert = 'low']/tei:g">
		<i style="text-decoration:none; color:#ff9f80">
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:gap">
		<xsl:choose>
			<xsl:when test="@extent = 'unknown'">
				<sub> -<xsl:value-of select="concat(@extent, ' extent')"/>, <xsl:value-of
						select="@reason"/>- </sub>
			</xsl:when>
			<xsl:otherwise>
				<sub> -<xsl:value-of select="@extent"/>, <xsl:value-of select="@reason"/>- </sub>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:choice">
		<xsl:choose>
			<xsl:when test="child::tei:abbr or child::tei:unclear or child::tei:seg">
				<a>
					<xsl:value-of
						select="child::tei:abbr[@n = '1']/tei:w | child::tei:unclear[@n = '1']/tei:w | child::tei:seg[@n = '1']/tei:w"
					/>
				</a>
				<sub>
					<b>
						<i>
							<a
								title="Or, {child::tei:abbr[@n='2']/tei:w}{child::tei:unclear[@n='2']/tei:w}{child::tei:seg[@n='2']/tei:w}"
								>alt </a>
						</i>
					</b>
				</sub>
			</xsl:when>
			<xsl:when test="child::tei:sic and child::tei:corr">
				<a href="{child::tei:corr/tei:w/@lemmaRef}" title="'{child::tei:corr/tei:w/@lemma}'; {child::tei:corr/tei:w/@ana}" style="text-decoration:none; color:#000000">
					<xsl:value-of select="child::tei:corr/tei:w"/>
				</a>
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

</xsl:stylesheet>

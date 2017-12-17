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
				<h1/>
				<xsl:apply-templates select="descendant::tei:body"/>
			</body>
			<backmatter>
				<h1>Notes</h1>
				<xsl:for-each select="//tei:note[@type = 'fn']">
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
					<b><xsl:value-of select="@n"/>: <xsl:value-of
							select="preceding::tei:handShift/@new"/></b>
				</xsl:when>
				<xsl:otherwise>
					<b><xsl:value-of select="@n"/>: <xsl:value-of select="ancestor::tei:div/@resp"
						/></b>
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

	<xsl:template match="//tei:lg//tei:lb">
		<sub><a title="MS fol/p {preceding::tei:pb/@n}, line {@n}" href="#" onclick="return false;"
				style="text-decoration:none; color:#000000"><xsl:value-of select="@n"/></a>. </sub>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:lg">
		<xsl:choose>
			<xsl:when test="count(parent::tei:div//tei:lg[@type = 'stanza']) > 1">
				<br/>
				<b align="left">
					<a title="Stanza number" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">
						<xsl:value-of select="@n"/>
					</a>
				</b>
				<br/>
				<p style="margin-left:30px">
					<xsl:apply-templates select="descendant::tei:l"/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p style="margin-left:30px">
					<br/>
					<xsl:apply-templates select="descendant::tei:l"/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:apply-templates/>
		<br/>
	</xsl:template>

	<xsl:template match="tei:w">
		<xsl:choose>
			<xsl:when test="not(@lemma)">
				<xsl:choose>
					<xsl:when test="ancestor::tei:name[@type = 'personal']">
						<a title="Personal name" href="#" onclick="return false;"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/></a>&#160; </xsl:when>
					<xsl:when test="ancestor::tei:name[@type = 'place']">
						<a title="Placename" href="#" onclick="return false;"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/></a>&#160; </xsl:when>
					<xsl:when test="@xml:lang">
						<a title="Language = '{@xml:lang}'" href="#" onclick="return false;"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/></a>&#160; </xsl:when>
					<xsl:otherwise><mark><a title="{@ana}; lemma unavailable" href="#"
								onclick="return false;" style="text-decoration:none; color:#000000">
								<xsl:apply-templates/></a></mark>&#160;</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@lemma = 'UNKNOWN'">
				<mark><a title="{@ana}; lemma unknown" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">
						<xsl:apply-templates/></a></mark>&#160;</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="ancestor::tei:name[@type = 'personal']">
						<a href="{@lemmaRef}" title="'{@lemma}'; {@ana} (personal name)"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/></a>&#160; </xsl:when>
					<xsl:when test="ancestor::tei:name[@type = 'place']">
						<a href="{@lemmaRef}" title="'{@lemma}'; {@ana} (placename)"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/></a>&#160; </xsl:when>
					<xsl:otherwise><a href="{@lemmaRef}" title="'{@lemma}'; {@ana}"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/></a>&#160;</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:supplied">
		<xsl:text>[</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="tei:g">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:abbr[@cert = 'low']/tei:g">
		<mark>
			<i>
				<xsl:apply-templates/>
			</i>
		</mark>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:choose>
			<xsl:when test="/@cert = 'low'">
				<xsl:text>{</xsl:text>
				<mark>
					<xsl:apply-templates/>
				</mark>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:gap">
		<xsl:choose>
			<xsl:when test="@extent = 'unknown'">
				<a title="{concat(@extent, ' extent')}, {@reason}" href="#" onclick="return false;"
					style="text-decoration:none; color:#000000">
					<sub>
						<b>
							<i>-gap-</i>
						</b>
					</sub>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a title="{@extent}, {@reason}" href="#" onclick="return false;"
					style="text-decoration:none; color:#000000">
					<sub>
						<b>
							<i>-gap-</i>
						</b>
					</sub>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:choice[//tei:w]">
		<xsl:choose>
			<xsl:when test="child::tei:abbr or child::tei:unclear or child::tei:seg">
				<xsl:choose>
					<xsl:when test="count(child::tei:seg/*/tei:w) > 1">
						<xsl:text>{</xsl:text><xsl:for-each select="tei:seg">
							<xsl:apply-templates select="child::*[@n = '1']/tei:w"/>
							<xsl:if test="child::*[@n = '2']/tei:w">
							<sub>
								<b>
									<i>
										<a title="Or, {child::*[@n = '2']} ({child::*[@n = '2']/tei:w/@lemma}); {child::*[@n = '2']/tei:w/@ana}"
											href="{child::*[@n = '2']/tei:w/@lemmaRef}" style="text-decoration:none; color:#000000">alt </a>
									</i>
								</b>
							</sub>
							</xsl:if>
						</xsl:for-each><xsl:text>}</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="child::*[@n = '1']"/>
						<sub>
							<b>
								<i>
									<a title="Or, {child::*[@n='2']}; {child::*[@n='2']/@ana}"
										href="{child::*[@n='2']/@lemmaRef}"
										style="text-decoration:none; color:#000000">alt </a>
								</i>
							</b>
						</sub>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="child::tei:sic and child::tei:corr">
				<xsl:apply-templates select="tei:corr"/>
				<sub>
					<b>
						<i>
							<xsl:choose>
								<xsl:when test="child::tei:sic/tei:w/@lemmaRef">
									<a href="{child::tei:sic/tei:w/@lemmaRef}"
										title="MS: {child::tei:sic/tei:w}"
										style="text-decoration:none; color:#000000"> alt </a>
								</xsl:when>
								<xsl:when test="child::tei:sic/tei:w[not(@lemmaRef)]">
									<a title="MS: {child::tei:sic/tei:w}"
										style="text-decoration:none; color:#000000"> alt </a>
								</xsl:when>
							</xsl:choose>
						</i>
					</b>
				</sub>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:note[@resp = '#EPT']">
		<sup>
			<b>
				<xsl:value-of select="@n"/>
			</b>
		</sup>
	</xsl:template>

	<xsl:template match="tei:add">
		<xsl:choose>
			<xsl:when test="@place = 'above'">
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000"> \ </a>
				</b>
				<xsl:apply-templates/>
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">/ </a>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'below'">
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000"> / </a>
				</b>
				<xsl:apply-templates/>
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">\ </a>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, right'">
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">&lt; &lt;</a>
				</b>
				<xsl:apply-templates/>
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">&lt; &lt;</a>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, left'">
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">&gt; &gt;</a>
				</b>
				<xsl:apply-templates/>
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">&gt; &gt;</a>
				</b>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:handShift">
		<sub>
			<b> beg. <xsl:value-of select="@new"/>
			</b>
		</sub>
	</xsl:template>

	<xsl:template match="tei:div/@resp">
		<xsl:if test="not(preceding::tei:div/@resp or preceding::tei:handShift/@new)">
			<sub>
				<b> beg. <xsl:value-of select="@resp"/>
				</b>
			</sub>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>

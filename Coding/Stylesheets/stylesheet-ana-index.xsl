<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.0">
	<xsl:strip-space elements="*"/>

	<xsl:output method="html"/>

	<xsl:template match="/">
		<html>
			<head>
				<h1>FnaG MSS Corpus Index</h1>
			</head>
			<body>
				<xsl:for-each
					select="//tei:w[@lemma and not(descendant::tei:w) and not(@lemmaRef = preceding::tei:w/@lemmaRef) and not(@xml:lang) and not(@type = 'data') and not(@lemma = 'UNKNOWN')]">
					<xsl:sort
						select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
					<xsl:call-template name="entry"/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="entry">
		<xsl:variable name="lemRef" select="@lemmaRef"/>
		<xsl:variable name="lem" select="@lemma"/>
		<p>
			<b>
				<xsl:choose>
					<xsl:when test="not($lemRef = '')">
						<a href="{$lemRef}" target="_blank">
							<xsl:value-of select="$lem"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$lem"/>
					</xsl:otherwise>
				</xsl:choose>
			</b>
			<xsl:if
				test="document('..\..\Transcribing\hwData.xml')//tei:entryFree[@corresp = $lemRef]/tei:w[not(@lemmaDW = '')]/@lemmaDW">
				<xsl:text> (</xsl:text>
				<xsl:choose>
					<xsl:when
						test="document('..\..\Transcribing\hwData.xml')//tei:entryFree[@corresp = $lemRef]/tei:w[not(@lemmaDW = '')]/@lemmaRefDW">
						<a
							href="{document('..\..\Transcribing\hwData.xml')//tei:entryFree[@corresp = $lemRef]/tei:w[not(@lemmaDW = '')]/@lemmaRefDW}"
							target="_blank">
							<xsl:value-of
								select="document('..\..\Transcribing\hwData.xml')//tei:entryFree[@corresp = $lemRef]/tei:w/@lemmaDW"
							/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of
							select="document('..\..\Transcribing\hwData.xml')//tei:entryFree[@corresp = $lemRef]/tei:w/@lemmaDW"
						/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:text>: </xsl:text>
			<xsl:for-each select="//tei:TEI[not(@xml:id = 'hwData')]//tei:w[@lemmaRef = $lemRef]">
				<xsl:call-template name="word"/>
			</xsl:for-each>
		</p>
	</xsl:template>

	<xsl:template name="word">
		<xsl:variable name="lemRef" select="@lemmaRef"/>
		<xsl:variable name="wordCount"
			select="count(//tei:TEI[not(@xml:id = 'hwData')]//tei:w[@lemmaRef = $lemRef])"/>
		<xsl:variable name="msRef">
			<xsl:choose>
				<xsl:when test="preceding::tei:lb[1]/@sameAs">
					<xsl:value-of select="preceding::tei:lb[1]/@sameAs"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="preceding::tei:lb[1]/@xml:id"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::tei:w">
				<xsl:if test="preceding-sibling::tei:w or preceding-sibling::*[descendant::tei:w]">
					<xsl:text>-</xsl:text>
				</xsl:if>
				<xsl:apply-templates/>
				<xsl:if test="following-sibling::tei:w or following-sibling::*[descendant::tei:w]">
					<xsl:text>-</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text> (</xsl:text>
		<xsl:value-of select="@ana"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="$msRef"/>
		<xsl:text>);</xsl:text>
	</xsl:template>

	<xsl:template match="tei:g">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:text>{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="tei:supplied">
		<xsl:text>[</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="tei:del">
		<del rend="strikethrough">
			<xsl:apply-templates/>
		</del>
	</xsl:template>

	<xsl:template match="tei:add">
		<xsl:text>\</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>/</xsl:text>
	</xsl:template>

</xsl:stylesheet>

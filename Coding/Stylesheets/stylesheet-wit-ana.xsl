<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="2.0">

	<xsl:template match="/">
		<html>
			<head>
				<h1>
					<xsl:value-of select="//tei:titleStmt/tei:title"/>
				</h1>
			</head>
			<body>
				<table border="1px solid black" id="tbl">
					<tr>
						<th style="bold">
							<xsl:text>ID</xsl:text>
						</th>
						<th style="bold">
							<xsl:text>MS line</xsl:text>
						</th>
						<xsl:for-each select="//*[@type = 'wit']">
							<th style="bold">
								<xsl:choose>
									<xsl:when test="@subtype = 'bib'">
										<xsl:choose>
											<xsl:when test="count(tei:author/tei:surname) = 1">
												<xsl:value-of select="tei:author/tei:surname"/>
											</xsl:when>
											<xsl:when test="count(tei:author/tei:surname) = 2">
												<xsl:value-of select="tei:author[1]/tei:surname"/>
												<xsl:text> &amp; </xsl:text>
												<xsl:value-of select="tei:author[2]/tei:surname"/>
											</xsl:when>
											<xsl:when test="count(tei:author/tei:surname) > 2">
												<xsl:value-of select="tei:author[1]/tei:surname"/>
												<i>
												<xsl:text> et al.</xsl:text>
												</i>
											</xsl:when>
										</xsl:choose>
										<xsl:text> (</xsl:text>
										<xsl:value-of select="tei:date"/>
										<xsl:text>)</xsl:text>
									</xsl:when>
									<xsl:when test="@subtype = 'ms'">
										<a href="#" onclick="return false;"
											style="text-decoration:none; color:#000000"
											title="{tei:msIdentifier/tei:msName}">
											<xsl:value-of
												select="tei:msIdentifier/tei:idno[@type = 'shelfmark']"
											/>
										</a>
									</xsl:when>
								</xsl:choose>
							</th>
						</xsl:for-each>
					</tr>
					<xsl:for-each select="//tei:app">
						<tr>
							<td>
								<xsl:value-of select="@xml:id"/>
							</td>
							<td>
								<xsl:value-of select="preceding::tei:lb[1]/@n"/>
							</td>
							<xsl:for-each select="tei:rdg">
								<td>
									<xsl:apply-templates/>
								</td>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="tei:expan">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:text>{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="tei:gap">
		<xsl:text>―</xsl:text>
	</xsl:template>

	<xsl:template match="tei:add">
		<xsl:text>\</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>/</xsl:text>
	</xsl:template>

</xsl:stylesheet>

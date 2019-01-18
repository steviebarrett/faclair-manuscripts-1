<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="2.0" xmlns:f="http://www.example.com/f">

	<xsl:template match="/">
		<html>
			<head>
				<h1>
					<xsl:value-of select="//tei:titleStmt/tei:title"/>
				</h1>
			</head>
			<body>
				<p>The following table presents a collation of previous transcriptions with the
					current manuscript evidence. Each cell contains a reading that is true to the
					source from which it is taken (see column header). A cell containing "―" means,
					in the case of a manuscript, that the manuscript is illegible at this point and,
					in the case of secondary transcription, that the transcriber has declared the
					manuscript illegible. A completely empty cell means that the source is clear but
					that it does not contain anything matching a reading that appears elsewhere. If
					"yes" appears in the "Minor Variants?" column, then one or more readings differs
					at least in terms of capitalisation or accent placement. If "yes" appears in the
					"Major Variants?" column, then one or more readings varies more substantially.
					Major variants will always also display as minor variants. Rows containing major
					variants are highlighted. The ID number in the leftmost column relates to the
					source XML and is of no bibliographical significance.</p>
				<table border="1px solid black" id="tbl">
					<tr>
						<th style="bold">
							<xsl:text>ID</xsl:text>
						</th>
						<th style="bold">
							<xsl:text>MS line</xsl:text>
						</th>
						<xsl:for-each select="//*[@type = 'wit']">
							<xsl:sort select="tei:date/@from"/>
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
											style="text-decoration:none; color:#000000; bold"
											title="{tei:msIdentifier/tei:msName}">
											<xsl:value-of
												select="tei:msIdentifier/tei:idno[@type = 'shelfmark']"
											/>
										</a>
									</xsl:when>
								</xsl:choose>
							</th>
						</xsl:for-each>
						<th>
							<xsl:text>Minor Variants?</xsl:text>
						</th>
						<th>
							<xsl:text>Major Variants?</xsl:text>
						</th>
					</tr>
					<xsl:for-each select="//tei:app">
						<xsl:variable name="appID" select="@xml:id"/>
						<tr>
							<xsl:if
								test="f:majvariants(//tei:rdg[parent::tei:app/@xml:id = $appID and not(child::tei:gap)]) = false()">
								<xsl:attribute name="style">background-color:#babdc4</xsl:attribute>
							</xsl:if>
							<td>
								<xsl:value-of select="@xml:id"/>
							</td>
							<td>
								<xsl:value-of select="preceding::tei:lb[1]/@n"/>
							</td>
							<xsl:for-each select="tei:rdg">
								<xsl:sort>
									<xsl:variable name="witID" select="@wit"/>
									<xsl:value-of select="//*[@type = 'wit' and @xml:id = $witID]/tei:date/@from"/>
								</xsl:sort>
								<td>
									<xsl:apply-templates/>
								</td>
							</xsl:for-each>
							<td>
								<xsl:choose>
									<xsl:when
										test="f:minvariants(//tei:rdg[parent::tei:app/@xml:id = $appID and not(child::tei:gap)]) = true()">
										<xsl:text>no</xsl:text>
									</xsl:when>
									<xsl:when
										test="f:minvariants(//tei:rdg[parent::tei:app/@xml:id = $appID and not(child::tei:gap)]) = false()">
										<xsl:text>yes</xsl:text>
									</xsl:when>
								</xsl:choose>
							</td>
							<td>
								<xsl:choose>
									<xsl:when
										test="f:majvariants(//tei:rdg[parent::tei:app/@xml:id = $appID and not(child::tei:gap)]) = true()">
										<xsl:text>no</xsl:text>
									</xsl:when>
									<xsl:when
										test="f:majvariants(//tei:rdg[parent::tei:app/@xml:id = $appID and not(child::tei:gap)]) = false()">
										<xsl:text>yes</xsl:text>
									</xsl:when>
								</xsl:choose>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:function name="f:majvariants" as="xs:boolean">
		<xsl:param name="r" as="item()*"/>
		<xsl:variable name="transFrom">
			<xsl:text>AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ</xsl:text>
		</xsl:variable>
		<xsl:variable name="transTo">
			<xsl:text>aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz</xsl:text>
		</xsl:variable>
		<xsl:value-of
			select="
				every $i in $r
					satisfies translate($i, $transFrom, $transTo) = (translate($r[1], $transFrom, $transTo))"
		/>
	</xsl:function>

	<xsl:function name="f:minvariants" as="xs:boolean">
		<xsl:param name="r" as="item()*"/>
		<xsl:value-of select="
				every $i in $r
					satisfies $i = ($r[1])"/>
	</xsl:function>

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

	<xsl:template match="tei:lb">
		<sub>
			<xsl:value-of select="@n"/>
			<xsl:text>.</xsl:text>
		</sub>
	</xsl:template>

</xsl:stylesheet>

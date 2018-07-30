<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.0">
	<xsl:include href="stylesheet-ed-pub.xsl"/>

	<xsl:output method="html"/>

	<xsl:key name="handToText" match="*" use="@resp"/>
	<xsl:key name="handToHS" match="*" use="@new"/>
	<xsl:key name="text" match="*" use="@corresp"/>

	<xsl:template match="/">
		<xsl:variable name="wordCount"
			select="count(//tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type='data')])"/>
		<xsl:variable name="unclearWordCount"
			select="count(//tei:w[not(descendant::tei:w) and ancestor::tei:unclear or descendant::tei:unclear and not(@xml:lang)])"/>
		<xsl:variable name="lemmaCount"
			select="count(//tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type='data') and not(@lemmaRef = preceding::tei:w[not(descendant::tei:w)]/@lemmaRef)])"/>

		<html>
			<head>
				<h1>FnaG MSS Corpus Stats</h1>
			</head>
			<body>
				<table>
					<tr>
						<td>
							<xsl:text>Words in Corpus: </xsl:text>
						</td>
						<td>
							<xsl:value-of select="$wordCount"/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:text>Individual Lexical Items in Corpus: </xsl:text>
						</td>
						<td>
							<xsl:value-of select="$lemmaCount"/>
						</td>
						<tr>
							<td>Mean occurrence rate of an individual lexical item:</td>
							<td>
								<xsl:value-of select="round(($wordCount div $lemmaCount) * 100) div 100"/>
							</td>
						</tr>
					</tr>
					<tr>
						<td>
							<xsl:text>Names in Corpus: </xsl:text>
						</td>
						<td>
							<xsl:value-of
								select="count(//tei:name[ancestor::tei:div and not(ancestor::tei:name)])"
							/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:text>Unidentified Words in Corpus: </xsl:text>
						</td>
						<td>
							<xsl:value-of
								select="count(//tei:w[@lemma = 'UNKNOWN' and not(descendant::tei:w) and not(@xml:lang)])"
							/>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:text>Proportion of corpus "unclear": </xsl:text>
						</td>
						<td>
							<xsl:value-of
								select="round((($unclearWordCount div $wordCount) * 100) * 100) div 100"/>
							<xsl:text>%</xsl:text>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:text>Prose: </xsl:text>
						</td>
						<td>
							<xsl:variable name="proseCount"><xsl:value-of
								select="round((((count(//tei:w[ancestor::tei:div[1][@type = 'prose'] and not(descendant::tei:w) and not(@xml:lang)])) div $wordCount) * 100) * 100) div 100"/></xsl:variable>
							<xsl:variable name="divProseCount"><xsl:value-of
								select="round((((count(//tei:w[ancestor::tei:div[1][@type = 'divprose'] and not(descendant::tei:w) and not(@xml:lang)])) div $wordCount) * 100) * 100) div 100"/></xsl:variable>
							<xsl:value-of select="$proseCount + $divProseCount"/><xsl:text>%</xsl:text>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:text>Verse: </xsl:text>
						</td>
						<td>
							<xsl:value-of
								select="round((((count(//tei:w[ancestor::tei:div[1][@type = 'verse'] and not(descendant::tei:w) and not(@xml:lang)])) div $wordCount) * 100) * 100) div 100"/>
							<xsl:text>%</xsl:text>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:text>Material by Beatons: </xsl:text>
						</td>
						<td>
							<xsl:value-of
								select="round((((count(//tei:w[ancestor::tei:div[contains(key('hands', @resp)/tei:surname, 'Beaton')] and not(descendant::tei:w) and not(@xml:lang)])) div $wordCount) * 100) * 100) div 100"/>
							<xsl:text>%</xsl:text>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:text>Material by Mac Mhuirichs: </xsl:text>
						</td>
						<td>
							<xsl:value-of
								select="round((((count(//tei:w[ancestor::tei:div[contains(key('hands', @resp)/tei:surname, 'Mhuirich')] and not(descendant::tei:w) and not(@xml:lang)])) div $wordCount) * 100) * 100) div 100"/>
							<xsl:text>%</xsl:text>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:text>Words rendered using the most abbreviations (top 5):</xsl:text>
						</td>
						<td>
							<xsl:for-each select="//tei:w[not(descendant::tei:w) and not(@type='data')]">
								<xsl:sort order="descending" select="count(descendant::tei:g)"/>
								<xsl:if test="position() &lt; 6">
									<xsl:value-of select="position()"/><xsl:text>. </xsl:text><xsl:call-template name="word_ed"/><xsl:text> (</xsl:text><xsl:value-of select="count(descendant::tei:g)"/><xsl:text>)</xsl:text><br/>
								</xsl:if>
							</xsl:for-each>
						</td>
					</tr>
				</table>
				<br/>
				<table>
					<tr>
						<th>Scribe</th>
						<th>Date</th>
						<th>Word Count</th>
					</tr>
					<xsl:for-each select="tei:teiCorpus/tei:teiHeader//tei:handNote">
						<xsl:sort order="ascending" select="tei:date"/>
						<xsl:variable name="HandID" select="@xml:id"/>
						<xsl:variable name="comDiv" select="ancestor::tei:div[1]/@corresp"/>
							<tr>
								<td>
									<xsl:value-of select="tei:forename"/><xsl:text> </xsl:text><xsl:value-of select="tei:surname"/><xsl:text> (</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>)</xsl:text>
								</td>
								<td>
									<xsl:value-of select="tei:date"/><xsl:if test="not(@xml:id='Hand999')"><sup>th</sup><xsl:text> cent.</xsl:text></xsl:if>
								</td>
								<td>
									<xsl:variable name="proseCount"><xsl:value-of select="count(key('handToText', @xml:id)/tei:p/descendant::tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type='data') and not(preceding::tei:handShift[1][ancestor::tei:div[1][@corresp=$comDiv] and not(@new=$HandID)]) and not(ancestor::tei:add)])"/></xsl:variable>
									<xsl:variable name="lgCount"><xsl:value-of select="count(key('handToText', @xml:id)/tei:lg/descendant::tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type='data') and not(preceding::tei:handShift[1][ancestor::tei:div[1][@corresp=$comDiv]  and not(@new=$HandID)]) and not(ancestor::tei:add)])"/></xsl:variable>
									<xsl:variable name="hsCount"><xsl:value-of select="count(key('handToHS', @xml:id)/following::tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type='data') and not(ancestor::tei:add) and not(preceding::tei:handShift[1][not(@new=$HandID)]) and ancestor::tei:div[@corresp=$comDiv]])"/></xsl:variable>
									<xsl:variable name="addCount"><xsl:value-of select="count(//tei:w[ancestor::tei:add[@resp=$HandID] or descendant::tei:add[@resp=$HandID]])"/></xsl:variable>
									<xsl:value-of select="$proseCount + $lgCount + $hsCount + $addCount"/>
								</td>
							</tr>
					</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>

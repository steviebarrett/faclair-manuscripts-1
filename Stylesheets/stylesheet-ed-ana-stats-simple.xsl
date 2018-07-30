<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.0">
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
				</table>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>

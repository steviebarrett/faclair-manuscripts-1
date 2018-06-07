<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.0">

	<xsl:output method="html"/>

	<xsl:key name="hands" match="*" use="@xml:id"/>
	<xsl:key name="text" match="*" use="@corresp"/>
	<xsl:key name="text" match="*" use="@xml:id"/>

	<xsl:template match="/">
		<xsl:variable name="wordCount"
			select="count(//tei:w[not(descendant::tei:w) and not(@xml:lang)])"/>
		<xsl:variable name="unclearWordCount"
			select="count(//tei:w[not(descendant::tei:w) and ancestor::tei:unclear or descendant::tei:unclear])"/>

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
							<xsl:text>Individual Headwords in Corpus: </xsl:text>
						</td>
						<td>
							<xsl:value-of
								select="count(//tei:w[not(descendant::tei:w) and @lemmaRef and not(@lemmaRef = preceding::tei:w/@lemmaRef)])"
							/>
						</td>
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
							<xsl:text>"Unclear" words: </xsl:text>
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
							<xsl:value-of
								select="round((((count(//tei:w[ancestor::tei:div[@type = 'prose' or @type = 'divProse'] and not(descendant::tei:w) and not(@xml:lang)])) div $wordCount) * 100) * 100) div 100"/>
							<xsl:text>%</xsl:text>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:text>Verse: </xsl:text>
						</td>
						<td>
							<xsl:value-of
								select="round((((count(//tei:w[ancestor::tei:div[@type = 'verse'] and not(descendant::tei:w) and not(@xml:lang)])) div $wordCount) * 100) * 100) div 100"
							/><xsl:text>%</xsl:text>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:text>Material by Beatons: </xsl:text>
						</td>
						<td>
							<xsl:value-of
								select="round((((count(//tei:w[ancestor::tei:div[contains(key('hands', @resp)/tei:surname, 'Beaton')] and not(descendant::tei:w) and not(@xml:lang)])) div $wordCount) * 100) * 100) div 100"
							/><xsl:text>%</xsl:text>
						</td>
					</tr>
					<tr>
						<td>
							<xsl:text>Material by Mac Mhuirichs: </xsl:text>
						</td>
						<td>
							<xsl:value-of
								select="round((((count(//tei:w[ancestor::tei:div[contains(key('hands', @resp)/tei:surname, 'Mhuirich')] and not(descendant::tei:w) and not(@xml:lang)])) div $wordCount) * 100) * 100) div 100"
							/><xsl:text>%</xsl:text>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>

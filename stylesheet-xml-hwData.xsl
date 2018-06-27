<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="3.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<xsl:call-template name="hwData"/>
	</xsl:template>

	<xsl:template name="hwData">
		<?xml-model href="fnag_mss2.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
		<TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="hwData">
			<teiHeader>
				<fileDesc>
					<titleStmt>
						<title> FnaG MSS Corpus: Headword Data </title>
					</titleStmt>
					<publicationStmt>
						<p> This data is extracted from the FnaG MSS Corpus, supplemented from other
							sources, and then re-used within the Corpus. It is for FnaG internal use
							only. </p>
					</publicationStmt>
					<sourceDesc>
						<p> The FnaG MSS Corpus has been transcribed from manuscripts and marked up
							with lexical and palaeographical data from various sources (e.g. eDIL).
							Transcriptions also have introductions, which are based on the relevant
							secondary literature and the editors' own observations. </p>
					</sourceDesc>
				</fileDesc>
			</teiHeader>
			<text>
				<body>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type='data') and @lemmaRef]">
						<xsl:if
							test="not(@lemmaRef = preceding::tei:w[not(descendant::tei:w)]/@lemmaRef) and not(contains(@ana, ','))">
							<xsl:call-template name="entry"/>
						</xsl:if>
					</xsl:for-each>
				</body>
			</text>
		</TEI>
	</xsl:template>

	<xsl:template name="entry">
		<entryFree>
			<xsl:attribute name="corresp">
				<xsl:value-of select="@lemmaRef"/>
			</xsl:attribute>
			<xsl:attribute name="n">
				<xsl:variable name="wordID" select="@lemmaRef"/>
				<xsl:value-of
					select="count(//tei:w[not(descendant::tei:w) and not(@xml:lang) and @lemmaRef = $wordID])"
				/>
			</xsl:attribute>
			<w>
				<xsl:attribute name="type">
					<xsl:text>data</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="lemma">
					<xsl:value-of select="@lemma"/>
				</xsl:attribute>
				<xsl:attribute name="lemmaRef">
					<xsl:value-of select="@lemmaRef"/>
				</xsl:attribute>
				<xsl:attribute name="ana">
					<xsl:value-of select="@ana"/>
				</xsl:attribute>
				<xsl:attribute name="lemmaDW">
					<xsl:text/>
				</xsl:attribute>
				<xsl:attribute name="lemmaRefDW">
					<xsl:text/>
				</xsl:attribute>
			</w>
			<gen/>
			<iType/>
		</entryFree>
	</xsl:template>

</xsl:stylesheet>

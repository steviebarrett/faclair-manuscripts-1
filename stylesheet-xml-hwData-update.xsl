<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="3.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<xsl:call-template name="hwDataUpdate"/>
	</xsl:template>

	<xsl:template name="hwDataUpdate">
		<TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="hwData">
			<teiHeader>
				<fileDesc>
					<titleStmt>
						<title> FnaG MSS Corpus: New Headword Data </title>
					</titleStmt>
					<publicationStmt>
						<p> This data is extracted from the FnaG MSS Corpus and compared to the
							existing headword database (hwData.xml). Only headwords that do not
							appear in that database are presented here. It is assumed that the
							relevant data will be added to each entry in this file and the entries
							then transferred manually to hwData.xml.</p>
					</publicationStmt>
					<sourceDesc>
						<p> The FnaG MSS Corpus has been transcribed from manuscripts and marked up
							with lexical and palaeographical data from various sources (e.g. eDIL).
							Transcriptions also have introductions, which are based on the relevant
							secondary literature and the editors' own observations. </p>
						<p>hwData.xml contains data on each headword in the Corpus supplied by the editors while transcribing and while reviewing the headwords.</p>
					</sourceDesc>
				</fileDesc>
			</teiHeader>
			<text>
				<body>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and not(@xml:lang) and @lemmaRef]">
						<xsl:sort select="@lemma"/>
						<xsl:variable name="wordID" select="@lemmaRef"/>
						<xsl:if
							test="not(@lemmaRef = preceding::tei:w[not(descendant::tei:w)]/@lemmaRef) and not(contains(@ana, ',')) and not(//tei:TEI[@xml:id = 'hwData']/descendant::tei:entryFree/tei:w/@corresp = $wordID)">
							<entryFree>
								<xsl:variable name="wordID" select="@lemmaRef"/>
								<xsl:attribute name="n">
									<xsl:value-of
										select="count(//tei:w[not(descendant::tei:w) and not(@xml:lang) and @lemmaRef = $wordID])"
									/>
								</xsl:attribute>
								<w>
									<xsl:attribute name="lemma">
										<xsl:value-of select="@lemma"/>
									</xsl:attribute>
									<xsl:attribute name="corresp">
										<xsl:value-of select="@lemmaRef"/>
									</xsl:attribute>
									<xsl:attribute name="ana">
										<xsl:value-of select="@ana"/>
									</xsl:attribute>
									<xsl:attribute name="lemmaDW"/>
									<xsl:attribute name="lemmaRefDW"/>
								</w>
								<gen/>
								<iType/>
							</entryFree>
						</xsl:if>
					</xsl:for-each>
				</body>
			</text>
		</TEI>
	</xsl:template>

</xsl:stylesheet>

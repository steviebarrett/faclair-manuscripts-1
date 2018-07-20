<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="3.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<xsl:call-template name="hwDataUpdate"/>
	</xsl:template>

	<xsl:template name="hwDataUpdate">
		<?xml-model href="fnag_mss2.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>
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
						<p>hwData.xml contains data on each headword in the Corpus supplied by the
							editors while transcribing and while reviewing the headwords.</p>
					</sourceDesc>
				</fileDesc>
			</teiHeader>
			<text>
				<body>
					<xsl:for-each
						select="//tei:teiCorpus//tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type='data') and @lemmaRef and not(@lemmaRefDW)]">
						<xsl:variable name="wordID" select="@lemmaRef"/>
						<xsl:if
							test="not(@lemmaRef = preceding::tei:w[not(descendant::tei:w)]/@lemmaRef) and not(contains(@ana, ','))">
							<entryFree>
								<xsl:attribute name="corresp">
									<xsl:value-of select="@lemmaRef"/>
								</xsl:attribute>
								<xsl:attribute name="n">
									<xsl:value-of
										select="count(//tei:w[not(descendant::tei:w) and not(@xml:lang) and @lemmaRef = $wordID])"
									/>
								</xsl:attribute>
								<xsl:if test="not(//tei:TEI[@xml:id = 'hwData']/descendant::tei:entryFree[@corresp = $wordID])">
									<xsl:attribute name="class">
										<xsl:text>new</xsl:text>
									</xsl:attribute>
								</xsl:if>
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
										<xsl:value-of select="//tei:TEI[@xml:id = 'hwData']/descendant::tei:entryFree[@corresp = $wordID]/tei:w/@lemmaDW"/>
									</xsl:attribute>
									<xsl:attribute name="lemmaRefDW">
										<xsl:value-of select="//tei:TEI[@xml:id = 'hwData']/descendant::tei:entryFree[@corresp = $wordID]/tei:w/@lemmaRefDW"/>
									</xsl:attribute>
								</w>
								<xsl:copy-of select="//tei:TEI[@xml:id = 'hwData']/descendant::tei:entryFree[@corresp = $wordID]/tei:gen"/>
								<xsl:copy-of select="//tei:TEI[@xml:id = 'hwData']/descendant::tei:entryFree[@corresp = $wordID]/tei:iType"/>
							</entryFree>
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
					<xsl:variable name="wordID" select="@lemmaRef"/>
					<xsl:value-of select="//tei:TEI[@xml:id = 'hwData']/descendant::tei:entryFree[@corresp = $wordID]/tei:w/@lemmaDW"/>
				</xsl:attribute>
				<xsl:attribute name="lemmaRefDW">
					<xsl:variable name="wordID" select="@lemmaRef"/>
					<xsl:choose>
						<xsl:when test="contains(//tei:TEI[@xml:id = 'hwData']/descendant::tei:entryFree[@corresp = $wordID]/tei:w/@lemmaRefDW, 'faclair')">
							<xsl:value-of select="@lemmaRefDW"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</w>
			<gen/>
			<iType/>
		</entryFree>
	</xsl:template>

</xsl:stylesheet>

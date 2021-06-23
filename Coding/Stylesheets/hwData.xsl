<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ns="https://dasg.ac.uk/corpus/"
	exclude-result-prefixes="xs" version="3.0">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:variable name="timestamp">
		<xsl:value-of
			select="
				(current-dateTime() -
				xs:dateTime('1970-01-01T00:00:00'))
				div xs:dayTimeDuration('PT1S') * 1000"
		/>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:result-document href="{concat('hwData_', $timestamp, '.xml')}">
			<xsl:call-template name="hwDataUpdate"/>
		</xsl:result-document>
	</xsl:template>

	<xsl:template name="hwDataUpdate">
		<xsl:variable name="lostHwCount">
			<xsl:value-of
				select="count(//ns:TEI[@xml:id = 'hwData']//ns:entryFree[not(@corresp = //ns:TEI[not(@xml:id = 'hwData')]//ns:w/@lemmaRef)])"
			/>
		</xsl:variable>
		<TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="hwData">
			<teiHeader>
				<fileDesc>
					<titleStmt>
						<title> FnaG MSS Corpus: Headword Data </title>
					</titleStmt>
					<publicationStmt>
						<p>
							<xsl:call-template name="date"/>
						</p>
						<p> This data was extracted from the FnaG MSS Corpus and the existing
							headword database (hwData.xml). A new database is generated consisting
							of the pre-existing database together with headwords that have been
							found in the corpus that do not appear in the pre-existing database.
							These are tagged 'source="new"'. The counts ('@n') of occurences of
							headwords in the corpus have been updated based on the version of the
							corpus used to generate this file.</p>
					</publicationStmt>
					<sourceDesc>
						<p> The FnaG MSS Corpus has been transcribed from manuscripts and marked up
							with lexical and palaeographical data from various sources (e.g. eDIL).
							Transcriptions also have introductions, which are based on the relevant
							secondary literature and the editors' own observations. </p>
						<p>The headword database (hwData.xml) contains data on each headword in the
							FnaG MSS Corpus supplied by the editors while transcribing and while
							reviewing the headwords. Headwords and URLs from eDIL and Dwelly are
							added during transcription. Morphological data and additional
							headwords/URLs are added to the headwords database.</p>
						<p>There are currently <xsl:call-template name="wCount"/> Gaelic words in
							the corpus and <xsl:call-template name="hwCount"/> headword entries in
							the headword database. <xsl:call-template name="scgDataPc"/> of these
							contain headwords from both eDIL and Dwelly.</p>
						<p><xsl:call-template name="newHwCount"/> new words have been added to the
							corpus since <xsl:call-template name="prevDate"/>. Entries have been
							created for them in the headword database. These are:<xsl:call-template
								name="newHwList"/></p>
						<xsl:if test="$lostHwCount > 0">
							<p><xsl:value-of select="$lostHwCount"/> words have been removed from
								the corpus since <xsl:call-template name="prevDate"/> and thus no
								longer appear in the headword database. These are:
									<xsl:call-template name="lostHwList"/></p>
						</xsl:if>
					</sourceDesc>
				</fileDesc>
			</teiHeader>
			<text>
				<body>
					<xsl:for-each
						select="//ns:w[@lemmaRef and not(@lemmaRef = preceding::ns:w/@lemmaRef) and not(@type = 'data')]">
						<xsl:variable name="wordID" select="@lemmaRef"/>
						<entryFree>
							<xsl:attribute name="corresp">
								<xsl:value-of select="$wordID"/>
							</xsl:attribute>
							<xsl:attribute name="n">
								<xsl:value-of
									select="count(//ns:w[not(contains(@lemmaRef, ',')) and not(@xml:lang) and not(@type = 'data') and @lemmaRef = $wordID])"
								/>
							</xsl:attribute>
							<xsl:if
								test="not(//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]) or //ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/@source = 'new'">
								<xsl:attribute name="source">
									<xsl:text>new</xsl:text>
								</xsl:attribute>
							</xsl:if>
							<xsl:choose>
								<xsl:when
									test="not(//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID])">
									<xsl:attribute name="source">
										<xsl:text>new</xsl:text>
									</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when
											test="//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/@source = 'new'">
											<xsl:attribute name="source">
												<xsl:text>new</xsl:text>
											</xsl:attribute>
										</xsl:when>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
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
								<xsl:attribute name="pos">
									<xsl:choose>
										<xsl:when test="@ana">
											<xsl:value-of select="@ana"/>
										</xsl:when>
										<xsl:when test="@pos">
											<xsl:value-of select="@pos"/>
										</xsl:when>
									</xsl:choose>
								</xsl:attribute>
								<xsl:if
									test="//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/ns:w/@lemmaDW">
									<xsl:attribute name="lemmaDW">
										<xsl:value-of
											select="//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/ns:w/@lemmaDW"
										/>
									</xsl:attribute>
								</xsl:if>
								<xsl:if
									test="//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/ns:w/@lemmaRefDW">
									<xsl:attribute name="lemmaRefDW">
										<xsl:value-of
											select="//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/ns:w/@lemmaRefDW"
										/>
									</xsl:attribute>
								</xsl:if>
								<!-- New -->
								<xsl:variable name="lems" as="element()">
									<lems>
										<xsl:for-each
											select="//ns:w[@lemmaRef = $wordID and not(@type = 'data')]">
											<lem>
												<xsl:value-of select="@lemma"/>
											</lem>
										</xsl:for-each>
									</lems>
								</xsl:variable>
								<xsl:for-each select="$lems/*">
									<xsl:variable name="lem" select="string(.)"/>
									<xsl:if test="not(self::* = preceding-sibling::*)">
										<span>
											<xsl:attribute name="type">lem</xsl:attribute>
											<xsl:attribute name="n"
												select="count($lems/*[self::* = $lem])"/>
											<xsl:value-of select="$lem"/>
										</span>
									</xsl:if>
								</xsl:for-each>
								<!-- <xsl:variable name="firstLem"
									select="//ns:w[1][@lemmaRef = $wordID and not(@lemmaRef = preceding::ns:w/@lemmaRef)]/@lemma"/>
								<xsl:if test="//ns:w[@lemmaRef = $wordID and @lemma != $firstLem]">
									<span>
										<xsl:attribute name="type">altLem</xsl:attribute>
										<xsl:attribute name="n">
											<xsl:value-of
												select="count(//ns:w[@lemma = $firstLem])"/>
										</xsl:attribute>
										<xsl:value-of select="$firstLem"/>
									</span>
									<xsl:for-each
										select="//ns:w[@lemmaRef = $wordID and @lemma != $firstLem]">
										<xsl:variable name="thisLem" select="@lemma"/>
										<xsl:if
											test="not(preceding::ns:w[@lemmaRef = $wordID]/@lemma = $thisLem)">
											<span>
												<xsl:attribute name="type">altLem</xsl:attribute>
												<xsl:attribute name="n">
												<xsl:value-of
												select="count(//ns:w[@lemma = $thisLem])"/>
												</xsl:attribute>
												<xsl:value-of select="$thisLem"/>
											</span>
										</xsl:if>
									</xsl:for-each>
								</xsl:if> -->
								<!-- New -->
								<xsl:variable name="forms" as="element()">
									<forms>
										<xsl:for-each
											select="//ns:w[@lemmaRef = $wordID and not(@type = 'data')]">
											<form>
												<xsl:value-of
												select="string(translate(normalize-space(.), ' ', ''))"
												/>
											</form>
										</xsl:for-each>
									</forms>
								</xsl:variable>
								<xsl:for-each select="$forms/*">
									<xsl:variable name="form" select="string(.)"/>
									<xsl:if test="not(self::* = preceding-sibling::*)">
										<span>
											<xsl:attribute name="type">form</xsl:attribute>
											<xsl:attribute name="n"
												select="count($forms/*[self::* = $form])"/>
											<xsl:value-of select="$form"/>
										</span>
									</xsl:if>
								</xsl:for-each>
								<!-- <xsl:variable name="firstForm"
									select="//ns:w[not(descendant::ns:w) and not(@type = 'data') and @lemmaRef = $wordID and not(@lemmaRef = preceding::ns:w[not(descendant::ns:w)]/@lemmaRef)]/string(translate(normalize-space(self::*), ' ', ''))"/>
								<xsl:if
									test="//ns:w[not(descendant::ns:w) and not(@type = 'data') and @lemmaRef = $wordID and not(string(translate(normalize-space(self::*), ' ', '')) = $firstForm)]">
									<span>
										<xsl:attribute name="type">altForm</xsl:attribute>
										<xsl:value-of
											select="translate(normalize-space($firstForm), ' ', '')"
										/>
									</span>
									<xsl:for-each
										select="//ns:w[not(descendant::ns:w) and not(@type = 'data') and @lemmaRef = $wordID and not(string(translate(normalize-space(self::*), ' ', '')) = preceding::ns:w[not(@type = 'data') and @lemmaRef = $wordID]/string(translate(normalize-space(self::*), ' ', ''))) and not(string(translate(normalize-space(self::*), ' ', '')) = $firstForm)]">
										<xsl:variable name="thisForm"
											select="string(translate(normalize-space(self::*), ' ', ''))"/>
										<span>
											<xsl:attribute name="type">altForm</xsl:attribute>
											<xsl:value-of
												select="translate(normalize-space($thisForm), ' ', '')"
											/>
										</span>
									</xsl:for-each>
								</xsl:if>
								<xsl:for-each
									select="//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/ns:w/comment()">
									<xsl:comment>
										<xsl:value-of select="concat(' ', string(preceding::ns:span[1]/@type), ' &quot;', preceding::ns:span[1], '&quot;', ': ', string(.))"/>
									</xsl:comment>
								</xsl:for-each> -->
							</w>
							<xsl:copy-of
								select="//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/comment()"
								copy-namespaces="no"/>
							<xsl:copy-of
								select="//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/ns:gramGrp"
								copy-namespaces="no"/>
							<xsl:copy-of
								select="//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/ns:gen[not(ancestor::ns:gramGrp)]"
								copy-namespaces="no"/>
							<xsl:copy-of
								select="//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/ns:iType[not(ancestor::ns:gramGrp)]"
								copy-namespaces="no"/>
						</entryFree>
					</xsl:for-each>
				</body>
			</text>
		</TEI>
	</xsl:template>

	<xsl:template name="hwCount">
		<xsl:value-of select="count(//ns:TEI[@xml:id = 'hwData']//ns:entryFree)"/>
	</xsl:template>

	<xsl:template name="wCount">
		<xsl:value-of
			select="count(//ns:w[not(descendant::ns:w) and not(@xml:lang) and not(@type = 'data')])"
		/>
	</xsl:template>

	<xsl:template name="scgDataPc">
		<xsl:variable name="calc"
			select="count(//ns:TEI[@xml:id = 'hwData']//ns:entryFree[ns:w[@lemmaDW and @lemma]]) div count(//ns:TEI[@xml:id = 'hwData']//ns:entryFree)"/>
		<xsl:value-of select="format-number($calc, '##%')"/>
	</xsl:template>

	<xsl:template name="newHwCount">
		<xsl:value-of
			select="count(//ns:w[not(@xml:lang) and not(@type = 'data') and not(contains(@lemmaRef, ',')) and @lemmaRef and not(@lemmaRef = //ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree/@corresp) and not(@lemmaRef = preceding::ns:w/@lemmaRef)])"
		/>
	</xsl:template>

	<xsl:template name="newHwList">
		<list>
			<xsl:for-each
				select="//ns:w[not(@xml:lang) and not(@type = 'data') and not(contains(@lemmaRef, ',')) and @lemmaRef and not(@lemmaRef = //ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree/@corresp) and not(@lemmaRef = preceding::ns:w/@lemmaRef)]">
				<xsl:sort
					select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
				<item>
					<xsl:value-of select="@lemma"/>
				</item>
			</xsl:for-each>
		</list>
	</xsl:template>

	<xsl:template name="lostHwList">
		<list>
			<xsl:for-each
				select="//ns:TEI[@xml:id = 'hwData']//ns:entryFree[not(@corresp = //ns:TEI[not(@xml:id = 'hwData')]//ns:w/@lemmaRef)]">
				<xsl:variable name="wordID" select="@corresp"/>
				<xsl:if test="not(//ns:TEI[not(@xml:id = 'hwData')]//ns:w/@lemmaRef = $wordID)">
					<item>
						<xsl:value-of
							select="//ns:TEI[@xml:id = 'hwData']//ns:entryFree[@corresp = $wordID]/ns:w/@lemma"
						/>
					</item>
				</xsl:if>
			</xsl:for-each>
		</list>
	</xsl:template>

	<xsl:template name="date">
		<xsl:value-of select="current-dateTime()"/>
	</xsl:template>

	<xsl:template name="prevDate">
		<xsl:value-of select="//ns:TEI[@xml:id = 'hwData']//ns:publicationStmt/ns:p[1]"/>
	</xsl:template>

	<!-- <xsl:template name="entry">
		<entryFree>
			<xsl:attribute name="corresp">
				<xsl:value-of select="@lemmaRef"/>
			</xsl:attribute>
			<xsl:attribute name="n">
				<xsl:variable name="wordID" select="@lemmaRef"/>
				<xsl:value-of
					select="count(//ns:w[not(descendant::ns:w) and not(@xml:lang) and @lemmaRef = $wordID])"
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
					<xsl:value-of
						select="//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/ns:w/@lemmaDW"
					/>
				</xsl:attribute>
				<xsl:attribute name="lemmaRefDW">
					<xsl:variable name="wordID" select="@lemmaRef"/>
					<xsl:choose>
						<xsl:when
							test="contains(//ns:TEI[@xml:id = 'hwData']/descendant::ns:entryFree[@corresp = $wordID]/ns:w/@lemmaRefDW, 'faclair')">
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
	</xsl:template> -->

</xsl:stylesheet>

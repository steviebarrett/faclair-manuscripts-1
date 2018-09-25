<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="stylesheet-dip-comp.xsl"/>
	<xsl:strip-space elements="*"/>

	<xsl:output method="html"/>

	<xsl:key name="abbrs" match="*" use="@xml:id"/>
	<xsl:key name="hands" match="*" use="@xml:id"/>
	<xsl:key name="mss" match="*" use="@xml:id"/>
	<xsl:key name="bib" match="*" use="@xml:id"/>
	<xsl:key name="pos" match="*" use="@xml:id"/>
	<xsl:key name="probs" match="*" use="@xml:id"/>
	<xsl:key name="divTitle" match="*" use="@xml:id"/>
	<xsl:key name="auth" match="*" use="@xml:id"/>
	<xsl:key name="lang" match="*" use="@xml:id"/>
	<xsl:key name="text" match="*" use="@corresp"/>
	<xsl:key name="altText" match="*" use="@corresp"/>
	<xsl:key name="hwData" match="*" use="@corresp"/>

	<xsl:param name="sicReplace" select="'alt'"/>

	<!-- <xsl:attribute-set name="tblBorder">
		<xsl:attribute name="border">solid 0.1mm black</xsl:attribute>
	</xsl:attribute-set> -->

	<xsl:template match="/">
		<html id="root">
			<head>
				<script src="../Coding/JS_FIles/WordFile.js"/>
				<script src="../Coding/JS_FIles/ref.js"/>
				<script src="../Coding/JS_FIles/hilites.js"/>
				<script src="../Coding/JS_FIles/textComm.js"/>
				<script src="../Coding/JS_FIles/ilTextComm.js"/>
			</head>
			<body onload="getSessionID()">
				<h1 style="text-align:center; font-size:18px">
					<xsl:value-of
						select="tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				</h1>
				<xsl:for-each select="//tei:TEI[not(@xml:id = 'hwData')]">
					<br/>
					<xsl:call-template name="tempEd"/>
					<br/>
					<h2 style="text-align:center;font-size:18px">Diplomatic Text</h2>
					<xsl:for-each select="//tei:TEI[not(@xml:id = 'hwData')]">
						<xsl:choose>
							<xsl:when test="descendant::tei:div/key('divTitle', @corresp)/tei:locus/@n">
								<xsl:for-each select="//tei:div[not(descendant::tei:div)]">
									<xsl:sort select="key('divTitle', @corresp)/tei:locus/@n"/>
									<xsl:apply-templates mode="dip"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates mode="dip"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
					<h3 style="font-size:18px">Bibliography</h3>
					<h4 style="font-size:16px">Manuscripts</h4>
					<ul>
						<xsl:for-each select="descendant::tei:ref[@type = 'ms']">
							<xsl:sort select="tei:settlement"/>
							<xsl:variable name="transcrID" select="ancestor::tei:TEI/@xml:id"/>
							<xsl:variable name="msID" select="@target"/>
							<xsl:if test="not(preceding::tei:ref[@target = $msID])">
								<li style="font-size:11px;list-style: none">
									<xsl:call-template name="mssBib"/>
								</li>
							</xsl:if>
						</xsl:for-each>
					</ul>
					<h4 style="font-size:16px">Works Cited</h4>
					<ul>
						<xsl:for-each select="descendant::tei:ref[@type = 'bib']">
							<xsl:variable name="transcrID" select="ancestor::tei:TEI/@xml:id"/>
							<xsl:variable name="bibID" select="@target"/>
							<xsl:if test="not(preceding::tei:ref[@target = $bibID])">
								<li style="font-size:11px;list-style: none">
									<xsl:call-template name="litBib"/>
								</li>
							</xsl:if>
						</xsl:for-each>
					</ul>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

	<!-- <xsl:template match="/" mode="word">
		<html>
			<head>
				<script src="WordFile.js"/>
				<script src="ref.js"/>
				<script src="hilites.js"/>
			</head>
			<body>
				<h1 style="text-align:center; font-size:18px">
					<xsl:value-of select="tei:teiCorpus/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				</h1>
				<xsl:for-each select="//tei:TEI[not(@xml:id='hwData')]">
					<br/>
					<xsl:call-template name="tempEd"/>
					<br/>
					<h2 style="text-align:center;font-size:18px">Diplomatic Text</h2>
					<xsl:apply-templates mode="dip"/>
					<h3 style="font-size:18px">Bibliography</h3>
					<h4 style="font-size:16px">Manuscripts</h4>
					<ul>
						<xsl:for-each select="descendant::tei:ref[@type = 'ms']">
							<xsl:sort select="tei:settlement"/>
							<xsl:variable name="transcrID" select="ancestor::tei:TEI/@xml:id"/>
							<xsl:variable name="msID" select="@target"/>
							<xsl:if test="not(preceding::tei:ref[@target = $msID])">
								<li style="font-size:11px;list-style: none">
									<xsl:call-template name="mssBib"/>
								</li>
							</xsl:if>
						</xsl:for-each>
					</ul>
					<h4 style="font-size:16px">Works Cited</h4>
					<ul>
						<xsl:for-each select="descendant::tei:ref[@type = 'bib']">
							<xsl:variable name="transcrID" select="ancestor::tei:TEI/@xml:id"/>
							<xsl:variable name="bibID" select="@target"/>
							<xsl:if
								test="not(preceding::tei:ref[@target = $bibID])">
								<li style="font-size:11px;list-style: none">
									<xsl:call-template name="litBib"/>
								</li>
							</xsl:if>
						</xsl:for-each>
					</ul>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template> -->

	<xsl:template name="mssBib" match="tei:listBibl[@type = 'mss']/tei:msDesc/tei:msIdentifier">
		<xsl:value-of select="key('bib', @target)/tei:settlement"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="key('bib', @target)/tei:repository"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="key('bib', @target)/tei:idno"/>
		<xsl:choose>
			<xsl:when test="key('bib', @target)/tei:msName">
				<xsl:text>, </xsl:text>
				<xsl:value-of select="key('bib', @target)/tei:msName"/>
				<xsl:text>.</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>.</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="rspStmt">
		<xsl:variable name="bibDate" select="ancestor::tei:biblStruct//tei:imprint/tei:date"/>
		<xsl:variable name="rspCount" select="count(parent::*/descendant::tei:respStmt)"/>
		<xsl:variable name="rsp">
			<xsl:for-each select="tei:resp">
				<xsl:choose>
					<xsl:when test="text() = 'author'">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="text() = 'editor'">
						<xsl:text> (ed.)</xsl:text>
					</xsl:when>
					<xsl:when test="text() = 'translator'">
						<xsl:text> (tr.)</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="position() = 1">
				<xsl:choose>
					<xsl:when
						test="ancestor::tei:monogr and ancestor::tei:biblStruct[child::tei:analytic]">
						<xsl:value-of select="tei:name/tei:forename"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="tei:name/tei:surname"/>
						<xsl:value-of select="$rsp"/>
						<xsl:if test="$rspCount = 1 or $rspCount > 2">
							<xsl:text>, </xsl:text>
						</xsl:if>
						<xsl:if test="$rspCount = 2">
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="tei:name/tei:surname">
								<xsl:value-of select="tei:name/tei:surname"/>
								<xsl:text> (</xsl:text>
								<xsl:value-of select="$bibDate"/>
								<xsl:text>), </xsl:text>
								<xsl:value-of select="tei:name/tei:forename"/>
								<xsl:value-of select="$rsp"/>
								<xsl:text>, </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="tei:name"/>
								<xsl:text> (</xsl:text>
								<xsl:value-of select="$bibDate"/>
								<xsl:text>)</xsl:text>
								<xsl:text>, </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="position() > 1">
				<xsl:choose>
					<xsl:when test="position() &lt; $rspCount">
						<xsl:value-of select="tei:name/tei:forename"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="tei:name/tei:surname"/>
						<xsl:value-of select="$rsp"/>
						<xsl:text>, </xsl:text>
					</xsl:when>
					<xsl:when test="position() = $rspCount">
						<xsl:text>and </xsl:text>
						<xsl:value-of select="tei:name/tei:forename"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="tei:name/tei:surname"/>
						<xsl:value-of select="$rsp"/>
						<xsl:text>, </xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="litBib">
		<xsl:variable name="contrs_a">
			<xsl:if test="key('bib', @target)/tei:analytic">
				<xsl:for-each select="key('bib', @target)/tei:analytic/tei:respStmt">
					<xsl:call-template name="rspStmt"/>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="not(key('bib', @target)/tei:analytic)">
				<xsl:for-each select="key('bib', @target)/tei:monogr/tei:respStmt">
					<xsl:call-template name="rspStmt"/>
				</xsl:for-each>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="contrs_m">
			<xsl:for-each select="key('bib', @target)[tei:analytic]/tei:monogr/tei:respStmt">
				<xsl:call-template name="rspStmt"/>
			</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="key('bib', @target)/@type = 'book'">
				<xsl:value-of select="$contrs_a"/>
				<i>
					<xsl:value-of select="key('bib', @target)/tei:monogr/tei:title"/>
				</i>
				<xsl:if
					test="key('bib', @target)/tei:monogr/tei:imprint/tei:biblScope[@unit = 'volume']">
					<xsl:text>, vol. </xsl:text>
					<xsl:value-of
						select="key('bib', @target)/tei:monogr/tei:imprint/tei:biblScope[@unit = 'volume']"
					/>
				</xsl:if>
				<xsl:if test="key('bib', @target)/tei:series">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="key('bib', @target)/tei:series/tei:title"/>
					<xsl:if test="key('bib', @target)/tei:series/tei:biblScope[@unit = 'volume']">
						<xsl:text> </xsl:text>
						<xsl:value-of
							select="key('bib', @target)/tei:series/tei:biblScope[@unit = 'volume']"
						/>
					</xsl:if>
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="key('bib', @target)/tei:monogr/tei:imprint/tei:pubPlace"/>
				<xsl:text>: </xsl:text>
				<xsl:value-of select="key('bib', @target)/tei:monogr/tei:imprint/tei:publisher"/>
			</xsl:when>
			<xsl:when test="key('bib', @target)/@type = 'journalArticle'">
				<xsl:value-of select="$contrs_a"/>
				<xsl:text>'</xsl:text>
				<xsl:value-of select="key('bib', @target)/tei:analytic/tei:title"/>
				<xsl:text>', </xsl:text>
				<i>
					<xsl:value-of select="key('bib', @target)/tei:monogr/tei:title"/>
				</i>
				<xsl:text> </xsl:text>
				<xsl:value-of
					select="key('bib', @target)/tei:monogr/tei:imprint/tei:biblScope[@unit = 'volume']"/>
				<xsl:if
					test="key('bib', @target)/tei:monogr/tei:imprint/tei:biblScope[@unit = 'issue']">
					<xsl:text>:</xsl:text>
					<xsl:value-of
						select="key('bib', @target)/tei:monogr/tei:imprint/tei:biblScope[@unit = 'issue']"
					/>
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of
					select="key('bib', @target)/tei:monogr/tei:imprint/tei:biblScope[@unit = 'page']"
				/>
			</xsl:when>
			<xsl:when test="key('bib', @target)/@type = 'bookSection'">
				<xsl:value-of select="$contrs_a"/>
				<xsl:text>'</xsl:text>
				<xsl:value-of select="key('bib', @target)/tei:analytic/tei:title"/>
				<xsl:text>', in </xsl:text>
				<xsl:value-of select="$contrs_m"/>
				<i>
					<xsl:value-of select="key('bib', @target)/tei:monogr/tei:title"/>
				</i>
				<xsl:if test="key('bib', @target)/tei:series">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="key('bib', @target)/tei:series/tei:title"/>
					<xsl:if test="key('bib', @target)/tei:series/tei:biblScope[@unit = 'volume']">
						<xsl:text> </xsl:text>
						<xsl:value-of
							select="key('bib', @target)/tei:series/tei:biblScope[@unit = 'volume']"
						/>
					</xsl:if>
				</xsl:if>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="key('bib', @target)/tei:monogr/tei:imprint/tei:pubPlace"/>
				<xsl:text>: </xsl:text>
				<xsl:value-of select="key('bib', @target)/tei:monogr/tei:imprint/tei:publisher"/>
				<xsl:text>, </xsl:text>
				<xsl:value-of
					select="key('bib', @target)/tei:monogr/tei:imprint/tei:biblScope[@unit = 'page']"
				/>
			</xsl:when>
			<xsl:when test="key('bib', @target)/@type = 'webpage'">
				<xsl:value-of select="$contrs_a"/>
				<i>
					<xsl:value-of select="key('bib', @target)/tei:monogr/tei:title"/>
				</i>
				<xsl:text>, &lt;</xsl:text>
				<a href="{key('bib', @target)/tei:monogr/tei:imprint/tei:note[@type = 'url']}">
					<xsl:value-of
						select="key('bib', @target)/tei:monogr/tei:imprint/tei:note[@type = 'url']"
					/>
				</a>
				<xsl:text>&gt;, accessed </xsl:text>
				<xsl:value-of
					select="key('bib', @target)/tei:monogr/tei:imprint/tei:note[@type = 'accessed']"
				/>
			</xsl:when>
			<xsl:when test="key('bib', @target)/@type = 'report'">
				<xsl:value-of select="$contrs_a"/>
				<xsl:text>'</xsl:text>
				<xsl:value-of select="key('bib', @target)/tei:monogr/tei:title"/>
				<xsl:text>', unpubl. report, </xsl:text>
				<xsl:value-of select="key('bib', @target)/tei:monogr/tei:imprint/tei:pubPlace"/>
				<xsl:text>: </xsl:text>
				<xsl:value-of select="key('bib', @target)/tei:monogr/tei:imprint/tei:publisher"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="tempEd" match="tei:teiCorpus/tei:TEI">
		<br/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:body">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:teiHeader">
		<xsl:if test="not(ancestor::tei:TEI[@xml:id = 'hwData'])">
			<xsl:apply-templates/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:fileDesc/tei:titleStmt">
		<h2 style="font-size:18px">
			<xsl:apply-templates select="tei:title"/>
		</h2>
		<h3 style="font-size:16px">Publication Details</h3>
		<xsl:for-each select="tei:respStmt">
			<xsl:apply-templates select="tei:name"/>
			<xsl:text> (</xsl:text>
			<xsl:apply-templates select="tei:resp"/>
			<xsl:text>)</xsl:text>
			<br/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:fileDesc/tei:extent">
		<xsl:variable name="fileID" select="ancestor::tei:TEI[1]/@xml:id"/>
		<xsl:value-of
			select="count(//tei:w[not(descendant::tei:w) and ancestor::tei:TEI[1][@xml:id = $fileID]])"/>
		<xsl:text> words</xsl:text>
	</xsl:template>

	<xsl:template
		match="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence">
		<p style="font-size:12px">
			<xsl:choose>
				<xsl:when test="parent::tei:availability/@status = 'restricted'">
					<xsl:value-of
						select="ancestor::tei:teiCorpus/tei:teiHeader//tei:publicationStmt/tei:availability/tei:licence/tei:p"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="tei:p"/>
				</xsl:otherwise>
			</xsl:choose>
		</p>
		<p style="font-size:12px">
			<xsl:for-each select="ancestor::tei:teiCorpus/tei:teiHeader//tei:address/tei:addrLine">
				<xsl:apply-templates/>
				<br/>
			</xsl:for-each>
		</p>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:fileDesc/tei:notesStmt">
		<xsl:variable name="msref">
			<xsl:apply-templates
				select="parent::tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:settlement"/>
			<xsl:text>, </xsl:text>
			<xsl:apply-templates
				select="parent::tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:repository"/>
			<xsl:text>, </xsl:text>
			<xsl:apply-templates
				select="parent::tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:idno"/>
		</xsl:variable>
		<h3 style="font-size:16px">Manuscript: <xsl:value-of select="$msref"/></h3>
		<xsl:for-each select="tei:note/tei:p">
			<p style="font-size:11px">
				<xsl:apply-templates/>
			</p>
			<table/>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
				Comment</button>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:fileDesc/tei:sourceDesc">
		<h4 style="font-size:16px">Hands</h4>
		<xsl:for-each select="tei:msDesc/tei:physDesc/tei:handDesc/tei:handNote/tei:note">
			<h5>
				<xsl:value-of select="key('hands', parent::tei:handNote/@corresp)/tei:forename"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="key('hands', parent::tei:handNote/@corresp)/tei:surname"/>
				<xsl:text> (</xsl:text>
				<xsl:value-of select="parent::tei:handNote/@corresp"/>
				<xsl:text>)</xsl:text>
			</h5>
			<xsl:for-each select="tei:p">
				<xsl:if test="@comment">
					<h6>
						<xsl:value-of select="@comment"/>
					</h6>
				</xsl:if>
				<p style="font-size:11px">
					<xsl:apply-templates/>
				</p>
				<table/>
				<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px"
					>Add Comment</button>
			</xsl:for-each>
		</xsl:for-each>
		<h4 style="font-size:16px">Contents</h4>
		<h5 style="font-size:14px">Summary</h5>
		<xsl:for-each select="tei:msDesc/tei:msContents/tei:summary/tei:p">
			<p style="text-decoration:none;color:#000000;font-size:11px">
				<xsl:apply-templates/>
			</p>
		</xsl:for-each>
		<table/>
		<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
			Comment</button>
		<xsl:for-each select="tei:msDesc/tei:msContents/tei:msItem">
			<xsl:variable name="inc"
				select="key('text', @xml:id)//preceding::tei:lb[1]/@xml:id | @sameAs"/>
			<h4 id="{ancestor::tei:TEI/@xml:id}msContents" style="font-size:16px">
				<xsl:value-of select="@n"/>
				<xsl:text>: </xsl:text>
				<a href="#{@xml:id}">
					<xsl:apply-templates select="tei:title"/>
				</a>
			</h4>
			<xsl:if test="tei:locus">
				<a style="text-decoration:none;color:#000000;font-size:11px">
					<xsl:apply-templates select="tei:locus"/>
				</a>
				<br/>
			</xsl:if>
			<xsl:if test="tei:incipit">
				<a style="text-decoration:none;color:#000000;font-size:11px">
					<xsl:text>Beg. "</xsl:text>
					<xsl:apply-templates select="tei:incipit"/>
					<xsl:text>"</xsl:text>
				</a>
				<br/>
			</xsl:if>
			<xsl:if test="tei:explicit">
				<a style="text-decoration:none;color:#000000;font-size:11px">
					<xsl:text>Ends. "</xsl:text>
					<xsl:apply-templates select="tei:explicit"/>
					<xsl:text>"</xsl:text>
				</a>
				<br/>
			</xsl:if>
			<xsl:if test="not(child::tei:msItem)">
				<xsl:variable name="ItemID" select="@xml:id"/>
				<xsl:variable name="comDiv" select="ancestor::tei:div[@corresp = $ItemID]"/>
				<xsl:variable name="itemHand" select="@resp"/>
				<a style="text-decoration:none;color:#000000;font-size:11px">
					<xsl:text>Main scribe: </xsl:text>
					<xsl:value-of select="key('hands', @resp)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="key('hands', @resp)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="@resp"/>
					<xsl:text>)</xsl:text>
				</a>
				<br/>
				<a style="text-decoration:none;color:#000000;font-size:11px">
					<xsl:text>Other hands: </xsl:text>
				</a>
				<xsl:for-each select="//tei:handShift[ancestor::tei:div[@corresp = $ItemID]]">
					<xsl:if
						test="not(@new = preceding::tei:handShift[ancestor::tei:div[@corresp = $ItemID]]/@new) and not(@new = $itemHand) or not(preceding::tei:handShift[ancestor::tei:div[@corresp = $ItemID]])">
						<a style="text-decoration:none;color:#000000;font-size:11px">
							<xsl:value-of select="key('hands', @new)/tei:forename"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="key('hands', @new)/tei:surname"/>
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@new"/>
							<xsl:text>); </xsl:text>
						</a>
					</xsl:if>
				</xsl:for-each>
				<br/>
				<a style="text-decoration:none;color:#000000;font-size:11px">
					<xsl:text>Additions/emendations: </xsl:text>
				</a>
				<xsl:for-each
					select="//tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]] | //tei:del[ancestor::tei:div[@corresp = $ItemID]]">
					<xsl:if
						test="not(@resp = preceding::tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]]/@resp | preceding::tei:del[ancestor::tei:div[@corresp = $ItemID]]/@resp) and not(@resp = $itemHand) or not(preceding::tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]] | preceding::tei:del[ancestor::tei:div[@corresp = $ItemID]])">
						<a style="text-decoration:none;color:#000000;font-size:11px">
							<xsl:value-of select="key('hands', @resp)/tei:forename"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="key('hands', @resp)/tei:surname"/>
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@resp"/>
							<xsl:text>); </xsl:text>
						</a>
					</xsl:if>
				</xsl:for-each>
				<br/>
				<a style="text-decoration:none;color:#000000;font-size:11px">
					<xsl:text>Glossing: </xsl:text>
				</a>
				<xsl:for-each
					select="//tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]]">
					<xsl:if
						test="not(@resp = preceding::tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]]/@resp) and not(@resp = $itemHand) or not(preceding::tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]])">
						<a style="text-decoration:none;color:#000000;font-size:11px">
							<xsl:value-of select="key('hands', @resp)/tei:forename"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="key('hands', @resp)/tei:surname"/>
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@resp"/>
							<xsl:text>); </xsl:text>
						</a>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="self::*">
					<xsl:call-template name="textCommentary"/>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="child::tei:msItem">
				<xsl:variable name="ItemID" select="@xml:id"/>
				<xsl:variable name="comDiv" select="ancestor::tei:div[@corresp = $ItemID]"/>
				<xsl:variable name="itemHand" select="@resp"/>
				<a style="text-decoration:none;color:#000000;font-size:11px">
					<xsl:text>Main scribe: </xsl:text>
					<xsl:value-of select="key('hands', @resp)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="key('hands', @resp)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="@resp"/>
					<xsl:text>)</xsl:text>
				</a>
				<br/>
				<a style="text-decoration:none;color:#000000;font-size:11px">
					<xsl:text>Other hands: </xsl:text>
				</a>
				<xsl:for-each select="//tei:handShift[ancestor::tei:div[@corresp = $ItemID]]">
					<xsl:if
						test="not(@new = preceding::tei:handShift[ancestor::tei:div[@corresp = $ItemID]]/@new) and not(@new = $itemHand) or not(preceding::tei:handShift[ancestor::tei:div[@corresp = $ItemID]])">
						<a style="text-decoration:none;color:#000000;font-size:11px">
							<xsl:value-of select="key('hands', @new)/tei:forename"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="key('hands', @new)/tei:surname"/>
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@new"/>
							<xsl:text>); </xsl:text>
						</a>
					</xsl:if>
				</xsl:for-each>
				<br/>
				<a style="text-decoration:none;color:#000000;font-size:11px">
					<xsl:text>Additions/emendations: </xsl:text>
				</a>
				<xsl:for-each
					select="//tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]] | //tei:del[ancestor::tei:div[@corresp = $ItemID]]">
					<xsl:if
						test="not(@resp = preceding::tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]]/@resp | preceding::tei:del[ancestor::tei:div[@corresp = $ItemID]]/@resp) and not(@resp = $itemHand) or not(preceding::tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]] | preceding::tei:del[ancestor::tei:div[@corresp = $ItemID]])">
						<a style="text-decoration:none;color:#000000;font-size:11px">
							<xsl:value-of select="key('hands', @resp)/tei:forename"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="key('hands', @resp)/tei:surname"/>
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@resp"/>
							<xsl:text>); </xsl:text>
						</a>
					</xsl:if>
				</xsl:for-each>
				<br/>
				<a style="text-decoration:none;color:#000000;font-size:11px">
					<xsl:text>Glossing: </xsl:text>
				</a>
				<xsl:for-each
					select="//tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]]">
					<xsl:if
						test="not(@resp = preceding::tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]]/@resp) and not(@resp = $itemHand) or not(preceding::tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]])">
						<a style="text-decoration:none;color:#000000;font-size:11px">
							<xsl:value-of select="key('hands', @resp)/tei:forename"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="key('hands', @resp)/tei:surname"/>
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@resp"/>
							<xsl:text>); </xsl:text>
						</a>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="self::*">
					<xsl:call-template name="textCommentary"/>
				</xsl:for-each>
				<xsl:for-each select="child::tei:msItem">
					<xsl:variable name="ItemID" select="@xml:id"/>
					<xsl:variable name="comDiv" select="ancestor::tei:div[@corresp = $ItemID]"/>
					<xsl:variable name="itemHand" select="@resp"/>
					<xsl:variable name="incChild"
						select="key('text', @xml:id)//preceding::tei:lb[1]/@xml:id | @sameAs"/>
					<h5 style="margin-left:40px;font-size:14px">
						<a href="#{@xml:id}">
							<xsl:apply-templates select="tei:title"/>
						</a>
					</h5>
					<p style="font-size: smaller">
						<xsl:apply-templates select="tei:locus"/>
						<br/>
						<a style="text-decoration:none;color:#000000;font-size:11px">
							<xsl:text>Beg. "</xsl:text>
							<xsl:apply-templates select="tei:incipit"/>
							<xsl:text>"</xsl:text>
						</a>
						<br/>
						<a style="text-decoration:none;color:#000000;font-size:11px">
							<xsl:text>Ends. "</xsl:text>
							<xsl:apply-templates select="tei:explicit"/>
							<xsl:text>"</xsl:text>
						</a>
						<br/>
						<a style="text-decoration:none;color:#000000;font-size:11px">
							<xsl:text>Main scribe: </xsl:text>
							<xsl:value-of select="key('hands', @resp)/tei:forename"/>
							<xsl:text> </xsl:text>
							<xsl:value-of select="key('hands', @resp)/tei:surname"/>
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@resp"/>
							<xsl:text>)</xsl:text>
						</a>
						<br/>
						<xsl:text>Other hands: </xsl:text>
						<xsl:for-each
							select="//tei:handShift[ancestor::tei:div[@corresp = $ItemID]]">
							<xsl:if
								test="not(@new = preceding::tei:handShift[ancestor::tei:div[@corresp = $ItemID]]/@new) and not(@new = $itemHand) or not(preceding::tei:handShift[ancestor::tei:div[@corresp = $ItemID]])">
								<a style="text-decoration:none;color:#000000;font-size:11px">
									<xsl:value-of select="key('hands', @new)/tei:forename"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select="key('hands', @new)/tei:surname"/>
									<xsl:text> (</xsl:text>
									<xsl:value-of select="@new"/>
									<xsl:text>); </xsl:text>
								</a>
							</xsl:if>
						</xsl:for-each>
						<br/>
						<a style="text-decoration:none;color:#000000;font-size:11px">
							<xsl:text>Additions/emendations: </xsl:text>
						</a>
						<xsl:for-each
							select="//tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]] | //tei:del[ancestor::tei:div[@corresp = $ItemID]]">
							<xsl:if
								test="not(@resp = preceding::tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]]/@resp | preceding::tei:del[ancestor::tei:div[@corresp = $ItemID]]/@resp) and not(@resp = $itemHand) or not(preceding::tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]] | preceding::tei:del[ancestor::tei:div[@corresp = $ItemID]])">
								<a style="text-decoration:none;color:#000000;font-size:11px">
									<xsl:value-of select="key('hands', @resp)/tei:forename"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select="key('hands', @resp)/tei:surname"/>
									<xsl:text> (</xsl:text>
									<xsl:value-of select="@resp"/>
									<xsl:text>); </xsl:text>
								</a>
							</xsl:if>
						</xsl:for-each>
						<br/>
						<xsl:text>Glossing: </xsl:text>
						<xsl:for-each
							select="//tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]]">
							<xsl:if
								test="not(@resp = preceding::tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]]/@resp) and not(@resp = $itemHand) or not(preceding::tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]])">
								<a style="text-decoration:none;color:#000000;font-size:11px">
									<xsl:value-of select="key('hands', @resp)/tei:forename"/>
									<xsl:text> </xsl:text>
									<xsl:value-of select="key('hands', @resp)/tei:surname"/>
									<xsl:text> (</xsl:text>
									<xsl:value-of select="@resp"/>
									<xsl:text>); </xsl:text>
								</a>
							</xsl:if>
						</xsl:for-each>
						<br/>
					</p>
					<table/>
					<button id="{generate-id()}" onclick="textComment(this.id)"
						style="font-size:12px">Add Comment</button>
					<xsl:call-template name="textCommentary"/>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
		<h4 style="font-size:16px">Physical Description of Manuscrpt</h4>
		<xsl:if test="tei:msDesc/tei:physDesc/tei:p">
			<xsl:for-each select="tei:msDesc/tei:physDesc/tei:p">
				<p style="font-size:11px">
					<xsl:apply-templates select="tei:msDesc/tei:physDesc/tei:p"/>
				</p>
				<table/>
				<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px"
					>Add Comment</button>
			</xsl:for-each>
		</xsl:if>
		<h5 style="font-size:14px"> Writing Surface </h5>
		<xsl:for-each
			select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:p">
			<p style="font-size:11px">
				<xsl:apply-templates/>
			</p>
			<table/>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
				Comment</button>
		</xsl:for-each>
		<h5 style="font-size:14px"> Foliation </h5>
		<xsl:for-each
			select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:foliation/tei:p">
			<p style="font-size:11px">
				<xsl:apply-templates/>
			</p>
			<table/>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
				Comment</button>
		</xsl:for-each>
		<h5 style="font-size:14px"> Condition </h5>
		<xsl:for-each
			select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:condition/tei:p">
			<p style="font-size:11px">
				<xsl:apply-templates/>
			</p>
			<table/>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
				Comment</button>
		</xsl:for-each>
		<h5 style="font-size:14px"> Layout of Page </h5>
		<xsl:for-each select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:layoutDesc/tei:p">
			<p style="font-size:11px">
				<xsl:apply-templates/>
			</p>
			<table/>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
				Comment</button>
		</xsl:for-each>
		<h4 style="font-size:16px"> History of the Manuscript </h4>
		<h5 style="font-size:14px">Summary</h5>
		<xsl:for-each select="tei:msDesc/tei:history/tei:summary/tei:p">
			<p style="font-size:11px">
				<xsl:apply-templates/>
			</p>
			<table/>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
				Comment</button>
		</xsl:for-each>
		<h5 style="font-size:14px">Origin</h5>
		<xsl:for-each select="tei:msDesc/tei:history/tei:origin/tei:p">
			<p style="font-size:11px">
				<xsl:apply-templates/>
			</p>
			<table/>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
				Comment</button>
		</xsl:for-each>
		<h5 style="font-size:14px">Subsequent History</h5>
		<xsl:for-each select="tei:msDesc/tei:history/tei:provenance/tei:p">
			<p style="font-size:11px">
				<xsl:apply-templates/>
			</p>
			<table/>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
				Comment</button>
		</xsl:for-each>
		<h5 style="font-size:14px">Acquisition</h5>
		<xsl:for-each select="tei:msDesc/tei:history/tei:acquisition/tei:p">
			<p style="font-size:11px">
				<xsl:apply-templates/>
			</p>
			<table/>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
				Comment</button>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="textCommentary">
		<xsl:if test="tei:note">
			<h5 style="font-size:14px">Text Summary</h5>
			<xsl:for-each select="tei:note/tei:p">
				<xsl:if test="@comment">
					<h6 style="font-size:12px">
						<xsl:value-of select="@comment"/>
					</h6>
				</xsl:if>
				<p style="font-size:11px">
					<xsl:apply-templates/>
				</p>
				<table/>
				<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px"
					>Add Comment</button>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="tei:filiation">
			<h5>Filiation of Text</h5>
			<xsl:for-each select="tei:filiation/tei:p">
				<p style="font-size:11px">
					<xsl:apply-templates/>
				</p>
				<table/>
				<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px"
					>Add Comment</button>
			</xsl:for-each>
			<br/>
		</xsl:if>
		<xsl:if test="tei:textLang">
			<h5 style="font-size:14px">Language and Style</h5>
			<xsl:for-each select="tei:textLang/tei:note">
				<xsl:if test="@comment">
					<h6 style="font-size:12px">
						<xsl:value-of select="@comment"/>
					</h6>
				</xsl:if>
				<xsl:for-each select="tei:p">
					<xsl:if test="@comment">
						<b>
							<h7 style="font-size:11px">
								<xsl:value-of select="@comment"/>
							</h7>
						</b>
					</xsl:if>
					<p style="font-size:11px">
						<xsl:apply-templates/>
					</p>
					<table/>
					<button id="{generate-id()}" onclick="textComment(this.id)"
						style="font-size:12px">Add Comment</button>
					<br/>
					<br/>
				</xsl:for-each>
			</xsl:for-each>
			<br/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:encodingDesc">
		<h3 style="font-size:16px">Encoding of this Transcription</h3>
		<h4 style="font-size:16px">Issues</h4>
		<xsl:for-each select="tei:editorialDecl/tei:p">
			<xsl:if test="@comment">
				<b>
					<h7 style="font-size:11px">
						<xsl:value-of select="@comment"/>
					</h7>
				</b>
			</xsl:if>
			<p style="font-size:11px">
				<xsl:apply-templates/>
			</p>
			<table/>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
				Comment</button>
		</xsl:for-each>
		<xsl:if test="tei:metDecl">
			<h4 style="font-size:16px">Metrics</h4>
			<xsl:for-each select="tei:metDecl/tei:p">
				<xsl:if test="@comment">
					<b>
						<h7 style="font-size:11px">
							<xsl:value-of select="@comment"/>
						</h7>
					</b>
				</xsl:if>
				<p style="font-size:11px">
					<xsl:apply-templates/>
				</p>
				<table/>
				<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px"
					>Add Comment</button>
			</xsl:for-each>
		</xsl:if>
		<h4 style="font-size:16px">Referencing of this Transcription</h4>
		<xsl:for-each select="tei:refsDecl/tei:p">
			<xsl:if test="@comment">
				<b>
					<h7 style="font-size:11px">
						<xsl:value-of select="@comment"/>
					</h7>
				</b>
			</xsl:if>
			<p style="font-size:11px">
				<xsl:apply-templates/>
			</p>
			<table/>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
				Comment</button>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:profileDesc/tei:textClass">
		<h3 style="font-size:16px">Keywords</h3>
		<ul style="margin-left:30px">
			<xsl:for-each select="tei:keywords/tei:term">
				<li style="font-size:11px">
					<xsl:apply-templates/>
				</li>
			</xsl:for-each>
		</ul>
		<table/>
		<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
			Comment</button>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:revisionDesc">
		<h3 style="font-size:16px">Revision History</h3>
		<ul style="margin-left:30px">
			<xsl:for-each select="tei:change">
				<li style="font-size:11px">
					<b>
						<xsl:value-of select="@when"/>
						<xsl:text>: </xsl:text>
					</b>
					<xsl:apply-templates/>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="tei:list">
		<ul>
			<xsl:if test="child::tei:item[@n]">
				<xsl:attribute name="style">
					<xsl:text>list-style-type:none</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="tei:head">
				<xsl:choose>
					<xsl:when test="@n">
						<li style="margin-left:30px;font-size:11px">
							<b>
								<xsl:value-of select="@n"/>
								<xsl:text>.  </xsl:text>
								<xsl:apply-templates/>
							</b>
						</li>
					</xsl:when>
					<xsl:otherwise>
						<li style="font-size:11px;list-style: none">
							<b>
								<xsl:apply-templates/>
							</b>
						</li>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
			<xsl:for-each select="tei:item">
				<xsl:choose>
					<xsl:when test="@n">
						<li style="margin-left:30px;font-size:11px">
							<xsl:value-of select="@n"/>
							<xsl:text>.  </xsl:text>
							<xsl:apply-templates/>
						</li>
					</xsl:when>
					<xsl:otherwise>
						<li style="margin-left:30px;font-size:11px">
							<xsl:apply-templates/>
						</li>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="tei:table">
		<table style="margin-left:30px;font-size:11px" border="1">
			<xsl:for-each select="tei:row">
				<xsl:if test="@role = 'label'">
					<tr>
						<xsl:for-each select="tei:cell">
							<th style="bold; font-size: small">
								<xsl:if test="@cols">
									<xsl:attribute name="colSpan" select="@cols"/>
								</xsl:if>
								<xsl:apply-templates/>
							</th>
						</xsl:for-each>
					</tr>
				</xsl:if>
				<xsl:if test="@role = 'data'">
					<tr style="font-size: small">
						<xsl:for-each select="tei:cell">
							<td>
								<xsl:if test="@cols">
									<xsl:attribute name="colSpan" select="@cols"/>
								</xsl:if>
								<xsl:apply-templates/>
							</td>
						</xsl:for-each>
					</tr>
				</xsl:if>
			</xsl:for-each>
		</table>
		<br/>
	</xsl:template>

	<xsl:template match="tei:hi[@rend = 'italics']">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:hi[@rend = 'bold']">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>

	<xsl:template match="tei:hi[@rend = 'sup']">
		<sup>
			<xsl:apply-templates/>
		</sup>
	</xsl:template>

	<xsl:template match="tei:hi[@rend = 'sub']">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>

	<xsl:template match="tei:hi[@rend = 'underline' and not(descendant::tei:w)]">
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>

	<xsl:template match="tei:hi[contains(@rend, 'colour:')]">
		<xsl:variable name="colour" select="substring(@rend, 8)"/>
		<seg style="text-decoration:none;color:{$colour}">
			<xsl:apply-templates/>
		</seg>
	</xsl:template>

	<xsl:template match="tei:pb">
		<xsl:choose>
			<xsl:when test="ancestor::tei:div[1][@type = 'prose']">
				<xsl:variable name="comDiv" select="ancestor::tei:div[1]/@corresp"/>
				<xsl:if test="preceding::tei:lb[ancestor::tei:div/@corresp = $comDiv]">
					<xsl:variable name="lineID">
						<xsl:choose>
							<xsl:when test="preceding::tei:pb[1]/@xml:id">
								<span id="word{count(ancestor::tei:w[1]/preceding::*)}_pb"
									class="pb" onmouseover="disableWordFunctions(this.id)"
									onmouseout="enableWordFunctions(this.id)" style="color:#000000">
									<xsl:value-of select="preceding::tei:pb[1]/@xml:id"/>
								</span>
							</xsl:when>
							<xsl:when test="preceding::tei:pb[1]/@sameAs">
								<span id="word{count(ancestor::tei:w[1]/preceding::*)}_pb"
									class="pb" onmouseover="disableWordFunctions(this.id)"
									onmouseout="enableWordFunctions(this.id)" style="color:#000000">
									<xsl:value-of select="preceding::tei:pb[1]/@sameAs"/>
								</span>
							</xsl:when>
						</xsl:choose>
						<xsl:text>.</xsl:text>
						<xsl:value-of select="preceding::tei:lb[1]/@n + 1"/>
					</xsl:variable>
					<xsl:text xml:space="preserve"> </xsl:text>
					<button id="plus{$lineID}" onclick="revealComment(this.id)"
						style="font-size:12px" class="pb"
						onmouseover="disableWordFunctions(this.id)"
						onmouseout="enableWordFunctions(this.id)">
						<b>+</b>
					</button>
					<br id="plus{$lineID}br" hidden="hidden" class="pb"
						onmouseover="disableWordFunctions(this.id)"
						onmouseout="enableWordFunctions(this.id)"/>
					<table hidden="hidden">
						<xsl:if test="ancestor::tei:w">
							<xsl:attribute name="onmouseover">
								<xsl:text>disableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="onmouseout">
								<xsl:text>enableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
						</xsl:if>
					</table>
					<button id="{generate-id()}_addComment" onclick="textComment(this.id)"
						style="font-size:12px" hidden="hidden" class="pb"
						onmouseover="disableWordFunctions(this.id)"
						onmouseout="enableWordFunctions(this.id)">Add Comment</button>
				</xsl:if>
				<br id="word{count(ancestor::tei:w[1]/preceding::*)}_pb_br1" class="pb"
					onmouseover="disableWordFunctions(this.id)"
					onmouseout="enableWordFunctions(this.id)" style="color:#000000"/>
				<hr align="left" width="40%" id="word{count(ancestor::tei:w[1]/preceding::*)}_pb_hr"
					class="pb" onmouseover="disableWordFunctions(this.id)"
					onmouseout="enableWordFunctions(this.id)" style="color:#000000"/>
				<xsl:choose>
					<xsl:when test="ancestor::tei:div[1]//tei:handShift">
						<xsl:variable name="comDiv" select="ancestor::tei:div[1]/@xml:id"/>
						<xsl:choose>
							<xsl:when
								test="preceding::tei:handShift/ancestor::tei:div[1]/@corresp = $comDiv">
								<seg align="left"
									id="word{count(ancestor::tei:w[1]/preceding::*)}_pb_tit"
									class="pb" onmouseover="disableWordFunctions(this.id)"
									onmouseout="enableWordFunctions(this.id)" style="color:#000000">
									<b><xsl:value-of select="@n"/>: <xsl:value-of
											select="key('hands', preceding::tei:handShift[1]/@new)/tei:forename"
											/><xsl:text> </xsl:text><xsl:value-of
											select="key('hands', preceding::tei:handShift[1]/@new)/tei:surname"
											/><xsl:text> (</xsl:text><xsl:value-of
											select="preceding::tei:handShift[1]/@new"
										/><xsl:text>)</xsl:text></b>
								</seg>
							</xsl:when>
							<xsl:otherwise>
								<seg n="{@n}" align="left"
									id="word{count(ancestor::tei:w[1]/preceding::*)}_pb_tit"
									class="pb" onmouseover="disableWordFunctions(this.id)"
									onmouseout="enableWordFunctions(this.id)" style="color:#000000">
									<b><xsl:value-of select="@n"/>: <xsl:value-of
											select="key('hands', ancestor::tei:div/@resp)/tei:forename"
											/><xsl:text> </xsl:text><xsl:value-of
											select="key('hands', ancestor::tei:div/@resp)/tei:surname"
											/><xsl:text> (</xsl:text><xsl:value-of
											select="ancestor::tei:div/@resp"
										/><xsl:text>) </xsl:text></b>
								</seg>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<seg align="left" id="word{count(ancestor::tei:w[1]/preceding::*)}_pb_tit"
							class="pb" onmouseover="disableWordFunctions(this.id)"
							onmouseout="enableWordFunctions(this.id)" style="color:#000000">
							<b><xsl:value-of select="@n"/>: <xsl:value-of
									select="key('hands', ancestor::tei:div/@resp)/tei:forename"
									/><xsl:text> </xsl:text><xsl:value-of
									select="key('hands', ancestor::tei:div/@resp)/tei:surname"
									/><xsl:text> (</xsl:text><xsl:value-of
									select="ancestor::tei:div[1]/@resp"/><xsl:text>) </xsl:text></b>
						</seg>
					</xsl:otherwise>
				</xsl:choose>
				<button id="{generate-id()}_cs" class="cs" onclick="createTable();beginCS(this)"
					onmouseover="disableWordFunctions(this.id)"
					onmouseout="enableWordFunctions(this.id)">Collect e-Slips</button>
				<button id="{generate-id()}_ws" class="ws" onclick="createTable();beginWS(this)"
						><xsl:if test="ancestor::tei:w">
						<xsl:attribute name="onmouseover">
							<xsl:text>disableWordFunctions(this.id)</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="onmouseout">
							<xsl:text>enableWordFunctions(this.id)</xsl:text>
						</xsl:attribute>
					</xsl:if>Headword Search</button>
				<button id="{generate-id()}_es" class="es" onclick="endSearch(this)" hidden="hidden"
					style="background-color:red">
					<xsl:if test="ancestor::tei:w">
						<xsl:attribute name="onmouseover">
							<xsl:text>disableWordFunctions(this.id)</xsl:text>
						</xsl:attribute>
						<xsl:attribute name="onmouseout">
							<xsl:text>enableWordFunctions(this.id)</xsl:text>
						</xsl:attribute>
					</xsl:if>
					<b>End Search</b>
				</button>
				<br id="word{count(ancestor::tei:w[1]/preceding::*)}_pb_br2" class="pb"
					onmouseover="disableWordFunctions(this.id)"
					onmouseout="enableWordFunctions(this.id)" style="color:#000000"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<sub>
					<b>
						<xsl:choose>
							<xsl:when test="contains(@n, 'r') or contains(@n, 'v')"
								>fol.<xsl:text> </xsl:text></xsl:when>
							<xsl:otherwise>p.<xsl:text> </xsl:text></xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="@n"/>
					</b>
				</sub>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="tei:cb">
		<xsl:choose>
			<xsl:when test="ancestor::tei:div[1]/@type = 'prose'">
				<span class="cb">
					<br/>
					<br/>
					<b>Col.<xsl:text> </xsl:text>
						<xsl:value-of select="@n"/></b>
					<br/>
					<br/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
				<sub>
					<b>
						<xsl:text>col. </xsl:text>
						<xsl:value-of select="@n"/>
					</b>
				</sub>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:lb">
		<xsl:variable name="lineID">
			<xsl:choose>
				<xsl:when test="@sameAs">
					<xsl:value-of select="@sameAs"/>
				</xsl:when>
				<xsl:when test="@xml:id">
					<xsl:value-of select="@xml:id"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::tei:p">
				<xsl:variable name="comDiv" select="ancestor::tei:div[1]/@corresp"/>
				<xsl:variable name="comPage">
					<xsl:choose>
						<xsl:when test="preceding::tei:pb[1]/@xml:id">
							<xsl:value-of select="preceding::tei:pb[1]/@xml:id"/>
						</xsl:when>
						<xsl:when test="preceding::tei:pb[1]/@sameAs">
							<xsl:value-of select="preceding::tei:pb[1]/@sameAs"/>
						</xsl:when>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="divPosition"
					select="count(preceding::tei:lb[ancestor::tei:div[@corresp = $comDiv]]) + 1"/>
				<xsl:variable name="pagePosition"
					select="count(preceding::tei:lb[preceding::tei:pb[@* = $comPage]]) + 1"/>
				<xsl:if test="$divPosition > 1 and $pagePosition > 1">
					<xsl:text xml:space="preserve"> </xsl:text>
					<button id="plus{$lineID}" onclick="revealComment(this.id)"
						style="font-size:12px">
						<xsl:if test="ancestor::tei:w">
							<xsl:attribute name="onmouseover">
								<xsl:text>disableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="onmouseout">
								<xsl:text>enableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
						</xsl:if>
						<b>+</b>
					</button>
					<br id="plus{$lineID}br" hidden="hidden"/>
					<table hidden="hidden">
						<xsl:if test="ancestor::tei:w">
							<xsl:attribute name="onmouseover">
								<xsl:text>disableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="onmouseout">
								<xsl:text>enableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
						</xsl:if>
					</table>
					<button id="{generate-id()}" onclick="textComment(this.id)"
						style="font-size:12px" hidden="hidden"><xsl:if test="ancestor::tei:w">
							<xsl:attribute name="onmouseover">
								<xsl:text>disableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="onmouseout">
								<xsl:text>enableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
						</xsl:if>Add Comment</button>
				</xsl:if>
				<br id="{$lineID}"/>
				<span>
					<xsl:if test="@sameAs">
						<xsl:attribute name="msRef">
							<xsl:variable name="elPOS" select="count(preceding::*)"/>
							<xsl:variable name="lID">
								<xsl:if
									test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
									<xsl:value-of
										select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
									<xsl:value-of select="preceding::tei:pb[1]/@n"/>
									<xsl:if
										test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
										<xsl:value-of select="preceding::tei:cb[1]/@n"/>
									</xsl:if>
									<xsl:value-of select="preceding::tei:lb[1]/@n"/>
								</xsl:if>
								<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
									<xsl:value-of
										select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
									<xsl:value-of
										select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
									<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
									<xsl:value-of select="ancestor::tei:l[1]/@n"/>
								</xsl:if>
							</xsl:variable>
							<xsl:value-of select="$lID"/>
						</xsl:attribute>
					</xsl:if>
					<sub>
						<xsl:if test="preceding::tei:addSpan">
							<xsl:variable name="asID" select="preceding::tei:addSpan[1]/@spanTo"/>
							<xsl:if test="following::tei:anchor[1]/@xml:id = $asID">
								<xsl:value-of select="preceding::tei:addSpan[1]/@place"/>
								<xsl:if test="preceding::tei:addSpan[1]/@n">
									<b>
										<xsl:value-of select="preceding::tei:addSpan[1]/@place"/>
									</b>
									<xsl:if test="preceding::tei:addSpan[1]/@n">
										<b>
											<xsl:text> #</xsl:text>
											<xsl:value-of select="preceding::tei:addSpan[1]/@n"/>
										</b>
									</xsl:if>
									<b>
										<xsl:text>: </xsl:text>
									</b>
								</xsl:if>
							</xsl:if>
						</xsl:if>
						<xsl:value-of select="@n"/>
						<xsl:text>. </xsl:text>
					</sub>
				</span>
			</xsl:when>
			<xsl:when
				test="ancestor::tei:lg or ancestor::tei:w[ancestor::tei:lg] or ancestor::tei:head">
				<xsl:variable name="elPOS" select="count(preceding::*)"/>
				<xsl:variable name="lID">
					<xsl:if
						test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
						<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
						<xsl:value-of select="preceding::tei:pb[1]/@n"/>
						<xsl:if
							test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
							<xsl:value-of select="preceding::tei:cb[1]/@n"/>
						</xsl:if>
						<xsl:value-of select="preceding::tei:lb[1]/@n"/>
					</xsl:if>
					<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
						<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
						<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
						<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
						<xsl:value-of select="ancestor::tei:l[1]/@n"/>
					</xsl:if>
				</xsl:variable>
				<sub id="{$lineID}" msLine="{$lID}">
					<xsl:if test="preceding::tei:addSpan">
						<xsl:variable name="asID" select="preceding::tei:addSpan[1]/@spanTo"/>
						<xsl:if test="following::tei:anchor[1]/@xml:id = $asID">
							<b>
								<xsl:value-of select="preceding::tei:addSpan[1]/@place"/>
							</b>
							<xsl:if test="preceding::tei:addSpan[1]/@n">
								<b>
									<xsl:text> #</xsl:text>
									<xsl:value-of select="preceding::tei:addSpan[1]/@n"/>
								</b>
							</xsl:if>
							<b>
								<xsl:text>: </xsl:text>
							</b>
						</xsl:if>
					</xsl:if>
					<xsl:text> </xsl:text>
					<xsl:value-of select="@n"/>
					<xsl:text>. </xsl:text>
				</sub>
			</xsl:when>
			<xsl:otherwise>
				<sub>
					<xsl:if
						test="preceding::tei:seg[@type = 'margNote' and following::tei:lb[1]/@* = $lineID]">
						<hr style="border-top: dotted 3px;"/>
						<xsl:for-each
							select="//tei:seg[@type = 'margNote' and following::tei:lb[1]/@* = $lineID]">
							<br/>
							<br/>
							<b>Marg.</b>
							<xsl:if
								test="count(preceding::tei:seg[@type = 'margNote' and following::tei:lb[1]/@* = $lineID]) > 1">
								<xsl:text> </xsl:text>
								<xsl:value-of select="position()"/>
							</xsl:if>
							<br/>
							<span style="margin-left:40px">
								<xsl:apply-templates select="child::*"/>
							</span>
							<br/>
							<table/>
							<button id="{generate-id()}" onclick="textComment(this.id)"
								style="font-size:12px">Add Comment</button>
							<br/>
							<br/>
						</xsl:for-each>
						<hr style="border-top: dotted 3px;"/>
					</xsl:if>
					<xsl:if test="preceding::tei:addSpan">
						<xsl:variable name="asID" select="preceding::tei:addSpan[1]/@spanTo"/>
						<xsl:if test="following::tei:anchor[1]/@xml:id = $asID">
							<b>
								<xsl:value-of select="preceding::tei:addSpan[1]/@place"/>
							</b>
							<xsl:if test="preceding::tei:addSpan[1]/@n">
								<b>
									<xsl:text> #</xsl:text>
									<xsl:value-of select="preceding::tei:addSpan[1]/@n"/>
								</b>
							</xsl:if>
							<b>
								<xsl:text>: </xsl:text>
							</b>
						</xsl:if>
					</xsl:if>
					<br id="{$lineID}"/>
					<xsl:value-of select="@n"/>
					<xsl:text>. </xsl:text>
				</sub>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="dipMSline">
		<xsl:variable name="comDiv" select="ancestor::tei:div[1]/@corresp"/>
		<xsl:variable name="lineID">
			<xsl:choose>
				<xsl:when test="@xml:id">
					<xsl:value-of select="@xml:id"/>
				</xsl:when>
				<xsl:when test="@sameAs">
					<xsl:value-of select="@sameAs"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<br/>
		<xsl:apply-templates
			select="//*[parent::tei:p[ancestor::tei:div[1][@corresp = $comDiv]] or parent::tei:l[ancestor::tei:div[1][@corresp = $comDiv]] and preceding::tei:lb[1]/@xml:id = $lineID and not(tei:lb)]"
			mode="dip"/>
		<xsl:apply-templates
			select="//*[parent::tei:p[ancestor::tei:div[1][@corresp = $comDiv]] or parent::tei:l[ancestor::tei:div[1][@corresp = $comDiv]] and preceding::tei:lb[1]/@sameAs = $lineID and not(tei:lb)]"
			mode="dip"/>
		<br/>
	</xsl:template>

	<xsl:template name="edMSline"/>

	<xsl:template match="tei:lg">
		<xsl:choose>
			<xsl:when test="@type = 'dúnad'">
				<p style="margin-left:30px">
					<xsl:apply-templates select="descendant::tei:l"/>
				</p>
			</xsl:when>
			<xsl:when test="@type = 'sig'">
				<p style="margin-left:30px">
					<xsl:apply-templates select="descendant::tei:l"/>
				</p>
			</xsl:when>
			<xsl:when test="@type = 'catchword'">
				<p style="margin-left:30px">
					<xsl:apply-templates select="descendant::tei:l"/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p style="margin-left:30px">
					<xsl:if test="@n">
						<b align="left">
							<xsl:value-of select="@n"/>
							<xsl:text>. </xsl:text>
						</b>
					</xsl:if>
					<xsl:text>  </xsl:text>
					<button id="{generate-id()}_cs" class="cs" onclick="createTable();beginCS(this)"
						onmouseover="disableWordFunctions(this.id)"
						onmouseout="enableWordFunctions(this.id)">Collect e-Slips</button>
					<button id="{generate-id()}_ws" class="ws" onclick="createTable();beginWS(this)"
							><xsl:if test="ancestor::tei:w">
							<xsl:attribute name="onmouseover">
								<xsl:text>disableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="onmouseout">
								<xsl:text>enableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
						</xsl:if>Headword Search</button>
					<button id="{generate-id()}_es" class="es" onclick="endSearch(this)"
						hidden="hidden" style="background-color:red">
						<xsl:if test="ancestor::tei:w">
							<xsl:attribute name="onmouseover">
								<xsl:text>disableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
							<xsl:attribute name="onmouseout">
								<xsl:text>enableWordFunctions(this.id)</xsl:text>
							</xsl:attribute>
						</xsl:if>
						<b>End Search</b>
					</button>
					<br id="word{count(ancestor::tei:w[1]/preceding::*)}_pb_br2" class="pb"
						onmouseover="disableWordFunctions(this.id)"
						onmouseout="enableWordFunctions(this.id)" style="color:#000000"/>
					<xsl:apply-templates select="descendant::tei:l"/>
					<xsl:if test="descendant::tei:seg[@type = 'margNote']">
						<hr style="border-top: dotted 3px;"/>
						<xsl:for-each select="descendant::tei:seg[@type = 'margNote']">
							<br/>
							<b>Marg.</b>
							<xsl:if
								test="count(ancestor::tei:lg[1]/descendant::tei:seg[@type = 'margNote']) > 1">
								<xsl:text> </xsl:text>
								<xsl:value-of select="position()"/>
							</xsl:if>
							<br/>
							<span style="margin-left:40px">
								<xsl:apply-templates select="child::*"/>
							</span>
							<button id="{generate-id()}" onclick="textComment(this.id)"
								style="font-size:12px">Add Comment</button>
							<br/>
							<br/>
						</xsl:for-each>
						<hr style="border-top: dotted 3px;"/>
					</xsl:if>
					<xsl:if test="@type = 'prosediv'">
						<br/>
						<br/>
					</xsl:if>
				</p>
				<table/>
				<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px"
					>Add Comment</button>
				<br/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:seg[@type = 'catchword']">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<p style="margin-right:90pc; text-align:center" msLine="{$lineID}">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:seg[@type = 'cfe']">
		<xsl:text/>
	</xsl:template>

	<xsl:template match="tei:seg[@type = 'title']">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<b msLine="{$lineID}">
			<xsl:apply-templates/>
		</b>
	</xsl:template>

	<xsl:template match="tei:seg[@type = 'gloss']">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:seg[@type = 'margNote']">
		<xsl:variable name="encLineID">
			<xsl:choose>
				<xsl:when test="preceding::tei:lb[1]/@xml:id">
					<xsl:value-of select="preceding::tei:lb[1]/@xml:id"/>
				</xsl:when>
				<xsl:when test="preceding::tei:lb[1]/@sameAs">
					<xsl:value-of select="preceding::tei:lb[1]/@sameAs"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="mnCount"
			select="count(//tei:seg[@type = 'margNote' and preceding::tei:lb[1]/@* = $encLineID])"/>
		<sub>
			<b>
				<i><xsl:text> </xsl:text>~m<xsl:if test="$mnCount > 1"
							><xsl:text>#</xsl:text><xsl:value-of select="$mnCount + 1"
					/></xsl:if>~<xsl:text> </xsl:text></i>
			</b>
		</sub>
	</xsl:template>

	<xsl:template match="tei:quote">
		<br/>
		<br/>
		<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
			Comment</button>
		<xsl:choose>
			<xsl:when test="child::tei:l">
				<br/>
				<br/>
				<xsl:for-each select="child::tei:l">
					<l style="margin-left: 40px;font-size:12px">
						<xsl:apply-templates/>
					</l>
					<br/>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<blockquote style="margin-left: 40px;font-size:12px">
					<p>
						<xsl:apply-templates/>
					</p>
				</blockquote>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:l" name="line">
		<xsl:variable name="Id" select="@xml:id"/>
		<xsl:variable name="MSlineID">
			<xsl:choose>
				<xsl:when test="descendant::tei:lb">
					<xsl:value-of select="descendant::tei:lb[1]/@xml:id | @sameAs"/>
				</xsl:when>
				<xsl:when test="not(descendant::tei:lb)">
					<xsl:value-of select="preceding::tei:lb[1]/@xml:id | @sameAs"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::tei:lg[@type = 'prosediv'] and attribute::n">
				<br id="{$MSlineID}"/>
				<xsl:value-of select="@n"/>
				<xsl:text>. </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<br id="{$MSlineID}"/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="ancestor::tei:lg[@type = 'prosediv']">
			<br/>
		</xsl:if>
		<xsl:apply-templates/>
		<xsl:text xml:space="preserve"> </xsl:text>
		<button id="plus{$Id}" onclick="revealComment(this.id)" style="font-size:12px">
			<xsl:if test="ancestor::tei:w">
				<xsl:attribute name="onmouseover">
					<xsl:text>disableWordFunctions(this.id)</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="onmouseout">
					<xsl:text>enableWordFunctions(this.id)</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<b>+</b>
		</button>
		<br id="plus{$Id}br" hidden="hidden"/>
		<table hidden="hidden">
			<xsl:if test="ancestor::tei:w">
				<xsl:attribute name="onmouseover">
					<xsl:text>disableWordFunctions(this.id)</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="onmouseout">
					<xsl:text>enableWordFunctions(this.id)</xsl:text>
				</xsl:attribute>
			</xsl:if>
		</table>
		<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px"
			hidden="hidden"><xsl:if test="ancestor::tei:w">
				<xsl:attribute name="onmouseover">
					<xsl:text>disableWordFunctions(this.id)</xsl:text>
				</xsl:attribute>
				<xsl:attribute name="onmouseout">
					<xsl:text>enableWordFunctions(this.id)</xsl:text>
				</xsl:attribute>
			</xsl:if>Add Comment</button>
		<xsl:if test="ancestor::tei:lg[@type = 'prosediv']">
			<br/>
		</xsl:if>
		<xsl:if test="//tei:note[@corresp = $Id]">
			<br/>
			<br/>
			<xsl:for-each select="key('altText', @xml:id)/tei:p">
				<style>
					.indent{
						padding-left: 40pt;
						padding-right: 40pt;
					}</style>
				<seg class="indent" style="font-size:11px">
					<xsl:apply-templates/>
					<br/>
				</seg>
				<br/>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:choice">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="child::tei:sic | tei:corr">
				<span msLine="{$lineID}">
					<xsl:text>{</xsl:text>
				</span>
				<xsl:apply-templates select="tei:corr"/>
				<xsl:choose>
					<xsl:when test="child::tei:sic[not(descendant::tei:w)]">
						<xsl:for-each select="descendant::tei:c">
							<xsl:variable name="alt" select="ancestor::tei:choice/tei:corr"/>
							<xsl:variable name="altSource"
								select="ancestor::tei:choice/tei:corr/@resp"/>
							<a id="{generate-id()}"
								title="MS: {self::*}&#10;- the intended reading cannot be identified; an amended reading ('{$alt}') has been supplied by {$altSource}."
								msLine="{$lineID}">
								<sub>
									<b>
										<i>
											<xsl:text>/alt</xsl:text>
										</i>
									</b>
								</sub>
							</a>
							<xsl:text> </xsl:text>
						</xsl:for-each>
						<xsl:text>}</xsl:text>
						<xsl:variable name="incr">
							<xsl:choose>
								<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
								<xsl:otherwise> 0 </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="following::*[1 + $incr]/self::tei:pc">
								<xsl:text/>
							</xsl:when>
							<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
								<xsl:text/>
							</xsl:when>
							<xsl:otherwise>
								<span msLine="{$lineID}">
									<xsl:text> </xsl:text>
								</span>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="tei:sic/descendant::tei:w">
								<xsl:for-each
									select="tei:sic/descendant::tei:w[not(descendant::tei:w)]">
									<xsl:call-template name="word_ed"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="tei:sic"/>
							</xsl:otherwise>
						</xsl:choose>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
						<span msLine="{$lineID}">
							<xsl:text>}</xsl:text>
						</span>
						<xsl:variable name="incr">
							<xsl:choose>
								<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
								<xsl:otherwise> 0 </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="following::*[1 + $incr]/self::tei:pc">
								<xsl:text/>
							</xsl:when>
							<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
								<xsl:text/>
							</xsl:when>
							<xsl:otherwise>
								<span msLine="{$lineID}">
									<xsl:text> </xsl:text>
								</span>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="word_ed" match="tei:w[not(descendant::tei:w)]">
		<xsl:param name="compWordID"/>
		<xsl:variable name="wordId" select="generate-id()"/>
		<xsl:variable name="wordPOS" select="count(preceding::*)"/>
		<xsl:variable name="lem">
			<xsl:choose>
				<xsl:when test="@lemma = 'UNKNOWN'">[LEMMA UNKNOWN]</xsl:when>
				<xsl:when test="not(@lemma)">
					<xsl:choose>
						<xsl:when test="ancestor::tei:name">
							<xsl:value-of select="ancestor::tei:name/@type"/>
							<xsl:text> name</xsl:text>
						</xsl:when>
						<xsl:when test="@xml:lang">Language: <xsl:value-of
								select="key('lang', @xml:lang)/text()"/></xsl:when>
						<xsl:otherwise>[no lemma entered]</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="ancestor::tei:name">
							<xsl:value-of select="@lemma"/>
							<xsl:text> (</xsl:text>
							<xsl:value-of select="ancestor::tei:name/@type"/>
							<xsl:text> name)</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@lemma"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="sicLem">
			<xsl:choose>
				<xsl:when test="ancestor::tei:sic">
					<xsl:variable name="alt">
						<xsl:for-each
							select="ancestor::tei:choice/tei:corr//tei:w[not(descendant::tei:w)]">
							<xsl:text> </xsl:text>
							<xsl:value-of select="self::*"/>
							<xsl:text> </xsl:text>
						</xsl:for-each>
					</xsl:variable>
					<xsl:text xml:space="preserve">MS: </xsl:text>
					<xsl:value-of select="self::*"/>
					<xsl:if test="@ana">
						<xsl:text>: </xsl:text>
						<xsl:value-of select="@ana"/>
					</xsl:if>
					<xsl:text>&#10;</xsl:text>
					<xsl:choose>
						<xsl:when test="not(@lemma)">
							<xsl:text>- this form cannot be interpreted</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>- this form is corrupt/unclear/implausible</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:text>; an amended reading ('</xsl:text>
					<xsl:value-of select="$alt"/>
					<xsl:text>') has been supplied by </xsl:text>
					<xsl:value-of select="ancestor::tei:choice/tei:corr/@resp"/>
					<xsl:text>&#10;</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="lemRef" select="@lemmaRef"/>
		<xsl:variable name="an" select="@ana"/>
		<xsl:variable name="prob">
			<xsl:if test="descendant::*[@reason] or ancestor::*[@reason]">
				<xsl:for-each select="descendant::*[@reason] | ancestor::*[@reason]">
					<xsl:choose>
						<xsl:when test="@reason = 'interp_obscure'">
							<xsl:choose>
								<xsl:when test="ancestor::tei:w and not(descendant::tei:w)">
									<xsl:text xml:space="preserve">- some characters within this word remain unexplained.&#10;</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text xml:space="preserve">- the interpretation of this word, or its context, is doubtful</xsl:text>
									<xsl:if
										test="descendant::tei:unclear[@cert = 'medium' or 'low' or 'unknown']//tei:w[not(count(preceding::*) = $wordPOS)] or descendant::tei:w[@lemma = 'UNKNOWN' and not(count(preceding::*) = $wordPOS)] or descendant::tei:w[descendant::tei:abbr[not(@cert = 'high')] and not(count(preceding::*) = $wordPOS)]">
										<xsl:text>; there is a particular issue with</xsl:text>
										<xsl:if
											test="descendant::tei:unclear[@cert = 'medium' or 'low' or 'unknown']//tei:w[count(preceding::*) = $wordPOS] or descendant::tei:w[@lemma = 'UNKNOWN' and count(preceding::*) = $wordPOS] or self::*/descendant::tei:w[descendant::tei:abbr[not(@cert = 'high')] and count(preceding::*) = $wordPOS]">
											<xsl:text xml:space="preserve"> this word and</xsl:text>
										</xsl:if>
										<xsl:for-each
											select="descendant::tei:unclear//tei:w[not(ancestor::tei:w) and not(count(preceding::*) = $wordPOS)] | descendant::tei:w[@lemma = 'UNKNOWN' and not(count(preceding::*) = $wordPOS)] | descendant::tei:w[descendant::tei:abbr[not(@cert = 'high')] and not(count(preceding::*) = $wordPOS)]">
											<xsl:text> "</xsl:text>
											<xsl:value-of select="self::*"/>
											<xsl:text>" </xsl:text>
										</xsl:for-each>
									</xsl:if>
									<xsl:text>&#10;</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="@reason = 'char'">
							<xsl:text xml:space="preserve">- a key character in this word ("</xsl:text>
							<xsl:value-of select="text()"/>
							<xsl:text xml:space="preserve">") is ambiguous.&#10;</xsl:text>
						</xsl:when>
						<xsl:when test="@reason = 'text_obscure'">
							<xsl:choose>
								<xsl:when
									test="@reason = 'text_obscure' and descendant::tei:w[not(descendant::tei:w)]">
									<xsl:text xml:space="preserve">- this word is difficult to decipher &#10;</xsl:text>
								</xsl:when>
								<xsl:when
									test="@reason = 'text_obscure' and ancestor::tei:w[not(descendant::tei:w)]">
									<xsl:text xml:space="preserve">- parts of this word are difficult to decipher &#10;</xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="@reason = 'other_mark'">
							<xsl:text xml:space="preserve">- there are additional pen-strokes that cannot be accounted for and may be significant &#10;</xsl:text>
						</xsl:when>
						<xsl:when test="@reason = 'abbrv'">
							<xsl:text xml:space="preserve">- this reading involves one or more abbreviations </xsl:text>
							<xsl:if test="descendant::tei:abbr[not(@cert = 'high')]">
								<xsl:text>("</xsl:text>
								<xsl:for-each select="descendant::tei:abbr[not(@cert = 'high')]">
									<xsl:text> </xsl:text>
									<xsl:value-of select="self::*"/>
									<xsl:text> </xsl:text>
								</xsl:for-each>
								<xsl:text>") </xsl:text>
							</xsl:if>
							<xsl:text xml:space="preserve">that cannot be expanded with certainty &#10;</xsl:text>
						</xsl:when>
						<xsl:when test="@reason = 'damage'">
							<xsl:text xml:space="preserve">- loss of vellum; some characters are lost and may have been supplied by an editor</xsl:text>
							<xsl:if
								test="descendant::*[@reason = 'damage']/@resp or ancestor::*[@reason = 'damage']/@resp">
								<xsl:text>(</xsl:text>
								<xsl:choose>
									<xsl:when test="ancestor::*[@reason = 'damage']/@resp">
										<xsl:value-of select="ancestor::*[@reason = 'damage']/@resp"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="descendant::*[@reason = 'damage']/@resp"/>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:text>)</xsl:text>
							</xsl:if>
							<xsl:text>&#10;</xsl:text>
						</xsl:when>
						<xsl:when test="@reason = 'met'">
							<xsl:text xml:space="preserve">- this word is part of a metrically irregular line&#10;</xsl:text>
						</xsl:when>
						<xsl:when test="@reason = 'fold'">
							<xsl:text xml:space="preserve">- the page edge is folded in the digital image; more text may be discernible by examining the manuscript in person &#10;</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
			<xsl:if
				test="descendant::tei:abbr[not(@cert = 'high')] and not(ancestor::tei:unclear[@reason = 'abbrv'])">
				<xsl:text xml:space="preserve">- this reading involves one or more abbreviations </xsl:text>
				<xsl:text>("</xsl:text>
				<xsl:for-each select="descendant::tei:abbr[not(@cert = 'high')]">
					<xsl:text> </xsl:text>
					<xsl:value-of select="self::*"/>
					<xsl:text> </xsl:text>
				</xsl:for-each>
				<xsl:text>") </xsl:text>
				<xsl:text xml:space="preserve">that cannot be expanded with certainty &#10;</xsl:text>
			</xsl:if>
			<xsl:if test="ancestor::tei:corr">
				<xsl:variable name="alt" select="ancestor::tei:choice/tei:sic"/>
				<xsl:text xml:space="preserve">- this is </xsl:text>
				<xsl:choose>
					<xsl:when
						test="count(ancestor::tei:choice/tei:sic/descendant::tei:w[not(descendant::tei:w)]) &lt; count(ancestor::tei:choice/tei:corr/descendant::tei:w[not(descendant::tei:w)])">
						<xsl:text>part of an</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>an</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> editorial emendation (from </xsl:text>
				<xsl:value-of select="ancestor::tei:corr/@resp"/>
				<xsl:text>) of the manuscript reading ("</xsl:text>
				<xsl:value-of select="$alt"/>
				<xsl:text>")&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="ancestor::tei:choice[descendant::tei:unclear]">
				<xsl:variable name="selfID" select="@n"/>
				<xsl:variable name="choiceID" select="ancestor::tei:unclear[parent::tei:choice]/@n"/>
				<xsl:variable name="altChoice"
					select="ancestor::tei:choice/tei:unclear[not(@n = $choiceID)]//tei:w[@n = $selfID]"/>
				<xsl:text xml:space="preserve">- there is a possible alternative to this reading ("</xsl:text>
				<xsl:value-of select="$altChoice"/>
				<xsl:text>"), </xsl:text>
				<xsl:value-of select="$altChoice/@ana"/>
				<xsl:text>&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="ancestor::tei:supplied">
				<xsl:text xml:space="preserve">- this word has been supplied by an editor (</xsl:text>
				<xsl:value-of select="ancestor::tei:supplied/@resp"/>
				<xsl:text>) &#10;</xsl:text>
			</xsl:if>
			<xsl:if test="descendant::tei:supplied">
				<xsl:text xml:space="preserve">- some characters have been supplied by an editor (</xsl:text>
				<xsl:value-of select="descendant::tei:supplied/@resp"/>
				<xsl:text>)&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="@xml:lang">
				<xsl:text xml:space="preserve">- this word is in a language other than Gaelic &#10;</xsl:text>
			</xsl:if>
			<xsl:if test="ancestor::tei:del">
				<xsl:text xml:space="preserve">- this word has been deleted by </xsl:text>
				<xsl:value-of select="key('hands', ancestor::tei:del/@resp)/tei:forename"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="key('hands', ancestor::tei:del/@resp)/tei:surname"/>
				<xsl:text> (</xsl:text>
				<xsl:value-of select="key('hands', ancestor::tei:del/@resp)/@xml:id"/>
				<xsl:text>)&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="descendant::tei:del">
				<xsl:for-each select="descendant::tei:del">
					<xsl:text xml:space="preserve">- characters have been deleted by </xsl:text>
					<xsl:value-of select="key('hands', @resp)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="key('hands', @resp)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="key('hands', @resp)/@xml:id"/>
					<xsl:text>)&#10;</xsl:text>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="ancestor::tei:add[@type = 'insertion']">
				<xsl:text xml:space="preserve">- this word has been added by </xsl:text>
				<xsl:value-of
					select="key('hands', ancestor::tei:add[@type = 'insertion']/@resp)/tei:forename"/>
				<xsl:text> </xsl:text>
				<xsl:value-of
					select="key('hands', ancestor::tei:add[@type = 'insertion']/@resp)/tei:surname"/>
				<xsl:text> (</xsl:text>
				<xsl:value-of
					select="key('hands', ancestor::tei:add[@type = 'insertion']/@resp)/@xml:id"/>
				<xsl:text>)&#10;</xsl:text>
			</xsl:if>
			<xsl:if test="descendant::tei:add[@type = 'insertion']">
				<xsl:for-each select="descendant::tei:add[@type = 'insertion']">
					<xsl:text xml:space="preserve">- characters have been added by </xsl:text>
					<xsl:value-of select="key('hands', @resp)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="key('hands', @resp)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="key('hands', @resp)/@xml:id"/>
					<xsl:text>)&#10;</xsl:text>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="@source">
				<xsl:text xml:space="preserve">- this word cannot be identified with an existing dictionary headword, but it may be related to "</xsl:text>
				<xsl:value-of select="@source"/>
				<xsl:text xml:space="preserve">".&#10;</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="certProb">
			<xsl:if test="ancestor::*[@cert] or descendant::*[@cert]">
				<xsl:choose>
					<xsl:when test="ancestor::*[@cert = 'low'] or descendant::*[@cert = 'low']">
						<xsl:text>Serious problems with this reading
					</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when
								test="ancestor::*[@cert = 'medium'] or descendant::*[@cert = 'medium']">
								<xsl:text>Moderate problems with this reading
						</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:choose>
									<xsl:when
										test="ancestor::*[@cert = 'unknown'] or descendant::*[@cert = 'unknown']">
										<xsl:text>Possible problems with this reading
							</xsl:text>
									</xsl:when>
									<xsl:otherwise/>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>&#10;</xsl:if>
		</xsl:variable>
		<xsl:variable name="abbrs">
			<xsl:choose>
				<xsl:when test="descendant::tei:abbr or ancestor::tei:abbr">
					<xsl:for-each select="descendant::tei:abbr/tei:g | ancestor::tei:abbr/tei:g">
						<xsl:value-of select="key('abbrs', @ref)/tei:glyphName"/>
						<xsl:text>; </xsl:text>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>none</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="abbrRef">
			<xsl:for-each select="descendant::tei:abbr//tei:g | ancestor::tei:abbr//tei:g">
				<xsl:if test="key('abbrs', @ref)/@corresp">
					<xsl:value-of select="key('abbrs', @ref)/@corresp"/>
				</xsl:if>
				<xsl:if test="key('abbrs', @ref)[not(@corresp)]">
					<xsl:value-of select="key('abbrs', @ref)/tei:glyphName"/>
				</xsl:if>
				<xsl:choose>
					<xsl:when
						test="following::tei:g/ancestor::tei:w[count(preceding::*) = $wordPOS]">
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="certLvl">
			<xsl:choose>
				<xsl:when test="ancestor::*[@cert] or descendant::*[@cert]">
					<xsl:choose>
						<xsl:when
							test="ancestor-or-self::tei:unclear[@cert = 'high'] or descendant-or-self::tei:unclear[@cert = 'high']">
							<xsl:text xml:space="preserve"> slight;</xsl:text>
						</xsl:when>
						<xsl:when
							test="ancestor-or-self::*[@cert = 'medium'] or descendant-or-self::*[@cert = 'medium']">
							<xsl:text xml:space="preserve"> moderate;</xsl:text>
						</xsl:when>
						<xsl:when
							test="ancestor-or-self::*[@cert = 'low'] or descendant-or-self::*[@cert = 'low']">
							<xsl:text xml:space="preserve"> severe;</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="ancestor::tei:choice">
					<xsl:choose>
						<xsl:when test="ancestor::tei:sic">
							<xsl:text xml:space="preserve"> sic;</xsl:text>
						</xsl:when>
						<xsl:when test="ancestor::tei:corr">
							<xsl:text xml:space="preserve"> leg.;</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="ancestor-or-self::tei:supplied">
					<xsl:text xml:space="preserve"> supp. word;</xsl:text>
				</xsl:when>
				<xsl:when test="descendant-or-self::tei:supplied">
					<xsl:text xml:space="preserve"> supp. char(s);</xsl:text>
				</xsl:when>
			</xsl:choose>
			<xsl:if test="@source">
				<xsl:text xml:space="preserve"> new vocab.</xsl:text>
			</xsl:if>
			<xsl:if test="@lemma = 'UNKNOWN'">
				<xsl:text xml:space="preserve"> headword unknown;</xsl:text>
			</xsl:if>
			<xsl:if test="ancestor::tei:add">
				<xsl:text xml:space="preserve"> added;</xsl:text>
			</xsl:if>
			<xsl:if test="ancestor::tei:del">
				<xsl:text xml:space="preserve"> del.;</xsl:text>
			</xsl:if>
			<xsl:if test="descendant::tei:add">
				<xsl:text xml:space="preserve">char(s) added;</xsl:text>
			</xsl:if>
			<xsl:if test="descendant::tei:del">
				<xsl:text xml:space="preserve">char(s) del.;</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="handRef">
			<xsl:choose>
				<xsl:when test="ancestor::tei:add">
					<xsl:value-of select="ancestor::tei:add/@resp"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="ancestor::tei:div[@resp]//tei:handShift">
							<xsl:variable name="comDiv" select="ancestor::tei:div[1]/@corresp"/>
							<xsl:choose>
								<xsl:when
									test="preceding::tei:handShift[1]/ancestor::tei:div[1]/@corresp = $comDiv">
									<xsl:value-of select="preceding::tei:handShift[1]/@new"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="ancestor::tei:div[1]/@resp"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="ancestor::tei:div[1]/@resp"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="hand">
			<xsl:choose>
				<xsl:when test="descendant::tei:handShift">
					<xsl:value-of select="key('hands', $handRef)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="key('hands', $handRef)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="substring($handRef, 5)"/>
					<xsl:text>); </xsl:text>
					<xsl:for-each select="descendant::tei:handShift">
						<xsl:value-of select="key('hands', @new)/tei:forename"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="key('hands', @new)/tei:surname"/>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="substring(@new, 5)"/>
						<xsl:text>); </xsl:text>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="key('hands', $handRef)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="key('hands', $handRef)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="substring($handRef, 5)"/>
					<xsl:text>) </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="handDate">
			<xsl:value-of select="key('hands', $handRef)/tei:date"/>
		</xsl:variable>
		<xsl:variable name="shelfmark">
			<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
		</xsl:variable>
		<xsl:variable name="msref">
			<xsl:variable name="pbpos">
				<xsl:value-of select="count(preceding::tei:pb[1]/preceding::*)"/>
			</xsl:variable>
			<xsl:variable name="cbpos">
				<xsl:value-of select="count(preceding::tei:cb[1]/preceding::*)"/>
			</xsl:variable>
			<xsl:choose>
				<xsl:when test="ancestor::tei:div//tei:cb and not($pbpos > $cbpos)">
					<xsl:value-of
						select="concat($shelfmark, ' ', preceding::tei:pb[1]/@n, '', preceding::tei:cb[1]/@n, '', preceding::tei:lb[1]/@n)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of
						select="concat($shelfmark, ' ', preceding::tei:pb[1]/@n, ' ', preceding::tei:lb[1]/@n)"
					/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="medium">
			<xsl:choose>
				<xsl:when test="ancestor::tei:div/@type = 'verse'">Verse</xsl:when>
				<xsl:when
					test="ancestor::tei:div/@type = 'prose' or ancestor::tei:div/@type = 'divprose'"
					>Prose</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="pos">
			<xsl:value-of select="@ana"/>
		</xsl:variable>
		<xsl:variable name="src">
			<xsl:choose>
				<xsl:when test="@source">
					<xsl:text>(from </xsl:text>
					<xsl:value-of select="@source"/>
					<xsl:text>)</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="gloss">
			<xsl:choose>
				<xsl:when
					test="ancestor::tei:seg[@type = 'gloss'] and not(ancestor::tei:add[@type = 'gloss'])">
					<xsl:text>A gloss has been added by </xsl:text>
					<xsl:value-of
						select="key('hands', ancestor::tei:seg[@type = 'gloss']/tei:add[@type = 'gloss']/@resp)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of
						select="key('hands', ancestor::tei:seg[@type = 'gloss']/tei:add[@type = 'gloss']/@resp)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of
						select="ancestor::tei:seg[@type = 'gloss']/tei:add[@type = 'gloss']/@resp"/>
					<xsl:text>): "</xsl:text>
					<xsl:apply-templates mode="dip"
						select="ancestor::tei:seg[@type = 'gloss']/tei:add[@type = 'gloss']/child::*"/>
					<xsl:text>"</xsl:text>
				</xsl:when>
				<xsl:when test="ancestor::tei:add[@type = 'gloss']">
					<xsl:text>This has been added as a gloss </xsl:text>
					<xsl:if test="ancestor::tei:seg[@type = 'gloss']">
						<xsl:text>on "</xsl:text>
						<xsl:apply-templates mode="dip"
							select="ancestor::tei:seg[@type = 'gloss']/child::*[not(ancestor-or-self::tei:add[@type = 'gloss'])]"/>
						<xsl:text>" </xsl:text>
					</xsl:if>
					<xsl:text>by </xsl:text>
					<xsl:value-of
						select="key('hands', ancestor::tei:add[@type = 'gloss']/@resp)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of
						select="key('hands', ancestor::tei:add[@type = 'gloss']/@resp)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="ancestor::tei:add[@type = 'gloss']/@resp"/>
					<xsl:text>).</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="choicePOS">
			<xsl:if test="ancestor::tei:choice">
				<xsl:value-of select="count(ancestor::tei:choice/preceding::tei:choice)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="DWlem">
			<xsl:value-of select="key('hwData', @lemmaRef)/tei:w/@lemmaDW"/>
		</xsl:variable>
		<xsl:variable name="DWref">
			<xsl:value-of select="key('hwData', @lemmaRef)/tei:w/@lemmaRefDW"/>
		</xsl:variable>
		<xsl:variable name="EDlem">
			<xsl:choose>
				<xsl:when test="contains(@lemmaRef, 'dil.ie')">
					<xsl:value-of select="@lemma"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@lemmaED"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="EDref">
			<xsl:choose>
				<xsl:when test="contains(@lemmaRef, 'dil.ie')">
					<xsl:value-of select="@lemmaRef"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@lemmaRefED"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="lineRef">
			<xsl:choose>
				<xsl:when test="preceding::tei:lb[1]/@sameAs">
					<xsl:value-of select="preceding::tei:lb[1]/@sameAs"/>
				</xsl:when>
				<xsl:when test="preceding::tei:lb[1]/@xml:id">
					<xsl:value-of select="preceding::tei:lb[1]/@xml:id"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $wordPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<a id="{$wordId}" pos="{$wordPOS}" onclick="addSlip(this.id)" onmouseover="hilite(this.id)"
			onmouseout="dhilite(this.id)" lemma="{$lem}" lemmaRef="{$lemRef}" lemmaED="{$EDlem}"
			lemmaRefED="{$EDref}" lemmaDW="{$DWlem}" lemmaRefDW="{$DWref}" lemmaSL="{@lemmaSL}"
			slipID="{@slipID}" ana="{@ana}" hand="{$hand}" ref="{$msref}" date="{$handDate}"
			medium="{$medium}" cert="{$certLvl}" abbrRefs="{$abbrRef}" lineID="{$lineRef}"
			title="{$lem}: {$pos} {$src}&#10;{$hand}&#10;{$prob}{$certProb}&#10;Abbreviations: {$abbrs}&#10;{$gloss}&#10;{@comment}"
			style="text-decoration:none; color:#000000" class="ed">
			<xsl:if test="not(ancestor::tei:del)">
				<xsl:attribute name="msLine">
					<xsl:value-of select="$lineID"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="not($compWordID = '')">
				<xsl:attribute name="data-compoundWord">
					<xsl:value-of select="$compWordID"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::tei:sic">
				<xsl:attribute name="title"><xsl:value-of select="$sicLem"/><xsl:value-of
						select="$prob"/><xsl:value-of select="$certProb"/><xsl:value-of
						select="$hand"/>&#10;<xsl:text>Abbreviations: </xsl:text><xsl:value-of
						select="$abbrs"/>&#10;<xsl:value-of select="$gloss"/>&#10;<xsl:value-of
						select="@comment"/></xsl:attribute>
				<xsl:attribute name="choicePOS">
					<xsl:text>sic</xsl:text>
					<xsl:value-of select="$choicePOS"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="ancestor::tei:corr">
				<xsl:attribute name="choicePOS">
					<xsl:text>corr</xsl:text>
					<xsl:value-of select="$choicePOS"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when
					test="ancestor::*[@cert = 'low'] or descendant::*[@cert = 'low'] or @lemma = 'UNKNOWN'">
					<xsl:attribute name="style">text-decoration:none; color:#ff0000</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when
							test="ancestor::*[@cert = 'medium'] or descendant::*[@cert = 'medium']">
							<xsl:attribute name="style">text-decoration:none;
								color:#ff9900</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when
									test="ancestor::tei:unclear[@cert = 'high'] or descendant::tei:unclear[@cert = 'high']">
									<xsl:attribute name="style">text-decoration:none;
										color:#cccc00</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="style">text-decoration:none;
										color:#000000</xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="ancestor::tei:sic">
					<sub>
						<b>
							<i>/alt</i>
						</b>
					</sub>
					<seg hidden="hidden" id="sic{$wordId}">
						<xsl:apply-templates/>
					</seg>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="child::tei:pb">
							<xsl:variable name="pageID" select="descendant::tei:pb/@xml:id"/>
							<xsl:apply-templates
								select="child::*[following::tei:pb/@xml:id = $pageID]"/>
							<xsl:apply-templates select="descendant::tei:pb"/>
							<xsl:apply-templates
								select="child::*[preceding::tei:pb/@xml:id = $pageID]"/>
						</xsl:when>
						<xsl:when test="child::tei:cb">
							<xsl:variable name="colID" select="descendant::tei:cb/@xml:id"/>
							<xsl:apply-templates
								select="child::*[following::tei:cb/@xml:id = $colID]"/>
							<xsl:apply-templates select="descendant::tei:cb"/>
							<xsl:apply-templates
								select="child::*[preceding::tei:cb/@xml:id = $colID]"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</a>
		<xsl:choose>
			<xsl:when test="not(ancestor::tei:w)">
				<xsl:choose>
					<xsl:when
						test="ancestor::tei:unclear[count(descendant::tei:w[not(descendant::tei:w)]) = 1]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="ancestor::tei:supplied[count(descendant::tei:w[not(descendant::tei:w)]) = 1]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="ancestor::tei:add[count(descendant::tei:w[not(descendant::tei:w)]) = 1]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="ancestor::tei:unclear and count(following-sibling::tei:w) = 0">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="ancestor::tei:supplied and count(ancestor-or-self::*[parent::tei:supplied]/following-sibling::*/descendant-or-self::tei:w) = 0">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="ancestor::tei:add and count(following-sibling::tei:w) = 0">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="incr">
							<xsl:choose>
								<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
								<xsl:otherwise> 0 </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="following::*[1 + $incr]/self::tei:pc">
								<xsl:text/>
							</xsl:when>
							<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
								<xsl:text/>
							</xsl:when>
							<xsl:otherwise>
								<span msLine="{$lineID}">
									<xsl:text> </xsl:text>
								</span>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@ana = 'part' and ancestor::tei:w[contains(@ana, 'part, verb')]">
						<xsl:choose>
							<xsl:when
								test="ancestor::tei:w[contains(@lemmaRef, 'http://www.dil.ie/29104')]">
								<xsl:text/>
							</xsl:when>
							<xsl:otherwise>
								<span msLine="{$lineID}">
									<xsl:text> </xsl:text>
								</span>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when
						test="@ana = 'part' and ancestor::tei:w[contains(@ana, 'part, pron, verb')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'part, pron, verb')]">
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:when>
					<xsl:when test="@ana = 'part' and ancestor::tei:w[contains(@ana, 'part, noun')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'pron' and ancestor::tei:w[@ana = 'pron, verb']">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, pron')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, emph')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, emph')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'verb' and ancestor::tei:w[contains(@ana, 'verb, emph')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, adj')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="@ana = 'prep' and ancestor::tei:w[contains(@ana, 'prep, dpron')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, dpron')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, pron')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'prep' and ancestor::tei:w[contains(@ana, 'prep, verb')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, dpron')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, ptcp')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, ptcp')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, pron')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, dpron')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'conj' and ancestor::tei:w[contains(@ana, 'noun, verb')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'verb' and ancestor::tei:w[contains(@ana, 'verb, pron')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, noun')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="@ana = 'vnoun' and ancestor::tei:w[contains(@ana, 'vnoun, vnoun')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, noun')] and following-sibling::tei:w[@ana = 'noun']">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, adj')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'num' and ancestor::tei:w[contains(@ana, 'num, noun')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'num' and ancestor::tei:w[contains(@ana, 'num, adj')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'num' and ancestor::tei:w[contains(@ana, 'num, vnoun')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="@ana = 'vnoun' and ancestor::tei:w[contains(@ana, 'vnoun, noun')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, vnoun')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'pref' and ancestor::tei:w[contains(@ana, 'pref, adj')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'pref' and ancestor::tei:w[contains(@ana, 'pref, ptcp')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, prep')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'pref' and ancestor::tei:w[contains(@ana, 'pref, noun')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, part')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'adv' and ancestor::tei:w[contains(@ana, 'adv, part')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'part' and ancestor::tei:w[contains(@ana, 'part, part')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'conj' and ancestor::tei:w[contains(@ana, 'conj, pron')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="@ana = 'conj' and ancestor::tei:w[contains(@ana, 'conj, verb')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="@ana = 'interrog' and ancestor::tei:w[contains(@ana, 'interrog, prep')]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="ancestor::tei:w and following::tei:pc[1]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="self::tei:pc and ancestor::tei:w and following::tei:w">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="@lemmaRef = 'http://www.dil.ie/33147' and following::tei:w[1]/@ana = 'pron'">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="not(following-sibling::*)">
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:when>
					<xsl:when
						test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, pron')] and following-sibling::tei:w[@ana = 'pron']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:w[descendant::tei:w]">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<xsl:apply-templates>
			<xsl:with-param name="compWordID">
				<xsl:value-of select="generate-id()"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:variable name="incr">
			<xsl:choose>
				<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
				<xsl:otherwise> 0 </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="following::*[1 + $incr]/self::tei:pc">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
				<xsl:text/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when
						test="ancestor::tei:unclear[count(descendant::tei:w[not(descendant::tei:w)]) = 1]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="ancestor::tei:supplied[count(descendant::tei:w[not(descendant::tei:w)]) = 1]">
						<xsl:text/>
					</xsl:when>
					<xsl:when
						test="ancestor::tei:add[count(descendant::tei:w[not(descendant::tei:w)]) = 1]">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="ancestor::tei:unclear and count(following-sibling::tei:w) = 0">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="ancestor::tei:supplied and count(following-sibling::tei:w) = 0">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="ancestor::tei:add and count(following-sibling::tei:w) = 0">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:name">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:date">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<a id="{generate-id()}" href="#" onclick="return false;"
			style="text-decoration:none; color:#000000">
			<xsl:if test="not(ancestor::tei:del)">
				<xsl:attribute name="msLine">
					<xsl:value-of select="$lineID"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</a>
		<xsl:variable name="incr">
			<xsl:choose>
				<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
				<xsl:otherwise> 0 </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="following::*[1 + $incr]/self::tei:pc">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
				<xsl:text/>
			</xsl:when>
			<xsl:otherwise>
				<span msLine="{$lineID}">
					<xsl:text> </xsl:text>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:num">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<a id="{generate-id()}" href="#" onclick="return false;"
			style="text-decoration:none; color:#000000">
			<xsl:if test="not(ancestor::tei:del)">
				<xsl:attribute name="msLine">
					<xsl:value-of select="$lineID"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</a>
		<xsl:variable name="incr">
			<xsl:choose>
				<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
				<xsl:otherwise> 0 </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="following::*[1 + $incr]/self::tei:pc">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
				<xsl:text/>
			</xsl:when>
			<xsl:otherwise>
				<span msLine="{$lineID}">
					<xsl:text> </xsl:text>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:ref">
		<xsl:variable name="newID">
			<xsl:value-of select="generate-id()"/>
			<xsl:value-of select="count(preceding::*)"/>
		</xsl:variable>
		<xsl:variable name="refPOS" select="count(preceding::*)"/>
		<xsl:variable name="refID" select="@target"/>
		<u>
			<a id="ref{$refPOS}" onclick="refDetails(this.id)" exp="0">
				<xsl:apply-templates/>
			</a>
		</u>
		<xsl:if test="@type = 'bib'">
			<seg id="ref{$refPOS}_exp" style="background-color:silver" hidden="hidden">
				<xsl:text> [</xsl:text>
				<b>
					<xsl:call-template name="litBib"/>
				</b>
				<xsl:text>] </xsl:text>
			</seg>
		</xsl:if>
		<xsl:if test="@type = 'ms'">
			<seg id="ref{$refPOS}_exp" style="background-color:silver" hidden="hidden">
				<xsl:text> [</xsl:text>
				<b>
					<xsl:call-template name="mssBib"/>
				</b>
				<xsl:text>] </xsl:text>
			</seg>
		</xsl:if>
		<xsl:if test="@type = 'text_ed_line'">
			<xsl:variable name="comDiv"
				select="//tei:l[@xml:id = $refID]/ancestor::tei:div[1]/@corresp"/>
			<seg id="ref{$refPOS}_exp" style="background-color:white" hidden="hidden">
				<br/>
				<br/>
				<xsl:for-each
					select="//tei:l[@xml:id = $refID]/descendant::tei:w[not(descendant::tei:w)]">
					<xsl:choose>
						<xsl:when test="ancestor::tei:sic">
							<xsl:text/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="ancestor::*[@cert] or descendant::*[@cert]">
									<xsl:choose>
										<xsl:when
											test="ancestor::*[@cert = 'low'] or descendant::*[@cert = 'low']">
											<a style="text-decoration:none; color:#ff0000">
												<xsl:apply-templates
												select="text() | self::*//*/text()"/>
											</a>
											<xsl:text> </xsl:text>
										</xsl:when>
										<xsl:when
											test="ancestor::*[@cert = 'medium'] or descendant::*[@cert = 'low']">
											<a style="text-decoration:none; color:#ff9900">
												<xsl:apply-templates
												select="text() | self::*//*/text()"/>
											</a>
											<xsl:text> </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates select="text() | self::*//*/text()"/>
											<xsl:text> </xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="ancestor::tei:supplied">
											<xsl:text>[</xsl:text>
											<xsl:apply-templates select="text() | self::*//*/text()"/>
											<xsl:text>] </xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="ancestor::tei:add">
												<xsl:text>+</xsl:text>
												<xsl:apply-templates
												select="text() | self::*//*/text()"/>
												<xsl:text>+ </xsl:text>
												</xsl:when>
												<xsl:otherwise>
												<xsl:apply-templates
												select="text() | self::*//*/text()"/>
												<xsl:text> </xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<br/>
				<br/>
				<!-- <a href="#{@target}">Go to text</a> -->
			</seg>
		</xsl:if>
		<xsl:if test="@type = 'text_dip_line'">
			<xsl:variable name="comDiv"
				select="//tei:lb[@xml:id = $refID or @sameAs = $refID]/ancestor::tei:div[1]/@corresp"/>
			<seg id="ref{$refPOS}_exp" style="background-color:white" hidden="hidden">
				<br/>
				<br/>
				<xsl:for-each
					select="//tei:w[not(descendant::tei:w) and preceding::tei:lb[1][@xml:id = $refID or @sameAs = $refID] and ancestor::tei:div[1][@corresp = $comDiv]]">
					<xsl:choose>
						<xsl:when test="ancestor::tei:corr">
							<xsl:text/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="ancestor::*[@cert] or descendant::*[@cert]">
									<xsl:choose>
										<xsl:when
											test="ancestor::*[@cert = 'low'] or descendant::*[@cert = 'low']">
											<a style="text-decoration:none; color:#ff0000">
												<xsl:apply-templates
												select="text() | self::*//*[not(name(self::*) = 'supplied')]/text()"
												/>
											</a>
											<xsl:if
												test="count(following::tei:space[1][@type = 'scribal']/preceding::*) &lt; count(following::tei:w[1]/preceding::*)">
												<xsl:text> </xsl:text>
											</xsl:if>
										</xsl:when>
										<xsl:when
											test="ancestor::*[@cert = 'medium'] or descendant::*[@cert = 'medium']">
											<a style="text-decoration:none; color:#ff9900">
												<xsl:apply-templates
												select="text() | self::*//*[not(name(self::*) = 'supplied')]/text()"
												/>
											</a>
											<xsl:if
												test="count(following::tei:space[1][@type = 'scribal']/preceding::*) &lt; count(following::tei:w[1]/preceding::*)">
												<xsl:text> </xsl:text>
											</xsl:if>
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates
												select="text() | self::*//*[not(name(self::*) = 'supplied')]/text()"/>
											<xsl:if
												test="count(following::tei:space[1][@type = 'scribal']/preceding::*) &lt; count(following::tei:w[1]/preceding::*)">
												<xsl:text> </xsl:text>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="ancestor::tei:supplied">
											<xsl:text/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:choose>
												<xsl:when test="ancestor::tei:add">
												<xsl:text>+</xsl:text>
												<xsl:apply-templates
												select="text() | self::*//*[not(name(self::*) = 'supplied')]/text()"/>
												<xsl:text>+</xsl:text>
												<xsl:if
												test="count(following::tei:space[1][@type = 'scribal']/preceding::*) &lt; count(following::tei:w[1]/preceding::*)">
												<xsl:text> </xsl:text>
												</xsl:if>
												</xsl:when>
												<xsl:otherwise>
												<xsl:apply-templates
												select="text() | self::*//*[not(name(self::*) = 'supplied')]/text()"/>
												<xsl:if
												test="count(following::tei:space[1][@type = 'scribal']/preceding::*) &lt; count(following::tei:w[1]/preceding::*)">
												<xsl:text> </xsl:text>
												</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<br/>
				<br/>
				<!-- <br/> -->
				<!-- <a href="#{@target}_dip">Go to text</a> -->
				<!-- <br/> -->
			</seg>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:c">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="handRef">
			<xsl:choose>
				<xsl:when test="ancestor::tei:add">
					<xsl:value-of select="ancestor::tei:add[@type = 'gloss']/@resp"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="ancestor::tei:div[@resp]//tei:handShift">
							<xsl:variable name="comDiv" select="ancestor::tei:div[1]/@corresp"/>
							<xsl:choose>
								<xsl:when
									test="preceding::tei:handShift[1]/ancestor::tei:div[1]/@corresp = $comDiv">
									<xsl:value-of select="preceding::tei:handShift[1]/@new"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="ancestor::tei:div[@resp]/@resp"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="ancestor::tei:div[1]/@resp"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="hand">
			<xsl:choose>
				<xsl:when test="descendant::tei:handShift">
					<xsl:value-of select="key('hands', $handRef)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="key('hands', $handRef)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="$handRef"/>
					<xsl:text>); </xsl:text>
					<xsl:for-each select="descendant::tei:handShift">
						<xsl:value-of select="key('hands', @new)/tei:forename"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="key('hands', @new)/tei:surname"/>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@new"/>
						<xsl:text>); </xsl:text>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="key('hands', $handRef)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="key('hands', $handRef)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="$handRef"/>
					<xsl:text>) </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="prob">
			<xsl:if test="ancestor::tei:del">
				<xsl:text xml:space="preserve">&#10;- characters deleted by </xsl:text>
				<xsl:value-of select="key('hands', ancestor::tei:del/@resp)/tei:forename"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="key('hands', ancestor::tei:del/@resp)/tei:surname"/>
				<xsl:text> (</xsl:text>
				<xsl:value-of select="key('hands', ancestor::tei:del/@resp)/@xml:id"/>
				<xsl:text>)&#10;</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="sicMessage">
			<xsl:choose>
				<xsl:when test="ancestor::tei:sic">
					<xsl:text>: an amended reading ("</xsl:text>
					<xsl:value-of select="ancestor::tei:choice/tei:corr"/>
					<xsl:text>") has been supplied.</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::tei:w">
				<xsl:apply-templates/>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<a id="{generate-id()}"
					title="Unexplained character(s){$sicMessage}&#10;{$hand}{$prob}" href="#"
					onclick="return false;" style="text-decoration:none; color:#000000">
					<xsl:if test="not(ancestor::tei:del)">
						<xsl:attribute name="msLine">
							<xsl:value-of select="$lineID"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when
							test="ancestor::*[@cert = 'low'] or descendant::*[@cert = 'low'] or @lemma = 'UNKNOWN'">
							<xsl:attribute name="style">text-decoration:none; color:#ff0000<xsl:if
									test="ancestor::tei:del">;line-through</xsl:if></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when
									test="ancestor::*[@cert = 'medium'] or descendant::*[@cert = 'medium']">
									<xsl:attribute name="style">text-decoration:none;
											color:#ff9900<xsl:if test="ancestor::tei:del"
											>;line-through</xsl:if></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when
											test="ancestor::tei:unclear[@cert = 'high'] or descendant::tei:unclear[@cert = 'high']">
											<xsl:attribute name="style">text-decoration:none;
												color:#cccc00<xsl:if test="ancestor::tei:del"
												>;line-through</xsl:if></xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="style">text-decoration:none;
												color:#000000<xsl:if test="ancestor::tei:del"
												>;line-through</xsl:if></xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates/>
				</a>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:pc">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::tei:w">
				<xsl:text/>
			</xsl:when>
			<xsl:otherwise>
				<a>
					<xsl:if test="not(ancestor::tei:del)">
						<xsl:attribute name="msLine">
							<xsl:value-of select="$lineID"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:choose>
						<xsl:when
							test="ancestor::*[@cert = 'low'] or descendant::*[@cert = 'low'] or @lemma = 'UNKNOWN'">
							<xsl:attribute name="style">text-decoration:none; color:#ff0000<xsl:if
									test="ancestor::tei:del">;line-through</xsl:if></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when
									test="ancestor::*[@cert = 'medium'] or descendant::*[@cert = 'medium']">
									<xsl:attribute name="style">text-decoration:none;
											color:#ff9900<xsl:if test="ancestor::tei:del"
											>;line-through</xsl:if></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when
											test="ancestor::tei:unclear[@cert = 'high'] or descendant::tei:unclear[@cert = 'high']">
											<xsl:attribute name="style">text-decoration:none;
												color:#cccc00<xsl:if test="ancestor::tei:del"
												>;line-through</xsl:if></xsl:attribute>
										</xsl:when>
										<xsl:otherwise>
											<xsl:attribute name="style">text-decoration:none;
												color:#000000<xsl:if test="ancestor::tei:del"
												>;line-through</xsl:if></xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates/>
				</a>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:space[@type = 'force']">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<span msLine="{$lineID}">&#160;</span>
	</xsl:template>

	<xsl:template match="tei:space[@type = 'em']">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<span msLine="{$lineID}">&#160;&#160;&#160;&#160;</span>
	</xsl:template>

	<xsl:template match="tei:space[@type = 'scribal']">
		<xsl:text/>
	</xsl:template>

	<xsl:template match="tei:space[@type = 'editorial']">
		<xsl:text/>
	</xsl:template>

	<xsl:template match="tei:supplied">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="descendant::tei:w">
				<span msLine="{$lineID}">
					<xsl:text>[</xsl:text>
				</span>
				<xsl:apply-templates/>
				<span msLine="{$lineID}">
					<xsl:text>]</xsl:text>
				</span>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="ancestor::tei:w[not(descendant::tei:w)]">
				<xsl:text>[</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<span msLine="{$lineID}">
					<xsl:text>[</xsl:text>
				</span>
				<xsl:apply-templates/>
				<span msLine="{$lineID}">
					<xsl:text>]</xsl:text>
				</span>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:g">
		<xsl:variable name="comWord"
			select="count(ancestor::tei:w[not(descendant::tei:w)]/preceding::tei:w[not(descendant::tei:w)])"/>
		<xsl:variable name="position"
			select="count(preceding::tei:g[ancestor::tei:w[not(descendant::tei:w) and count(preceding::tei:w[not(descendant::tei:w)]) = $comWord]])"/>
		<xsl:if test="contains(@ref, 'g')">
			<i class="glyph" id="l{$position}" cert="{ancestor::tei:abbr/@cert}">
				<xsl:apply-templates/>
			</i>
		</xsl:if>
		<xsl:if test="contains(@ref, 'l')">
			<span class="glyph" id="l{$position}" cert="{ancestor::tei:abbr/@cert}">
				<xsl:apply-templates/>
			</span>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="descendant::tei:w">
				<span msLine="{$lineID}">
					<xsl:text>{</xsl:text>
				</span>
				<xsl:apply-templates/>
				<span msLine="{$lineID}">
					<xsl:text>}</xsl:text>
				</span>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="ancestor::tei:w">
				<span>
					<xsl:text>{</xsl:text>
				</span>
				<xsl:apply-templates/>
				<span>
					<xsl:text>}</xsl:text>
				</span>
			</xsl:when>
			<xsl:when test="descendant::tei:date">
				<span>
					<xsl:if test="not(ancestor::tei:choice)">
						<xsl:attribute name="msLine">
							<xsl:value-of select="$lineID"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:text>{</xsl:text>
				</span>
				<xsl:apply-templates/>
				<span>
					<xsl:if test="not(ancestor::tei:choice)">
						<xsl:attribute name="msLine">
							<xsl:value-of select="$lineID"/>
						</xsl:attribute>
					</xsl:if>
					<xsl:text>}</xsl:text>
				</span>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="ancestor::tei:date">
				<span>
					<xsl:text>{</xsl:text>
				</span>
				<xsl:apply-templates/>
				<span>
					<xsl:text>}</xsl:text>
				</span>
			</xsl:when>
			<xsl:when test="descendant::tei:num">
				<span msLine="{$lineID}">
					<xsl:text>{</xsl:text>
				</span>
				<xsl:apply-templates/>
				<span msLine="{$lineID}">
					<xsl:text>}</xsl:text>
				</span>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="ancestor::tei:num">
				<span>
					<xsl:text>{</xsl:text>
				</span>
				<xsl:apply-templates/>
				<span>
					<xsl:text>}</xsl:text>
				</span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:gap">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="gapReason">
			<xsl:choose>
				<xsl:when test="@reason = 'text_obscure'">
					<xsl:text xml:space="preserve">illegible text; writing surface is intact</xsl:text>
				</xsl:when>
				<xsl:when test="@reason = 'damage'">
					<xsl:text xml:space="preserve">loss of writing surface</xsl:text>
				</xsl:when>
				<xsl:when test="@reason = 'fold'">
					<xsl:text xml:space="preserve">the page edge is folded in the digital image</xsl:text>
				</xsl:when>
				<xsl:when test="@reason = 'text_omitted'">
					<xsl:text xml:space="preserve">textual lacuna; no physical loss/damage</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text xml:space="preserve">reason unavailable</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@extent = 'unknown'">
				<a id="{generate-id()}" title="{concat(@extent, ' extent')}, {$gapReason}" href="#"
					onclick="return false;" style="text-decoration:none; color:#000000">
					<xsl:if test="not(ancestor::tei:del)">
						<xsl:attribute name="msLine">
							<xsl:value-of select="$lineID"/>
						</xsl:attribute>
					</xsl:if>
					<sub>
						<b>
							<i>-gap-</i>
						</b>
					</sub>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a id="{generate-id()}" title="{@extent}, {$gapReason}" href="#"
					onclick="return false;" style="text-decoration:none; color:#000000">
					<xsl:if test="not(ancestor::tei:del)">
						<xsl:attribute name="msLine">
							<xsl:value-of select="$lineID"/>
						</xsl:attribute>
					</xsl:if>
					<sub>
						<b>
							<i>-gap-</i>
						</b>
					</sub>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:del">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<span msLine="{$lineID}">
			<del rend="strikethrough">
				<xsl:apply-templates/>
			</del>
		</span>
	</xsl:template>

	<xsl:template match="tei:note[@type = 'fn']">
		<xsl:variable name="comDiv" select="ancestor::tei:div[not(ancestor::tei:div)]/@corresp"/>
		<xsl:variable name="fnNum"
			select="count(preceding::tei:note[@type = 'fn' and ancestor::tei:div/@corresp = $comDiv]) + 1"/>
		<sup>
			<b>
				<a id="{$comDiv}.ref{$fnNum}" href="#{$comDiv}.fn{$fnNum}"
					title="{descendant::tei:p}">
					<xsl:value-of select="$fnNum"/>
				</a>
			</b>
		</sup>
		<xsl:variable name="incr">
			<xsl:choose>
				<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
				<xsl:otherwise> 0 </xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="following::*[1 + $incr]/self::tei:pc">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
				<xsl:text/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:add[@type = 'insertion']">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::tei:w">
				<xsl:choose>
					<xsl:when test="@place = 'above'">
						<sub>
							<b>
								<xsl:text>\</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub>
							<b>
								<xsl:text>/</xsl:text>
							</b>
						</sub>
					</xsl:when>
					<xsl:when test="@place = 'below'">
						<sub>
							<b>
								<xsl:text>/</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub>
							<b>
								<xsl:text>\</xsl:text>
							</b>
						</sub>
					</xsl:when>
					<xsl:when test="@place = 'margin, right'">
						<sub>
							<b>
								<xsl:text>&lt;</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub>
							<b style="font:smaller">
								<xsl:text>&lt;</xsl:text>
							</b>
						</sub>
					</xsl:when>
					<xsl:when test="@place = 'margin, left'">
						<sub>
							<b style="font:smaller">
								<xsl:text>&gt;</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub>
							<b style="font:smaller">
								<xsl:text>&gt;</xsl:text>
							</b>
						</sub>
					</xsl:when>
					<xsl:when test="@place = 'margin, top'">
						<sub>
							<b>
								<xsl:text>\\</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub>
							<b>
								<xsl:text>//</xsl:text>
							</b>
						</sub>
					</xsl:when>
					<xsl:when test="@place = 'margin, bottom'">
						<sub>
							<b>
								<xsl:text>\\</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub>
							<b>
								<xsl:text>//</xsl:text>
							</b>
						</sub>
					</xsl:when>
					<xsl:when test="@place = 'inline'">
						<sub>
							<b style="font:smaller">
								<xsl:text>|</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub>
							<b style="font:smaller">
								<xsl:text>|</xsl:text>
							</b>
						</sub>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@place = 'above'">
						<sub>
							<b>
								<xsl:text>\</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub msLine="{$lineID}">
							<b>
								<xsl:text>/</xsl:text>
							</b>
						</sub>
						<xsl:variable name="incr">
							<xsl:choose>
								<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
								<xsl:otherwise> 0 </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="following::*[1 + $incr]/self::tei:pc">
								<xsl:text/>
							</xsl:when>
							<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
								<xsl:text/>
							</xsl:when>
							<xsl:otherwise>
								<span msLine="{$lineID}">
									<xsl:text> </xsl:text>
								</span>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="@place = 'below'">
						<sub msLine="{$lineID}">
							<b>
								<xsl:text>/</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub msLine="{$lineID}">
							<b>
								<xsl:text>\</xsl:text>
							</b>
						</sub>
						<xsl:variable name="incr">
							<xsl:choose>
								<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
								<xsl:otherwise> 0 </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="following::*[1 + $incr]/self::tei:pc">
								<xsl:text/>
							</xsl:when>
							<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
								<xsl:text/>
							</xsl:when>
							<xsl:otherwise>
								<span msLine="{$lineID}">
									<xsl:text> </xsl:text>
								</span>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="@place = 'margin, right'">
						<sub msLine="{$lineID}">
							<b style="font:smaller">
								<xsl:text>&lt;</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub msLine="{$lineID}">
							<b style="font:smaller">
								<xsl:text>&lt;</xsl:text>
							</b>
						</sub>
						<xsl:variable name="incr">
							<xsl:choose>
								<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
								<xsl:otherwise> 0 </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="following::*[1 + $incr]/self::tei:pc">
								<xsl:text/>
							</xsl:when>
							<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
								<xsl:text/>
							</xsl:when>
							<xsl:otherwise>
								<span msLine="{$lineID}">
									<xsl:text> </xsl:text>
								</span>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="@place = 'margin, left'">
						<sub msLine="{$lineID}">
							<b style="font:smaller">
								<xsl:text>&gt;</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub msLine="{$lineID}">
							<b style="font:smaller">
								<xsl:text>&gt;</xsl:text>
							</b>
						</sub>
						<xsl:variable name="incr">
							<xsl:choose>
								<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
								<xsl:otherwise> 0 </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="following::*[1 + $incr]/self::tei:pc">
								<xsl:text/>
							</xsl:when>
							<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
								<xsl:text/>
							</xsl:when>
							<xsl:otherwise>
								<span msLine="{$lineID}">
									<xsl:text> </xsl:text>
								</span>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="@place = 'margin, top'">
						<sub msLine="{$lineID}">
							<b>
								<xsl:text>//</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub msLine="{$lineID}">
							<b>
								<xsl:text>\\</xsl:text>
							</b>
						</sub>
						<xsl:variable name="incr">
							<xsl:choose>
								<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
								<xsl:otherwise> 0 </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="following::*[1 + $incr]/self::tei:pc">
								<xsl:text/>
							</xsl:when>
							<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
								<xsl:text/>
							</xsl:when>
							<xsl:otherwise>
								<span msLine="{$lineID}">
									<xsl:text> </xsl:text>
								</span>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="@place = 'margin, bottom'">
						<sub msLine="{$lineID}">
							<b>
								<xsl:text>\\</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub msLine="{$lineID}">
							<b>
								<xsl:text>//</xsl:text>
							</b>
						</sub>
						<xsl:variable name="incr">
							<xsl:choose>
								<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
								<xsl:otherwise> 0 </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="following::*[1 + $incr]/self::tei:pc">
								<xsl:text/>
							</xsl:when>
							<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
								<xsl:text/>
							</xsl:when>
							<xsl:otherwise>
								<span msLine="{$lineID}">
									<xsl:text> </xsl:text>
								</span>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="@place = 'inline'">
						<sub msLine="{$lineID}">
							<b style="font:smaller">
								<xsl:text>|</xsl:text>
							</b>
						</sub>
						<xsl:apply-templates/>
						<sub msLine="{$lineID}">
							<b style="font:smaller">
								<xsl:text>|</xsl:text>
							</b>
						</sub>
						<xsl:variable name="incr">
							<xsl:choose>
								<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
								<xsl:otherwise> 0 </xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="following::*[1 + $incr]/self::tei:pc">
								<xsl:text/>
							</xsl:when>
							<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
								<xsl:text/>
							</xsl:when>
							<xsl:otherwise>
								<span msLine="{$lineID}">
									<xsl:text> </xsl:text>
								</span>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:add[@type = 'gloss']">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="@place = 'above'">
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>\ gl. </xsl:text>
					</b>
				</sub>
				<xsl:apply-templates/>
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>/</xsl:text>
					</b>
				</sub>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@place = 'below'">
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>/ gl. </xsl:text>
					</b>
				</sub>
				<xsl:apply-templates/>
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>\</xsl:text>
					</b>
				</sub>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@place = 'margin, right'">
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>&lt; gl. </xsl:text>
					</b>
				</sub>
				<xsl:apply-templates/>
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>&lt;</xsl:text>
					</b>
				</sub>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@place = 'margin, left'">
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>&gt; gl. </xsl:text>
					</b>
				</sub>
				<xsl:apply-templates/>
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>&gt;</xsl:text>
					</b>
				</sub>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@place = 'margin, top'">
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>// gl. </xsl:text>
					</b>
				</sub>
				<xsl:apply-templates/>
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>\\</xsl:text>
					</b>
				</sub>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@place = 'margin, bottom'">
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>\\ gl. </xsl:text>
					</b>
				</sub>
				<xsl:apply-templates/>
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>//</xsl:text>
					</b>
				</sub>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@place = 'inline'">
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>| gl. </xsl:text>
					</b>
				</sub>
				<xsl:apply-templates/>
				<sub msLine="{$lineID}">
					<b>
						<xsl:text>|</xsl:text>
					</b>
				</sub>
				<xsl:variable name="incr">
					<xsl:choose>
						<xsl:when test="following::*[1]/self::tei:space"> 1 </xsl:when>
						<xsl:otherwise> 0 </xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="following::*[1 + $incr]/self::tei:pc">
						<xsl:text/>
					</xsl:when>
					<xsl:when test="following::*[1 + $incr]/self::tei:note[@type = 'fn']">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<span msLine="{$lineID}">
							<xsl:text> </xsl:text>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:handShift">
		<xsl:variable name="elPOS" select="count(preceding::*)"/>
		<xsl:variable name="lineID">
			<xsl:if
				test="ancestor::tei:div[1]/@type = 'prose' or ancestor::tei:div/@type = 'divprose'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:pb[1]/following::tei:cb[1]/preceding::*) &lt; $elPOS">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</xsl:if>
			<xsl:if test="ancestor::tei:div[1]/@type = 'verse'">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="translate(ancestor::tei:div[1]/@n, '.', '')"/>
				<xsl:value-of select="ancestor::tei:lg[1]/@n"/>
				<xsl:value-of select="ancestor::tei:l[1]/@n"/>
			</xsl:if>
		</xsl:variable>
		<sub>
			<xsl:if test="not(ancestor::tei:del)">
				<xsl:attribute name="msLine">
					<xsl:value-of select="$lineID"/>
				</xsl:attribute>
			</xsl:if>
			<i>
				<b>-beg. H<xsl:value-of select="substring(@new, 5)"/>-</b>
			</i>
		</sub>
	</xsl:template>

	<xsl:template match="tei:div[@n]">
		<xsl:variable name="comDiv" select="@corresp"/>
		<xsl:variable name="contents"
			select="ancestor::tei:TEI//tei:msDesc/tei:msContents/tei:msItem/h4/@id"/>
		<xsl:if test="@n and ancestor::tei:div or not(descendant::tei:div)">
			<p>
				<a href="{$contents}">Back to MS contents</a>
			</p>
		</xsl:if>
		<h2 style="text-align:center" id="{@corresp}">
			<xsl:value-of select="key('divTitle', @corresp)/tei:title"/>
		</h2>
		<xsl:apply-templates/>
		<xsl:if test="@type = 'prose' and not(descendant::tei:div)">
			<xsl:variable name="lineID">
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:text>.</xsl:text>
				<xsl:choose>
					<xsl:when
						test="descendant::tei:pb[not(following::tei:pb[ancestor::tei:div[@corresp = $comDiv]])]/@xml:id">
						<xsl:value-of
							select="substring-after(descendant::tei:pb[not(following::tei:pb[ancestor::tei:div[@corresp = $comDiv]])]/@xml:id, '.')"
						/>
					</xsl:when>
					<xsl:when
						test="descendant::tei:pb[not(following::tei:pb[ancestor::tei:div[@corresp = $comDiv]])]/@sameAs">
						<xsl:value-of
							select="substring-after(descendant::tei:pb[not(following::tei:pb[ancestor::tei:div[@corresp = $comDiv]])]/@sameAs, '.')"
						/>
					</xsl:when>
				</xsl:choose>
				<xsl:text>.</xsl:text>
				<xsl:value-of
					select="descendant::tei:lb[not(following::tei:lb[ancestor::tei:div[@corresp = $comDiv]])]/@n + 1"
				/>
			</xsl:variable>
			<xsl:text xml:space="preserve"> </xsl:text>
			<button id="plus{$lineID}" onclick="revealComment(this.id)" style="font-size:12px">
				<xsl:if test="ancestor::tei:w">
					<xsl:attribute name="onmouseover">
						<xsl:text>disableWordFunctions(this.id)</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="onmouseout">
						<xsl:text>enableWordFunctions(this.id)</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<b>+</b>
			</button>
			<br id="plus{$lineID}br" hidden="hidden"/>
			<table hidden="hidden">
				<xsl:if test="ancestor::tei:w">
					<xsl:attribute name="onmouseover">
						<xsl:text>disableWordFunctions(this.id)</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="onmouseout">
						<xsl:text>enableWordFunctions(this.id)</xsl:text>
					</xsl:attribute>
				</xsl:if>
			</table>
			<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px"
				hidden="hidden"><xsl:if test="ancestor::tei:w">
					<xsl:attribute name="onmouseover">
						<xsl:text>disableWordFunctions(this.id)</xsl:text>
					</xsl:attribute>
					<xsl:attribute name="onmouseout">
						<xsl:text>enableWordFunctions(this.id)</xsl:text>
					</xsl:attribute>
				</xsl:if>Add Comment</button>
			<br/>
			<table/>
			<button id="{generate-id()} + 'x'" onclick="textComment(this.id)" style="font-size:12px"
				>Add Comment</button>
		</xsl:if>
		<xsl:if test="not(ancestor::tei:div) and descendant::tei:note[@type = 'fn']">
			<h3 style="font-size:16px">Notes</h3>
			<xsl:for-each select="descendant::tei:note[@type = 'fn']">
				<xsl:variable name="comDiv"
					select="ancestor::tei:div[not(ancestor::tei:div)]/@corresp"/>
				<xsl:variable name="fnNum"
					select="count(preceding::tei:note[@type = 'fn' and ancestor::tei:div/@corresp = $comDiv]) + 1"/>
				<p style="font-size:11px">
					<b>
						<a id="{$comDiv}.fn{$fnNum}" href="#{$comDiv}.ref{$fnNum}">
							<xsl:value-of select="$fnNum"/>
							<xsl:text>.</xsl:text>
						</a>
					</b>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="child::tei:p"/>
				</p>
				<table/>
				<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:10px"
					>Add Comment</button>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:head">
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>

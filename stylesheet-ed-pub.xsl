<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.0">
	<xsl:include href="stylesheet-dip-comp.xsl"/>
	<xsl:strip-space elements="*"/>

	<xsl:output method="html"/>

	<xsl:key name="abbrs" match="*" use="@xml:id"/>
	<xsl:key name="hands" match="*" use="@xml:id"/>
	<xsl:key name="mss" match="*" use="@xml:id"/>
	<xsl:key name="pos" match="*" use="@xml:id"/>
	<xsl:key name="probs" match="*" use="@xml:id"/>
	<xsl:key name="divTitle" match="*" use="@xml:id"/>
	<xsl:key name="auth" match="*" use="@xml:id"/>
	<xsl:key name="lang" match="*" use="@xml:id"/>
	<xsl:key name="text" match="*" use="@corresp"/>
	<xsl:key name="altText" match="*" use="@corresp"/>

	<xsl:param name="sicReplace" select="'alt'"/>

	<xsl:attribute-set name="tblBorder">
		<xsl:attribute name="border">solid 0.1mm black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="/">
		<html>
			<head>
				<script src="WordFile.js"/>
				<script src="ref.js"/>
				<script src="hilites.js"/>
			</head>
			<body>
				<h1 style="text-align:center; font-size:20px">
					<xsl:value-of select="tei:teiCorpus//tei:title"/>
				</h1>
				<!-- <xsl:apply-templates select="tei:teiCorpus/tei:teiHeader"/> -->
				<xsl:for-each select="tei:teiCorpus/tei:TEI">
					<br/>
					<xsl:call-template name="tempEd"/>
					<br/>
					<h3 style="font-size:16px">Diplomatic Text</h3>
					<xsl:apply-templates mode="dip"/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="tempEd" match="tei:teiCorpus/tei:TEI">
		<br/>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:body">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:teiHeader">
		<xsl:apply-templates/>
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
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:fileDesc/tei:publicationStmt">
		<p style="font-size:12px">
			<xsl:apply-templates select="tei:availability"/>
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
			<xsl:text> </xsl:text>
			<xsl:apply-templates
				select="parent::tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:repository"/>
			<xsl:text> </xsl:text>
			<xsl:apply-templates
				select="parent::tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:idno"/>
		</xsl:variable>
		<u><h3 style="font-size:16px">Manuscript: <xsl:value-of select="$msref"/></h3></u>
		<xsl:for-each select="tei:note/tei:p">
			<p style="font-size:10px">
				<xsl:apply-templates/>
			</p>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:fileDesc/tei:sourceDesc">
		<h4 style="font-size:16px">Hands</h4>
		<xsl:for-each select="tei:msDesc/tei:physDesc/tei:handDesc/tei:handNote/tei:note">
				<h5>
					<xsl:value-of select="key('hands', parent::tei:handNote/@corresp)/tei:forename"/><xsl:text> </xsl:text><xsl:value-of select="key('hands', parent::tei:handNote/@corresp)/tei:surname"/><xsl:text> (</xsl:text><xsl:value-of select="parent::tei:handNote/@corresp"/><xsl:text>)</xsl:text>
				</h5>
			<xsl:for-each select="tei:p">
				<xsl:if test="@comment">
					<h6>
						<xsl:value-of select="@comment"/>
					</h6>
				</xsl:if>
				<p style="font-size:10px">
					<xsl:apply-templates/>
				</p>
			</xsl:for-each>
		</xsl:for-each>
		<h4 style="font-size:16px">Contents</h4>
		<h5 style="font-size:14px">Summary</h5>
		<p style="font-size: small">
			<xsl:apply-templates select="tei:msDesc/tei:msContents/tei:summary"/>
		</p>
		<xsl:for-each select="tei:msDesc/tei:msContents/tei:msItem">
			<xsl:variable name="inc"
				select="key('text', @xml:id)//preceding::tei:lb[1]/@xml:id | @sameAs"/>
			<h4 id="{ancestor::tei:TEI/@xml:id}msContents">
				<xsl:value-of select="@n"/>
				<xsl:text>: </xsl:text>
				<a href="#{@xml:id}">
					<xsl:apply-templates select="tei:title"/>
				</a>
			</h4>
			<xsl:if test="tei:locus">
				<xsl:apply-templates select="tei:locus"/>
				<br/>
			</xsl:if>
			<xsl:if test="tei:incipit">
				<xsl:text>Beg. "</xsl:text>
				<xsl:apply-templates select="tei:incipit"/>
				<xsl:text>"</xsl:text>
				<br/>
			</xsl:if>
			<xsl:if test="tei:explicit">
				<xsl:text>Ends. "</xsl:text>
				<xsl:apply-templates select="tei:explicit"/>
				<xsl:text>"</xsl:text>
				<br/>
			</xsl:if>
			<xsl:if test="not(child::tei:msItem)">
				<xsl:variable name="ItemID" select="@xml:id"/>
				<xsl:variable name="comDiv" select="ancestor::tei:div[@corresp = $ItemID]"/>
				<xsl:variable name="itemHand" select="@resp"/>
				<xsl:text>Main scribe: </xsl:text>
				<xsl:value-of select="key('hands', @resp)/tei:forename"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="key('hands', @resp)/tei:surname"/>
				<xsl:text> (</xsl:text>
				<xsl:value-of select="@resp"/>
				<xsl:text>)</xsl:text>
				<br/>
				<xsl:text>Other hands: </xsl:text>
				<xsl:for-each select="//tei:handShift[ancestor::tei:div[@corresp = $ItemID]]">
					<xsl:if
						test="not(@new = preceding::tei:handShift[ancestor::tei:div[@corresp = $ItemID]]/@new) and not(@new = $itemHand) or not(preceding::tei:handShift[ancestor::tei:div[@corresp = $ItemID]])">
						<xsl:value-of select="key('hands', @new)/tei:forename"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="key('hands', @new)/tei:surname"/>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@new"/>
						<xsl:text>); </xsl:text>
					</xsl:if>
				</xsl:for-each>
				<br/>
				<xsl:text>Additions/emendations: </xsl:text>
				<xsl:for-each
					select="//tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]] | //tei:del[ancestor::tei:div[@corresp = $ItemID]]">
					<xsl:if
						test="not(@resp = preceding::tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]]/@resp | preceding::tei:del[ancestor::tei:div[@corresp = $ItemID]]/@resp) and not(@resp = $itemHand) or not(preceding::tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]] | preceding::tei:del[ancestor::tei:div[@corresp = $ItemID]])">
						<xsl:value-of select="key('hands', @resp)/tei:forename"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="key('hands', @resp)/tei:surname"/>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@resp"/>
						<xsl:text>); </xsl:text>
					</xsl:if>
				</xsl:for-each>
				<br/>
				<xsl:text>Glossing: </xsl:text>
				<xsl:for-each
					select="//tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]]">
					<xsl:if
						test="not(@resp = preceding::tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]]/@resp) and not(@resp = $itemHand) or not(preceding::tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]])">
						<xsl:value-of select="key('hands', @resp)/tei:forename"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="key('hands', @resp)/tei:surname"/>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@resp"/>
						<xsl:text>); </xsl:text>
					</xsl:if>
				</xsl:for-each>

			</xsl:if>
			<xsl:if test="child::tei:msItem">
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
						<xsl:text>Beg. "</xsl:text>
						<xsl:apply-templates select="tei:incipit"/>
						<xsl:text>"</xsl:text>
						<br/>
						<xsl:text>Ends. "</xsl:text>
						<xsl:apply-templates select="tei:explicit"/>
						<xsl:text>"</xsl:text>
						<br/>
						<xsl:text>Main scribe: </xsl:text>
						<xsl:value-of select="key('hands', @resp)/tei:forename"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="key('hands', @resp)/tei:surname"/>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@resp"/>
						<xsl:text>)</xsl:text>
						<br/>
						<xsl:text>Other hands: </xsl:text>
						<xsl:for-each
							select="//tei:handShift[ancestor::tei:div[@corresp = $ItemID]]">
							<xsl:if
								test="not(@new = preceding::tei:handShift[ancestor::tei:div[@corresp = $ItemID]]/@new) and not(@new = $itemHand) or not(preceding::tei:handShift[ancestor::tei:div[@corresp = $ItemID]])">
								<xsl:value-of select="key('hands', @new)/tei:forename"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="key('hands', @new)/tei:surname"/>
								<xsl:text> (</xsl:text>
								<xsl:value-of select="@new"/>
								<xsl:text>); </xsl:text>
							</xsl:if>
						</xsl:for-each>
						<br/>
						<xsl:text>Additions/emendations: </xsl:text>
						<xsl:for-each
							select="//tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]] | //tei:del[ancestor::tei:div[@corresp = $ItemID]]">
							<xsl:if
								test="not(@resp = preceding::tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]]/@resp | preceding::tei:del[ancestor::tei:div[@corresp = $ItemID]]/@resp) and not(@resp = $itemHand) or not(preceding::tei:add[@type = 'insertion'][ancestor::tei:div[@corresp = $ItemID]] | preceding::tei:del[ancestor::tei:div[@corresp = $ItemID]])">
								<xsl:value-of select="key('hands', @resp)/tei:forename"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="key('hands', @resp)/tei:surname"/>
								<xsl:text> (</xsl:text>
								<xsl:value-of select="@resp"/>
								<xsl:text>); </xsl:text>
							</xsl:if>
						</xsl:for-each>
						<br/>
						<xsl:text>Glossing: </xsl:text>
						<xsl:for-each
							select="//tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]]">
							<xsl:if
								test="not(@resp = preceding::tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]]/@resp) and not(@resp = $itemHand) or not(preceding::tei:add[@type = 'gloss'][ancestor::tei:div[@corresp = $ItemID]])">
								<xsl:value-of select="key('hands', @resp)/tei:forename"/>
								<xsl:text> </xsl:text>
								<xsl:value-of select="key('hands', @resp)/tei:surname"/>
								<xsl:text> (</xsl:text>
								<xsl:value-of select="@resp"/>
								<xsl:text>); </xsl:text>
							</xsl:if>
						</xsl:for-each>
						<br/>
					</p>
				</xsl:for-each>
			</xsl:if>
			<h5 style="font-size:14px">Text Summary</h5>
			<xsl:for-each select="tei:note/tei:p">
				<xsl:if test="@comment">
					<h6 style="font-size:12px">
						<xsl:value-of select="@comment"/>
					</h6>
				</xsl:if>
				<p style="font-size:10px">
					<xsl:apply-templates/>
				</p>
			</xsl:for-each>
			<h5>Filiation of Text</h5>
			<xsl:for-each select="tei:filiation/tei:p">
				<p style="font-size:10px">
					<xsl:apply-templates/>
				</p>
			</xsl:for-each>
			<br/>
			<h5 style="font-size:14px">Language and Style</h5>
			<xsl:for-each select="tei:textLang/tei:note">
				<xsl:if test="@comment">
					<h6 style="font-size:12px">
						<xsl:value-of select="@comment"/>
					</h6>
				</xsl:if>
				<xsl:for-each select="tei:p">
					<xsl:if test="@comment">
						<b><h7 style="font-size:10px">
							<xsl:value-of select="@comment"/>
						</h7></b>
					</xsl:if>
					<p style="font-size:10px">
						<xsl:apply-templates/>
					</p>
				</xsl:for-each>
			</xsl:for-each>
			<br/>
		</xsl:for-each>
		<h4 style="font-size:16px">Physical Description of Manuscrpt</h4>
		<xsl:if test="tei:msDesc/tei:physDesc/tei:p">
			<p style="font-size:10px">
				<xsl:apply-templates select="tei:msDesc/tei:physDesc/tei:p"/>
			</p>
		</xsl:if>
		<h5 style="font-size:14px"> Writing Surface </h5>
		<p style="font-size:10px">
			<xsl:apply-templates
				select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:p"/>
		</p>
		<h5 style="font-size:14px"> Foliation </h5>
		<p style="font-size:10px">
			<xsl:apply-templates
				select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:foliation/tei:p"
			/>
		</p>
		<h5 style="font-size:14px"> Condition </h5>
		<p style="font-size:10px">
			<xsl:apply-templates
				select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:condition/tei:p"
			/>
		</p>
		<h5 style="font-size:14px"> Layout of Page </h5>
		<p style="font-size:10px">
			<xsl:apply-templates
				select="tei:msDesc/tei:physDesc/tei:objectDesc/tei:layoutDesc/tei:p"/>
		</p>
		<h4 style="font-size:16px"> History of the Manuscript </h4>
		<h5 style="font-size:14px">Summary</h5>
		<p style="font-size:10px">
			<xsl:apply-templates select="tei:msDesc/tei:history/tei:summary/tei:p"/>
		</p>
		<h5 style="font-size:14px">Origin</h5>
		<p style="font-size:10px">
			<xsl:apply-templates select="tei:msDesc/tei:history/tei:origin/tei:p"/>
		</p>
		<h5 style="font-size:14px">Subsequent History</h5>
		<p style="font-size:10px">
			<xsl:apply-templates select="tei:msDesc/tei:history/tei:provenance/tei:p"/>
		</p>
		<h5 style="font-size:14px">Acquisition</h5>
		<p style="font-size:10px">
			<xsl:apply-templates select="tei:msDesc/tei:history/tei:acquisition/tei:p"/>
		</p>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:encodingDesc">
		<h3 style="font-size:16px">Encoding of this Transcription</h3>
		<h4 style="font-size:16px">Issues</h4>
		<p style="font-size:10px">
			<xsl:apply-templates select="tei:editorialDecl/tei:p"/>
		</p>
		<xsl:if test="tei:metDecl">
			<h4 style="font-size:16px">Metrics</h4>
			<p style="font-size:10px">
				<xsl:apply-templates select="tei:metDecl/tei:p"/>
			</p>
		</xsl:if>
		<h4 style="font-size:16px">Referencing of this Transcription</h4>
		<p style="font-size:10px">
			<xsl:apply-templates select="tei:refsDecl/tei:p"/>
		</p>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:profileDesc/tei:textClass">
		<h3 style="font-size:16px">Keywords</h3>
		<ul style="margin-left:30px">
			<xsl:for-each select="tei:keywords/tei:term">
				<li style="font-size:10px">
					<xsl:apply-templates/>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:revisionDesc">
		<h3 style="font-size:16px">Revision History</h3>
		<ul style="margin-left:30px">
		<xsl:for-each select="tei:change">
			<li style="font-size:10px"><b>
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
			<xsl:for-each select="tei:head">
				<li style="font-size:10px;list-style: none">
					<b>
						<xsl:apply-templates/>
					</b>
				</li>
			</xsl:for-each>
			<xsl:for-each select="tei:item">
				<li style="margin-left:30px;font-size:10px">
					<xsl:apply-templates/>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="tei:table">
		<table style="margin-left:30px">
			<tr>
				<xsl:for-each select="tei:row[@role = 'label']/tei:cell">
					<th style="bold; font-size: small">
						<xsl:apply-templates/>
					</th>
				</xsl:for-each>
			</tr>
			<xsl:for-each select="tei:row[@role = 'data']">
				<tr style="font-size: small">
					<xsl:for-each select="tei:cell">
						<td>
							<xsl:apply-templates/>
						</td>
					</xsl:for-each>
				</tr>
			</xsl:for-each>
		</table>
		<br/>
	</xsl:template>
	
	<xsl:template match="tei:quote">
		<blockquote style="margin-left:40px;font-size: small">
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>
	
	<xsl:template match="tei:quote/tei:l">
		<xsl:apply-templates/><br/>
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

	<xsl:template match="tei:hi[@rend = 'underline' and not(descendant::tei:w)]">
		<u>
			<xsl:apply-templates/>
		</u>
	</xsl:template>

	<xsl:template match="tei:pb">
		<br/>
		<hr align="left" width="40%"/>
		<xsl:choose>
			<xsl:when test="ancestor::tei:div[1]//tei:handShift">
				<xsl:variable name="comDiv" select="ancestor::tei:div[1]/@xml:id"/>
				<xsl:choose>
					<xsl:when
						test="preceding::tei:handShift/ancestor::tei:div[1]/@corresp = $comDiv">
						<seg align="left">
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
						<seg align="left">
							<b><xsl:value-of select="@n"/>: <xsl:value-of
									select="key('hands', ancestor::tei:div/@resp)/tei:forename"
									/><xsl:text> </xsl:text><xsl:value-of
									select="key('hands', ancestor::tei:div/@resp)/tei:surname"
									/><xsl:text> (</xsl:text><xsl:value-of
									select="ancestor::tei:div/@resp"/><xsl:text>) </xsl:text></b>
						</seg>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<seg align="left">
					<b><xsl:value-of select="@n"/>: <xsl:value-of
							select="key('hands', ancestor::tei:div/@resp)/tei:forename"
							/><xsl:text> </xsl:text><xsl:value-of
							select="key('hands', ancestor::tei:div/@resp)/tei:surname"
							/><xsl:text> (</xsl:text><xsl:value-of select="ancestor::tei:div/@resp"
						/><xsl:text>) </xsl:text></b>
				</seg>
			</xsl:otherwise>
		</xsl:choose>
		<button onclick="createTable()">Collect Slips</button>
		<br/>
	</xsl:template>

	<xsl:template match="tei:cb">
		<br/>
		<b>Col.<xsl:text> </xsl:text>
			<xsl:value-of select="@n"/></b>
		<br/>
	</xsl:template>

	<xsl:template match="tei:lb">
		<xsl:choose>
			<xsl:when test="ancestor::tei:p">
				<sub>
					<br/>
					<xsl:value-of select="@n"/>
					<xsl:text>. </xsl:text>
				</sub>
			</xsl:when>
			<xsl:when test="ancestor::tei:lg or ancestor::tei:w[ancestor::tei:lg]">
				<sub>
					<xsl:text> </xsl:text>
					<xsl:value-of select="@n"/>
					<xsl:text>. </xsl:text>
				</sub>
			</xsl:when>
			<xsl:otherwise>
				<sub>
					<br/>
					<xsl:value-of select="@n"/>
					<xsl:text>. </xsl:text>
				</sub>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:lg">
		<xsl:choose>
			<xsl:when test="child::tei:pb">
				<xsl:variable name="conID" select="@xml:id"/>
				<p style="margin-left:40px">
					<b align="left">
						<xsl:value-of select="@n"/>
						<xsl:text>. </xsl:text>
					</b>
					<xsl:text>  </xsl:text>
					<xsl:apply-templates
						select="descendant::tei:l[following::tei:pb[ancestor::tei:lg[@xml:id = $conID]]]"
					/>
				</p>
				<xsl:apply-templates select="child::tei:pb"/>
				<p style="margin-left:30px">
					<xsl:apply-templates
						select="descendant::tei:l[preceding::tei:pb[ancestor::tei:lg[@xml:id = $conID]]]"
					/>
				</p>
			</xsl:when>
			<!-- <xsl:when test="child::tei:l/descendant::tei:pb">
				<xsl:variable name="conID" select="@xml:id"/>
				<p style="margin-left:30px">
					<b align="left">
						<xsl:value-of select="@n"/>
						<xsl:text>. </xsl:text>
					</b>
					<xsl:text>  </xsl:text>
					<xsl:apply-templates
						select="descendant::*[following::tei:pb[ancestor::tei:lg[@xml:id = $conID]]]"
					/>
				</p>
				<xsl:apply-templates select="descendant::tei:pb"/>
				<p style="margin-left:30px">
					<xsl:apply-templates
						select="descendant::*[preceding::tei:pb[ancestor::tei:lg[@xml:id = $conID]]]"
					/>
				</p>
			</xsl:when> -->
			<xsl:otherwise>
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
					<xsl:otherwise>
						<p style="margin-left:30px">
							<b align="left">
								<xsl:value-of select="@n"/>
								<xsl:text>. </xsl:text>
							</b>
							<xsl:text>  </xsl:text>
							<xsl:apply-templates select="descendant::tei:l"/>
						</p>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:seg[@type = 'catchword']">
		<p style="margin-right:90pc; text-align:center">
			<xsl:apply-templates/>
		</p>
	</xsl:template>

	<xsl:template match="tei:seg[@type = 'cfe']">
		<xsl:text/>
	</xsl:template>

	<xsl:template match="tei:l">
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
		<xsl:choose>
			<xsl:when test="descendant::tei:pb">
				<xsl:variable name="pbId" select="descendant::tei:pb/@xml:id"/>
				<xsl:apply-templates select="*[following::tei:pb[@xml:id = $pbId]]"/>
				<xsl:apply-templates select="child::tei:pb"/>
				<xsl:apply-templates select="*[preceding::tei:pb[@xml:id = $pbId]]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
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
		<xsl:variable name="choicePOS" select="count(preceding::tei:choice)"/>
		<xsl:choose>
			<xsl:when test="child::tei:sic | tei:corr">
				<xsl:text>{</xsl:text>
				<xsl:apply-templates select="tei:corr"/>
				<xsl:choose>
					<xsl:when test="child::tei:sic[not(descendant::tei:w)]">
						<xsl:for-each select="descendant::tei:c">
							<xsl:variable name="alt" select="ancestor::tei:choice/tei:corr"/>
							<xsl:variable name="altSource"
								select="ancestor::tei:choice/tei:corr/@resp"/>
							<a id="{generate-id()}"
								title="MS: {self::*}&#10;- the intended reading cannot be identified; an amended reading ('{$alt}') has been supplied by {$altSource}.">
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
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="tei:sic/descendant::tei:w">
								<xsl:for-each select="tei:sic/descendant::tei:w">
									<xsl:call-template name="word_ed"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="tei:sic"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:text> </xsl:text>
						<xsl:text>}</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="child::tei:unclear">
				<xsl:text>{</xsl:text>
				<xsl:for-each select="tei:unclear[@n = '1']/descendant::*[@n]">
					<xsl:variable name="wpos" select="@n"/>
					<xsl:apply-templates select="self::*"/>
					<xsl:if
						test="ancestor::tei:choice/tei:unclear[@n = '2']/descendant::*/@n = $wpos">
						<a id="{generate-id()}"
							title="Or, {ancestor::tei:choice/tei:unclear[@n = '2']/descendant::tei:w[@n = $wpos]} ({ancestor::tei:choice/tei:unclear[@n = '2']/descendant::tei:w[@n = $wpos]/@ana})&#10;{key('probs', ancestor::tei:unclear/@reason)}">
							<xsl:if
								test="ancestor::tei:choice/tei:unclear[@n = '2']/descendant::*[@n = $wpos]/@lemma">
								<xsl:attribute name="href">
									<xsl:value-of
										select="ancestor::tei:choice/tei:unclear[@n = '2']/descendant::*[@n = $wpos]/@lemmaRef"
									/>
								</xsl:attribute>
								<xsl:attribute name="style">text-decoration:none;
									color:#000000</xsl:attribute>
							</xsl:if>
							<sub>
								<b>
									<i>/alt</i>
								</b>
							</sub>
						</a>
					</xsl:if>
				</xsl:for-each>
				<xsl:for-each
					select="tei:unclear[@n = '2']/*[@n > ancestor::tei:choice/tei:unclear[@n = '1']//tei:w//@n]">
					<a id="{generate-id()}" title="{self::*}">
						<xsl:if test="@lemma">
							<xsl:attribute name="href">
								<xsl:value-of select="@lemmaRef"/>
							</xsl:attribute>
							<xsl:attribute name="style">text-decoration:none;
								color:#000000</xsl:attribute>
						</xsl:if>
						<sub>
							<b>
								<i><xsl:text> </xsl:text>/alt<xsl:text> </xsl:text></i>
							</b>
						</sub>
					</a>
				</xsl:for-each>
				<xsl:text>} </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="word_ed" match="tei:w[not(descendant::tei:w)]">
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
						<xsl:when test="ancestor::tei:name"><xsl:value-of select="@lemma"/>
								(<xsl:value-of select="ancestor::tei:name/@type"/> name)</xsl:when>
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
				<xsl:when
					test="ancestor-or-self::tei:unclear[@cert = 'high'] or descendant-or-self::tei:unclear[@cert = 'high']"
					>slight</xsl:when>
				<xsl:when
					test="ancestor-or-self::*[@cert = 'medium'] or descendant-or-self::*[@cert = 'medium']"
					>moderate</xsl:when>
				<xsl:when
					test="ancestor-or-self::*[@cert = 'low'] or descendant-or-self::*[@cert = 'low']"
					>severe</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="ancestor::tei:sic"> sic </xsl:when>
						<xsl:when test="ancestor::tei:corr"> leg. </xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="ancestor-or-self::tei:supplied"> supp. word </xsl:when>
								<xsl:when test="descendant-or-self::tei:supplied"> supp. char(s) </xsl:when>
								<xsl:when test="@source"> new vocab. </xsl:when>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="handRef">
			<xsl:choose>
				<xsl:when test="ancestor::tei:add">
					<xsl:value-of select="ancestor::tei:add/@resp"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="ancestor::tei:div[@resp]//tei:handShift">
							<xsl:variable name="comDiv" select="ancestor::tei:div[@resp]/@corresp"/>
							<xsl:choose>
								<xsl:when
									test="preceding::tei:handShift[1]/ancestor::tei:div[@resp]/@corresp = $comDiv">
									<xsl:value-of select="preceding::tei:handShift[1]/@new"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="ancestor::tei:div[@resp]/@resp"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="ancestor::tei:div[@resp]/@resp"/>
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
				<xsl:when test="descendant::tei:add[@type = 'gloss']">
					<xsl:for-each select="descendant::tei:add[@type = 'gloss']">
						<xsl:text>A gloss ("</xsl:text>
						<xsl:value-of select="self::*"/>
						<xsl:text>") has been added by </xsl:text>
						<xsl:value-of select="key('hands', @resp)/tei:forename"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="key('hands', @resp)/tei:surname"/>
						<xsl:text> (</xsl:text>
						<xsl:value-of select="@resp"/>
						<xsl:text>)</xsl:text>
					</xsl:for-each>
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
		<a id="{$wordId}" pos="{$wordPOS}" onmouseover="hilite(this.id)"
			onmouseout="dhilite(this.id)" lemma="{$lem}" lemmaRef="{$lemRef}" lemmaDW="{@lemmaDW}"
			lemmaRefDW="{@lemmaRefDW}" ana="{@ana}" hand="{$hand}" ref="{$msref}" date="{$handDate}"
			medium="{$medium}" cert="{$certLvl}" abbrRefs="{$abbrRef}"
			title="{$lem}: {$pos} {$src}&#10;{$hand}&#10;{$prob}{$certProb}&#10;Abbreviations: {$abbrs}&#10;{$gloss}"
			style="text-decoration:none; color:#000000">
			<xsl:if test="ancestor::tei:sic">
				<xsl:attribute name="title"><xsl:value-of select="$sicLem"/><xsl:value-of
						select="$prob"/><xsl:value-of select="$certProb"/><xsl:value-of
						select="$hand"/>&#10;<xsl:text>Abbreviations: </xsl:text><xsl:value-of
						select="$abbrs"/>&#10;<xsl:value-of select="$gloss"/></xsl:attribute>
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
			<xsl:if test="@lemma">
				<xsl:attribute name="onclick">addSlip(this.id)</xsl:attribute>
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
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
		<xsl:choose>
			<xsl:when test="not(ancestor::tei:w)">
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="@ana = 'part' and ancestor::tei:w[contains(@ana, 'part, verb')]">
				<xsl:choose>
					<xsl:when test="ancestor::tei:w[contains(@lemmaRef, 'http://www.dil.ie/29104')]">
						<xsl:text/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@ana = 'part' and ancestor::tei:w[contains(@ana, 'part, pron, verb')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'part, pron, verb')]">
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[@ana = 'pron, verb']">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, pron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, adj')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'prep' and ancestor::tei:w[contains(@ana, 'prep, dpron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, dpron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'prep' and ancestor::tei:w[contains(@ana, 'prep, verb')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, dpron')]">
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
				test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, noun')] and following-sibling::tei:w[@ana = 'noun']">
				<xsl:text/>
			</xsl:when>
			<xsl:when
				test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, adj')] and @n = '1'">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'num' and ancestor::tei:w[contains(@ana, 'num, noun')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'num' and ancestor::tei:w[contains(@ana, 'num, vnoun')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'vnoun' and ancestor::tei:w[contains(@ana, 'vnoun, noun')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pref' and ancestor::tei:w[contains(@ana, 'pref, adj')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pref' and ancestor::tei:w[contains(@ana, 'pref, noun')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, part')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'conj' and ancestor::tei:w[contains(@ana, 'conj, pron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'conj' and ancestor::tei:w[contains(@ana, 'conj, verb')]">
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
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when
				test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, pron')] and following-sibling::tei:w[@ana = 'pron']">
				<xsl:text/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:w[descendant::tei:w]">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:name">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:date">
		<a id="{generate-id()}" href="#" onclick="return false;"
			style="text-decoration:none; color:#000000">
			<xsl:apply-templates/>
		</a>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:num">
		<a id="{generate-id()}" href="#" onclick="return false;"
			style="text-decoration:none; color:#000000">
			<xsl:apply-templates/>
		</a>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:ref">
		<a id="ref{count(preceding::*)}" onclick="refDetails(this.id)"><xsl:apply-templates/></a>
		<seg id="ref{count(preceding::*)}_tbl" style="display:none"><b>REF TEXT HERE</b></seg>
	</xsl:template>

	<xsl:template match="tei:c">
		<xsl:variable name="handRef">
			<xsl:choose>
				<xsl:when test="ancestor::tei:add">
					<xsl:value-of select="ancestor::tei:add[@type = 'gloss']/@resp"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="ancestor::tei:div[@resp]//tei:handShift">
							<xsl:variable name="comDiv" select="ancestor::tei:div[@resp]/@corresp"/>
							<xsl:choose>
								<xsl:when
									test="preceding::tei:handShift[1]/ancestor::tei:div[@resp]/@corresp = $comDiv">
									<xsl:value-of select="preceding::tei:handShift[1]/@new"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="ancestor::tei:div[@resp]/@resp"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="ancestor::tei:div[@resp]/@resp"/>
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
					<xsl:apply-templates/>
				</a>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:pc">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:space[@type = 'force']"> &#160; </xsl:template>

	<xsl:template match="tei:space[@type = 'em']"> &#160;&#160;&#160;&#160; </xsl:template>

	<xsl:template match="tei:supplied">
		<xsl:choose>
			<xsl:when test="descendant::tei:w">
				<xsl:text>[ </xsl:text>
				<xsl:apply-templates/>
				<xsl:text>] </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>[</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>]</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:g">
		<xsl:variable name="comWord"
			select="count(ancestor::tei:w[not(descendant::tei:w)]/preceding::tei:w[not(descendant::tei:w)])"/>
		<xsl:variable name="position"
			select="count(preceding::tei:g[ancestor::tei:w[not(descendant::tei:w) and count(preceding::tei:w[not(descendant::tei:w)]) = $comWord]])"/>
		<i id="l{$position}" cert="{ancestor::tei:abbr/@cert}">
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:choose>
			<xsl:when test="descendant::tei:w">
				<xsl:text>{ </xsl:text>
				<xsl:apply-templates/>
				<xsl:text>} </xsl:text>
			</xsl:when>
			<xsl:when test="ancestor::tei:w">
				<xsl:text>{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:when test="descendant::tei:date">
				<xsl:text> {</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>} </xsl:text>
			</xsl:when>
			<xsl:when test="ancestor::tei:date">
				<xsl:text>{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:gap">
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
					<sub>
						<b>
							<i>-gap-</i>
						</b>
					</sub>
				</a>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<a id="{generate-id()}" title="{@extent}, {$gapReason}" href="#"
					onclick="return false;" style="text-decoration:none; color:#000000">
					<sub>
						<b>
							<i>-gap-</i>
						</b>
					</sub>
				</a>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:del">
		<del rend="strikethrough">
			<xsl:apply-templates/>
		</del>
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
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:add[@type = 'insertion']">
		<xsl:choose>
			<xsl:when test="ancestor::tei:w">
				<xsl:choose>
					<xsl:when test="@place = 'above'">
						<b>
							<xsl:text>\ </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> /</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'below'">
						<b>
							<xsl:text>/ </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> \</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, right'">
						<b>
							<xsl:text>&lt; </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> &lt;</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, left'">
						<b>
							<xsl:text>&gt; </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> &gt;</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, top'">
						<b>
							<xsl:text>// </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> \\</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'inline'">
						<b>
							<xsl:text>| </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> |</xsl:text>
						</b>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@place = 'above'">
						<b>
							<xsl:text> \ </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> / </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'below'">
						<b>
							<xsl:text> / </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> \ </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, right'">
						<b>
							<xsl:text> &lt; </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> &lt; </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, left'">
						<b>
							<xsl:text> &gt; </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> &gt; </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, top'">
						<b>
							<xsl:text>// </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> \\</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'inline'">
						<b>
							<xsl:text>| </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> |</xsl:text>
						</b>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:add[@type = 'gloss']">
		<xsl:choose>
			<xsl:when test="@place = 'above'">
				<b>
					<xsl:text> \ gl. </xsl:text>
				</b>
				<xsl:apply-templates/>
				<b>
					<xsl:text> / </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'below'">
				<b>
					<xsl:text> / gl. </xsl:text>
				</b>
				<xsl:apply-templates/>
				<b>
					<xsl:text> \ </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, right'">
				<b>
					<xsl:text> &lt; gl. </xsl:text>
				</b>
				<xsl:apply-templates/>
				<b>
					<xsl:text> &lt;  </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, left'">
				<b>
					<xsl:text> &gt; gl. </xsl:text>
				</b>
				<xsl:apply-templates/>
				<b>
					<xsl:text> &gt; </xsl:text>
				</b>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:handShift">
		<xsl:text> </xsl:text>
		<sub>
			<i>
				<b> beg. H<xsl:value-of select="substring(@new, 5)"/></b>
			</i>
		</sub>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:div[@n]">
		<xsl:variable name="contents"
			select="ancestor::tei:TEI//tei:msDesc/tei:msContents/tei:msItem/h4/@id"/>
		<xsl:variable name="lineID" select="preceding::tei:lb[1]/@xml:id | @sameAs"/>
		<!-- <xsl:if test="/@resp = not(preceding::tei:div/@resp or preceding::tei:handShift/@new)">
			<sub>
				<b>beg. <xsl:value-of select="key('hands', @resp)/tei:forename"
						/><xsl:text> </xsl:text><xsl:value-of
						select="key('hands', @resp)/tei:surname"
						/><xsl:text> (</xsl:text><xsl:value-of select="@resp"
					/><xsl:text>) </xsl:text></b>
			</sub>
		</xsl:if> -->
		<xsl:if test="@n and ancestor::tei:div or not(descendant::tei:div)">
			<p>
				<a href="{$contents}">Back to MS contents</a>
			</p>
		</xsl:if>
		<h2 style="text-align:center" id="{@corresp}">
			<xsl:value-of select="key('divTitle', @corresp)/tei:title"/>
		</h2>
		<xsl:apply-templates/>
		<xsl:if test="not(ancestor::tei:div) and descendant::tei:note[@type = 'fn']">
			<h3>Notes</h3>
			<xsl:for-each select="descendant::tei:note[@type = 'fn']">
				<xsl:variable name="comDiv"
					select="ancestor::tei:div[not(ancestor::tei:div)]/@corresp"/>
				<xsl:variable name="fnNum"
					select="count(preceding::tei:note[@type = 'fn' and ancestor::tei:div/@corresp = $comDiv]) + 1"/>
				<p>
					<b>
						<a id="{$comDiv}.fn{$fnNum}" href="#{$comDiv}.ref{$fnNum}">
							<xsl:value-of select="$fnNum"/>
							<xsl:text>.</xsl:text>
						</a>
					</b>
					<xsl:text> </xsl:text>
					<xsl:apply-templates select="child::tei:p"/>
				</p>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:head">
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>

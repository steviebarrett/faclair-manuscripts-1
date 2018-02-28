<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.1">
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

	<xsl:attribute-set name="tblBorder">
		<xsl:attribute name="border">solid 0.1mm black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="/">
		<html>
			<head>
				<script src="WordFile.js"/>
			</head>
			<body>
				<h1>
					<xsl:value-of select="tei:teiCorpus//tei:title"/>
				</h1>
				<!-- <xsl:apply-templates select="tei:teiCorpus/tei:teiHeader"/> -->
				<xsl:for-each select="tei:teiCorpus/tei:TEI">
					<br/>
					<xsl:apply-templates/>
					<br/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="tei:teiCorpus/tei:TEI">
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
		<h2>
			<xsl:apply-templates select="tei:title"/>
		</h2>
		<h3>Publication Details</h3>
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
		<p>
			<xsl:apply-templates select="tei:availability"/>
		</p>
		<p>
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
		<h3>Manuscript Details: <xsl:value-of select="$msref"/></h3>
		<xsl:for-each select="tei:note/tei:p">
			<p>
				<xsl:apply-templates/>
			</p>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="tei:teiHeader/tei:fileDesc/tei:sourceDesc">
		<p>
			<xsl:apply-templates select="tei:msDesc/tei:msContents/tei:summary"/>
		</p>
		<xsl:for-each select="tei:msDesc/tei:msContents/tei:msItem">
			<h4>
				<xsl:apply-templates select="tei:title"/>
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
			<xsl:if test="@resp">
				<xsl:text>Main scribe: </xsl:text>
				<xsl:value-of select="key('hands', @resp)/tei:forename"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="key('hands', @resp)/tei:surname"/>
				<xsl:text> (</xsl:text>
				<xsl:value-of select="@resp"/>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:if test="child::tei:msItem">
				<xsl:for-each select="child::tei:msItem">
					<h5 style="margin-left:40px">
						<xsl:apply-templates select="tei:title"/>
					</h5>
					<p style="margin-left:40px">
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
					</p>
				</xsl:for-each>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="tei:pb">
		<br/>
		<hr align="left" width="40%"/>
		<p align="left">
			<xsl:choose>
				<xsl:when test="ancestor::tei:div//tei:handShift">
					<xsl:choose>
						<xsl:when test="preceding::tei:handShift">
							<b><xsl:value-of select="@n"/>: <xsl:value-of
									select="key('hands', preceding::tei:handShift[1]/@new)/tei:forename"
									/><xsl:text> </xsl:text><xsl:value-of
									select="key('hands', preceding::tei:handShift[1]/@new)/tei:surname"
									/><xsl:text> (</xsl:text><xsl:value-of
									select="preceding::tei:handShift[1]/@new"
								/><xsl:text>)</xsl:text></b>
						</xsl:when>
						<xsl:otherwise>
							<b><xsl:value-of select="@n"/>: <xsl:value-of
									select="key('hands', ancestor::tei:div/@resp)/tei:forename"
									/><xsl:text> </xsl:text><xsl:value-of
									select="key('hands', ancestor::tei:div/@resp)/tei:surname"
									/><xsl:text> (</xsl:text><xsl:value-of
									select="ancestor::tei:div/@resp"/><xsl:text>) </xsl:text></b>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<b><xsl:value-of select="@n"/>: <xsl:value-of
							select="key('hands', ancestor::tei:div/@resp)/tei:forename"
							/><xsl:text> </xsl:text><xsl:value-of
							select="key('hands', ancestor::tei:div/@resp)/tei:surname"
							/><xsl:text> (</xsl:text><xsl:value-of select="ancestor::tei:div/@resp"
						/><xsl:text>) </xsl:text></b>
				</xsl:otherwise>
			</xsl:choose>
			<button onclick="createTable()">Collect Slips</button>
		</p>
	</xsl:template>
	
	<xsl:template match="tei:cb">
		<br/>
		<b>Column:<xsl:text> </xsl:text></b><xsl:value-of select="@n"/>
	</xsl:template>

	<xsl:template match="tei:p//tei:lb">
		<br/>
		<xsl:value-of select="@n"/>
		<xsl:text>. </xsl:text>
	</xsl:template>

	<xsl:template match="tei:lb[ancestor::tei:lg] | tei:lb[ancestor::tei:w[ancestor::tei:lg]]">
		<sub><xsl:value-of select="@n"/>.</sub>
	</xsl:template>

	<xsl:template match="tei:lg">
		<xsl:choose>
			<xsl:when test="count(parent::tei:div//tei:lg[@type = 'stanza']) > 1">
				<br/>
				<b align="left">
					<a title="Stanza number" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">
						<xsl:value-of select="@n"/>
					</a>
				</b>
				<br/>
				<p style="margin-left:30px">
					<xsl:apply-templates select="descendant::tei:l"/>
				</p>
			</xsl:when>
			<xsl:otherwise>
				<p style="margin-left:30px">
					<b align="left">
						<a title="Dictum number" href="#" onclick="return false;"
							style="text-decoration:none; color:#000000">
							<xsl:value-of select="@n"/>
						</a>
						<xsl:text>. </xsl:text>
					</b>
					<xsl:text>  </xsl:text>
					<xsl:apply-templates select="descendant::tei:l"/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:apply-templates/>
		<br/>
	</xsl:template>

	<xsl:template match="tei:w[not(descendant::tei:w)]">
		<xsl:variable name="lem">
			<xsl:choose>
				<xsl:when test="@lemma = 'UNKNOWN'">[lemma unknown]</xsl:when>
				<xsl:when test="not(@lemma)">
					<xsl:choose>
						<xsl:when test="ancestor::tei:name">
							<xsl:choose>
								<xsl:when test="ancestor::tei:name/@type = 'place'"><xsl:value-of
										select="ancestor::tei:name/@type"/>name</xsl:when>
								<xsl:otherwise><xsl:value-of select="ancestor::tei:name/@type"/>
									name</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:when test="@xml:lang">Language: <xsl:value-of select="key('lang', @xml:lang)/text()"
							/></xsl:when>
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
		<xsl:variable name="lemRef" select="@lemmaRef"/>
		<xsl:variable name="an" select="@ana"/>
		<xsl:variable name="prob">
			<xsl:if test="descendant::*[@reason] or ancestor::*[@reason]">
				<xsl:for-each select="descendant::*[@reason] | ancestor::*[@reason]">
					<xsl:choose>
						<xsl:when test="@reason = 'interp_obscure'">
							<xsl:text xml:space="preserve">- the interpretation of this word, in itself or in context, is doubtful &#10;</xsl:text>
						</xsl:when>
						<xsl:when test="@reason = 'text_obscure'">
							<xsl:text xml:space="preserve">- some or all of this word is difficult to decipher &#10;</xsl:text>
						</xsl:when>
						<xsl:when test="@reason = 'abbrv'">
							<xsl:text xml:space="preserve">- this reading involves an abbreviation that cannot be expanded with certainty &#10;</xsl:text>
						</xsl:when>
						<xsl:when test="@reason = 'damage'">
							<xsl:text xml:space="preserve">- loss of vellum; some characters are lost and may have been supplied by an editor &#10;</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="ancestor::tei:choice">
				<xsl:text xml:space="preserve">- there is a possible alternative to this reading &#10;</xsl:text>
			</xsl:if>
			<xsl:if test="ancestor::tei:supplied">
				<xsl:text xml:space="preserve">- this word has been supplied by an editor &#10;</xsl:text>
			</xsl:if>
			<xsl:if test="descendant::tei:supplied">
				<xsl:text xml:space="preserve">- some characters have been supplied by an editor &#10;</xsl:text>
			</xsl:if>
			<xsl:if test="@xml:lang">
				<xsl:text xml:space="preserve">- this word is in a language other than Gaelic &#10;</xsl:text>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="certProb">
			<xsl:if test="ancestor::*[@cert] or descendant::*[@cert]">
				<xsl:for-each select="ancestor::*[@cert] | descendant::*[@cert]">
					<xsl:choose>
						<xsl:when test="@cert = 'High'">Slight/possible problems with this reading
							&#10;</xsl:when>
						<xsl:when test="@cert = 'medium'">Moderate problems with this reading
							&#10;</xsl:when>
						<xsl:when test="@cert = 'low'">Serious problems with this reading
							&#10;</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
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
			<xsl:if test="descendant::tei:abbr or ancestor::tei:abbr">
				<xsl:for-each select="descendant::tei:abbr/tei:g | ancestor::tei:abbr/tei:g">
					<xsl:value-of select="key('abbrs', @ref)/@corresp"/>
					<xsl:text>&#10;</xsl:text>
				</xsl:for-each>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="certLvl">
			<xsl:choose>
				<xsl:when
					test="ancestor-or-self::*[@cert = 'medium'] or descendant-or-self::*[@cert = 'medium']"
					>Moderate</xsl:when>
				<xsl:when test="ancestor-or-self::tei:unclear or descendant-or-self::tei:unclear"
					>Moderate</xsl:when>
				<xsl:when
					test="ancestor-or-self::*[@cert = 'low'] or descendant-or-self::*[@cert = 'low']"
					>Severe</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="handRef">
			<xsl:choose>
				<xsl:when test="ancestor::tei:div[@resp]/descendant::tei:handShift">
					<xsl:choose>
						<xsl:when test="preceding::tei:handShift">
							<xsl:value-of select="preceding::tei:handShift/@new[1]"/>
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
		</xsl:variable>
		<xsl:variable name="hand">
			<xsl:choose>
				<xsl:when test="descendant::tei:handShift">
					<xsl:value-of select="key('hands', $handRef)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="key('hands', $handRef)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="$handRef"/>
					<xsl:text>) / </xsl:text><xsl:value-of select="key('hands', descendant::tei:handShift/@new)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of select="key('hands', descendant::tei:handShift/@new)/tei:surname"/>
					<xsl:text> (</xsl:text>
					<xsl:value-of select="descendant::tei:handShift/@new"/><xsl:text>) </xsl:text>
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
		<xsl:variable name="handDate">
			<xsl:value-of select="key('hands', $handRef)/tei:date"/>
		</xsl:variable>
		<xsl:variable name="shelfmark">
			<xsl:value-of
				select="concat(ancestor::tei:TEI//tei:msIdentifier/tei:repository, ' ', ancestor::tei:TEI//tei:msIdentifier/tei:idno)"
			/>
		</xsl:variable>
		<xsl:variable name="msref">
			<xsl:value-of
				select="concat($shelfmark, ' ', preceding::tei:pb[1]/@n, ' ', preceding::tei:lb[1]/@n)"
			/>
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
			<xsl:value-of select="key('pos', @ana)"/>
		</xsl:variable>
		<a id="{generate-id()}" lemma="{$lem}" lemmaRef="{$lemRef}" ana="{@ana}" hand="{$hand}"
			ref="{$msref}" date="{$handDate}" medium="{$medium}" cert="{$certLvl}"
			abbrRefs="{$abbrRef}"
			title="{$lem}: {$pos}&#10;{$hand}&#10;{$prob}{$certProb}&#10;Abbreviations: {$abbrs}"
			style="text-decoration:none; color:#000000">
			<xsl:if test="@lemma">
				<xsl:attribute name="onclick">addSlip(this.id)</xsl:attribute>
			</xsl:if>
			<xsl:if test="@lemmaRef">
				<xsl:attribute name="href">
					<xsl:value-of select="@lemmaRef"/>
				</xsl:attribute>
				<xsl:attribute name="target">
					<xsl:value-of select="@lemmaRef"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</a>
		<xsl:choose>
			<xsl:when test="not(ancestor::tei:w)">
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="@ana = 'part' and ancestor::tei:w[contains(@ana, 'part, verb')]">
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="@ana = 'part' and ancestor::tei:w[contains(@ana, 'part, pron, verb')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'part, pron, verb')]">
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, pron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, pron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'conj' and ancestor::tei:w[contains(@ana, 'noun, verb')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'verb' and ancestor::tei:w[contains(@ana, 'verb, pron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when
				test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, noun')] and following-sibling::tei:w[@ana = 'noun']">
				<xsl:text/>
			</xsl:when>
			<xsl:when
				test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, noun')] and following-sibling::tei:w[@ana = 'noun']">
				<xsl:text/>
			</xsl:when>
			<xsl:when
				test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, adj')] and following-sibling::tei:w[@ana = 'adj']">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'num' and ancestor::tei:w[contains(@ana, 'num, noun')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pref' and ancestor::tei:w[contains(@ana, 'pref, adj')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, part')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, verb')]">
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

	<xsl:template match="tei:name">
		<xsl:apply-templates/>
	</xsl:template>

	<!--	<xsl:template match="tei:w">
		 <xsl:variable name="handRef">
			<xsl:choose>
				<xsl:when test="ancestor::tei:div[@resp]/descendant::tei:handShift">
					<xsl:choose>
						<xsl:when test="preceding::tei:handShift">
							<xsl:value-of select="preceding::tei:handShift/@new[1]"/>
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
		</xsl:variable>
		<xsl:variable name="hand">
			<xsl:value-of select="key('hands', $handRef)/tei:forename"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="key('hands', $handRef)/tei:surname"/>
			<xsl:text> (</xsl:text>
			<xsl:value-of select="$handRef"/>
			<xsl:text>) </xsl:text>
		</xsl:variable>
		<xsl:variable name="handDate">
			<xsl:value-of select="key('hands', $handRef)/tei:date"/>
		</xsl:variable>
		<xsl:variable name="shelfmark">
			<xsl:value-of
				select="concat(ancestor::tei:TEI//tei:msIdentifier/tei:settlement, ', ', ancestor::tei:TEI//tei:msIdentifier/tei:repository, ' ', ancestor::tei:TEI//tei:msIdentifier/tei:idno)"
			/>
		</xsl:variable>
		<xsl:variable name="msref">
			<xsl:value-of
				select="concat($shelfmark, ' ', preceding::tei:pb[1]/@n, preceding::tei:lb[1]/@n)"/>
		</xsl:variable>
		<xsl:variable name="prob">
			<xsl:choose>
				<xsl:when
					test="ancestor-or-self::*[@cert = 'medium'] or descendant-or-self::*[@cert = 'medium']"
					>Moderate</xsl:when>
				<xsl:when test="ancestor-or-self::tei:unclear or descendant-or-self::tei:unclear"
					>Moderate</xsl:when>
				<xsl:when
					test="ancestor-or-self::*[@cert = 'low'] or descendant-or-self::*[@cert = 'low']"
					>Severe</xsl:when>
				<xsl:when test="ancestor::tei:supplied">Form supplied by editor</xsl:when>
				<xsl:when test="/@xml:lang">Word in a language other than Gaelic</xsl:when>
				<xsl:when test="descendant::tei:supplied">Some characters supplied by
					editor</xsl:when>
				<xsl:otherwise>None</xsl:otherwise>
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
		<xsl:choose>
			<xsl:when test="not(@lemma)">
				<xsl:choose>
					<xsl:when test="ancestor::tei:name[@type = 'personal']">
						<a title="Personal name" href="#" onclick="return false;"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/>
						</a>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:when test="ancestor::tei:name[@type = 'place']">
						<a title="Placename" href="#" onclick="return false;"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/>
						</a>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:when test="ancestor::tei:name[@type = 'population']">
						<a title="Population group name" href="#" onclick="return false;"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/>
						</a>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:when test="@xml:lang">
						<a title="Language = '{@xml:lang}'" href="#" onclick="return false;"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/>
						</a>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="@ana">
								<a title="{@ana}; lemma unavailable" href="#"
									onclick="return false;"
									style="text-decoration:none; background-color:#ffff00">
									<xsl:apply-templates/>
								</a>
								<xsl:text> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<a title="PoS unavailable; lemma unavailable" href="#"
									onclick="return false;"
									style="text-decoration:none; background-color:#ffff00">
									<xsl:apply-templates/>
								</a>
								<xsl:text> </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="@lemma = 'UNKNOWN'">
				<xsl:choose>
					<xsl:when test="@ana">
						<a title="{@ana}; lemma unknown" href="#" onclick="return false;"
							style="text-decoration:none; background-color:#ffff00">
							<xsl:apply-templates/>
						</a>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<a title="PoS unavailable; lemma unknown" href="#" onclick="return false;"
							style="text-decoration:none; background-color:#ffff00">
							<xsl:apply-templates/>
						</a>
						<xsl:text> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="ancestor::tei:name[@type = 'personal']">
						<a href="{@lemmaRef}" title="'{@lemma}'; {@ana} (personal name)"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/>
						</a>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:when test="ancestor::tei:name[@type = 'place']">
						<a href="{@lemmaRef}" title="'{@lemma}'; {@ana} (placename)"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/>
						</a>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<a id="{generate-id()}" onclick="addSlip(this.id)" lemma="{@lemma}"
							lemmaRef="{@lemmaRef}" ana="{@ana}" title="'{@lemma}'; {@ana}"
							hand="{$hand}" ref="{$msref}" date="{$handDate}" problem="{$prob}"
							medium="{$medium}" style="text-decoration:none; color:#000000">
							<xsl:apply-templates/>
						</a>
						<xsl:text> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> -->

	<!-- <xsl:template match="tei:w[ancestor::tei:w]">
		<xsl:choose>
			<xsl:when test="@ana = 'part' and ancestor::tei:w[contains(@ana, 'part, verb')] | ancestor::tei:w[contains(@ana, 'part, pron, verb')]">
					<xsl:apply-templates/>
					<xsl:text>-</xsl:text>
			</xsl:when>
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'part, pron, verb')]">
					<xsl:apply-templates/>
					<xsl:text>-</xsl:text>
			</xsl:when>
			<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, pron')]">
					<xsl:apply-templates/>
					<xsl:text>-</xsl:text>
			</xsl:when>
			<xsl:when test="@ana = 'verb' and ancestor::tei:w[contains(@ana, 'verb, pron')]">
					<xsl:apply-templates/>
					<xsl:text>-</xsl:text>
			</xsl:when>
			<xsl:when test="@ana = 'adv' and ancestor::tei:w[contains(@ana, 'adv, verb')]">
					<xsl:apply-templates/>
					<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="not(following-sibling::*)">
					<xsl:apply-templates/>
					<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
					<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> -->

	<xsl:template match="tei:date">
		<a id="{generate-id()}" href="#" onclick="return false;"
			style="text-decoration:none; color:#000000">
			<xsl:apply-templates/>
		</a>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:c">
		<a id="{generate-id()}" title="Unexplained character" href="#" onclick="return false;"
			style="text-decoration:none; color:#000000">
			<xsl:apply-templates/>
		</a>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:pc">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>

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
		<xsl:choose>
			<xsl:when test="ancestor::tei:abbr[@cert = 'low']">
				<i style="background-color:#ffff00">
					<xsl:apply-templates/>
				</i>
			</xsl:when>
			<xsl:otherwise>
				<i>
					<xsl:apply-templates/>
				</i>
			</xsl:otherwise>
		</xsl:choose>
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
		<xsl:choose>
			<xsl:when test="@extent = 'unknown'">
				<a id="{generate-id()}" title="{concat(@extent, ' extent')}, {@reason}" href="#"
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
				<a id="{generate-id()}" title="{@extent}, {@reason}" href="#"
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

	<xsl:template match="tei:choice">
		<xsl:choose>
			<xsl:when test="child::tei:sic | tei:corr">
				<xsl:apply-templates select="child::tei:corr"/>
				<a id="{generate-id()}" title="MS: {child::tei:sic}">
						<xsl:if test="tei:sic//tei:w/@lemma">
							<xsl:attribute name="href">
								<xsl:value-of select="child::tei:sic//tei:w[not(descendant::tei:w)]/@lemmaRef"/>
							</xsl:attribute>
							<xsl:attribute name="style">text-decoration:none; color:#000000</xsl:attribute>
							</xsl:if>
							<sub>
								<b>
									<i>alt</i>
								</b>
							</sub>
						</a>
						<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="child::tei:unclear">
				<xsl:text>{</xsl:text><xsl:for-each select="tei:unclear[@n = '1']/descendant::*[@n]"><xsl:variable name="wpos" select="@n"/>
					<xsl:apply-templates select="self::*"/><xsl:if test="ancestor::tei:choice/tei:unclear[@n = '2']/descendant::*/@n = $wpos"><a id="{generate-id()}" title="Or, {ancestor::tei:choice/tei:unclear[@n = '2']/descendant::tei:w[@n = $wpos]}">
						<xsl:if test="ancestor::tei:choice/tei:unclear[@n = '2']/descendant::*[@n = $wpos]/@lemma">
							<xsl:attribute name="href">
								<xsl:value-of select="ancestor::tei:choice/tei:unclear[@n = '2']/descendant::*[@n = $wpos]/@lemmaRef"/>
							</xsl:attribute>
							<xsl:attribute name="style">text-decoration:none; color:#000000</xsl:attribute>
						</xsl:if>
						<sub>
							<b>
								<i>alt</i>
							</b>
						</sub>
					</a>
						</xsl:if>
				</xsl:for-each>
				<xsl:for-each select="tei:unclear[@n = '2']/*[@n > ancestor::tei:choice/tei:unclear[@n = '1']//tei:w//@n]">
					<a id="{generate-id()}" title="{self::*}">
						<xsl:if test="@lemma">
							<xsl:attribute name="href">
								<xsl:value-of select="@lemmaRef"/>
							</xsl:attribute>
							<xsl:attribute name="style">text-decoration:none; color:#000000</xsl:attribute>
						</xsl:if>
						<sub>
							<b>
								<i><xsl:text> </xsl:text>alt<xsl:text> </xsl:text></i>
							</b>
						</sub>
					</a>
				</xsl:for-each><xsl:text>} </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- <xsl:template match="tei:choice[descendant::tei:w]">
		<xsl:choose>
			<xsl:when test="child::tei:abbr or child::tei:unclear or child::tei:seg">
				<xsl:choose>
					<xsl:when test="count(child::tei:seg/*/tei:w) > 1">
						<a id="{generate-id()}" title="{child::tei:unclear/@reason}"
							style="text-decoration:none; color:#000000" href="#"
							onclick="return false">{</a>
						<xsl:for-each select="tei:seg">
							<xsl:apply-templates select="child::*[@n = '1']/tei:w"/>
							<xsl:if test="child::*[@n = '2']/tei:w">
								<sub>
									<b>
										<i>
											<a id="{generate-id()}"
												title="Or, {child::*[@n = '2']} ({child::*[@n = '2']/tei:w/@lemma}); {child::*[@n = '2']/tei:w/@ana}"
												href="{child::*[@n = '2']/tei:w/@lemmaRef}"
												style="text-decoration:none; color:#000000">alt </a>
										</i>
									</b>
								</sub>
							</xsl:if>
						</xsl:for-each>
						<a id="{generate-id()}" title="{child::tei:unclear/@reason}"
							style="text-decoration:none; color:#000000" href="#"
							onclick="return false">}</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="child::*[@n = '1']"/>
						<sub>
							<b>
								<i>
									<a id="{generate-id()}"
										title="Or, {child::*[@n='2']//*} ({child::*[@n='2']//*/@lemma}); {child::*[@n='2']//*/@ana}"
										href="{child::*[@n='2']//*/@lemmaRef}"
										style="text-decoration:none; color:#000000">alt </a>
								</i>
							</b>
						</sub>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="child::tei:sic">
				<xsl:choose>
					<xsl:when
						test="count(child::tei:sic/tei:w) > 1 or count(child::tei:corr/tei:w) > 1">
						<xsl:for-each select="tei:corr//tei:w[@n]">
							<xsl:apply-templates select="self::*"/>
							<xsl:variable name="wpos" select="self::*/@n"/>
							<xsl:choose>
								<xsl:when test="ancestor::tei:choice/tei:sic/tei:w/@lemmaRef">
									<sub>
										<b>
											<i>
												<a id="{generate-id()}"
												title="MS: {ancestor::tei:choice/tei:sic//tei:w[@n = $wpos]}; {ancestor::tei:choice/tei:sic//tei:w[@n = $wpos]/@ana}"
												href="{ancestor::tei:choice/tei:sic//tei:w[@n = $wpos]/@lemmaRef}"
												style="text-decoration:none; color:#000000"
												>alt</a>
											</i>
										</b>
									</sub>
								</xsl:when>
								<xsl:when test="ancestor::tei:choice/tei:sic/tei:w[not(@lemmaRef)]">
									<sub>
										<b>
											<i>
												<a id="{generate-id()}"
												title="MS: {ancestor::tei:choice/tei:sic//tei:w[@n = $wpos]}"
												href="#" onclick="return false;"
												style="text-decoration:none; color:#000000"
												>alt</a>
											</i>
										</b>
									</sub>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="tei:corr"/>
						<xsl:choose>
							<xsl:when test="child::tei:sic/tei:w/@lemmaRef">
								<a id="{generate-id()}" href="{child::tei:sic/tei:w/@lemmaRef}"
									title="MS: {child::tei:sic//*}"
									style="text-decoration:none; color:#000000">
									<sub>
										<b>
											<i>alt </i>
										</b>
									</sub>
								</a>
							</xsl:when>
							<xsl:when test="child::tei:sic/tei:w[not(@lemmaRef)]">
								<a id="{generate-id()}" title="MS: {child::tei:sic//*}"
									style="text-decoration:none; color:#000000" href="#"
									onclick="return false;">
									<sub>
										<b>
											<i>alt </i>
										</b>
									</sub>
								</a>
							</xsl:when>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:choice[not(descendant::tei:w)]">
		<xsl:apply-templates select="tei:corr"/>
		<a id="{generate-id()}" title="MS: {child::tei:sic//*}" href="#"
			style="text-decoration:none; color:#000000" onclick="return false">
			<sub>
				<b>
					<i>alt </i>
				</b>
			</sub>
		</a>
	</xsl:template> -->

	<xsl:template match="tei:note[@type = 'fn']">
		<sup>
			<b>
				<a id="{generate-id()}" title="{descendant::tei:p}">
					<xsl:value-of select="@n"/>
				</a>
			</b>
		</sup>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:add[@type = 'insertion']">
		<xsl:choose>
			<xsl:when test="@place = 'above'">
				<b> \ </b>
				<xsl:text> </xsl:text>
				<xsl:apply-templates/>
				<b> / </b>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="@place = 'below'">
				<b> / </b>
				<xsl:text> </xsl:text>
				<xsl:apply-templates/>
				<b> \ </b>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="@place = 'margin, right'">
				<b> &lt; </b>
				<xsl:text> </xsl:text>
				<xsl:apply-templates/>
				<b> &lt; </b>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="@place = 'margin, left'">
				<b> &gt; </b>
				<xsl:text> </xsl:text>
				<xsl:apply-templates/>
				<b> &gt; </b>
				<xsl:text> </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:add[@type = 'gloss']">
		<b>
			<xsl:text>gl. </xsl:text>
		</b>
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
		<!-- Write a function to display the gloss in a new window? -->
	</xsl:template>

	<xsl:template match="tei:handShift">
		<xsl:text> </xsl:text><sub>
			<b>
				new hand
			</b>
		</sub><xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:div[@n]">
		<!-- <xsl:if test="/@resp = not(preceding::tei:div/@resp or preceding::tei:handShift/@new)">
			<sub>
				<b>beg. <xsl:value-of select="key('hands', @resp)/tei:forename"
						/><xsl:text> </xsl:text><xsl:value-of
						select="key('hands', @resp)/tei:surname"
						/><xsl:text> (</xsl:text><xsl:value-of select="@resp"
					/><xsl:text>) </xsl:text></b>
			</sub>
		</xsl:if> -->
		<h2>
			<xsl:value-of select="key('divTitle', @corresp)/tei:title"/>
		</h2>
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>

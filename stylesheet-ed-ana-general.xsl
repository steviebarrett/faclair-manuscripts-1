<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.0">

	<xsl:output method="html"/>

	<xsl:key name="abbrs" match="*" use="@xml:id"/>
	<xsl:key name="hands" match="*" use="@xml:id"/>


	<xsl:template match="/">
		<html>
			<head>
				<title> Report: <xsl:value-of
						select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				</title>
				<script src="sortTable.js"/>
			</head>
			<body>
				<table border="1px solid black" id="tbl">
					<tr>
						<th onclick="sortTable(0)">
							<b>Form</b>
						</th>
						<th onclick="sortTable(1)">
							<b>Lemma</b>
						</th>
						<th onclick="sortTable(2)">
							<b>Part of Speech</b>
						</th>
						<th onclick="sortTable(3)">
							<b>Scribe</b>
						</th>
						<th onclick="sortTable(4)">
							<b>Div</b>
						</th>
						<th onclick="sortTable(5)">
							<b>Reference</b>
						</th>
						<th onclick="sortTable(6)">
							<b>Context</b>
						</th>
					</tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w)]">
						<xsl:sort select="@lemma"/>
						<xsl:sort select="@ana"/>
						<tr>
							<td>
								<xsl:apply-templates/>
							</td>
							<td>
								<a href="{@lemmaRef}">
									<xsl:value-of select="@lemma"/>
								</a>
							</td>
							<td>
								<xsl:value-of select="@ana"/>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="ancestor::tei:div//tei:handShift">
										<xsl:value-of
											select="key('hands', preceding::tei:handShift[1]/@new)/tei:forename | key('hands', preceding::tei:div[1]/@resp)/tei:forename"/>
										<xsl:text> </xsl:text>
										<xsl:value-of
											select="key('hands', preceding::tei:handShift[1]/@new)/tei:surname | key('hands', preceding::tei:div[1]/@resp)/tei:surname"
										/><xsl:text> (</xsl:text><xsl:value-of select="preceding::tei:handShift[1]/@new | preceding::tei:div[1]/@resp"/><xsl:text>)</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of
											select="key('hands', ancestor::tei:div[1]/@resp)/tei:forename"/>
										<xsl:text> </xsl:text>
										<xsl:value-of
											select="key('hands', ancestor::tei:div[1]/@resp)/tei:surname"
										/><xsl:text> (</xsl:text><xsl:value-of select="ancestor::tei:div[1]/@resp"/><xsl:text>)</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:value-of select="ancestor::tei:div[@n][1]/@n"/>
							</td>
							<td>
								<xsl:value-of select="preceding::tei:lb[1]/@xml:id | preceding::tei:lb[1]/@sameAs"/>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="ancestor::tei:div[@type='verse'][1] | ancestor::tei:div[@type='divprose'][1]">
										<xsl:apply-templates select="ancestor::tei:l[1]"/>
									</xsl:when>
									<xsl:when test="ancestor::*[parent::tei:p]">
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][8]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][7]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][6]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][5]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][4]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][3]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][2]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][1]"/>
										<b><xsl:apply-templates select="ancestor::*[parent::tei:p]"/></b>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][1]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][2]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][3]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][4]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][5]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][6]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][7]"/>
										<xsl:apply-templates select="ancestor::*[parent::tei:p]/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][8]"/>	
									</xsl:when>
									<!-- <xsl:when test="ancestor::tei:name">
										<xsl:apply-templates select="ancestor::tei:name/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][8]"/>
										<xsl:apply-templates select="ancestor::tei:name/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][7]"/>
										<xsl:apply-templates select="ancestor::tei:name/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][6]"/>
										<xsl:apply-templates select="ancestor::tei:name/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][5]"/>
										<xsl:apply-templates select="ancestor::tei:name/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][4]"/>
										<xsl:apply-templates select="ancestor::tei:name/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][3]"/>
										<xsl:apply-templates select="ancestor::tei:name/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][2]"/>
										<xsl:apply-templates select="ancestor::tei:name/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][1]"/>
										<b><xsl:apply-templates select="ancestor::tei:name[not(ancestor::tei:name)]"/></b>
										<xsl:apply-templates select="ancestor::tei:name/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][1]"/>
										<xsl:apply-templates select="ancestor::tei:name/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][2]"/>
										<xsl:apply-templates select="ancestor::tei:name/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][3]"/>
										<xsl:apply-templates select="ancestor::tei:name/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][4]"/>
										<xsl:apply-templates select="ancestor::tei:name/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][5]"/>
										<xsl:apply-templates select="ancestor::tei:name/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][6]"/>
										<xsl:apply-templates select="ancestor::tei:name/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][7]"/>
										<xsl:apply-templates select="ancestor::tei:name/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][8]"/>
									</xsl:when>
									<xsl:when test="ancestor::tei:w">
										<xsl:apply-templates select="ancestor::tei:w/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][8]"/>
										<xsl:apply-templates select="ancestor::tei:w/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][7]"/>
										<xsl:apply-templates select="ancestor::tei:w/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][6]"/>
										<xsl:apply-templates select="ancestor::tei:w/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][5]"/>
										<xsl:apply-templates select="ancestor::tei:w/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][4]"/>
										<xsl:apply-templates select="ancestor::tei:w/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][3]"/>
										<xsl:apply-templates select="ancestor::tei:w/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][2]"/>
										<xsl:apply-templates select="ancestor::tei:w/preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][1]"/>
										<b><xsl:apply-templates select="ancestor::tei:w[not(ancestor::tei:w)]"/></b>
										<xsl:apply-templates select="ancestor::tei:w/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][1]"/>
										<xsl:apply-templates select="ancestor::tei:w/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][2]"/>
										<xsl:apply-templates select="ancestor::tei:w/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][3]"/>
										<xsl:apply-templates select="ancestor::tei:w/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][4]"/>
										<xsl:apply-templates select="ancestor::tei:w/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][5]"/>
										<xsl:apply-templates select="ancestor::tei:w/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][6]"/>
										<xsl:apply-templates select="ancestor::tei:w/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][7]"/>
										<xsl:apply-templates select="ancestor::tei:w/following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][8]"/>
									</xsl:when> -->
									<xsl:otherwise>
										<xsl:apply-templates select="preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][8]"/>
										<xsl:apply-templates select="preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][7]"/>
										<xsl:apply-templates select="preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][6]"/>
										<xsl:apply-templates select="preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][5]"/>
										<xsl:apply-templates select="preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][4]"/>
										<xsl:apply-templates select="preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][3]"/>
										<xsl:apply-templates select="preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][2]"/>
										<xsl:apply-templates select="preceding::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][1]"/>
										<b><xsl:apply-templates/><xsl:text> </xsl:text></b>
										<xsl:apply-templates select="following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][1]"/>
										<xsl:apply-templates select="following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][2]"/>
										<xsl:apply-templates select="following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][3]"/>
										<xsl:apply-templates select="following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][4]"/>
										<xsl:apply-templates select="following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][5]"/>
										<xsl:apply-templates select="following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][6]"/>
										<xsl:apply-templates select="following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][7]"/>
										<xsl:apply-templates select="following::*[parent::tei:p or parent::tei:l and not(tei:lg|tei:note[@type='fn'])][8]"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
						</tr>
					</xsl:for-each>
				</table>
				
			</body>
		</html>
	</xsl:template>

	<!-- <xsl:template match="tei:pb">
		<br/>
		<hr align="left" width="40%"/>
		<p align="left">
			<xsl:choose>
				<xsl:when test="ancestor::tei:div//tei:handShift">
					<b><xsl:value-of select="@n"/>: <xsl:value-of
							select="preceding::tei:handShift/@new"/></b>
				</xsl:when>
				<xsl:otherwise>
					<b><xsl:value-of select="@n"/>: <xsl:value-of select="ancestor::tei:div/@resp"
						/></b>
				</xsl:otherwise>
			</xsl:choose>
		</p>
	</xsl:template> -->

	<!-- <xsl:template match="tei:p//tei:lb">
		<br/>
		<xsl:value-of select="@n"/>
		<xsl:text>. </xsl:text>
		<xsl:apply-templates/>
	</xsl:template> -->

	<xsl:template match="//tei:lg//tei:lb">
		<sub><a title="MS fol/p {preceding::tei:pb/@n}, line {@n}" href="#" onclick="return false;"
				style="text-decoration:none; color:#000000"><xsl:value-of select="@n"/></a>. </sub>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="tei:p">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- <xsl:template match="tei:lg">
		<xsl:choose>
			<xsl:when test="count(parent::tei:div//tei:lg[@type = 'stanza']) > 1">
				<b align="left">
					<a title="Stanza number" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">
						<xsl:value-of select="@n"/>
					</a>
				</b><p style="margin-left:30px"><xsl:apply-templates select="descendant::tei:l"/></p>
			</xsl:when>
			<xsl:otherwise>
				<p style="margin-left:30px"><xsl:apply-templates select="descendant::tei:l"/></p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> -->

	<xsl:template match="tei:l">
		<xsl:apply-templates/>
		<xsl:text> || </xsl:text>
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
						<xsl:when test="@xml:lang">Other lang.: <xsl:value-of select="@xml:lang"
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
							<xsl:text xml:space="preserve">- this word is based on the doubtful expansion of an abbreviation &#10;</xsl:text>
						</xsl:when>
						<xsl:when test="@reason = 'damage'">
							<xsl:text xml:space="preserve">- loss of vellum means some characters are lost and have had to be supplied &#10;</xsl:text>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="certProb">
			<xsl:if test="ancestor::*[@cert] or descendant::*[@cert]">
				<xsl:for-each select="ancestor::*[@cert] | descendant::*[@cert]">
					<xsl:choose>
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
				<xsl:when test="ancestor::tei:supplied">Form supplied by editor</xsl:when>
				<xsl:when test="@xml:lang">Word in a language other than Gaelic</xsl:when>
				<xsl:when test="descendant::tei:supplied">Some characters supplied by
					editor</xsl:when>
				<xsl:otherwise>None</xsl:otherwise>
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
				select="concat(ancestor::tei:TEI//tei:msIdentifier/tei:repository, ' ', ancestor::tei:TEI//tei:msIdentifier/tei:idno)"
			/>
		</xsl:variable>
		<xsl:variable name="msref">
			<xsl:value-of
				select="concat($shelfmark, ' ', preceding::tei:pb[1]/@n, preceding::tei:lb[1]/@n)"/>
		</xsl:variable>
		<xsl:variable name="medium">
			<xsl:choose>
				<xsl:when test="ancestor::tei:div/@type = 'verse'">Verse</xsl:when>
				<xsl:when
					test="ancestor::tei:div/@type = 'prose' or ancestor::tei:div/@type = 'divprose'"
					>Prose</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<a id="{generate-id()}" onclick="addSlip(this.id)" lemma="{$lem}" lemmaRef="{$lemRef}"
			ana="{@ana}" hand="{$hand}" ref="{$msref}" date="{$handDate}" medium="{$medium}"
			cert="{$certLvl}" abbrRefs="{$abbrRef}"
			title="{$lem}&#10;{@ana}&#10;{$prob}{$certProb}&#10;Abbreviations: {$abbrs}">
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
			<xsl:when test="not(following-sibling::*)">
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:supplied">
		<xsl:text>[</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="tei:g">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:abbr[@cert = 'low']/tei:g">
		<mark>
			<i>
				<xsl:apply-templates/>
			</i>
		</mark>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:choose>
			<xsl:when test="/@cert = 'low'">
				<xsl:text>{</xsl:text>
				<mark>
					<xsl:apply-templates/>
				</mark>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>{</xsl:text>
				<xsl:apply-templates/>
				<xsl:text>}</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:gap">
		<xsl:choose>
			<xsl:when test="@extent = 'unknown'">
				<a title="{concat(@extent, ' extent')}, {@reason}" href="#" onclick="return false;"
					style="text-decoration:none; color:#000000">
					<sub>
						<b>
							<i>-gap-</i>
						</b>
					</sub>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a title="{@extent}, {@reason}" href="#" onclick="return false;"
					style="text-decoration:none; color:#000000">
					<sub>
						<b>
							<i>-gap-</i>
						</b>
					</sub>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="tei:choice[//tei:w]">
		<xsl:choose>
			<xsl:when test="child::tei:abbr or child::tei:unclear or child::tei:seg">
				<xsl:choose>
					<xsl:when test="count(child::tei:seg/*/tei:w) > 1">
						<xsl:text>{</xsl:text>
						<xsl:for-each select="tei:seg">
							<xsl:apply-templates select="child::*[@n = '1']/tei:w"/>
							<xsl:if test="child::*[@n = '2']/tei:w">
								<sub>
									<b>
										<i>
											<a
												title="Or, {child::*[@n = '2']} ({child::*[@n = '2']/tei:w/@lemma}); {child::*[@n = '2']/tei:w/@ana}"
												href="{child::*[@n = '2']/tei:w/@lemmaRef}"
												style="text-decoration:none; color:#000000">alt </a>
										</i>
									</b>
								</sub>
							</xsl:if>
						</xsl:for-each>
						<xsl:text>}</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="child::*[@n = '1']"/>
						<sub>
							<b>
								<i>
									<a title="Or, {child::*[@n='2']}; {child::*[@n='2']/@ana}"
										href="{child::*[@n='2']/@lemmaRef}"
										style="text-decoration:none; color:#000000">alt </a>
								</i>
							</b>
						</sub>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="child::tei:sic and child::tei:corr">
				<xsl:apply-templates select="tei:corr"/>
				<sub>
					<b>
						<i>
							<xsl:choose>
								<xsl:when test="child::tei:sic/tei:w/@lemmaRef">
									<a href="{child::tei:sic/tei:w/@lemmaRef}"
										title="MS: {child::tei:sic/tei:w}"
										style="text-decoration:none; color:#000000"> alt </a>
								</xsl:when>
								<xsl:when test="child::tei:sic/tei:w[not(@lemmaRef)]">
									<a title="MS: {child::tei:sic/tei:w}"
										style="text-decoration:none; color:#000000"> alt </a>
								</xsl:when>
							</xsl:choose>
						</i>
					</b>
				</sub>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:note[@type = 'fn']">
		<p hidden="hidden"><xsl:apply-templates/></p>
	</xsl:template>

	<xsl:template match="tei:add">
		<xsl:choose>
			<xsl:when test="@place = 'above'">
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000"> \ </a>
				</b>
				<xsl:apply-templates/>
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">/ </a>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'below'">
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000"> / </a>
				</b>
				<xsl:apply-templates/>
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">\ </a>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, right'">
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">&lt; &lt;</a>
				</b>
				<xsl:apply-templates/>
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">&lt; &lt;</a>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, left'">
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">&gt; &gt;</a>
				</b>
				<xsl:apply-templates/>
				<b>
					<a title="{@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">&gt; &gt;</a>
				</b>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:handShift">
		<sub>
			<b> beg. <xsl:value-of select="@new"/>
			</b>
		</sub>
	</xsl:template>

	<xsl:template match="tei:div/@resp">
		<xsl:if test="not(preceding::tei:div/@resp or preceding::tei:handShift/@new)">
			<sub>
				<b> beg. <xsl:value-of select="@resp"/>
				</b>
			</sub>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.0">
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

	<xsl:attribute-set name="tblBorder">
		<xsl:attribute name="border">solid 0.1mm black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template mode="dip" name="tempDip" match="tei:teiCorpus/tei:TEI">
		<br/>
		<xsl:apply-templates mode="dip"/>
	</xsl:template>

	<xsl:template mode="dip" match="tei:teiHeader">
		<xsl:text/>
	</xsl:template>

	<xsl:template mode="dip" name="tempDipBody" match="tei:body">
		<xsl:apply-templates mode="dip"/>
	</xsl:template>

	<xsl:template mode="dip" match="tei:hi[@rend = 'italics']">
		<i>
			<xsl:apply-templates mode="dip"/>
		</i>
	</xsl:template>

	<xsl:template mode="dip" match="tei:hi[@rend = 'bold']">
		<b>
			<xsl:apply-templates mode="dip"/>
		</b>
	</xsl:template>

	<xsl:template mode="dip" match="tei:hi[@rend = 'sup']">
		<sup>
			<xsl:apply-templates mode="dip"/>
		</sup>
	</xsl:template>

	<xsl:template mode="dip" match="tei:hi[@rend = 'underline' and not(descendant::tei:w)]">
		<u>
			<xsl:apply-templates mode="dip"/>
		</u>
	</xsl:template>

	<xsl:template mode="dip" match="tei:pb">
		<table/>
		<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
			Comment</button>
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
		<button class="cs" onclick="createTable();beginCS(this)">Collect e-Slips</button>
		<button class="ws" onclick="createTable();beginWS(this)">Headword Search</button>
		<button class="es" onclick="endSearch(this)" hidden="hidden" style="background-color:red">
			<b>End Search</b></button>
		<br/>
	</xsl:template>

	<xsl:template mode="dip" match="tei:cb">
		<br/>
		<b>Col.<xsl:text> </xsl:text>
			<xsl:value-of select="@n"/></b>
		<br/>
	</xsl:template>

	<xsl:template mode="dip" match="tei:lb">
		<sub>
			<br id="{generate-id()}_dip"/>
			<xsl:value-of select="@n"/>
			<xsl:text>. </xsl:text>
		</sub>
	</xsl:template>

	<xsl:template mode="dip" match="tei:space[@type = 'scribal' or @type = 'editorial']">
		<xsl:choose>
			<xsl:when test="ancestor::tei:w[not(descendant::tei:w)]">
				<xsl:text>&#160;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<a id="{generate-id()}_dip">
					<xsl:text>&#160;</xsl:text>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="dip" match="tei:seg[@type = 'catchword']">
		<xsl:apply-templates mode="dip"/>
	</xsl:template>

	<xsl:template mode="dip" match="tei:seg[@type = 'cfe']">
		<xsl:text/>
	</xsl:template>

	<xsl:template mode="dip" match="tei:choice">
		<xsl:apply-templates mode="dip" select="tei:sic"/>
	</xsl:template>

	<xsl:template mode="dip" name="word" match="tei:w[not(descendant::tei:w)]">
		<xsl:variable name="wordId">
			<xsl:value-of select="generate-id()"/>
			<xsl:text>_dip</xsl:text>
		</xsl:variable>
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
					<xsl:for-each
						select="ancestor::tei:seg[@type = 'gloss']/tei:add[@type = 'gloss']/descendant::*">
						<xsl:if test="self::tei:w[not(descendant::tei:w)]">
							<xsl:value-of select="self::*"/>
						</xsl:if>
						<xsl:if test="self::tei:c">
							<xsl:value-of select="self::*"/>
						</xsl:if>
						<xsl:if test="self::tei:pc">
							<xsl:value-of select="self::*"/>
						</xsl:if>
						<xsl:if test="self::tei:date">
							<xsl:value-of select="self::*"/>
						</xsl:if>
						<xsl:if test="self::tei:num">
							<xsl:value-of select="self::*"/>
						</xsl:if>
						<xsl:if test="self::tei:space[@type = 'scribal' or @type = 'force']">
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:if test="self::tei:space[@type = 'em']">
							<xsl:text>   </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:text>"</xsl:text>
				</xsl:when>
				<xsl:when test="ancestor::tei:add[@type = 'gloss']">
					<xsl:text>This has been added as a gloss </xsl:text>
					<xsl:if test="ancestor::tei:seg[@type = 'gloss']">
						<xsl:text>on "</xsl:text>
						<xsl:for-each
							select="ancestor::tei:seg[@type = 'gloss']/child::*[not(ancestor-or-self::tei:add[@type = 'gloss'])]">
							<xsl:if test="self::tei:w[not(descendant::tei:w)]">
								<xsl:value-of select="self::*"/>
							</xsl:if>
							<xsl:if test="self::tei:c">
								<xsl:value-of select="self::*"/>
							</xsl:if>
							<xsl:if test="self::tei:pc">
								<xsl:value-of select="self::*"/>
							</xsl:if>
							<xsl:if test="self::tei:date">
								<xsl:value-of select="self::*"/>
							</xsl:if>
							<xsl:if test="self::tei:num">
								<xsl:value-of select="self::*"/>
							</xsl:if>
							<xsl:if test="self::tei:space[@type = 'scribal' or @type = 'force']">
								<xsl:text> </xsl:text>
							</xsl:if>
							<xsl:if test="self::tei:space[@type = 'em']">
								<xsl:text>   </xsl:text>
							</xsl:if>
						</xsl:for-each>
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
		<a class="dip" id="{$wordId}" pos="{$wordPOS}" onmouseover="hilite(this.id)"
			onmouseout="dhilite(this.id)" lemma="{$lem}" lemmaRef="{$lemRef}" lemmaDW="{$DWlem}"
			lemmaRefDW="{$DWref}" lemmaED="{$EDlem}" lemmaRefED="{$EDref}" lemmaSL="{@lemmaSL}"
			ana="{@ana}" hand="{$hand}" ref="{$msref}" date="{$handDate}" medium="{$medium}"
			cert="{$certLvl}" abbrRefs="{$abbrRef}"
			title="{$lem}: {$pos} {$src}&#10;{$hand}&#10;{$prob}{$certProb}&#10;Abbreviations: {$abbrs}&#10;{$gloss}"
			style="text-decoration:none; color:#000000">
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
			<xsl:apply-templates mode="dip"/>
		</a>
	</xsl:template>

	<xsl:template mode="dip" match="tei:w[descendant::tei:w]">
		<xsl:apply-templates mode="dip"/>
	</xsl:template>

	<xsl:template mode="dip" match="tei:name">
		<xsl:apply-templates mode="dip"/>
	</xsl:template>

	<xsl:template mode="dip" match="tei:date">
		<a id="{generate-id()}_dip" href="#" onclick="return false;"
			style="text-decoration:none; color:#000000">
			<xsl:apply-templates mode="dip"/>
		</a>
	</xsl:template>

	<xsl:template mode="dip" match="tei:num">
		<a id="{generate-id()}_dip" href="#" onclick="return false;"
			style="text-decoration:none; color:#000000">
			<xsl:apply-templates mode="dip"/>
		</a>
	</xsl:template>

	<xsl:template mode="dip" match="tei:ref">
		<a onclick="refDetails()">
			<xsl:apply-templates mode="dip"/>
		</a>
	</xsl:template>

	<xsl:template mode="dip" match="tei:c">
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
				<xsl:apply-templates mode="dip"/>
			</xsl:when>
			<xsl:otherwise>
				<a id="{generate-id()}_dip"
					title="Unexplained character(s){$sicMessage}&#10;{$hand}{$prob}" href="#"
					onclick="return false;" style="text-decoration:none; color:#000000">
					<xsl:choose>
						<xsl:when
							test="ancestor::*[@cert = 'low'] or descendant::*[@cert = 'low'] or @lemma = 'UNKNOWN'">
							<xsl:attribute name="style">text-decoration:none;
								color:#ff0000</xsl:attribute>
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
					<xsl:apply-templates mode="dip"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="dip" match="tei:pc">
		<xsl:choose>
			<xsl:when test="ancestor::tei:w">
				<xsl:apply-templates mode="dip"/>
			</xsl:when>
			<xsl:otherwise>
				<a>
				<xsl:choose>
					<xsl:when
						test="ancestor::*[@cert = 'low'] or descendant::*[@cert = 'low'] or @lemma = 'UNKNOWN'">
						<xsl:attribute name="style">text-decoration:none;
							color:#ff0000</xsl:attribute>
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
					<xsl:apply-templates mode="dip"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- <xsl:template mode="dip" match="tei:space[@type = 'force']">
		<xsl:choose>
			<xsl:when test="ancestor::tei:w[not(descendant::tei:w)]">
				<xsl:text>&#160;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<a id="{generate-id()}_dip">
					<xsl:text>&#160;</xsl:text>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> -->

	<xsl:template mode="dip" match="tei:space[@type = 'em']">
		<xsl:choose>
			<xsl:when test="ancestor::tei:w[not(descendant::tei:w)]">
				<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<a id="{generate-id()}_dip">
					<xsl:text>&#160;&#160;&#160;&#160;</xsl:text>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="dip" match="tei:supplied">
		<xsl:text/>
	</xsl:template>

	<xsl:template mode="dip" match="tei:g">
		<xsl:variable name="comWord"
			select="count(ancestor::tei:w[not(descendant::tei:w)]/preceding::tei:w[not(descendant::tei:w)])"/>
		<xsl:variable name="position"
			select="count(preceding::tei:g[ancestor::tei:w[not(descendant::tei:w) and count(preceding::tei:w[not(descendant::tei:w)]) = $comWord]])"/>
		<i id="l{$position}" cert="{ancestor::tei:abbr/@cert}">
			<xsl:apply-templates mode="dip"/>
		</i>
	</xsl:template>

	<xsl:template mode="dip" match="tei:unclear">
		<xsl:choose>
			<xsl:when test="descendant::tei:w">
				<xsl:text>{</xsl:text>
				<xsl:apply-templates mode="dip"/>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:when test="ancestor::tei:w">
				<xsl:text>{</xsl:text>
				<xsl:apply-templates mode="dip"/>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:when test="descendant::tei:date">
				<xsl:text>{</xsl:text>
				<xsl:apply-templates mode="dip"/>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:when test="ancestor::tei:date">
				<xsl:text>{</xsl:text>
				<xsl:apply-templates mode="dip"/>
				<xsl:text>}</xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="dip" match="tei:gap">
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
				<a id="{generate-id()}_dip" title="{concat(@extent, ' extent')}, {$gapReason}"
					href="#" onclick="return false;" style="text-decoration:none; color:#000000">
					<sub>
						<b>
							<i>-gap-</i>
						</b>
					</sub>
				</a>
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<a id="{generate-id()}_dip" title="{@extent}, {$gapReason}" href="#"
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

	<xsl:template mode="dip" match="tei:del">
		<del rend="strikethrough">
			<xsl:apply-templates mode="dip"/>
		</del>
	</xsl:template>

	<xsl:template mode="dip" match="tei:note[@type = 'fn']">
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

	<xsl:template mode="dip" match="tei:add[@type = 'insertion']">
		<xsl:choose>
			<xsl:when test="ancestor::tei:w">
				<xsl:choose>
					<xsl:when test="@place = 'above'">
						<b>
							<xsl:text>\</xsl:text>
						</b>
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text>/</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'below'">
						<b>
							<xsl:text>/</xsl:text>
						</b>
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text>\</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, right'">
						<b>
							<xsl:text>&lt;</xsl:text>
						</b>
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text>&lt;</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, left'">
						<b>
							<xsl:text>&gt;</xsl:text>
						</b>
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text>&gt;</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, top'">
						<b>
							<xsl:text>//</xsl:text>
						</b>
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text>\\</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, bottom'">
						<b>
							<xsl:text>\\</xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text>//</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'inline'">
						<b>
							<xsl:text>|</xsl:text>
						</b>
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text>|</xsl:text>
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
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text> / </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'below'">
						<b>
							<xsl:text> / </xsl:text>
						</b>
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text> \ </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, right'">
						<b>
							<xsl:text> &lt; </xsl:text>
						</b>
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text> &lt; </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, left'">
						<b>
							<xsl:text> &gt; </xsl:text>
						</b>
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text> &gt; </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, top'">
						<b>
							<xsl:text> // </xsl:text>
						</b>
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text> \\ </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, bottom'">
						<b>
							<xsl:text> \\ </xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text> // </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'inline'">
						<b>
							<xsl:text> | </xsl:text>
						</b>
						<xsl:apply-templates mode="dip"/>
						<b>
							<xsl:text> | </xsl:text>
						</b>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="dip" match="tei:add[@type = 'gloss']">
		<xsl:choose>
			<xsl:when test="@place = 'above'">
				<b>
					<xsl:text> \ gl. </xsl:text>
				</b>
				<xsl:apply-templates mode="dip"/>
				<b>
					<xsl:text>/ </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'below'">
				<b>
					<xsl:text> / gl. </xsl:text>
				</b>
				<xsl:apply-templates mode="dip"/>
				<b>
					<xsl:text>\ </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, right'">
				<b>
					<xsl:text> &lt; gl. </xsl:text>
				</b>
				<xsl:apply-templates mode="dip"/>
				<b>
					<xsl:text>&lt;  </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, left'">
				<b>
					<xsl:text> &gt; gl. </xsl:text>
				</b>
				<xsl:apply-templates mode="dip"/>
				<b>
					<xsl:text> &gt; </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, top'">
				<b>
					<xsl:text> // gl. </xsl:text>
				</b>
				<xsl:apply-templates/>
				<b>
					<xsl:text> \\ </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, bottom'">
				<b>
					<xsl:text> \\ gl. </xsl:text>
				</b>
				<xsl:apply-templates/>
				<b>
					<xsl:text> // </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'inline'">
				<b>
					<xsl:text> | gl. </xsl:text>
				</b>
				<xsl:apply-templates/>
				<b>
					<xsl:text> | </xsl:text>
				</b>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="dip" match="tei:handShift">
		<xsl:text> </xsl:text>
		<sub>
			<i>
				<b> beg. H<xsl:value-of select="substring(@new, 5)"/></b>
			</i>
		</sub>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template mode="dip" match="tei:div[@n]">
		<xsl:apply-templates mode="dip"/>
		<table/>
		<button id="{generate-id()}" onclick="textComment(this.id)" style="font-size:12px">Add
			Comment</button>
	</xsl:template>

	<xsl:template mode="dip" match="tei:head">
		<xsl:apply-templates mode="dip"/>
	</xsl:template>

</xsl:stylesheet>

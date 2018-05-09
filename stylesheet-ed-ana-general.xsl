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
	<xsl:key name="text" match="*" use="@corresp"/>
	<xsl:key name="altText" match="*" use="@corresp"/>

	<xsl:param name="sicReplace" select="'alt'"/>

	<xsl:attribute-set name="tblBorder">
		<xsl:attribute name="border">solid 0.1mm black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="contentRow">
		<tr>
		<td>
			<xsl:apply-templates/>
		</td>
		<td>
			<a href="{@lemmaRef}"><xsl:value-of select="@lemma"/></a>
		</td>
		<td>
			<xsl:value-of select="@ana"/>
		</td>
			<td>
			<xsl:choose>
				<xsl:when test="ancestor::tei:div//tei:handShift">
					<xsl:value-of
						select="key('hands', preceding::tei:handShift[1]/@new)/tei:forename | key('hands', preceding::tei:div[1])/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of
						select="key('hands', preceding::tei:handShift[1]/@new)/tei:surname | key('hands', preceding::tei:div[1]/@resp, 5)/tei:surname"
					/><xsl:text> (</xsl:text><xsl:value-of select="substring(preceding::tei:handShift[1]/@new, 5) | substring(preceding::tei:div[1]/@resp, 5)"/><xsl:text>)</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of
						select="key('hands', ancestor::tei:div[1]/@resp)/tei:forename"/>
					<xsl:text> </xsl:text>
					<xsl:value-of
						select="key('hands', ancestor::tei:div[1]/@resp)/tei:surname"
					/><xsl:text> (</xsl:text><xsl:value-of select="substring(ancestor::tei:div[1]/@resp, 5)"/><xsl:text>)</xsl:text>
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
	</tr></xsl:template>

	<xsl:template match="/">
		<html>
			<head><h1>Report</h1></head>
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
					<tr><th>Definite Article</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='art']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Nouns</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='noun' or @ana='name' or @ana='title']">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr><th>Pronouns</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='pron' or @ana='dpron']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Adjectives</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='adj']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Numbers</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='num']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Verbs</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='verb']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Verbal Nouns</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='vnoun']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Participles</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='ptcp']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Adverbs</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='adv']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Conjunctions</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='conj']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Prepositions</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='prep']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Particles</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='part']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Prefixes</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and @ana='pref']">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Compounds</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and contains(@ana, ',')]">
						<xsl:call-template name="contentRow"/>						
						<xsl:sort select="@lemma"/>
					</xsl:for-each>
					<tr><th>Unidentified</th></tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and not(@ana)]">
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
				</table>
			</body>
		</html>
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
		<sub>
			<b>
				<xsl:text>page beg. </xsl:text>
				<xsl:value-of select="@n"/>
				<xsl:text> </xsl:text>
			</b>
		</sub>
	</xsl:template>

	<xsl:template match="tei:cb">
		<sub>
			<b>
				<xsl:text>col. beg. </xsl:text>
				<xsl:value-of select="@n"/>
				<xsl:text> </xsl:text>
			</b>
		</sub>
	</xsl:template>

	<xsl:template match="tei:lb">
		<sub>
			<b>
				<xsl:text>ms. line beg. </xsl:text>
				<xsl:value-of select="@n"/>
				<xsl:text> </xsl:text>
			</b>
		</sub>
	</xsl:template>

	<xsl:template match="tei:lg">
		<p style="margin-left:30px">
			<b align="left">
				<xsl:text>St. </xsl:text>
				<xsl:value-of select="@n"/>
				<xsl:text>. </xsl:text>
			</b>
			<xsl:text>  </xsl:text>
			<xsl:apply-templates select="descendant::tei:l"/>
		</p>
	</xsl:template>

	<xsl:template match="tei:seg[@type = 'catchword']">
			<xsl:text>   </xsl:text><xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:seg[@type = 'cfe']">
		<xsl:text/>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="word" match="tei:w[not(descendant::tei:w)]">
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
						<xsl:for-each select="ancestor::tei:choice/tei:corr//tei:w">
							<xsl:text> </xsl:text><xsl:value-of select="self::*"/><xsl:text> </xsl:text>
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
					<xsl:text>') has been supplied:&#10;&#10;</xsl:text>
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
								<xsl:when test="ancestor::tei:unclear[@reason = 'text_obscure']">
									<xsl:text xml:space="preserve">- this word is difficult to decipher &#10;</xsl:text>
								</xsl:when>
								<xsl:when test="descendant::tei:unclear[@reason = 'text_obscure']">
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
							<xsl:text xml:space="preserve">- loss of vellum; some characters are lost and may have been supplied by an editor &#10;</xsl:text>
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
				<xsl:text xml:space="preserve">- this is an editorial emendation of the manuscript reading ("</xsl:text>
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
				<xsl:text xml:space="preserve">- this word has been supplied by an editor &#10;</xsl:text>
			</xsl:if>
			<xsl:if test="descendant::tei:supplied">
				<xsl:text xml:space="preserve">- some characters have been supplied by an editor &#10;</xsl:text>
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
		<xsl:variable name="handDate">
			<xsl:value-of select="key('hands', $handRef)/tei:date"/>
		</xsl:variable>
		<xsl:variable name="shelfmark">
			<xsl:value-of
				select="concat(ancestor::tei:TEI//tei:msIdentifier/tei:repository, ' ', ancestor::tei:TEI//tei:msIdentifier/tei:idno)"
			/>
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
		<a id="{$wordId}" pos="{$wordPOS}" onmouseover="hilite(this.id)"
			onmouseout="dhilite(this.id)" lemma="{$lem}" lemmaRef="{$lemRef}" ana="{@ana}"
			hand="{$hand}" ref="{$msref}" date="{$handDate}" medium="{$medium}" cert="{$certLvl}"
			title="{$lem}: {$pos} {$src}&#10;{$hand}&#10;{$prob}{$certProb}&#10;Abbreviations: {$abbrs}&#10;{$gloss}"
			style="text-decoration:none; color:#000000">
			<xsl:if test="ancestor::tei:sic">
				<xsl:attribute name="title"><xsl:value-of select="$sicLem"/>&#10;<xsl:value-of
						select="$hand"/>&#10;<xsl:value-of select="$prob"/><xsl:value-of
						select="$certProb"/>&#10;<xsl:text>Abbreviations: </xsl:text><xsl:value-of
						select="$abbrs"/>&#10;<xsl:value-of select="$gloss"/></xsl:attribute>
			</xsl:if>
			<xsl:if test="@lemma">
				<xsl:attribute name="onclick">addSlip(this.id)</xsl:attribute>
			</xsl:if>
			<!--			<xsl:if test="@lemmaRef">
				<xsl:attribute name="href">
					<xsl:value-of select="@lemmaRef"/>
				</xsl:attribute>
				<xsl:attribute name="target">
					<xsl:value-of select="@lemmaRef"/>
				</xsl:attribute>
			</xsl:if> -->
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
					<seg id="sic{$wordId}" hidden="hidden">
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
	
	<xsl:template match="tei:space[@type = 'editorial']"> &#160; </xsl:template>

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
		<i id="l{$position}">
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

	<xsl:template match="tei:choice">
		<xsl:choose>
			<xsl:when test="child::tei:sic | tei:corr">
				<xsl:text>{</xsl:text>
				<xsl:apply-templates select="tei:corr"/>
				<xsl:choose>
					<xsl:when test="child::tei:sic[not(descendant::tei:w)]">
						<xsl:for-each select="descendant::tei:c">
							<xsl:variable name="alt"/>
							<a id="{generate-id()}"
								title="MS: {self::*}&#10;- the intended reading cannot be identified; an amended reading ('{$alt}') has been supplied.">
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
						<xsl:apply-templates select="tei:sic"/>
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
				<b> beg. H<xsl:value-of select="substring(@new, 5)"/></b>
		</sub>
		<xsl:text> </xsl:text>
	</xsl:template>

</xsl:stylesheet>

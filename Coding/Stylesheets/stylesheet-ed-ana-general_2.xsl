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

	<xsl:template name="contentRow">
		<xsl:param name="posID"/>
		<xsl:variable name="wordPosition" select="count(preceding::*)"/>
		<xsl:variable name="comDiv" select="ancestor::tei:div[1]/@corresp"/>
		<xsl:variable name="comPage" select="preceding::tei:pb[1]/@xml:id"/>
		<xsl:variable name="handRef">
			<xsl:choose>
				<xsl:when test="ancestor::tei:add">
					<xsl:value-of select="ancestor::tei:add/@resp"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:choose>
						<xsl:when test="ancestor::tei:div[@resp]//tei:handShift">
							<xsl:choose>
								<xsl:when
									test="preceding::tei:handShift[1]/ancestor::tei:div[1]/@corresp = $comDiv">
									<xsl:value-of select="preceding::tei:handShift[1]/@new"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="ancestor::tei:div[1][@resp]/@resp"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="ancestor::tei:div[1][@resp]/@resp"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr>
			<td>
				<xsl:value-of select="$posID"/>
				<xsl:value-of select="position()"/>
			</td>
			<td>
				<xsl:value-of select="$wordPosition"/>
			</td>
			<td>
				<a href="{@lemmaRef}">
					<xsl:value-of select="@lemma"/>
				</a>
			</td>
			<td>
				<span>
					<xsl:attribute name="style">
						<xsl:if test="ancestor::*[@cert] or descendant::*[@cert]"><xsl:choose>
							<xsl:when test="ancestor::*/@cert = 'low' or descendant::*/@cert = 'low'">
								<xsl:text>color:#ff0000</xsl:text>
							</xsl:when>
							<xsl:when test="ancestor::*/@cert = 'medium' or descendant::*/@cert = 'medium'">
								<xsl:text>color:#ff9900</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text/>
							</xsl:otherwise>
						</xsl:choose></xsl:if>
					</xsl:attribute>
					<xsl:apply-templates/>
				</span>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="ancestor::tei:supplied">
						<xsl:text>supp.</xsl:text>
					</xsl:when>
					<xsl:when
						test="descendant::tei:supplied or descendant::tei:unclear[@reason = 'damage']">
						<xsl:text>chars supp.</xsl:text>
					</xsl:when>
					<xsl:when test="ancestor::tei:unclear[@reason = 'interp_obscure']">
						<xsl:text>meaning unclear</xsl:text>
					</xsl:when>
					<xsl:when test="ancestor::tei:unclear[@reason = 'text_obscure']">
						<xsl:text>word unclear</xsl:text>
					</xsl:when>
					<xsl:when test="descendant::tei:abbr[not(@cert = 'high')]">
						<xsl:text>exp. unclear</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>none</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="descendant::tei:g">
							<xsl:for-each select="descendant::tei:g">
									<xsl:if test="count(ancestor::tei:w[not(descendant::tei:w)]/descendant::tei:g) > 1">
										<b>|</b>
									</xsl:if>
									<a>
										<xsl:if test="key('abbrs', @ref)/@corresp">
											<xsl:attribute name="href">
												<xsl:value-of select="key('abbrs', @ref)/@corresp"/>
											</xsl:attribute>
										</xsl:if>
										<xsl:value-of select="key('abbrs', @ref)/tei:glyphName"/>
									</a>
									<xsl:if test="count(ancestor::tei:w/descendant::tei:g) > 1">
										<b>|</b>
									</xsl:if>
							</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>none</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:value-of select="@ana"/>
			</td>
			<td>
				<xsl:value-of select="key('hands', $handRef)/tei:forename"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="key('hands', $handRef)/tei:surname"/>
				<xsl:text> (</xsl:text>
				<xsl:value-of select="substring($handRef, 5)"/>
				<xsl:text>)</xsl:text>
			</td>
			<td>
				<xsl:value-of select="key('hands', $handRef)/tei:date"/>
			</td>
			<td>
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/tei:repository"/>
				<xsl:text>, </xsl:text>
				<xsl:value-of select="ancestor::tei:TEI//tei:msIdentifier/tei:idno"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when
						test="contains(preceding::tei:pb[1]/@n, 'r') or contains(preceding::tei:pb[1]/@n, 'v')">
						<xsl:text>fol. </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>p. </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="preceding::tei:pb[1]/@n"/>
				<xsl:if
					test="count(preceding::tei:cb[1]/preceding::*) > count(preceding::tei:pb[1]/preceding::*)">
					<xsl:value-of select="preceding::tei:cb[1]/@n"/>
				</xsl:if>
			</td>
			<td>
				<xsl:value-of select="preceding::tei:lb[1]/@n"/>
			</td>
			<td>
				<xsl:value-of select="ancestor::tei:div[1]/@n"/>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="ancestor::tei:lg/@type = 'stanza'">
						<xsl:text>q.</xsl:text>
						<xsl:value-of select="ancestor::tei:lg/@n"/>
						<xsl:value-of select="ancestor::tei:l/@n"/>
					</xsl:when>
					<xsl:when test="ancestor::tei:lg[@type = 'prosediv']/@n">
						<xsl:text>§</xsl:text>
						<xsl:value-of select="ancestor::tei:lg/@n"/>
						<xsl:value-of select="ancestor::tei:l/@n"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>n/a</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="ancestor::tei:div[1][@type = 'verse']">
						<xsl:variable name="comLine" select="ancestor::tei:l/@xml:id"/>
						<xsl:variable name="comVerse" select="ancestor::tei:lg/@xml:id"/>
						<xsl:if
							test="not(preceding::tei:w[ancestor::tei:l[@xml:id = $comLine]]) and ancestor::tei:l/preceding::tei:l[ancestor::tei:lg[@xml:id = $comVerse]]">
							<sub>
								<b>
									<xsl:value-of
										select="preceding::tei:l[1][ancestor::tei:lg[@xml:id = $comVerse]]/@n"/>
									<xsl:text>. </xsl:text>
								</b>
							</sub>
							<xsl:apply-templates
								select="preceding::tei:l[1][ancestor::tei:lg[@xml:id = $comVerse]]"/>
							<br/>
						</xsl:if>
						<xsl:if
							test="not(preceding::tei:w[ancestor::tei:l[@xml:id = $comLine]]) and ancestor::tei:l/preceding::tei:l[ancestor::tei:lg[@xml:id = $comVerse]] or not(following::tei:w[ancestor::tei:l[@xml:id = $comLine]]) and ancestor::tei:l/following::tei:l[ancestor::tei:lg[@xml:id = $comVerse]]">
							<sub>
								<b>
									<xsl:value-of select="ancestor::tei:l/@n"/>
									<xsl:text>. </xsl:text>
								</b>
							</sub>
						</xsl:if>
						<xsl:apply-templates
							select="ancestor-or-self::*[parent::tei:l]/preceding::*[parent::tei:l[@xml:id = $comLine]]"/>
						<xsl:apply-templates select="ancestor-or-self::*[parent::tei:l]">
							<xsl:with-param name="wordID">
								<xsl:value-of select="$wordPosition"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<xsl:apply-templates
							select="ancestor-or-self::*[parent::tei:l]/following::*[parent::tei:l[@xml:id = $comLine]]"/>
						<xsl:if
							test="not(following::tei:w[ancestor::tei:l[@xml:id = $comLine]]) and ancestor::tei:l/following::tei:l[ancestor::tei:lg[@xml:id = $comVerse]]">
							<br/>
							<sub>
								<b>
									<xsl:value-of
										select="following::tei:l[1][ancestor::tei:lg[@xml:id = $comVerse]]/@n"/>
									<xsl:text>. </xsl:text>
								</b>
							</sub>
							<xsl:apply-templates
								select="following::tei:l[1][ancestor::tei:lg[@xml:id = $comVerse]]"
							/>
						</xsl:if>
					</xsl:when>
					<xsl:otherwise>
						<xsl:variable name="comLine">
							<xsl:value-of select="preceding::tei:lb[1][@xml:id]/@xml:id"/>
						</xsl:variable>
						<xsl:variable name="precLine">
							<xsl:value-of
								select="preceding::tei:lb[1][@xml:id]/preceding::tei:lb[1][@xml:id]/@xml:id"
							/>
						</xsl:variable>
						<xsl:variable name="nextLine">
							<xsl:value-of
								select="preceding::tei:lb[1][@xml:id]/following::tei:lb[1][@xml:id]/@xml:id"
							/>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="ancestor::tei:div[1][@type = 'prose']">
								<xsl:if
									test="not(preceding::tei:w[preceding::tei:lb[1][@xml:id = $comLine]]) and preceding::tei:lb[1][ancestor::tei:div[1][@corresp = $comDiv and @type = 'prose']]">
									<sub>
										<b>
											<xsl:value-of select="//tei:lb[@xml:id = $precLine]/@n"/>
											<xsl:text>. </xsl:text>
										</b>
									</sub>
									<xsl:apply-templates
										select="//*[preceding::tei:lb[1][@xml:id = $precLine] and parent::tei:p[parent::tei:div]]"/>
									<br/>
									<sub>
										<b>
											<xsl:value-of select="//tei:lb[@xml:id = $comLine]/@n"/>
											<xsl:text>. </xsl:text>
										</b>
									</sub>
								</xsl:if>
								<xsl:if
									test="not(following::tei:w[preceding::tei:lb[1][@xml:id = $comLine]]) and following::tei:lb[1][@xml:id and ancestor::tei:div[1][@corresp = $comDiv and @type = 'prose']]">
									<sub>
										<b>
											<xsl:value-of select="//tei:lb[@xml:id = $comLine]/@n"/>
											<xsl:text>. </xsl:text>
										</b>
									</sub>
								</xsl:if>
								<xsl:apply-templates
									select="ancestor-or-self::*[parent::tei:p]/preceding::*[preceding::tei:lb[1]/@xml:id = $comLine and parent::tei:p[parent::tei:div]]"
								/>
							</xsl:when>
							<xsl:when test="ancestor::tei:div[1][@type = 'divprose']">
								<xsl:if
									test="not(preceding::tei:w[preceding::tei:lb[1][@xml:id = $comLine]]) and preceding::tei:lb[1][ancestor::tei:div[1][@corresp = $comDiv and @type = 'divprose']]">
									<sub>
										<b>
											<xsl:value-of select="//tei:lb[@xml:id = $precLine]/@n"/>
											<xsl:text>. </xsl:text>
										</b>
									</sub>
									<xsl:apply-templates
										select="//*[preceding::tei:lb[1][@xml:id = $precLine] and parent::tei:l]"/>
									<br/>
									<sub>
										<b>
											<xsl:value-of select="//tei:lb[@xml:id = $comLine]/@n"/>
											<xsl:text>. </xsl:text>
										</b>
									</sub>
								</xsl:if>
								<xsl:if
									test="not(following::tei:w[preceding::tei:lb[1][@xml:id = $comLine]]) and following::tei:lb[1][@xml:id and ancestor::tei:div[1][@corresp = $comDiv and @type = 'divprose']]">
									<sub>
										<b>
											<xsl:value-of select="//tei:lb[@xml:id = $comLine]/@n"/>
											<xsl:text>. </xsl:text>
										</b>
									</sub>
								</xsl:if>
								<xsl:apply-templates
									select="ancestor-or-self::*[parent::tei:l]/preceding::*[preceding::tei:lb[1]/@xml:id = $comLine and parent::tei:l]"
								/>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="ancestor::tei:div[1][@type = 'prose']">
								<xsl:apply-templates select="ancestor-or-self::*[parent::tei:p]">
									<xsl:with-param name="wordID">
										<xsl:value-of select="$wordPosition"/>
									</xsl:with-param>
								</xsl:apply-templates>

							</xsl:when>
							<xsl:when test="ancestor::tei:div[1][@type = 'divprose']">
								<xsl:apply-templates select="ancestor-or-self::*[parent::tei:l]">
									<xsl:with-param name="wordID">
										<xsl:value-of select="$wordPosition"/>
									</xsl:with-param>
								</xsl:apply-templates>
							</xsl:when>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test="ancestor::tei:div[1][@type = 'prose']">
								<xsl:apply-templates
									select="ancestor-or-self::*[parent::tei:p]/following::*[preceding::tei:lb[1]/@xml:id = $comLine and parent::tei:p[parent::tei:div]]"/>
								<xsl:if
									test="not(following::tei:w[preceding::tei:lb[1][@xml:id = $comLine]]) and following::tei:lb[1][@xml:id and ancestor::tei:div[1][@corresp = $comDiv and @type = 'prose']]">
									<br/>
									<sub>
										<b>
											<xsl:value-of select="//tei:lb[@xml:id = $nextLine]/@n"/>
											<xsl:text>. </xsl:text>
										</b>
									</sub>
									<xsl:apply-templates
										select="//*[preceding::tei:lb[1][@xml:id = $nextLine] and parent::tei:p[parent::tei:div]]"
									/>
								</xsl:if>
							</xsl:when>
							<xsl:when test="ancestor::tei:div[1][@type = 'divprose']">
								<xsl:apply-templates
									select="ancestor-or-self::*[parent::tei:l]/following::*[preceding::tei:lb[1][@xml:id = $comLine] and parent::tei:l]"/>
								<xsl:if
									test="not(following::tei:w[preceding::tei:lb[1][@xml:id = $comLine]]) and following::tei:lb[1][@xml:id and ancestor::tei:div[1][@corresp = $comDiv and @type = 'divprose']]">
									<br/>
									<sub>
										<b>
											<xsl:value-of select="//tei:lb[@xml:id = $nextLine]/@n"/>
											<xsl:text>. </xsl:text>
										</b>
									</sub>
									<xsl:apply-templates
										select="//*[preceding::tei:lb[1][@xml:id = $nextLine] and parent::tei:l]"
									/>
								</xsl:if>
							</xsl:when>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	<xsl:template match="/">
		<html>
			<head>
				<script>
					
				</script>
				<h1>Corpus Report</h1>
			</head>
			<body>
				<table border="1px solid black" id="tbl">
					<tr>
						<th>
							<b>Data ID</b>
						</th>
						<th>
							<b>Form ID</b>
						</th>
						<th>
							<b>Lexeme</b>
						</th>
						<th>
							<b>Form</b>
						</th>
						<th>
							<b>Problem(s)</b>
						</th>
						<th>
							<b>Abbrevs/Ligs</b>
						</th>
						<th>
							<b>Part of Speech</b>
						</th>
						<th>
							<b>Scribe</b>
						</th>
						<th>
							<b>Date</b>
						</th>
						<th>
							<b>MS</b>
						</th>
						<th>
							<b>Fol./Page</b>
						</th>
						<th>
							<b>Line</b>
						</th>
						<th>
							<b>Text No.</b>
						</th>
						<th>
							<b>Text Ref.</b>
						</th>
						<th>
							<b>Context</b>
						</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'art') and not(@type = 'data') and not(contains(@ana, 'part'))]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>art</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(ancestor::tei:name) and contains(@ana, 'noun') and not(@type = 'data') and not(contains(@ana, 'vnoun')) and not(@xml:lang)]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>noun</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'pron')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>pron</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'poss')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>poss</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'adj')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>adj</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'num')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>num</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and @lemmaRef = 'http://www.dil.ie/4927']">
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>subst</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and @lemmaRef = 'http://www.dil.ie/29104']">
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>cop</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'verb') and not(@lemmaRef = 'http://www.dil.ie/29104') and not(@lemmaRef = 'http://www.dil.ie/4927')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>verb</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'vnoun')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>vn</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'ptcp')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>ptcp</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'adv')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>adv</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'conj')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>conj</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'prep')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>prep</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'part')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>part</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'interrog')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>int</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and contains(@ana, 'pref')]">
						<xsl:sort select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>pref</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
					<xsl:for-each
						select="//tei:w[ancestor::tei:body and not(descendant::tei:w) and not(@type = 'data') and @lemma = 'UNKNOWN']">
						<xsl:call-template name="contentRow">
							<xsl:with-param name="posID">
								<xsl:text>unk</xsl:text>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="tei:w[descendant::tei:w]">
		<xsl:param name="wordID"/>
		<span>
			<xsl:if test="count(descendant::tei:w/preceding::*) = $wordID">
				<xsl:attribute name="style">
					<xsl:text>color:#809fff</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates>
				<xsl:with-param name="wordID">
					<xsl:value-of select="$wordID"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</span>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:w[not(descendant::tei:w)]">
		<xsl:param name="wordID"/>
		<span>
			<xsl:if test="count(preceding::*) = $wordID">
				<xsl:attribute name="style">
					<xsl:text>color:#0039e6;font-weight:bold;</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</span>
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
			<xsl:when test="@ana = 'part' and ancestor::tei:w[contains(@ana, 'part, noun')]">
				<xsl:text/>
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
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, pron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'prep' and ancestor::tei:w[contains(@ana, 'prep, verb')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, dpron')]">
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
			<xsl:when test="@ana = 'vnoun' and ancestor::tei:w[contains(@ana, 'vnoun, vnoun')]">
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
			<xsl:when test="@ana = 'vnoun' and ancestor::tei:w[contains(@ana, 'vnoun, noun')]">
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

	<xsl:template match="tei:g">
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="ancestor::tei:abbr/@cert = 'low'">
					<xsl:text>#ff0000</xsl:text>
				</xsl:when>
				<xsl:when test="ancestor::tei:abbr/@cert = 'medium'">
					<xsl:text>#ff9900</xsl:text>
				</xsl:when>
				<xsl:when test="ancestor::tei:abbr/@cert = 'unknown'">
					<xsl:text>#d9d9d9</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains(@ref, 'g')">
				<i style="color:{$color}">
					<xsl:apply-templates/>
				</i>
			</xsl:when>
			<xsl:otherwise>
				<span style="color:{$color}">
					<xsl:apply-templates/>
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:c">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:date">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:pc">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:num">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:del">
		<xsl:param name="wordID"/>
		<del rend="strikethrough">
			<xsl:apply-templates>
				<xsl:with-param name="wordID">
					<xsl:value-of select="$wordID"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</del>
	</xsl:template>

	<xsl:template match="tei:gap">
		<sub>
			<b>
				<xsl:text>-gap-</xsl:text>
				<xsl:text> </xsl:text>
			</b>
		</sub>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:param name="wordID"/>
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="@cert = 'low'">
					<xsl:text>#ff0000</xsl:text>
				</xsl:when>
				<xsl:when test="@cert = 'medium'">
					<xsl:text>#ff9900</xsl:text>
				</xsl:when>
				<xsl:when test="@cert = 'high'">
					<xsl:text>#cccc00</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="descendant::tei:w">
				<xsl:text>{ </xsl:text>
				<span style="color:{$color}">
					<xsl:apply-templates>
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</span>
				<xsl:text>} </xsl:text>
			</xsl:when>
			<xsl:when test="ancestor::tei:w">
				<xsl:text>{</xsl:text>
				<span style="color:{$color}">
					<xsl:apply-templates>
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</span>
				<xsl:text>}</xsl:text>
			</xsl:when>
			<xsl:when test="descendant::tei:date">
				<xsl:text> {</xsl:text>
				<span style="color:{$color}">
					<xsl:apply-templates>
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</span>
				<xsl:text>} </xsl:text>
			</xsl:when>
			<xsl:when test="ancestor::tei:num">
				<xsl:text> {</xsl:text>
				<span style="color:{$color}">
					<xsl:apply-templates>
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</span>
				<xsl:text>} </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:choice">
		<xsl:param name="wordID"/>
		<xsl:choose>
			<xsl:when test="descendant::tei:sic">
				<xsl:apply-templates select="tei:sic">
					<xsl:with-param name="wordID">
						<xsl:value-of select="$wordID"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<sub>
					<xsl:text>[</xsl:text>
					<b>
						<xsl:text>leg. </xsl:text>
					</b>
					<xsl:apply-templates select="tei:corr">
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
					</xsl:apply-templates>
					<xsl:text>] </xsl:text>
				</sub>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="descendant::tei:unclear[1]">
					<xsl:with-param name="wordID">
						<xsl:value-of select="$wordID"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:handShift">
		<sub>
			<b>beg. <xsl:value-of select="@new"/></b>
		</sub>
	</xsl:template>

	<xsl:template match="tei:add[@type = 'insertion']">
		<xsl:param name="wordID"/>
		<xsl:choose>
			<xsl:when test="ancestor::tei:w">
				<xsl:choose>
					<xsl:when test="@place = 'above'">
						<b>
							<xsl:text>\</xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text>/</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'below'">
						<b>
							<xsl:text>/</xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text>\</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, right'">
						<b>
							<xsl:text>&lt;</xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text>&lt;</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, left'">
						<b>
							<xsl:text>&gt;</xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text>&gt;</xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, top'">
						<b>
							<xsl:text>\\</xsl:text>
						</b>
						<xsl:apply-templates/>
						<b>
							<xsl:text>//</xsl:text>
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
						<xsl:apply-templates/>
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
							<xsl:text>\ </xsl:text>
						</b>
						<xsl:apply-templates>
							<xsl:with-param name="wordID">
								<xsl:value-of select="$wordID"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<b>
							<xsl:text>/ </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'below'">
						<b>
							<xsl:text>/ </xsl:text>
						</b>
						<xsl:apply-templates>
							<xsl:with-param name="wordID">
								<xsl:value-of select="$wordID"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<b>
							<xsl:text>\ </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, right'">
						<b>
							<xsl:text>&lt; </xsl:text>
						</b>
						<xsl:apply-templates>
							<xsl:with-param name="wordID">
								<xsl:value-of select="$wordID"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<b>
							<xsl:text>&lt; </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, left'">
						<b>
							<xsl:text>&gt; </xsl:text>
						</b>
						<xsl:apply-templates>
							<xsl:with-param name="wordID">
								<xsl:value-of select="$wordID"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<b>
							<xsl:text>&gt; </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, top'">
						<b>
							<xsl:text>// </xsl:text>
						</b>
						<xsl:apply-templates>
							<xsl:with-param name="wordID">
								<xsl:value-of select="$wordID"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<b>
							<xsl:text>\\ </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'margin, bottom'">
						<b>
							<xsl:text>\\ </xsl:text>
						</b>
						<xsl:apply-templates>
							<xsl:with-param name="wordID">
								<xsl:value-of select="$wordID"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<b>
							<xsl:text>// </xsl:text>
						</b>
					</xsl:when>
					<xsl:when test="@place = 'inline'">
						<b>
							<xsl:text>| </xsl:text>
						</b>
						<xsl:apply-templates>
							<xsl:with-param name="wordID">
								<xsl:value-of select="$wordID"/>
							</xsl:with-param>
						</xsl:apply-templates>
						<b>
							<xsl:text>| </xsl:text>
						</b>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:add[@type = 'gloss']">
		<xsl:param name="wordID"/>
		<xsl:choose>
			<xsl:when test="@place = 'above'">
				<b>
					<xsl:text> \ gl. </xsl:text>
				</b>
				<xsl:apply-templates>
					<xsl:with-param name="wordID">
						<xsl:value-of select="$wordID"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<b>
					<xsl:text> / </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'below'">
				<b>
					<xsl:text> / gl. </xsl:text>
				</b>
				<xsl:apply-templates>
					<xsl:with-param name="wordID">
						<xsl:value-of select="$wordID"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<b>
					<xsl:text> \ </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, right'">
				<b>
					<xsl:text> &lt; gl. </xsl:text>
				</b>
				<xsl:apply-templates>
					<xsl:with-param name="wordID">
						<xsl:value-of select="$wordID"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<b>
					<xsl:text> &lt;  </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, left'">
				<b>
					<xsl:text> &gt; gl. </xsl:text>
				</b>
				<xsl:apply-templates>
					<xsl:with-param name="wordID">
						<xsl:value-of select="$wordID"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<b>
					<xsl:text> &gt; </xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, top'">
				<b>
					<xsl:text>// gl. </xsl:text>
				</b>
				<xsl:apply-templates>
					<xsl:with-param name="wordID">
						<xsl:value-of select="$wordID"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<b>
					<xsl:text> \\</xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'margin, bottom'">
				<b>
					<xsl:text>\\ gl. </xsl:text>
				</b>
				<xsl:apply-templates>
					<xsl:with-param name="wordID">
						<xsl:value-of select="$wordID"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<b>
					<xsl:text> //</xsl:text>
				</b>
			</xsl:when>
			<xsl:when test="@place = 'inline'">
				<b>
					<xsl:text>| gl. </xsl:text>
				</b>
				<xsl:apply-templates>
					<xsl:with-param name="wordID">
						<xsl:value-of select="$wordID"/>
					</xsl:with-param>
				</xsl:apply-templates>
				<b>
					<xsl:text> |</xsl:text>
				</b>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:space[@type = 'force']"> &#160; </xsl:template>

	<xsl:template match="tei:space[@type = 'em']"> &#160;&#160;&#160;&#160; </xsl:template>

	<xsl:template match="tei:space[@type = 'scribal']">
		<xsl:text/>
	</xsl:template>

	<xsl:template match="tei:space[@type = 'editorial']">
		<xsl:text/>
	</xsl:template>

	<xsl:template match="tei:note[@type = 'fn']">
		<xsl:text/>
	</xsl:template>

	<xsl:template match="tei:pb">
		<sub>
			<b>
				<xsl:text>p.</xsl:text>
				<xsl:value-of select="@n"/>
				<xsl:text> </xsl:text>
			</b>
		</sub>
	</xsl:template>

	<xsl:template match="tei:cb">
		<sub>
			<b>
				<xsl:text>col. </xsl:text>
				<xsl:value-of select="@n"/>
				<xsl:text> </xsl:text>
			</b>
		</sub>
	</xsl:template>

	<xsl:template match="tei:lb">
		<xsl:if test="@xml:id">
			<xsl:choose>
				<xsl:when test="not(ancestor::tei:lg[@type = 'stanza'])">
					<xsl:text/>
				</xsl:when>
				<xsl:otherwise>
					<sub>
						<b>
							<xsl:value-of select="@n"/>
							<xsl:text>.</xsl:text>
						</b>
					</sub>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="@sameAs">
			<sub>
				<b>
					<xsl:value-of select="@n"/>
					<xsl:text>.</xsl:text>
				</b>
			</sub>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:apply-templates/>
	</xsl:template>

</xsl:stylesheet>

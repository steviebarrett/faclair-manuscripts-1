<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="3.0">
	<xsl:output method="html"/>

	<xsl:template match="/">
		<html>
			<head>
				<title><xsl:value-of select="//tei:TEI/@xml:id"/>_error _report_<xsl:value-of
						select="current-dateTime()"/></title>
			</head>
			<style>
				span {
					display: inline-block;
					margin-right: 0px;
				}</style>
			<body>
				<xsl:call-template name="abbrCert"/>
				<xsl:call-template name="glyphRef"/>
				<xsl:call-template name="wrongLemma"/>
				<xsl:call-template name="wNoAttrs"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="wNoAttrs">
		<h2>&lt;w&gt; without attributes</h2>
		<table>
			<thead>
				<tr>
					<th width="120">MS line</th>
					<th>Word</th>
				</tr>
			</thead>
			<xsl:if test="//tei:w[not(@lemma) and not(@lemmaRef) and not(@ana) and not(@xml:lang)]">
				<tbody>
					<xsl:for-each select="//tei:w[not(@lemma) and not(@lemmaRef) and not(@ana) and not(@xml:lang)]">
						<tr>
							<td>
								<xsl:choose>
									<xsl:when test="preceding::tei:lb[1]/@sameAs">
										<xsl:value-of select="preceding::tei:lb[1]/@sameAs"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="preceding::tei:lb[1]/@xml:id"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:value-of select="string(self::*)"/>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</xsl:if>
		</table>
	</xsl:template>

	<xsl:template name="abbrCert">
		<h2>&lt;abbr&gt; without @cert</h2>
		<xsl:if test="//tei:abbr[not(@cert)]">
			<table id="abbrCertTbl">
				<thead>
					<tr>
						<th width="120">MS line</th>
						<th>Word</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="//tei:abbr[not(@cert)]">
						<xsl:variable name="wordID"
							select="count(ancestor::tei:w[not(descendant::tei:w)]/preceding::*)"/>
						<xsl:variable name="abbrID"
							select="count(preceding::tei:abbr[count(ancestor::tei:w[not(descendant::tei:w)]/preceding::*) = $wordID])"/>
						<xsl:variable name="glyphID">
							<xsl:text>xxx</xsl:text>
						</xsl:variable>
						<tr>
							<td>
								<xsl:choose>
									<xsl:when test="preceding::tei:lb[1]/@sameAs">
										<xsl:value-of select="preceding::tei:lb[1]/@sameAs"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="preceding::tei:lb[1]/@xml:id"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:apply-templates
									select="ancestor::tei:w[not(descendant::tei:w)]">
									<xsl:with-param name="abbrID">
										<xsl:value-of select="$abbrID"/>
									</xsl:with-param>
									<xsl:with-param name="wordID">
										<xsl:value-of select="$wordID"/>
									</xsl:with-param>
									<xsl:with-param name="glyphID">
										<xsl:value-of select="$glyphID"/>
									</xsl:with-param>
								</xsl:apply-templates>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template name="glyphRef">
		<h2>&lt;g&gt; without @ref</h2>
		<xsl:if test="//tei:g[not(@ref)]">
			<table id="glyphRefTbl">
				<thead>
					<tr>
						<th width="120">MS line</th>
						<th>Word</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="//tei:g[not(@ref)]">
						<xsl:variable name="wordID"
							select="count(ancestor::tei:w[not(descendant::tei:w)]/preceding::*)"/>
						<xsl:variable name="glyphID"
							select="count(preceding::tei:g[count(ancestor::tei:w[not(descendant::tei:w)]/preceding::*) = $wordID])"/>
						<xsl:variable name="abbrID"
							select="count(ancestor::tei:abbr/preceding::tei:abbr[count(ancestor::tei:w[not(descendant::tei:w)]/preceding::*) = $wordID])"/>
						<tr>
							<td>
								<xsl:choose>
									<xsl:when test="preceding::tei:lb[1]/@sameAs">
										<xsl:value-of select="preceding::tei:lb[1]/@sameAs"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="preceding::tei:lb[1]/@xml:id"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:apply-templates
									select="ancestor::tei:w[not(descendant::tei:w)]">
									<xsl:with-param name="wordID">
										<xsl:value-of select="$wordID"/>
									</xsl:with-param>
									<xsl:with-param name="glyphID">
										<xsl:value-of select="$glyphID"/>
									</xsl:with-param>
									<xsl:with-param name="abbrID">
										<xsl:value-of select="$abbrID"/>
									</xsl:with-param>
								</xsl:apply-templates>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template name="wrongLemma">
		<xsl:variable name="hwFilepath" select="string('..\..\Transcribing\hwData.xml')"/>
		<h2>Unrecognised Lemmata</h2>
		<table id="wrongLemmaTbl">
			<thead>
				<th width="120">MS line</th>
				<th>Lemma (form)</th>
			</thead>
			<tbody>
				<xsl:for-each select="//tei:w[not(descendant::tei:w) and @lemmaRef]">
					<xsl:variable name="lemRef" select="@lemmaRef"/>
					<xsl:if
						test="string(@lemma) != document($hwFilepath)//tei:entryFree[@corresp = $lemRef]/tei:w/@lemma and string(@lemma) != document($hwFilepath)//tei:entryFree[@corresp = $lemRef]/tei:w/tei:span[@type = 'altLem']/text()">
						<tr>
							<td>
								<xsl:choose>
									<xsl:when test="preceding::tei:lb[1]/@sameAs">
										<xsl:value-of select="preceding::tei:lb[1]/@sameAs"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="preceding::tei:lb[1]/@xml:id"/>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<td>
								<xsl:value-of select="@lemma"/>
								<xsl:text> (</xsl:text>
								<xsl:value-of select="string(self::*)"/>
								<xsl:text>)</xsl:text>
							</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="tei:w[not(descendant::tei:w)]">
		<xsl:param name="wordID"/>
		<xsl:param name="abbrID"/>
		<xsl:param name="glyphID"/>
		<xsl:apply-templates>
			<xsl:with-param name="abbrID">
				<xsl:value-of select="$abbrID"/>
			</xsl:with-param>
			<xsl:with-param name="wordID">
				<xsl:value-of select="$wordID"/>
			</xsl:with-param>
			<xsl:with-param name="glyphID">
				<xsl:value-of select="$glyphID"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="tei:abbr">
		<xsl:param name="wordID"/>
		<xsl:param name="abbrID"/>
		<xsl:param name="glyphID"/>
		<xsl:choose>
			<xsl:when
				test="count(preceding::tei:abbr[count(ancestor::tei:w[not(descendant::tei:w)]/preceding::*) = $wordID]) = $abbrID">
				<span style="background-color:#ff5c33">
					<xsl:apply-templates>
						<xsl:with-param name="glyphID">
							<xsl:value-of select="$glyphID"/>
						</xsl:with-param>
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
						<xsl:with-param name="abbrID">
							<xsl:value-of select="$abbrID"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates>
					<xsl:with-param name="glyphID">
						<xsl:value-of select="$glyphID"/>
					</xsl:with-param>
					<xsl:with-param name="wordID">
						<xsl:value-of select="$wordID"/>
					</xsl:with-param>
					<xsl:with-param name="abbrID">
						<xsl:value-of select="$abbrID"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:g">
		<xsl:param name="wordID"/>
		<xsl:param name="glyphID"/>
		<xsl:param name="abbrID"/>
		<xsl:choose>
			<xsl:when test="$glyphID = 'xxx'">
				<span style="font-style:italic;">
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when
						test="count(preceding::tei:g[count(ancestor::tei:w[not(descendant::tei:w)]/preceding::*) = $wordID]) = $glyphID">
						<span style="background-color:#ff5c33;font-style:italic;">
							<xsl:apply-templates/>
						</span>
					</xsl:when>
					<xsl:otherwise>
						<span style="font-style:italic;">
							<xsl:apply-templates/>
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.0">
	<xsl:strip-space elements="*"/>

	<xsl:output method="html" version="5"/>

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

	<xsl:template mode="table" match="/">
		<html>
			<head>
				<title>FnaG MSS Corpus</title>
			</head>
			<body>
				<table border="1px solid black" id="tbl">
					<thead>
						<tr>
							<th>
								<b>Form ID</b>
							</th>
							<th>
								<b>Headword</b>
							</th>
							<th>
								<b>Form</b>
							</th>
							<th>
								<b>Problem(s)?</b>
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
					</thead>
					<tbody>
						<xsl:for-each
							select="//tei:w[not(descendant::tei:w) and not(@type = 'data') and not(@xml:lang) and not(ancestor::tei:supplied)]">
							<xsl:call-template name="contentRow"/>
						</xsl:for-each>
					</tbody>
				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:template mode="table" name="contentRow">
		<xsl:variable name="wordPosition" select="count(preceding::*)"/>
		<xsl:variable name="comDiv" select="ancestor::tei:div[1]/@corresp"/>
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
						<xsl:if test="ancestor::*[@cert] or descendant::*[@cert]">
							<xsl:choose>
								<xsl:when
									test="ancestor::*/@cert = 'low' or descendant::*/@cert = 'low'">
									<xsl:text>color:#ff0000</xsl:text>
								</xsl:when>
								<xsl:when
									test="ancestor::*/@cert = 'medium' or descendant::*/@cert = 'medium'">
									<xsl:text>color:#ff9900</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</xsl:attribute>
					<xsl:apply-templates mode="table"/>
				</span>
			</td>
			<td>
				<xsl:choose>
					<xsl:when
						test="ancestor::tei:supplied or ancestor::tei:unclear or descendant::tei:supplied or descendant::unclear or @lemma = 'UNKNOWN'">
						<xsl:text>yes</xsl:text>
					</xsl:when>
					<xsl:otherwise> no </xsl:otherwise>
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
				<xsl:call-template name="contextCell">
					<xsl:with-param name="wordPosition">
						<xsl:value-of select="$wordPosition"/>
					</xsl:with-param>
					<xsl:with-param name="lineID">
						<xsl:value-of select="preceding::tei:lb[1][@xml:id]/@xml:id"/>
					</xsl:with-param>
				</xsl:call-template>
			</td>
		</tr>
	</xsl:template>

	<xsl:template name="contextCell" mode="table">
		<xsl:param name="wordPosition"/>
		<xsl:param name="lineID"/>
		<xsl:apply-templates mode="context"
			select="document('corpus-contexts.xml')//tei:seg[@type = 'msLine' and @xml:id = $lineID]/child::*">
			<xsl:with-param name="wordPosition">
				<xsl:value-of select="$wordPosition"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="context" match="tei:w">
		<xsl:param name="wordPosition"/>
		<span class="word">
			<xsl:if test="@xml:id = $wordPosition">
				<xsl:attribute name="style">
					<xsl:choose>
						<xsl:when test="@style">
							<xsl:value-of select="concat(@style, ';', 'background-color:#aqua')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>background-color:#aqua</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="child::* | child::text()"/>
		</span>
	</xsl:template>

	<xsl:template mode="context" match="tei:space"> &#160; </xsl:template>

	<xsl:template mode="context" match="tei:expan">
		<span class="expansion" style="italic">
			<xsl:apply-templates select="child::* | child::text()"/>
		</span>
	</xsl:template>

	<xsl:template mode="context" match="tei:hi">
		<xsl:choose>
			<xsl:when test="@rend = 'sup'">
				<sup>
					<xsl:apply-templates select="child::* | child::text()"/>
				</sup>
			</xsl:when>
			<xsl:when test="@rend = 'strikethrough'">
				<del>
					<xsl:apply-templates select="child::* | child::text()"/>
				</del>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="context" match="tei:seg">
		<xsl:choose>
			<xsl:when test="@type = 'punctuation'">
				<span class="punctuation">
					<xsl:apply-templates select="child::* | child::text()"/>
				</span>
			</xsl:when>
			<xsl:when test="@type = 'character'">
				<span class="character">
					<xsl:apply-templates select="child::* | child::text()"/>
				</span>
			</xsl:when>
			<xsl:when test="@type = 'date'">
				<span class="date">
					<xsl:apply-templates select="child::* | child::text()"/>
				</span>
			</xsl:when>
			<xsl:when test="@type = 'number'">
				<span class="number">
					<xsl:apply-templates select="child::* | child::text()"/>
				</span>
			</xsl:when>
			<xsl:when test="@type = 'fragment'">
				<span class="fragment">
					<xsl:apply-templates select="child::* | child::text()"/>
				</span>
			</xsl:when>
			<xsl:when test="@style">
				<span class="unclear">
					<xsl:attribute name="style">
						<xsl:value-of select="@style"/>
					</xsl:attribute>
					<xsl:apply-templates select="child::* | child::text()"/>
				</span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template mode="context" match="tei:supplied">
		<xsl:text>[</xsl:text>
		<xsl:apply-templates select="child::* | child::text()"/>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template mode="context" match="tei:gap">
		<xsl:text xml:space="preserve"> [...] </xsl:text>
	</xsl:template>

	<xsl:template mode="table" name="tableForm">
		<xsl:apply-templates select="child::* | child::text()"/>
	</xsl:template>

	<xsl:template mode="table" match="tei:abbr">
		<xsl:apply-templates select="child::* | child::text()">
			<xsl:with-param name="abbrCert">
				<xsl:value-of select="@cert"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template mode="table" match="tei:g">
		<xsl:param name="abbrCert"/>
		<xsl:variable name="color">
			<xsl:choose>
				<xsl:when test="$abbrCert = 'low'">
					<xsl:text>#ff0000</xsl:text>
				</xsl:when>
				<xsl:when test="$abbrCert = 'medium'">
					<xsl:text>#ff9900</xsl:text>
				</xsl:when>
				<xsl:when test="$abbrCert = 'unknown'">
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

	<xsl:template mode="table" match="tei:del">
		<del>
			<xsl:apply-templates select="child::* | child::text()"/>
		</del>
	</xsl:template>

	<xsl:template mode="table" match="tei:unclear">
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
		<span class="unclear" style="color:{$color}">
			<xsl:apply-templates select="child::* | child::text()"/>
		</span>
	</xsl:template>

	<xsl:template mode="table" match="tei:handShift">
		<sub>
			<b>beg. <xsl:value-of select="@new"/></b>
		</sub>
	</xsl:template>

	<xsl:template mode="table" match="tei:add">
		<sup>
			<xsl:apply-templates select="child::* | child::text()"/>
		</sup>
	</xsl:template>

	<xsl:template mode="table" match="tei:space[@type = 'force']">&#160;</xsl:template>

	<xsl:template mode="table" match="tei:space[@type = 'em']"
		>&#160;&#160;&#160;&#160;</xsl:template>

	<xsl:template mode="table" match="tei:space[@type = 'scribal']"> &#160; </xsl:template>

	<xsl:template mode="table" match="tei:space[@type = 'editorial']">
		<xsl:text/>
	</xsl:template>

	<xsl:template mode="table" match="tei:note[@type = 'fn']">
		<xsl:text/>
	</xsl:template>

	<xsl:template mode="table" match="tei:pb">
		<sub>
			<b>
				<xsl:text>p.</xsl:text>
				<xsl:value-of select="@n"/>
				<xsl:text> </xsl:text>
			</b>
		</sub>
	</xsl:template>

	<xsl:template mode="table" match="tei:cb">
		<sub>
			<b>
				<xsl:text>col. </xsl:text>
				<xsl:value-of select="@n"/>
				<xsl:text> </xsl:text>
			</b>
		</sub>
	</xsl:template>

	<xsl:template mode="table" match="tei:lb">
		<sub>
			<b>
				<xsl:value-of select="@n"/>
				<xsl:text>.</xsl:text>
			</b>
		</sub>
	</xsl:template>

</xsl:stylesheet>

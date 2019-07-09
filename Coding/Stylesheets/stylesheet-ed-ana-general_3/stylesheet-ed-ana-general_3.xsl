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
					<xsl:apply-templates/>
				</span>
			</td>
			<td>
				<xsl:choose>
					<xsl:when test="ancestor::tei:supplied or ancestor::tei:unclear or descendant::tei:supplied or descendant::unclear or @lemma = 'UNKNOWN'">
						<xsl:text>yes</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						no
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
	
	<xsl:template name="contextCell">
		<xsl:param name="wordPosition"/>
		<xsl:param name="lineID"/>
		<xsl:apply-templates mode="data" select="document('stylesheet-ed-ana-general_3_context.xsl')//tei:seg[@type = 'msLine' and @xml:id = $lineID]">
			<xsl:with-param name="wordPosition">
				<xsl:value-of select="$wordPosition"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

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
							select="//tei:w[not(descendant::tei:w) and not(@type = 'data') and not(@xml:lang)]">
							<xsl:call-template name="contentRow"/>
						</xsl:for-each>
					</tbody>
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
			<xsl:when test="@ana = 'prep' and ancestor::tei:w[contains(@ana, 'prep, dpron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'prep' and ancestor::tei:w[contains(@ana, 'prep, poss')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'prep' and ancestor::tei:w[contains(@ana, 'prep, art')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, dpron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'pron, pron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'prep' and ancestor::tei:w[contains(@ana, 'prep, pron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'prep' and ancestor::tei:w[contains(@ana, 'prep, verb')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, dpron')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'art' and ancestor::tei:w[contains(@ana, 'art, dpron')]">
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
			<xsl:when test="@ana = 'adj' and ancestor::tei:w[contains(@ana, 'adj, verb')]">
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
			<xsl:when test="@ana = 'pref' and ancestor::tei:w[contains(@ana, 'prep, noun')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pref' and ancestor::tei:w[contains(@ana, 'prep, num')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'pref' and ancestor::tei:w[contains(@ana, 'pref, vnoun')]">
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
			<xsl:when test="@ana = 'interrog' and ancestor::tei:w[contains(@ana, 'interrog, prep')]">
				<xsl:text/>
			</xsl:when>
			<xsl:when test="@ana = 'interrog' and ancestor::tei:w[contains(@ana, 'interrog, part')]">
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

	<xsl:template match="tei:supplied">
		<xsl:param name="wordID"/>
		<xsl:choose>
			<xsl:when test="descendant::tei:w">
				<xsl:text>[ </xsl:text>
				<span>
					<xsl:apply-templates>
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</span>
				<xsl:text>] </xsl:text>
			</xsl:when>
			<xsl:when test="ancestor::tei:w">
				<xsl:text>[</xsl:text>
				<span>
					<xsl:apply-templates>
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</span>
				<xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:when test="descendant::tei:date">
				<xsl:text> [</xsl:text>
				<span>
					<xsl:apply-templates>
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</span>
				<xsl:text>] </xsl:text>
			</xsl:when>
			<xsl:when test="ancestor::tei:num">
				<xsl:text> [</xsl:text>
				<span>
					<xsl:apply-templates>
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</span>
				<xsl:text>] </xsl:text>
			</xsl:when>
			<xsl:when test="ancestor::tei:date">
				<xsl:text>[</xsl:text>
				<span>
					<xsl:apply-templates>
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</span>
				<xsl:text>]</xsl:text>
			</xsl:when>
			<xsl:when test="descendant::tei:num">
				<xsl:text> [</xsl:text>
				<span>
					<xsl:apply-templates>
						<xsl:with-param name="wordID">
							<xsl:value-of select="$wordID"/>
						</xsl:with-param>
					</xsl:apply-templates>
				</span>
				<xsl:text>] </xsl:text>
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

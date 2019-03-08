<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="3.0">
	<xsl:output method="html"/>

	<xsl:template match="/">
		<html>
			<head>
				<script type="application/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"/>
				<script>
					$(document).ready(function(){
					$('tbody:not(:has(tr))').html('<tr><td>None :-)</td></tr>');
					});
				</script>
				<title><xsl:value-of select="//tei:TEI/@xml:id"/>_error _report_<xsl:call-template name="date"/></title>
			</head>
			<style>
				span {
					display: inline-block;
					margin-right: 0px;
				}</style>
			<body>
				<xsl:call-template name="strayChars"/>
				<xsl:call-template name="abbrCert"/>
				<xsl:call-template name="glyphRef"/>
				<xsl:call-template name="wrongLemma"/>
				<xsl:call-template name="wNoAttrs"/>
				<xsl:call-template name="wBlankAttr"/>
				<xsl:call-template name="wNoText"/>
				<xsl:call-template name="unclearBlankAttr"/>
				<!-- <xsl:call-template name="missingLineNumber"/> -->
			</body>
		</html>
	</xsl:template>

	<xsl:template name="strayChars">
		<h2>&lt;p&gt;/&lt;lg&gt;/&lt;l&gt; elements with direct text node children</h2>
		<table>
			<thead>
				<tr>
					<th width="120">xml:id</th>
				</tr>
			</thead>
			<tbody class="resultsBdy">
				<xsl:choose>
					<xsl:when
						test="//tei:p[ancestor::tei:body]/text()[normalize-space()] or //tei:lg[ancestor::tei:body]/text()[normalize-space()] or //tei:l[ancestor::tei:body]/text()[normalize-space()]">
						<xsl:for-each
							select="//tei:p[child::text()[normalize-space()] and ancestor::tei:body and not(parent::tei:note)]">
							<tr>
								<td>
									<xsl:choose>
										<xsl:when test="name() = 'p'">
											<xsl:text xml:space="preserve">div: </xsl:text>
											<xsl:value-of select="parent::tei:div/@corresp"/>
										</xsl:when>
									</xsl:choose>
								</td>
							</tr>
						</xsl:for-each>
						<xsl:for-each
							select="//tei:lg[ancestor::tei:body and text()[normalize-space()]] | //tei:l[ancestor::tei:body and text()[normalize-space()]]">
							<tr>
								<td>
									<xsl:value-of select="name()"/>
									<xsl:text>: </xsl:text>
									<xsl:value-of select="@xml:id"/>
								</td>
							</tr>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td>None :-)</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="wNoText">
		<h2>&lt;w&gt; containing no text</h2>
		<table>
			<thead>
				<tr>
					<th width="120">MS line</th>
				</tr>
			</thead>
			<tbody class="resultsBdy">
				<xsl:choose>
					<xsl:when test="string(//tei:w[not(descendant::tei:w)]/self::*) = ''">
						<xsl:for-each
							select="//tei:w[not(descendant::tei:w) and string(self::*) = '']">
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
							</tr>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td>None :-)</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="unclearBlankAttr">
		<h2>&lt;unclear&gt; with blank attribute(s)</h2>
		<table>
			<thead>
				<tr>
					<th width="120">MS line</th>
					<th>Word</th>
				</tr>
			</thead>
			<tbody class="resultsBdy">
				<xsl:choose>
					<xsl:when
						test="//tei:unclear[@reason and string(@reason) = '' or @cert and string(@cert) = '' or @resp and string(@resp) = '']">
						<xsl:for-each
							select="//tei:unclear[@reason and string(@reason) = '' or @cert and string(@cert) = '' or @resp and string(@resp) = '']">
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
									<xsl:choose>
										<xsl:when test="ancestor::tei:w[not(descendant::tei:w)]">
											<xsl:variable name="wordID"
												select="count(ancestor::tei:w[not(descendant::tei:w)]/preceding::*)"/>
											<xsl:variable name="abbrID"
												select="count(preceding::tei:abbr[count(ancestor::tei:w[not(descendant::tei:w)]/preceding::*) = $wordID])"/>
											<xsl:variable name="glyphID">
												<xsl:text>xxx</xsl:text>
											</xsl:variable>
											<xsl:apply-templates
												select="tei:w[not(descendant::tei:w)]">
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
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates/>
										</xsl:otherwise>
									</xsl:choose>
								</td>
							</tr>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td colspan="2">None :-)</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="wBlankAttr">
		<h2>&lt;w&gt; with blank attribute(s)</h2>
		<table>
			<thead>
				<tr>
					<th width="120">MS line</th>
					<th>Word</th>
				</tr>
			</thead>
			<tbody class="resultsBdy">
				<xsl:choose>
					<xsl:when
						test="//tei:w[@lemma and string(@lemma) = '' or @lemmaRef and string(@lemmaRef) = '' or @ana and string(@ana) = '' or @xml:lang and string(@xml:lang) = '' or @source and string(@source) = '']">
						<xsl:for-each
							select="//tei:w[@lemma and string(@lemma) = '' or @lemmaRef and string(@lemmaRef) = '' or @ana and string(@ana) = '' or @xml:lang and string(@xml:lang) = '' or @source and string(@source) = '']">
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
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td colspan="2">None :-)</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="missingLineNumber">
		<!--  NOT WORKING -->
		<h2>Broken line number sequence</h2>
		<table>
			<thead>
				<tr>
					<th width="120">MS line</th>
					<th>Preceding line</th>
				</tr>
			</thead>
			<tbody class="resultsBdy">
				<xsl:for-each select="//tei:lb[@xml:id]">
					<xsl:variable name="comPage" select="preceding::tei:pb[1]/@xml:id"/>
					<xsl:choose>
						<xsl:when test="preceding::tei:cb[preceding::tei:lb[1]/@xml:id = $comPage]">
							<xsl:variable name="comCol"
								select="preceding::tei:cb[1][preceding::tei:pb[1][@xml:id = $comPage]]/@xml:id"/>
							<xsl:variable name="precLineNo"
								select="number(preceding::tei:lb[1][@xml:id and preceding::tei:pb[1]/@xml:id = $comPage and preceding::tei:cb[1]/@xml:id = $comCol]/@n)"/>
							<xsl:if
								test="number(@n) &gt; 1 and number(@n) &gt; number($precLineNo + 1)">
								<tr>
									<td>
										<xsl:value-of select="@xml:id"/>
									</td>
									<td>
										<xsl:value-of select="preceding::tei:lb[1][@xml:id]/@xml:id"
										/>
									</td>
								</tr>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="precLineNo"
								select="number(preceding::tei:lb[1][@xml:id and preceding::tei:pb[1]/@xml:id = $comPage]/@n)"/>
							<xsl:if
								test="number(@n) &gt; 1 and number(@n) &gt; number($precLineNo + 1)">
								<tr>
									<td>
										<xsl:value-of select="@xml:id"/>
									</td>
									<td>
										<xsl:value-of select="preceding::tei:lb[1][@xml:id]/@xml:id"
										/>
									</td>
								</tr>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</tbody>
		</table>
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
			<tbody class="resultsBdy">
				<xsl:choose>
					<xsl:when
						test="//tei:w[not(@lemma) and not(@lemmaRef) and not(@ana) and not(@xml:lang)]">
						<xsl:for-each
							select="//tei:w[not(@lemma) and not(@lemmaRef) and not(@ana) and not(@xml:lang)]">
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
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td colspan="2">None :-)</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="abbrCert">
		<h2>&lt;abbr&gt; without @cert</h2>
		<table id="abbrCertTbl">
			<thead>
				<tr>
					<th width="120">MS line</th>
					<th>Word</th>
				</tr>
			</thead>
			<tbody class="resultsBdy">
				<xsl:choose>
					<xsl:when test="//tei:abbr[not(@cert)]">
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
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td colspan="2">None :-)</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>

	</xsl:template>

	<xsl:template name="glyphRef">
		<h2>&lt;g&gt; without @ref</h2>
		<table id="glyphRefTbl">
			<thead>
				<tr>
					<th width="120">MS line</th>
					<th>Word</th>
				</tr>
			</thead>
			<tbody class="resultsBdy">
				<xsl:choose>
					<xsl:when test="//tei:g[not(@ref)]">
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
					</xsl:when>
					<xsl:otherwise>
						<tr>
							<td colspan="2">2</td>
						</tr>
					</xsl:otherwise>
				</xsl:choose>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template name="wrongLemma">
		<xsl:variable name="hwFilepath" select="string('..\..\Transcribing\hwData.xml')"/>
		<h2>Unrecognised Lemmata</h2>
		<table id="wrongLemmaTbl">
			<thead>
				<th width="120">MS line</th>
				<th>Lemma (form)</th>
			</thead>
			<tbody class="resultsBdy">
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

	<xsl:template match="tei:space">
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:text>{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>
	
	<xsl:template name="date">
		<xsl:value-of select="current-dateTime()"/>
	</xsl:template>

</xsl:stylesheet>

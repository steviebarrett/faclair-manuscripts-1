<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="1.0">
	<xsl:strip-space elements="*"/>

	<xsl:output method="html"/>

	<xsl:template match="/">
		<html>
			<head>
				<title>
					<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
				</title>
			</head>
			<body>
				<xsl:apply-templates select="descendant::tei:body"/>
			</body>
			<backmatter>
				<h1>Notes</h1>
				<xsl:for-each select="//tei:note[@type = 'fn']">
					<xsl:value-of select="@n"/>. <xsl:value-of select="tei:p"/><br/>
				</xsl:for-each>
			</backmatter>
		</html>
	</xsl:template>

	<xsl:template match="tei:pb">
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
	</xsl:template>

	<xsl:template match="tei:p//tei:lb">
		<br/>
		<xsl:value-of select="@n"/>
		<xsl:text>. </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="//tei:lg//tei:lb">
		<sub><a title="MS fol/p {preceding::tei:pb/@n}, line {@n}" href="#" onclick="return false;"
				style="text-decoration:none; color:#000000"><xsl:value-of select="@n"/></a>. </sub>
		<xsl:apply-templates/>
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
					<br/>
					<xsl:apply-templates select="descendant::tei:l"/>
				</p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:l">
		<xsl:apply-templates/>
		<br/>
	</xsl:template>

	<xsl:template match="tei:w">
		<xsl:choose>
			<xsl:when test="not(@lemma)">
				<!-- If no @lemma has been entered -->
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
				<!-- If @lemma is UNKNOWN -->
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
				<!-- If there is a @lemma -->
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
						<script>
							function GetWordFile(there) {
							var opened = window.open("");
							opened.document.write("<h1>Test</h1><p><xsl:value-of select="@lemma"/></p>");
							} <!-- Returns "corr" (last @lemma in file) -->
						</script>
						<a id="w" onclick="GetWordFile(this)" lemma="{@lemma}" title="'{@lemma}'; {@ana}"
							style="text-decoration:none; color:#000000">
							<xsl:apply-templates/>
						</a>
						<xsl:text> </xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:w[ancestor::tei:w]">
		<xsl:choose>
			<xsl:when
				test="@ana = 'part' and ancestor::tei:w[contains(@ana, 'part, verb')] | ancestor::tei:w[contains(@ana, 'part, pron, verb')]">
				<a href="{@lemmaRef}" title="'{@lemma}'; {@ana}"
					style="text-decoration:none; color:#000000">
					<xsl:apply-templates/>
					<xsl:text>-</xsl:text>
				</a>
			</xsl:when>
			<xsl:when test="@ana = 'pron' and ancestor::tei:w[contains(@ana, 'part, pron, verb')]">
				<a href="{@lemmaRef}" title="'{@lemma}'; {@ana}"
					style="text-decoration:none; color:#000000">
					<xsl:apply-templates/>
					<xsl:text>-</xsl:text>
				</a>
			</xsl:when>
			<xsl:when test="@ana = 'noun' and ancestor::tei:w[contains(@ana, 'noun, pron')]">
				<a href="{@lemmaRef}" title="'{@lemma}'; {@ana}"
					style="text-decoration:none; color:#000000">
					<xsl:apply-templates/>
					<xsl:text>-</xsl:text>
				</a>
			</xsl:when>
			<xsl:when test="@ana = 'verb' and ancestor::tei:w[contains(@ana, 'verb, pron')]">
				<a href="{@lemmaRef}" title="'{@lemma}'; {@ana}"
					style="text-decoration:none; color:#000000">
					<xsl:apply-templates/>
					<xsl:text>-</xsl:text>
				</a>
			</xsl:when>
			<xsl:when test="not(following-sibling::*)">
				<a href="{@lemmaRef}" title="'{@lemma}'; {@ana}"
					style="text-decoration:none; color:#000000">
					<xsl:apply-templates/>
					<xsl:text> </xsl:text>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="{@lemmaRef}" title="'{@lemma}'; {@ana}"
					style="text-decoration:none; color:#000000">
					<xsl:apply-templates/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:date">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:c">
		<a title="Unexplained character" href="#" onclick="return false;"
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
				<xsl:choose>
					<xsl:when test="@cert = 'low'">
						<a title="{@reason}" style="text-decoration:none; color:#000000" href="#"
							onclick="return false">{ </a>
						<hi background-color="#ffff00">
							<xsl:apply-templates/>
						</hi>
						<a title="{@reason}" style="text-decoration:none; color:#000000" href="#"
							onclick="return false">} </a>
					</xsl:when>
					<xsl:otherwise>
						<a title="{@reason}" style="text-decoration:none; color:#000000" href="#"
							onclick="return false">{ </a>
						<xsl:apply-templates/>
						<a title="{@reason}" style="text-decoration:none; color:#000000" href="#"
							onclick="return false">} </a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@cert = 'low'">
						<a title="{@reason}" style="text-decoration:none; color:#000000" href="#"
							onclick="return false">{</a>
						<hi background-color="#ffff00">
							<xsl:apply-templates/>
						</hi>
						<a title="{@reason}" style="text-decoration:none; color:#000000" href="#"
							onclick="return false">}</a>
					</xsl:when>
					<xsl:otherwise>
						<a title="{@reason}" style="text-decoration:none; color:#000000" href="#"
							onclick="return false">{</a>
						<xsl:apply-templates/>
						<a title="{@reason}" style="text-decoration:none; color:#000000" href="#"
							onclick="return false">}</a>
					</xsl:otherwise>
				</xsl:choose>
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
				<xsl:text> </xsl:text>
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
				<xsl:text> </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:del">
		<del rend="strikethrough">
			<xsl:apply-templates/>
		</del>
	</xsl:template>

	<xsl:template match="tei:choice[descendant::tei:w]">
		<xsl:choose>
			<xsl:when test="child::tei:abbr or child::tei:unclear or child::tei:seg">
				<xsl:choose>
					<xsl:when test="count(child::tei:seg/*/tei:w) > 1">
						<a title="{child::tei:unclear/@reason}"
							style="text-decoration:none; color:#000000" href="#"
							onclick="return false">{</a>
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
						<a title="{child::tei:unclear/@reason}"
							style="text-decoration:none; color:#000000" href="#"
							onclick="return false">}</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="child::*[@n = '1']"/>
						<sub>
							<b>
								<i>
									<a title="Or, {child::*[@n='2']//*} ({child::*[@n='2']//*/@lemma}); {child::*[@n='2']//*/@ana}"
										href="{child::*[@n='2']//*/@lemmaRef}"
										style="text-decoration:none; color:#000000">alt </a>
								</i>
							</b>
						</sub>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="child::tei:sic and child::tei:corr">
				<xsl:choose>
					<xsl:when test="count(child::*/tei:w) > 1">
						<xsl:for-each select="tei:corr//tei:w[@n]">
							<xsl:apply-templates select="self::*"/>
							<xsl:variable name="wpos" select="self::*/@n"/>
							<xsl:choose>
								<xsl:when test="ancestor::tei:choice/tei:sic/tei:w/@lemmaRef">
									<sub>
										<b>
											<i>
												<a
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
												<a
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
								<a href="{child::tei:sic/tei:w/@lemmaRef}"
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
								<a title="MS: {child::tei:sic//*}"
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
		<a title="MS: {child::tei:sic//*}" href="#" style="text-decoration:none; color:#000000"
			onclick="return false">
			<sub>
				<b>
					<i>alt </i>
				</b>
			</sub>
		</a>
	</xsl:template>

	<xsl:template match="tei:note[@type = 'fn']">
		<sup>
			<b>
				<a title="{descendant::tei:p}">
					<xsl:value-of select="@n"/>
				</a>
			</b>
		</sup>
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="tei:add">
		<xsl:choose>
			<xsl:when test="not(descendant::tei:w)">
				<b>
					<a title="Addition by {@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">\</a>
				</b>
				<xsl:text> </xsl:text>
				<a href="{ancestor::tei:w[1]/@lemmaRef}"
					title="'{ancestor::tei:w[1]/@lemma}'; {ancestor::tei:w[1]/@ana}"
					style="text-decoration:none; color:#000000">
					<xsl:apply-templates/>
				</a>
				<xsl:text> </xsl:text>
				<b>
					<a title="Addition by {@resp}" href="#" onclick="return false;"
						style="text-decoration:none; color:#000000">/</a>
				</b>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="@place = 'above'">
						<b>
							<a title="Addition by {@resp}" href="#" onclick="return false;"
								style="text-decoration:none; color:#000000">\</a>
						</b>
						<xsl:text> </xsl:text>
						<xsl:apply-templates/>
						<b>
							<a title="Addition by {@resp}" href="#" onclick="return false;"
								style="text-decoration:none; color:#000000">/</a>
						</b>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:when test="@place = 'below'">
						<b>
							<a title="Addition by {@resp}" href="#" onclick="return false;"
								style="text-decoration:none; color:#000000">/</a>
						</b>
						<xsl:text> </xsl:text>
						<xsl:apply-templates/>
						<b>
							<a title="Addition by {@resp}" href="#" onclick="return false;"
								style="text-decoration:none; color:#000000">\</a>
						</b>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:when test="@place = 'margin, right'">
						<b>
							<a title="Addition by {@resp}" href="#" onclick="return false;"
								style="text-decoration:none; color:#000000">&lt;</a>
						</b>
						<xsl:text> </xsl:text>
						<xsl:apply-templates/>
						<b>
							<a title="Addition by {@resp}" href="#" onclick="return false;"
								style="text-decoration:none; color:#000000">&lt;</a>
						</b>
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:when test="@place = 'margin, left'">
						<b>
							<a title="Addition by {@resp}" href="#" onclick="return false;"
								style="text-decoration:none; color:#000000">&gt;</a>
						</b>
						<xsl:text> </xsl:text>
						<xsl:apply-templates/>
						<b>
							<a title="Addition by {@resp}" href="#" onclick="return false;"
								style="text-decoration:none; color:#000000">&gt;</a>
						</b>
						<xsl:text> </xsl:text>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:handShift">
		<sub>
			<b>
				<a title="beg. {@new}" href="#" onclick="return false;"
					style="text-decoration:none; color:#000000">handShift</a>
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

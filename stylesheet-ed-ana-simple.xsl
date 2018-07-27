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

	<xsl:param name="sicReplace" select="'alt'"/>

	<xsl:attribute-set name="tblBorder">
		<xsl:attribute name="border">solid 0.1mm black</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template name="contentRow">
		<tr>
			<td>
				<xsl:value-of select="position()"/>
			</td>
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
			<td><xsl:value-of select="preceding::tei:lb[1]/@xml:id | preceding::tei:lb[1]/@sameAs"/></td>
		</tr>
	</xsl:template>

	<xsl:template match="/">
		<html>
			<head>
				<h1>Report</h1>
			</head>
			<body>
				<table border="1px solid black" id="tbl">
					<tr>
						<th>ID</th>
						<th>
							<b>Form</b>
						</th>
						<th>
							<b>Lemma</b>
						</th>
						<th>
							<b>Part of Speech</b>
						</th>
						<th><b>MS Ref</b></th>
					</tr>
					<tr>
						<th>Definite Article</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'art') and not(contains(@ana, 'part'))]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Nouns</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'noun') and not(contains(@ana, 'vnoun')) or contains(@ana, 'name') or contains(@ana, 'title')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Pronouns</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'pron')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Possessive Pronouns</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'poss')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Adjectives</th>
					</tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and contains(@ana, 'adj')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Numbers</th>
					</tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and contains(@ana, 'num')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>
							<hi rend="italics">Attá</hi>
						</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and @lemmaRef = 'http://www.dil.ie/4927']">
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>
							<hi rend="italics">Is</hi>
						</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and @lemmaRef = 'http://www.dil.ie/29104']">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Verbs</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'verb') and not(@lemmaRef = 'http://www.dil.ie/29104') and not(@lemmaRef = 'http://www.dil.ie/4927')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Verbal Nouns</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'vnoun')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Participles</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'ptcp')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Adverbs</th>
					</tr>
					<xsl:for-each select="//tei:w[not(descendant::tei:w) and contains(@ana, 'adv')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Conjunctions</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'conj')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Prepositions</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'prep')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Particles</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'part')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Prefixes</th>
					</tr>
					<xsl:for-each
						select="//tei:w[not(descendant::tei:w) and contains(@ana, 'pref')]">
						<xsl:sort select="@lemma"/>
						<xsl:call-template name="contentRow"/>
					</xsl:for-each>
					<tr>
						<th>Unidentified</th>
					</tr>
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

	<xsl:template match="tei:seg[@type = 'catchword']">
		<xsl:text>   </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:seg[@type = 'cfe']">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template name="word" match="tei:w[not(descendant::tei:w)]">
		<xsl:apply-templates/><xsl:if test="ancestor::tei:sic"><b><xsl:text>[sic]</xsl:text></b></xsl:if><xsl:if test="ancestor::tei:corr"><b><xsl:text>[leg]</xsl:text></b></xsl:if>
	</xsl:template>

	<xsl:template match="tei:name">
		<xsl:apply-templates/>
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
		<i>
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

	<xsl:template match="tei:del">
		<del rend="strikethrough">
			<xsl:apply-templates/>
		</del>
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

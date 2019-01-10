<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="2.0">

	<xsl:template match="/">
		<html>
			<head>
				<h1>
					<xsl:value-of select="//tei:titleStmt/tei:title"/>
				</h1>
			</head>
			<body>
				<table border="1px solid black" id="tbl">
					<tr>
						<xsl:for-each select="//*[@type = 'wit']">
							<th>
								<xsl:choose>
									<xsl:when test="@subtype = 'bib'">
										<xsl:value-of select="tei:author/tei:surname"/>
										<xsl:text> (</xsl:text>
										<xsl:value-of select="tei:date"/>
										<xsl:text>)</xsl:text>
									</xsl:when>
									<xsl:when test="@subtype = 'ms'">
										<a href="#" onclick="return false;"
											style="text-decoration:none; color:#000000"
											title="{tei:msIdentifier/tei:msName}">
											<xsl:value-of select="tei:msIdentifier/tei:idno[@type = 'shelfmark']"/>
										</a>
									</xsl:when>
								</xsl:choose>
							</th>
						</xsl:for-each>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>

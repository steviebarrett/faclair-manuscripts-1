<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="1.0">
		
<xsl:output method="html"/>
		
<xsl:key name="abbrs" match="*" use="@xml:id"/>		
		
<xsl:template match="/">
	<xsl:variable name="glyph" select="//tei:TEI[@xml:id='T9']//tei:g"/>
	<xsl:variable name="count" select="count($glyph)"/>
	<html>
		<body>
			<table border="1px solid black">
				<tr>
					<th><b>Abbreviation</b></th>
					<th><b>Count</b></th>
				</tr>
				<xsl:for-each select="$glyph">
				<tr>
					<td><xsl:value-of select="key('abbrs', @ref)/tei:glyphName"/></td>
					<td><xsl:value-of select="$count"/></td>
				</tr>
				</xsl:for-each>
			</table>
		</body>
	</html>
</xsl:template>
		
</xsl:stylesheet>
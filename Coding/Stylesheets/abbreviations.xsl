<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="timestamp">
        <xsl:value-of
            select="
                (current-dateTime() -
                xs:dateTime('1970-01-01T00:00:00'))
                div xs:dayTimeDuration('PT1S') * 1000"
        />
    </xsl:variable>
    <xsl:variable name="transcriptionID">
        <xsl:value-of select="//tei:TEI[not(@xml:id = 'hwData')]/@xml:id"/>
    </xsl:variable>
    <xsl:variable name="filename">
        <xsl:value-of select="concat($transcriptionID, '_abbrvs', '-', $timestamp, '.xhtml')"/>
    </xsl:variable>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xhtml" indent="no"/>
    <xsl:template match="/">
        <xsl:result-document href="Data\abbreviations_data\{$filename}">
            <html xmlns="http://www.w3.org/1999/xhtml">
            <html>
                <head>
                    <title>FnaG MSS: Abbreviation Data</title>
                </head>
                <body>
                    <table>
                        <thead>
                            <tr>
                                <th>
                                    <xsl:text>Hand ID</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>Abbreviation ID</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>Abbreviation Name</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>Abbreviation Count</xsl:text>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each
                                select="//tei:handShift[not(@new = preceding::tei:handShift/@new)]">
                                <xsl:variable name="handID" select="@new"/>
                                <xsl:for-each
                                    select="//tei:g[preceding::tei:handShift[1]/@new = $handID and not(@ref = preceding::tei:g[preceding::tei:handShift[1]/@new = $handID]/@ref)]">
                                    <xsl:variable name="glyphID" select="@ref"/>
                                    <tr>
                                        <td>
                                            <xsl:value-of select="$handID"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="$glyphID"/>
                                        </td>
                                        <td>
                                            <xsl:value-of
                                                select="//tei:glyph[@xml:id = $glyphID]/tei:glyphName"
                                            />
                                        </td>
                                        <td>
                                            <xsl:value-of
                                                select="count(//tei:g[preceding::tei:handShift[1]/@new = $handID and @ref = $glyphID])"
                                            />
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>

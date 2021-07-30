<?xml version="1.0" encoding="UTF-8"?>
<!-- Run this stylesheet on corpus.xml with XInclude links open to get an XHTML table of abbreviation counts by scribe. -->
<!-- Results will be listed under a hand ID but will be based only on transcriptions that in scope. -->
<!-- This table will appear with a unique filename in "faclair-manuscripts\Transcribing\Data\abbreviations_data". -->
<!-- This stylesheet is a work-in-progress. It may be affected by slow performance, especially when run on all or a large part of the corpus, and results may not be accurate. -->
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:tei="https://dasg.ac.uk/corpus/"
    xmlns:ns="https://dasg.ac.uk/corpus/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="timestamp">
        <xsl:value-of
            select="
                (current-dateTime() -
                xs:dateTime('1970-01-01T00:00:00'))
                div xs:dayTimeDuration('PT1S') * 1000"
        />
    </xsl:variable>
    <xsl:variable name="filename">
        <xsl:value-of select="concat('abbrvs', '-', $timestamp, '.xhtml')"/>
    </xsl:variable>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xhtml" indent="no"/>
    <xsl:template match="/">
        <xsl:result-document href="Data\abbreviations_data\{$filename}">
            <html xmlns="http://www.w3.org/1999/xhtml">
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
                                select="//ns:handShift[not(@new = preceding::ns:handShift/@new)]">
                                <xsl:variable name="handID" select="@new"/>
                                <xsl:for-each
                                    select="//ns:g[preceding::ns:handShift[1]/@new = $handID and not(@ref = preceding::ns:g[preceding::ns:handShift[1]/@new = $handID]/@ref)]">
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
                                                select="//ns:glyph[@xml:id = $glyphID]/ns:glyphName"
                                            />
                                        </td>
                                        <td>
                                            <xsl:value-of
                                                select="count(//ns:g[preceding::ns:handShift[1]/@new = $handID and @ref = $glyphID])"
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

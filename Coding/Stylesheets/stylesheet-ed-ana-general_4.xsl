<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/>

    <xsl:output method="xhtml"/>

    <xsl:template match="/">
        <html>
            <head>
                <title> FnaG MSS: Corpus Data </title>
                <style>
                    table,
                    th,
                    td {
                        border: 1px solid black;
                        font-size: 11;
                    }
                    span {
                        display: inline;
                    }</style>
            </head>
            <body>
                <table>
                    <thead>
                        <tr>
                            <th>
                                <xsl:text>Lemma</xsl:text>
                            </th>
                            <th>
                                <xsl:text>Form</xsl:text>
                            </th>
                            <th>
                                <xsl:text>POS</xsl:text>
                            </th>
                            <th>
                                <xsl:text>Scribe</xsl:text>
                            </th>
                            <th>
                                <xsl:text>MS Ref.</xsl:text>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each
                            select="//tei:w[not(descendant::tei:w or @xml:lang or @type = 'data' or ancestor::tei:supplied or ancestor::tei:unclear[@reason = 'damage'] or ancestor::tei:corr) and @lemma]">
                            <xsl:sort order="ascending"
                                select="translate(translate(@lemma, '*-.', ''), 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
                            <xsl:variable name="formPosition" select="position()"/>
                            <tr>
                                <td class="lemma_cell">
                                    <xsl:choose>
                                        <xsl:when test="@lemma">
                                            <span class="lemma">
                                                <a href="{@lemmaRef}" target="_blank">
                                                  <xsl:value-of select="string(@lemma)"/>
                                                </a>
                                            </span>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <span class="lemma">
                                                <xsl:text>[none]</xsl:text>
                                            </span>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </td>
                                <td class="form_cell">
                                    <span class="form">
                                        <xsl:apply-templates mode="form"/>
                                    </span>
                                </td>
                                <td class="pos_cell">
                                    <xsl:choose>
                                        <xsl:when test="@pos">
                                            <span class="pos">
                                                <xsl:value-of select="@pos"/>
                                            </span>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>[none]</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </td>
                                <td class="scribe_cell">
                                    <xsl:choose>
                                        <xsl:when test="@pos">
                                            <span class="scribe">
                                                <xsl:value-of
                                                  select="preceding::tei:handShift[1]/@new"/>
                                            </span>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <span class="scribe">
                                                <xsl:text>[unavailable]</xsl:text>
                                            </span>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </td>
                                <td class="msref_cell">
                                    <xsl:choose>
                                        <xsl:when test="preceding::tei:lb[1]/@xml:id">
                                            <xsl:value-of select="preceding::tei:lb[1]/@xml:id"/>
                                        </xsl:when>
                                        <xsl:when test="preceding::tei:lb[1]/@sameAs">
                                            <xsl:value-of select="preceding::tei:lb[1]/@sameAs"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:abbr" mode="form">
        <xsl:apply-templates mode="form"/>
    </xsl:template>

    <xsl:template match="tei:g" mode="form">
        <span class="expansion" style="text-decoration:underline">
            <xsl:apply-templates mode="form"/>
        </span>
    </xsl:template>

    <xsl:template match="tei:add[@type = 'insertion']" mode="form">
        <span class="insertion">
            <sup>
                <xsl:apply-templates mode="form"/>
            </sup>
        </span>
    </xsl:template>

    <xsl:template match="tei:del" mode="form">
        <span class="deletion">
            <del>
                <xsl:apply-templates mode="form"/>
            </del>
        </span>
    </xsl:template>

    <xsl:template match="tei:unclear" mode="form">
        <span class="unclear">
            <xsl:text>{</xsl:text>
            <xsl:apply-templates mode="form"/>
            <xsl:text>}</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="tei:supplied" mode="form">
        <span class="supplied">
            <xsl:text>[</xsl:text>
            <xsl:apply-templates mode="lowerForm"/>
            <xsl:text>]</xsl:text>
        </span>
    </xsl:template>

    <xsl:template match="tei:seg[@type = 'cfe']" mode="form">
        <xsl:text/>
    </xsl:template>

</xsl:stylesheet>

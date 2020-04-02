<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <html>
            <head>
                <title>FnaG MSS: Verse Line Comparison</title>
            </head>
            <body>
                <table>
                    <thead>
                        <tr>
                            <th>
                                <xsl:text>Line Ref.</xsl:text>
                            </th>
                            <th>
                                <xsl:text>Line</xsl:text>
                            </th>
                            <th>
                                <xsl:text>Similar Line</xsl:text>
                            </th>
                            <th>
                                <xsl:text>Similar Line Ref.</xsl:text>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each select="//tei:l">
                            <xsl:variable name="lineID" select="@xml:id"/>
                            <xsl:for-each select="//tei:l[not(@xml:id = $lineID)]">
                                <xsl:variable name="thisLine" select="@xml:id"/>
                                <xsl:variable name="wordCount"
                                    select="count(//tei:w[@lemmaRef and not(descendant::tei:w) and ancestor::tei:l[@xml:id = $thisLine]])"/>
                                <xsl:variable name="commonWords"
                                    select="count(//tei:w[@lemmaRef and not(descendant::tei:w) and ancestor::tei:l[@xml:id = $thisLine]]/@lemmaRef = //tei:w[@lemmaRef and not(descendant::tei:w) and ancestor::tei:l[@xml:id = $lineID]]/@lemmaRef)"/>
                                <xsl:if test="$commonWords > ($wordCount div 2)"> 
                                    <tr>
                                        <td>
                                            <xsl:value-of select="string($lineID)"/>
                                        </td>
                                        <td>
                                            <xsl:apply-templates select="//tei:l[@xml:id = $lineID]"/>
                                        </td>
                                        <td>
                                            <xsl:apply-templates select="//tei:l[@xml:id = $thisLine]"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="string($thisLine)"/>
                                        </td>
                                    </tr>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:for-each>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="tei:l" mode="context">
        <xsl:param name="formID"/>
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates select="child::*" mode="context">
            <xsl:with-param name="formID" select="$formID"/>
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:w[descendant::tei:w]" mode="context">
        <xsl:param name="formID"/>
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates mode="context">
            <xsl:with-param name="formID" select="$formID"/>
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
        <xsl:if test="not(ancestor::tei:w)">
            <xsl:text xml:space="preserve"> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:w[not(descendant::tei:w)]" mode="context">
        <xsl:param name="formID"/>
        <xsl:param name="formLemRef"/>
        <xsl:variable name="lemRef" select="@lemmaRef"/>
        <xsl:choose>
            <xsl:when test="ancestor::tei:w">
                <xsl:choose>
                    <xsl:when
                        test="following::tei:w[1][@pos = 'verb' and not(@lemmaRef = 'http://www.dil.ie/29104')]">
                        <span class="context_form" title="{concat(@lemma, ', ', @pos)}">
                            <xsl:if test="$lemRef = $formLemRef">
                                <xsl:if test="count(preceding::*) = $formID">
                                    <xsl:attribute name="class">
                                        <xsl:text>form_in_context</xsl:text>
                                    </xsl:attribute>
                                </xsl:if>
                            </xsl:if>
                            <xsl:apply-templates mode="context"/>
                        </span>
                        <xsl:text xml:space="preserve"> </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <span class="context_form" title="{concat(@lemma, ', ', @pos)}">
                            <xsl:if test="$lemRef = $formLemRef">
                                <xsl:if test="count(preceding::*) = $formID">
                                    <xsl:attribute name="class">
                                        <xsl:text>form_in_context</xsl:text>
                                    </xsl:attribute>
                                </xsl:if>
                            </xsl:if>
                            <xsl:apply-templates mode="context"/>
                        </span>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <span class="context_form" title="{concat(@lemma, ', ', @pos)}">
                    <xsl:if test="$lemRef = $formLemRef">
                        <xsl:if test="count(preceding::*) = $formID">
                            <xsl:attribute name="class">
                                <xsl:text>form_in_context</xsl:text>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    <xsl:apply-templates mode="context"/>
                </span>
                <xsl:text xml:space="preserve"> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:abbr" mode="context">
        <xsl:param name="formID"/>
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates mode="context">
            <xsl:with-param name="formID" select="$formID"/>
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:g" mode="context">
        <xsl:param name="formID"/>
        <xsl:param name="formLemRef"/>
        <span class="expansion">
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formID" select="$formID"/>
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template match="tei:name" mode="context">
        <xsl:param name="formID"/>
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates mode="context">
            <xsl:with-param name="formID" select="$formID"/>
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:num" mode="context">
        <xsl:apply-templates mode="context"/>
    </xsl:template>
    <xsl:template match="tei:c" mode="context">
        <xsl:apply-templates mode="context"/>
    </xsl:template>
    <xsl:template match="tei:date" mode="context">
        <xsl:apply-templates mode="context"/>
    </xsl:template>
    <xsl:template match="tei:add[@type = 'insertion']" mode="context">
        <xsl:param name="formID"/>
        <xsl:param name="formLemRef"/>
        <span class="insertion">
            <sup>
                <xsl:apply-templates mode="context">
                    <xsl:with-param name="formID" select="$formID"/>
                    <xsl:with-param name="formLemRef" select="$formLemRef"/>
                </xsl:apply-templates>
            </sup>
        </span>
    </xsl:template>
    <xsl:template match="tei:del" mode="context">
        <xsl:param name="formID"/>
        <xsl:param name="formLemRef"/>
        <del>
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formID" select="$formID"/>
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </del>
    </xsl:template>
    <xsl:template match="tei:unclear[not(@reason = 'damage')]" mode="context">
        <xsl:param name="formID"/>
        <xsl:param name="formLemRef"/>
        <span class="unclear">
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formID" select="$formID"/>
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template match="tei:supplied | tei:unclear[@reason = 'damage']" mode="context">
        <xsl:param name="formID"/>
        <xsl:param name="formLemRef"/>
        <span class="supplied">
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formID" select="$formID"/>
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template match="tei:choice" mode="context">
        <xsl:param name="formID"/>
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates select="tei:corr/child::*" mode="context">
            <xsl:with-param name="formID" select="$formID"/>
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:seg[@type = 'fragment']" mode="context">
        <span class="fragment">
            <xsl:apply-templates mode="context"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:seg[@type = 'cfe']" mode="context">
        <xsl:text/>
    </xsl:template>
    <xsl:template match="tei:gap" mode="context">
        <xsl:text xml:space="preserve">[...] </xsl:text>
    </xsl:template>
    <xsl:template match="tei:space" mode="context">
        <xsl:text/>
    </xsl:template>
</xsl:stylesheet>

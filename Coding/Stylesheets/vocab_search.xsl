<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="vocabItemRef">
        <!-- USER: add URL below -->
        <xsl:value-of select="'http://www.dil.ie/19067'"/>
    </xsl:variable>
    <xsl:variable name="timestamp">
        <xsl:value-of
            select="
                (current-dateTime() -
                xs:dateTime('1970-01-01T00:00:00'))
                div xs:dayTimeDuration('PT1S') * 1000"
        />
    </xsl:variable>
    <xsl:variable name="vocabItem"
        select="//tei:w[@type = 'data' and @lemmaRef = $vocabItemRef]/@lemma"/>
    <xsl:variable name="filename">
        <xsl:value-of select="concat($vocabItem, '-', $timestamp, '.html')"/>
    </xsl:variable>
    <xsl:strip-space elements="*"/>
    <xsl:output method="html" indent="no"/>
    <xsl:template match="/">
        <xsl:result-document href="Data\vocab_searches\{$filename}">
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
                    <title>FnaG MSS: Vocab Item Search</title>
                    <style>
                        table,
                        th,
                        td {
                            border: 1px solid black;
                            font-size: 11;
                        }
                        del {
                            text-decoration: line-through;
                        }
                        span.expansion {
                            font-style: italic;
                        }
                        span.unclear {
                            color: #696969;
                        }
                        span.supplied {
                            font-variant: small-caps;
                            color: #ff0000;
                        }
                        span.form_in_context {
                            background-color: #05ffb0;
                            font-weight: bold;
                        }
                        span.line_number {
                            color: lightgrey;
                        }
                        span.msRef {
                            text-align: center;
                        }</style>
                </head>
                <body>
                    <table>
                        <th> Instances of <i><xsl:value-of select="$vocabItem"/></i> (<xsl:value-of
                                select="current-dateTime()"/>) </th>
                        <xsl:for-each
                            select="//tei:w[not(@type = 'data') and @lemmaRef = $vocabItemRef]">
                            <xsl:variable name="textID"
                                select="ancestor::tei:div[not(ancestor::tei:div)]/@corresp"/>
                            <xsl:variable name="msLine" select="preceding::tei:lb[1]/@xml:id"/>
                            <xsl:variable name="hand" select="preceding::tei:handShift[1]/@new"/>
                            <tr>
                                <td>
                                    <span class="msRef">
                                        <b>
                                            <xsl:value-of
                                                select="ancestor::tei:TEI//tei:sourceDesc/tei:msDesc//tei:msIdentifier/tei:settlement"
                                                />,&#160;<xsl:value-of
                                                select="ancestor::tei:TEI//tei:sourceDesc/tei:msDesc//tei:msIdentifier/tei:repository"
                                                />&#160;<xsl:value-of
                                                select="ancestor::tei:TEI//tei:sourceDesc/tei:msDesc//tei:msIdentifier/tei:idno"/>:&#160;<xsl:choose>
                                                <xsl:when
                                                  test="contains(preceding::tei:pb[1]/@n, 'r') or contains(preceding::tei:pb[1]/@n, 'v')"
                                                  >fol.&#160;</xsl:when>
                                                <xsl:otherwise>p.&#160;</xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:value-of select="preceding::tei:pb[1]/@n"/>
                                            <xsl:if
                                                test="preceding::tei:pb[1]/following::*[1]/name() = 'cb'">
                                                <xsl:value-of
                                                  select="preceding::tei:pb[1]/following::*[1]/@n"/>
                                            </xsl:if><xsl:choose><xsl:when
                                                  test="ancestor::tei:lg[@type = 'stanza']"
                                                  ><xsl:variable name="lbCount"
                                                  select="count(ancestor::tei:lg[@type = 'stanza']//tei:lb)"
                                                  />,&#160;lines&#160;<xsl:choose><xsl:when
                                                  test="$lbCount > 1"><xsl:value-of
                                                  select="ancestor::tei:lg[@type = 'stanza']/descendant::tei:lb[1]/@n"
                                                  />-<xsl:value-of
                                                  select="ancestor::tei:lg[@type = 'stanza']/descendant::tei:lb[$lbCount]/@n"
                                                  /></xsl:when><xsl:otherwise>,&#160;line&#160;<xsl:value-of
                                                  select="$lbCount"/></xsl:otherwise></xsl:choose>
                                                </xsl:when><xsl:otherwise><xsl:choose><xsl:when
                                                  test="count(ancestor::tei:p/descendant::tei:w[not(descendant::tei:w)]) &lt; 200"
                                                  ><xsl:variable name="lbCount"
                                                  select="count(ancestor::tei:p//tei:lb)"
                                                  />,&#160;lines&#160;<xsl:choose><xsl:when
                                                  test="$lbCount > 1"><xsl:value-of
                                                  select="ancestor::tei:p/descendant::tei:lb[1]/@n"
                                                  />-<xsl:value-of
                                                  select="ancestor::tei:p/descendant::tei:lb[$lbCount]/@n"
                                                  /></xsl:when><xsl:otherwise>,&#160;line&#160;<xsl:value-of
                                                  select="$lbCount"
                                                  /></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>,&#160;line&#160;<xsl:value-of
                                                  select="preceding::tei:lb[1][@xml:id]/@n"
                                                  /></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose>
                                        </b>
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Scribe:&#160;</b><xsl:choose>
                                        <xsl:when
                                            test="$hand = //tei:handNote[tei:forename | tei:surname]/@xml:id">
                                            <xsl:value-of
                                                select="//tei:handNote[@xml:id = $hand]/tei:forename"
                                                />&#160;<xsl:value-of
                                                select="//tei:handNote[@xml:id = $hand]/tei:surname"
                                            />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$hand"/>
                                        </xsl:otherwise>
                                    </xsl:choose>&#160;(saec. <xsl:value-of
                                        select="//tei:handNote[@xml:id = $hand]/tei:date"/>) </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Text</b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <xsl:choose>
                                        <xsl:when test="ancestor::tei:lg[@type = 'stanza']">
                                            <xsl:apply-templates select="ancestor::tei:lg"
                                                mode="context">
                                                <xsl:with-param name="formLemRef"
                                                  select="$vocabItemRef"/>
                                            </xsl:apply-templates>
                                        </xsl:when>
                                        <xsl:when test="ancestor::tei:p">
                                            <xsl:choose>
                                                <xsl:when
                                                  test="count(ancestor::tei:p/descendant::tei:w[not(descendant::tei:w)]) &lt; 200">
                                                  <xsl:apply-templates select="ancestor::tei:p"
                                                  mode="context">
                                                  <xsl:with-param name="formLemRef"
                                                  select="$vocabItemRef"/>
                                                  </xsl:apply-templates>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                  <xsl:variable name="prevMsLine"
                                                  select="preceding::tei:lb[1][@xml:id]/preceding::tei:lb[1][@xml:id]/@xml:id"/>
                                                  <xsl:variable name="nextMsLine"
                                                  select="preceding::tei:lb[1][@xml:id]/following::tei:lb[1][@xml:id]/@xml:id"/>
                                                  <span class="line_number"><xsl:value-of
                                                  select="preceding::tei:lb[1][@xml:id]/preceding::tei:lb[1][@xml:id]/@n"
                                                  /></span>&#160;<xsl:apply-templates
                                                  select="preceding::tei:lb[1][@xml:id]/preceding::tei:lb[1][@xml:id]/following::*[parent::tei:p and not(descendant-or-self::tei:lg) and ancestor::tei:div[@corresp = $textID] and preceding::tei:lb[1][@xml:id]/@xml:id = $prevMsLine and not(ancestor::tei:TEI[@xml:id = 'hwData'])]"
                                                  mode="context"/><br/><span class="line_number"
                                                  ><xsl:value-of
                                                  select="preceding::tei:lb[1][@xml:id]/@n"
                                                  /></span>&#160;<xsl:apply-templates
                                                  select="preceding::tei:lb[1][@xml:id]/following::*[parent::tei:p and not(descendant-or-self::tei:lg) and ancestor::tei:div[@corresp = $textID] and preceding::tei:lb[1][@xml:id]/@xml:id = $msLine and not(ancestor::tei:TEI[@xml:id = 'hwData'])]"
                                                  mode="context">
                                                  <xsl:with-param name="formLemRef"
                                                  select="$vocabItemRef"
                                                  /></xsl:apply-templates><br/><span
                                                  class="line_number"><xsl:value-of
                                                  select="preceding::tei:lb[1][@xml:id]/following::tei:lb[1][@xml:id]/@n"
                                                  /></span>&#160;<xsl:apply-templates
                                                  select="preceding::tei:lb[1][@xml:id]/following::tei:lb[1][@xml:id]/following::*[parent::tei:p and not(descendant-or-self::tei:lg) and ancestor::tei:div[@corresp = $textID] and preceding::tei:lb[1][@xml:id]/@xml:id = $nextMsLine and not(ancestor::tei:TEI[@xml:id = 'hwData'])]"
                                                  mode="context"/><br/></xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:text>[unavailable]</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Translation</b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <br/>
                                    <br/>
                                    <br/>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <b>Notes</b>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <br/>
                                    <br/>
                                    <br/>
                                </td>
                            </tr>
                        </xsl:for-each>
                    </table>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    <xsl:template match="tei:lg" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates select="tei:l" mode="context">
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:l" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates select="child::*" mode="context">
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
        <br/>
    </xsl:template>
    <xsl:template match="tei:w[descendant::tei:w]" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:choose>
            <xsl:when test="@lemmaRef = $formLemRef">
                <span class="form_in_context">
                    <xsl:apply-templates mode="context"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="context">
                    <xsl:with-param name="formLemRef" select="$formLemRef"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(ancestor::tei:w)">
            <xsl:text xml:space="preserve"> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:w[not(descendant::tei:w)]" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:choose>
            <xsl:when test="@lemmaRef = $formLemRef">
                <span class="form_in_context">
                    <xsl:apply-templates mode="context"/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="context"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="not(ancestor::tei:w)">
            <xsl:text xml:space="preserve"> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="tei:abbr" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates mode="context">
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:g" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:choose>
            <xsl:when test="contains(@ref, 'l')">
                <xsl:apply-templates mode="context">
                    <xsl:with-param name="formLemRef" select="$formLemRef"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <span class="expansion">
                    <xsl:apply-templates mode="context">
                        <xsl:with-param name="formLemRef" select="$formLemRef"/>
                    </xsl:apply-templates>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:name" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates mode="context">
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="tei:num" mode="context">
        <xsl:apply-templates mode="context"/>
        <xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:note" mode="context">
        <xsl:text/>
    </xsl:template>
    <xsl:template match="tei:c" mode="context">
        <xsl:apply-templates mode="context"/>
        <xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:pc" mode="context">
        <xsl:apply-templates mode="context"/>
        <xsl:text xml:space="preserve"> </xsl:text>

    </xsl:template>
    <xsl:template match="tei:date" mode="context">
        <xsl:apply-templates mode="context"/>
        <xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:add[@type = 'insertion']" mode="context">
        <xsl:param name="formLemRef"/>
        <span class="insertion">
            <sup>
                <xsl:apply-templates mode="context">
                    <xsl:with-param name="formLemRef" select="$formLemRef"/>
                </xsl:apply-templates>
            </sup>
        </span>
    </xsl:template>
    <xsl:template match="tei:del" mode="context">
        <xsl:param name="formLemRef"/>
        <del>
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </del>
    </xsl:template>
    <xsl:template match="tei:unclear[not(@reason = 'damage')]" mode="context">
        <xsl:param name="formLemRef"/>
        <span class="unclear">
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template match="tei:supplied | tei:unclear[@reason = 'damage']" mode="context">
        <xsl:param name="formLemRef"/>
        <span class="supplied">
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template match="tei:choice" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates select="tei:corr/child::*" mode="context">
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
    <xsl:template match="tei:handShift" mode="context">
        <span class="handShift">[hs]</span>
        <xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:space" mode="context">
        <xsl:text/>
    </xsl:template>
</xsl:stylesheet>

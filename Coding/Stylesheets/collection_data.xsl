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
    <xsl:variable name="filename">
        <xsl:value-of select="concat('collection_data', '-', $timestamp, '.xhtml')"/>
    </xsl:variable>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xhtml" indent="no"/>
    <xsl:template match="/">
        <xsl:result-document href="Data\collection_data\{$filename}">
            <html xmlns="http://www.w3.org/1999/xhtml">
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
                            font-style: bold;
                        }</style>
                </head>
                <body>
                    <table
                        id="{(current-dateTime() -
                    xs:dateTime('1970-01-01T00:00:00') )
                    div xs:dayTimeDuration('PT1S') * 1000}">
                        <thead>
                            <tr>
                                <th>
                                    <xsl:text>Lemma</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>Form</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>Form ID</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>Probs?</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>POS</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>OIr. Stem</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>OIr. Gender</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>Scribe</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>MS Ref.</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>Text Ref.</xsl:text>
                                </th>
                                <th>
                                    <xsl:text>Context</xsl:text>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <xsl:for-each
                                select="//tei:w[not(descendant::tei:w or @xml:lang or @type = 'data' or ancestor::tei:supplied or ancestor::tei:unclear[@reason = 'damage'] or ancestor::tei:corr) and @lemma]">
                                <xsl:sort order="ascending"
                                    select="translate(translate(@lemma, '*-.', ''), 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
                                <xsl:sort select="@pos"/>
                                <xsl:sort select="@lemmaRef"/>
                                <xsl:variable name="lineID">
                                    <xsl:choose>
                                        <xsl:when test="preceding::tei:lb[1]/@xml:id">
                                            <xsl:value-of select="preceding::tei:lb[1]/@xml:id"/>
                                        </xsl:when>
                                        <xsl:when test="preceding::tei:lb[1]/@sameAs">
                                            <xsl:value-of select="preceding::tei:lb[1]/@sameAs"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:variable name="formID"
                                    select="concat(ancestor::tei:TEI/@xml:id, '_', count(preceding::*))"/>
                                <xsl:variable name="lemRef" select="@lemmaRef"/>
                                <xsl:variable name="pos" select="@pos"/>
                                <xsl:variable name="divRef">
                                    <xsl:choose>
                                        <xsl:when test="ancestor::tei:div[1]/@corresp">
                                            <xsl:value-of select="ancestor::tei:div[1]/@corresp"/>
                                        </xsl:when>
                                        <xsl:when test="ancestor::tei:div[1]/@xml:id">
                                            <xsl:value-of select="ancestor::tei:div[1]/@xml:id"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:variable>
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
                                            <xsl:call-template name="form"/>
                                        </span>
                                    </td>
                                    <td class="form_ID_cell">
                                        <xsl:value-of select="$formID"/>
                                    </td>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when
                                                test="descendant::tei:abbr[@cert != 'high'] or descendant::tei:unclear or descendant::tei:supplied or @lemma = 'unknown' or ancestor::tei:unclear or ancestor::tei:choice">
                                                <xsl:text>yes</xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>no</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
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
                                    <td class="stem_cell">
                                        <xsl:choose>
                                            <xsl:when
                                                test="//tei:entryFree[@corresp = $lemRef]//tei:iType[@xml:lang = 'sga' or not(@xml:lang)]">
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="//tei:entryFree[@corresp = $lemRef]/tei:gramGrp">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="//tei:entryFree[@corresp = $lemRef]/tei:gramGrp/@type = $pos">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="count(//tei:entryFree[@corresp = $lemRef]/tei:gramGrp[@type = $pos]/tei:iType[@xml:lang = 'sga' or not(@xml:lang)]) > 1">
                                                  <xsl:variable name="iTypeCount"
                                                  select="count(//tei:entryFree[@corresp = $lemRef]/tei:gramGrp[@type = $pos]/tei:iType[@xml:lang = 'sga' or not(@xml:lang)])"/>
                                                  <xsl:for-each
                                                  select="//tei:entryFree[@corresp = $lemRef]/tei:gramGrp[@type = $pos]/tei:iType[@xml:lang = 'sga' or not(@xml:lang)]">
                                                  <xsl:value-of select="string(self::*)"/>
                                                  <xsl:if test="position() &lt; $iTypeCount">
                                                  <xsl:text xml:space="preserve">, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'sga' or not(@xml:lang)]"
                                                  />
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>―</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="count(//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'sga' or not(@xml:lang)]) > 1">
                                                  <xsl:variable name="iTypeCount"
                                                  select="count(//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'sga' or not(@xml:lang)])"/>
                                                  <xsl:for-each
                                                  select="//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'sga' or not(@xml:lang)]">
                                                  <xsl:value-of select="string(self::*)"/>
                                                  <xsl:if test="position() &lt; $iTypeCount">
                                                  <xsl:text xml:space="preserve">, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'sga' or not(@xml:lang)]"
                                                  />
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>―</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td class="gender_cell">
                                        <xsl:choose>
                                            <xsl:when
                                                test="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'sga' or not(@xml:lang)]">
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="//tei:entryFree[@corresp = $lemRef]/tei:gramGrp">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="//tei:entryFree[@corresp = $lemRef]/tei:gramGrp/@type = $pos">
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="count(//tei:entryFree[@corresp = $lemRef]/tei:gramGrp[@type = $pos]/tei:gen[@xml:lang = 'sga' or not(@xml:lang)]) > 1">
                                                  <xsl:variable name="genCount"
                                                  select="count(//tei:entryFree[@corresp = $lemRef]/tei:gramGrp[@type = $pos]/tei:gen[@xml:lang = 'sga' or not(@xml:lang)])"/>
                                                  <xsl:for-each
                                                  select="//tei:entryFree[@corresp = $lemRef]/tei:gramGrp[@type = $pos]/tei:gen[@xml:lang = 'sga' or not(@xml:lang)]">
                                                  <xsl:value-of select="string(self::*)"/>
                                                  <xsl:if test="position() &lt; $genCount">
                                                  <xsl:text xml:space="preserve">, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="//tei:entryFree[@corresp = $lemRef]/tei:gen[@xml:lang = 'sga' or not(@xml:lang)]"
                                                  />
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:text>―</xsl:text>
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:choose>
                                                  <xsl:when
                                                  test="count(//tei:entryFree[@corresp = $lemRef]/tei:gen[@xml:lang = 'sga' or not(@xml:lang)]) > 1">
                                                  <xsl:variable name="genCount"
                                                  select="count(//tei:entryFree[@corresp = $lemRef]/tei:gen[@xml:lang = 'sga' or not(@xml:lang)])"/>
                                                  <xsl:for-each
                                                  select="//tei:entryFree[@corresp = $lemRef]/tei:gen[@xml:lang = 'sga' or not(@xml:lang)]">
                                                  <xsl:value-of select="string(self::*)"/>
                                                  <xsl:if test="position() &lt; $genCount">
                                                  <xsl:text xml:space="preserve">, </xsl:text>
                                                  </xsl:if>
                                                  </xsl:for-each>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:value-of
                                                  select="//tei:entryFree[@corresp = $lemRef]/tei:gen[@xml:lang = 'sga' or not(@xml:lang)]"
                                                  />
                                                  </xsl:otherwise>
                                                  </xsl:choose>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>―</xsl:text>
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
                                        <xsl:value-of select="$lineID"/>
                                    </td>
                                    <td class="textref_cell">
                                        <xsl:choose>
                                            <xsl:when test="ancestor::tei:lg">
                                                <xsl:value-of select="ancestor::tei:l/@xml:id"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$divRef"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                    <td class="context_cell">
                                        <xsl:choose>
                                            <xsl:when test="ancestor::tei:lg[@type = 'stanza']">
                                                <xsl:apply-templates
                                                  select="ancestor::tei:l/child::*" mode="context">
                                                  <xsl:with-param name="formID">
                                                  <xsl:value-of
                                                  select="substring-after($formID, '_')"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="formLemRef">
                                                  <xsl:value-of select="$lemRef"/>
                                                  </xsl:with-param>
                                                </xsl:apply-templates>
                                            </xsl:when>
                                            <xsl:when test="ancestor::tei:p">
                                                <xsl:apply-templates
                                                  select="//tei:lb[@xml:id = $lineID or @sameAs = $lineID]/following::*[parent::tei:p and preceding::tei:lb[1]/@* = $lineID and not(ancestor::tei:TEI[@xml:id = 'hwDats'])]"
                                                  mode="context">
                                                  <xsl:with-param name="formID">
                                                  <xsl:value-of
                                                  select="substring-after($formID, '_')"/>
                                                  </xsl:with-param>
                                                  <xsl:with-param name="formLemRef">
                                                  <xsl:value-of select="$lemRef"/>
                                                  </xsl:with-param>
                                                </xsl:apply-templates>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:text>[unavailable]</xsl:text>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </tbody>
                    </table>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    <xsl:template name="form">
        <span class="form_container">
            <xsl:apply-templates mode="form"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:abbr" mode="form">
        <xsl:apply-templates mode="form"/>
    </xsl:template>
    <xsl:template match="tei:g" mode="form">
        <span class="expansion">
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
            <xsl:apply-templates mode="form"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:supplied" mode="form">
        <span class="supplied">
            <xsl:apply-templates mode="form"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:seg[@type = 'cfe']" mode="form">
        <xsl:text/>
    </xsl:template>
    <xsl:template match="tei:space" mode="form">
        <xsl:text xml:space="preserve"> </xsl:text>
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

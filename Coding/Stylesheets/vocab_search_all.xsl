<?xml version="1.0" encoding="UTF-8"?>
<!-- This stylesheet should be run on corpus.xml with XInclude to sought after transcriptions open. -->
<!-- It will create a unique folder in faclair-manuscripts\Transcribing\Data\vocab_searches and add an HTML file 
    for each headword in the corpus that is tagged with the user-specified part-of-speech in hwData.xml-->
<!-- This HTML file returns the same information for each word as would be returned by an individual search using vocab_search.xsl -->
<!-- Even for a small part-of-speech like "adverb", this transformation is time-consuming. Specifying "noun" or suchlike is likely to result in a lengthy run-time. -->
<!-- WARNING: hwData.xml only stores one part-of-speech for each headword. If a headword can have multiple parts-of-speech, it may not appear where you expect it to. -->
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:tei="https://dasg.ac.uk/corpus/"
    xmlns:ns="https://dasg.ac.uk/corpus/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="html" indent="no"/>
    <!-- USER: Enter the sought for part-of-speech within the single quotes below. -->
    <xsl:variable name="pos" select="'adverb'"/>
    <xsl:template match="/">
        <xsl:for-each select="//ns:w[@type = 'data' and @pos = $pos]">
            <xsl:variable name="vocabItem">
                <xsl:choose>
                    <xsl:when test="contains(@lemmaRef, 'faclair')">
                        <xsl:value-of select="@lemma"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="@lemmaRefDW">
                                <xsl:value-of select="@lemmaDW"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@lemma"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="vocabItemRef" select="@lemmaRef"/>
            <xsl:variable name="timestamp">
                <xsl:value-of
                    select="
                        (current-dateTime() -
                        xs:dateTime('1970-01-01T00:00:00'))
                        div xs:dayTimeDuration('PT1S') * 1000"
                />
            </xsl:variable>
            <xsl:variable name="filename"
                select="concat($vocabItem, '-', generate-id(), '-', $timestamp, '.html')"/>
            <xsl:result-document href="Data\vocab_searches\vocab-{$pos}-{$timestamp}\{$filename}">
                <html xmlns="http://www.w3.org/1999/xhtml">
                    <head>
                        <title>FnaG MSS: Vocab Item Search (Batch)</title>
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
                            <th> Instances of <i><xsl:value-of select="$vocabItem"/></i>
                                    (<xsl:value-of select="current-dateTime()"/>) </th>
                            <xsl:for-each
                                select="//ns:w[not(@type = 'data') and @lemmaRef = $vocabItemRef]">
                                <xsl:variable name="textID"
                                    select="ancestor::ns:div[not(ancestor::ns:div)]/@corresp"/>
                                <xsl:variable name="msLine" select="preceding::ns:lb[1]/@xml:id"/>
                                <xsl:variable name="hand" select="preceding::ns:handShift[1]/@new"/>
                                <tr>
                                    <td>
                                        <span class="msRef">
                                            <b>
                                                <xsl:value-of
                                                  select="ancestor::ns:TEI//ns:sourceDesc/ns:msDesc//ns:msIdentifier/ns:settlement"
                                                  />,&#160;<xsl:value-of
                                                  select="ancestor::ns:TEI//ns:sourceDesc/ns:msDesc//ns:msIdentifier/ns:repository"
                                                  />&#160;<xsl:value-of
                                                  select="ancestor::ns:TEI//ns:sourceDesc/ns:msDesc//ns:msIdentifier/ns:idno"/>:&#160;<xsl:choose>
                                                  <xsl:when
                                                  test="contains(preceding::ns:pb[1]/@n, 'r') or contains(preceding::ns:pb[1]/@n, 'v')"
                                                  >fol.&#160;</xsl:when>
                                                  <xsl:otherwise>p.&#160;</xsl:otherwise>
                                                </xsl:choose>
                                                <xsl:value-of select="preceding::ns:pb[1]/@n"/>
                                                <xsl:if
                                                  test="preceding::ns:pb[1]/following::*[1]/name() = 'cb'">
                                                  <xsl:value-of
                                                  select="preceding::ns:pb[1]/following::*[1]/@n"/>
                                                </xsl:if><xsl:choose><xsl:when
                                                  test="ancestor::ns:lg[@type = 'stanza']"
                                                  ><xsl:variable name="lbCount"
                                                  select="count(ancestor::ns:lg[@type = 'stanza']//ns:lb)"
                                                  />,&#160;lines&#160;<xsl:choose><xsl:when
                                                  test="$lbCount > 1"><xsl:value-of
                                                  select="ancestor::ns:lg[@type = 'stanza']/descendant::ns:lb[1]/@n"
                                                  />-<xsl:value-of
                                                  select="ancestor::ns:lg[@type = 'stanza']/descendant::ns:lb[$lbCount]/@n"
                                                  /></xsl:when><xsl:otherwise>,&#160;line&#160;<xsl:value-of
                                                  select="$lbCount"/></xsl:otherwise></xsl:choose>
                                                  </xsl:when><xsl:otherwise><xsl:choose><xsl:when
                                                  test="count(ancestor::ns:p/descendant::ns:w[not(descendant::ns:w)]) &lt; 200"
                                                  ><xsl:variable name="lbCount"
                                                  select="count(ancestor::ns:p//ns:lb)"
                                                  />,&#160;lines&#160;<xsl:choose><xsl:when
                                                  test="$lbCount > 1"><xsl:value-of
                                                  select="ancestor::ns:p/descendant::ns:lb[1]/@n"
                                                  />-<xsl:value-of
                                                  select="ancestor::ns:p/descendant::ns:lb[$lbCount]/@n"
                                                  /></xsl:when><xsl:otherwise>,&#160;line&#160;<xsl:value-of
                                                  select="$lbCount"
                                                  /></xsl:otherwise></xsl:choose></xsl:when><xsl:otherwise>,&#160;line&#160;<xsl:value-of
                                                  select="preceding::ns:lb[1][@xml:id]/@n"
                                                  /></xsl:otherwise></xsl:choose></xsl:otherwise></xsl:choose>
                                            </b>
                                        </span>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Scribe:&#160;</b><xsl:choose>
                                            <xsl:when
                                                test="$hand = //ns:handNote[ns:forename | ns:surname]/@xml:id">
                                                <xsl:value-of
                                                  select="//ns:handNote[@xml:id = $hand]/ns:forename"
                                                  />&#160;<xsl:value-of
                                                  select="//ns:handNote[@xml:id = $hand]/ns:surname"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$hand"/>
                                            </xsl:otherwise>
                                        </xsl:choose>&#160;(saec. <xsl:value-of
                                            select="//ns:handNote[@xml:id = $hand]/ns:date"/>) </td>
                                </tr>
                                <tr>
                                    <td>
                                        <b>Text</b>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="ancestor::ns:lg[@type = 'stanza']">
                                                <xsl:apply-templates select="ancestor::ns:lg"
                                                  mode="context">
                                                  <xsl:with-param name="formLemRef"
                                                  select="$vocabItemRef"/>
                                                </xsl:apply-templates>
                                            </xsl:when>
                                            <xsl:when test="ancestor::ns:p">
                                                <xsl:choose>
                                                  <xsl:when
                                                  test="count(ancestor::ns:p/descendant::ns:w[not(descendant::ns:w)]) &lt; 200">
                                                  <xsl:apply-templates select="ancestor::ns:p"
                                                  mode="context">
                                                  <xsl:with-param name="formLemRef"
                                                  select="$vocabItemRef"/>
                                                  </xsl:apply-templates>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                  <xsl:variable name="prevMsLine"
                                                  select="preceding::ns:lb[1][@xml:id]/preceding::ns:lb[1][@xml:id]/@xml:id"/>
                                                  <xsl:variable name="nextMsLine"
                                                  select="preceding::ns:lb[1][@xml:id]/following::ns:lb[1][@xml:id]/@xml:id"/>
                                                  <span class="line_number"><xsl:value-of
                                                  select="preceding::ns:lb[1][@xml:id]/preceding::ns:lb[1][@xml:id]/@n"
                                                  /></span>&#160;<xsl:apply-templates
                                                  select="preceding::ns:lb[1][@xml:id]/preceding::ns:lb[1][@xml:id]/following::*[parent::ns:p and not(descendant-or-self::ns:lg) and ancestor::ns:div[@corresp = $textID] and preceding::ns:lb[1][@xml:id]/@xml:id = $prevMsLine and not(ancestor::ns:TEI[@xml:id = 'hwData'])]"
                                                  mode="context"/><br/><span class="line_number"
                                                  ><xsl:value-of
                                                  select="preceding::ns:lb[1][@xml:id]/@n"
                                                  /></span>&#160;<xsl:apply-templates
                                                  select="preceding::ns:lb[1][@xml:id]/following::*[parent::ns:p and not(descendant-or-self::ns:lg) and ancestor::ns:div[@corresp = $textID] and preceding::ns:lb[1][@xml:id]/@xml:id = $msLine and not(ancestor::ns:TEI[@xml:id = 'hwData'])]"
                                                  mode="context">
                                                  <xsl:with-param name="formLemRef"
                                                  select="$vocabItemRef"
                                                  /></xsl:apply-templates><br/><span
                                                  class="line_number"><xsl:value-of
                                                  select="preceding::ns:lb[1][@xml:id]/following::ns:lb[1][@xml:id]/@n"
                                                  /></span>&#160;<xsl:apply-templates
                                                  select="preceding::ns:lb[1][@xml:id]/following::ns:lb[1][@xml:id]/following::*[parent::ns:p and not(descendant-or-self::ns:lg) and ancestor::ns:div[@corresp = $textID] and preceding::ns:lb[1][@xml:id]/@xml:id = $nextMsLine and not(ancestor::ns:TEI[@xml:id = 'hwData'])]"
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
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="ns:lg" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates select="ns:l" mode="context">
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="ns:l" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates select="child::*" mode="context">
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
        <br/>
    </xsl:template>
    <xsl:template match="ns:w[descendant::ns:w]" mode="context">
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
        <xsl:if test="not(ancestor::ns:w)">
            <xsl:text xml:space="preserve"> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="ns:w[not(descendant::ns:w)]" mode="context">
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
        <xsl:if test="not(ancestor::ns:w)">
            <xsl:text xml:space="preserve"> </xsl:text>
        </xsl:if>
    </xsl:template>
    <xsl:template match="ns:abbr" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates mode="context">
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="ns:g" mode="context">
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
    <xsl:template match="ns:name" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates mode="context">
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="ns:num" mode="context">
        <xsl:apply-templates mode="context"/>
        <xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>
    <xsl:template match="ns:note" mode="context">
        <xsl:text/>
    </xsl:template>
    <xsl:template match="ns:c" mode="context">
        <xsl:apply-templates mode="context"/>
        <xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>
    <xsl:template match="ns:pc" mode="context">
        <xsl:apply-templates mode="context"/>
        <xsl:text xml:space="preserve"> </xsl:text>

    </xsl:template>
    <xsl:template match="ns:date" mode="context">
        <xsl:apply-templates mode="context"/>
        <xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>
    <xsl:template match="ns:add[@type = 'insertion']" mode="context">
        <xsl:param name="formLemRef"/>
        <span class="insertion">
            <sup>
                <xsl:apply-templates mode="context">
                    <xsl:with-param name="formLemRef" select="$formLemRef"/>
                </xsl:apply-templates>
            </sup>
        </span>
    </xsl:template>
    <xsl:template match="ns:del" mode="context">
        <xsl:param name="formLemRef"/>
        <del>
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </del>
    </xsl:template>
    <xsl:template match="ns:unclear[not(@reason = 'damage')]" mode="context">
        <xsl:param name="formLemRef"/>
        <span class="unclear">
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template match="ns:supplied | ns:unclear[@reason = 'damage']" mode="context">
        <xsl:param name="formLemRef"/>
        <span class="supplied">
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template match="ns:choice" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates select="ns:corr/child::*" mode="context">
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="ns:seg[@type = 'fragment']" mode="context">
        <span class="fragment">
            <xsl:apply-templates mode="context"/>
        </span>
    </xsl:template>
    <xsl:template match="ns:seg[@type = 'cfe']" mode="context">
        <xsl:text/>
    </xsl:template>
    <xsl:template match="ns:gap" mode="context">
        <xsl:text xml:space="preserve">[...] </xsl:text>
    </xsl:template>
    <xsl:template match="ns:handShift" mode="context">
        <span class="handShift">[hs]</span>
        <xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>
    <xsl:template match="ns:space" mode="context">
        <xsl:text/>
    </xsl:template>
</xsl:stylesheet>

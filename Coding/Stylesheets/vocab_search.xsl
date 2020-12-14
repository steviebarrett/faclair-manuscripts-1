<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:variable name="vocabItemRef">
        <!-- USER: add URL below -->
        <xsl:value-of select="'http://www.dil.ie/36264'"/>
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
    <xsl:variable name="gdVocabItemRef">
        <xsl:choose>
            <xsl:when test="contains($vocabItemRef, 'dil.ie')">
                <xsl:choose>
                    <xsl:when
                        test="document('..\..\Transcribing\hwData.xml')//tei:w[@lemmaRef = $vocabItemRef]/@lemmaRefDW">
                        <xsl:value-of
                            select="document('..\..\Transcribing\hwData.xml')//tei:w[@lemmaRef = $vocabItemRef]/@lemmaRefDW"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>NULL</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="gdVocabItem">
        <xsl:if test="$gdVocabItemRef != 'NULL'">
            <xsl:value-of
                select="document('..\..\Transcribing\hwData.xml')//tei:w[@lemmaRef = $vocabItemRef]/@lemmaDW"
            />
        </xsl:if>
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
                            font-size: 15;
                            width: 70%;
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
                            font-family: "Courier New", monospace;
                        }
                        span.msRef {
                            text-align: center;
                        }
                        span.deletion {
                            text-decoration: line-through;
                        }
                        span.annotation {
                            font-family: "Courier New", monospace;
                        }</style>
                </head>
                <body>
                    <table>
                        <th>Instances of <i><a href="{$vocabItemRef}"><xsl:value-of
                                        select="$vocabItem"/></a></i><xsl:if
                                test="$gdVocabItemRef != 'NULL'"> (ScG. <i><a
                                        href="{$gdVocabItemRef}"><xsl:value-of select="$gdVocabItem"
                                        /></a></i>)</xsl:if> at <xsl:value-of
                                select="current-dateTime()"/></th>
                        <tr class="introduction">
                            <td>
                                <p>The extracts below are presented according to the following
                                    editorial conventions. Please note that these sometimes differ
                                    from those normally employed in printed editions of medieval
                                    Gaelic texts and from those employed on the FnaG MSS Webtool.
                                    This is to avoid computational difficulties associated with
                                    using brackets at the same time as normalising word
                                    division.</p>
                                <ul>
                                    <li>All expansions from abbreviations are <span
                                            class="expansion">italicised</span>.</li>
                                    <li>Text deleted by a scribe (whether the main scribe or a later
                                        scribe) is struck through: <span class="deletion">example of
                                            text deleted by a scribe</span>.</li>
                                    <li>Material inserted by a scribe is in superscript, regardless
                                        of where the scribe added it: <sup>example of text inserted
                                            by a scribe</sup>.</li>
                                    <li>Text supplied by an editor is in red small caps: <span
                                            class="supplied">example of text supplied by an
                                            editor</span>.</li>
                                    <li>Text that has been tagged as unclear is greyed out: <span
                                            class="unclear">example of text that is unclear</span>.
                                        This could be due to issues with legibility or because the
                                        FnaG MSS transcribers are unsure of its interpretation.
                                        Users should consult the TEI XML file or the webtool in
                                        order to learn why the text has been tagged as unclear.</li>
                                    <li>Editorial annotations are presented in a distinctive font:
                                            <span class="annotation">example of an editorial
                                            annotation</span>.</li>
                                    <li><span class="annotation">[...]</span> indicates a lacuna in
                                        the manuscript.</li>
                                    <li>Page, column (where applicable), and line breaks appear
                                        within the extract as editorial annotations.</li>
                                    <li>All punctuation is as per the MS, unless otherwise
                                        indicated.</li>
                                    <li>Occurrences of the searched for headword are <span
                                            class="form_in_context">highlighted</span>.</li>
                                    <li>The line reference (following the shelfmark) given <b>in
                                            bold</b> above the extract is to the occurrence of the
                                        specified headword to which the extract relates. The
                                        tripartite code following it (e.g. "<b>MS1.3v.1</b>")
                                        identifies the line-beginning (&lt;lb&gt;) element in the
                                        TEI XML relating to this line (e.g. &lt;lb n=&quot;1&quot;
                                        xml:id=&quot;MS1.3v.1&quot;/&gt;) to facilitate searching of
                                        the source transcription files, if needed."</li>
                                </ul>
                                <p>Multiple occurrences of the same headword may appear in the same
                                    line (if so, each will be highlighted), but a separate entry is
                                    provided for each occurrence; the same transcription extract may
                                    therefore appear multiple times. The layout of the extract will
                                    vary depending on whether the text is poetry or prose. With
                                    prose, if the headword occurs within a paragrph that is 200
                                    words or less, the entire paragraph will be returned. Otherwise,
                                    the MS line, plus the preceding and following lines, will be
                                    returned.</p>
                                <p>Only occurrences of the headword specified by the inputted URL
                                    will be returned. Instances of closely related headwords will
                                    not be returned. For example, if the specified headword is a
                                    verb, one should not expect the search results to include
                                    instances of the verbal noun or the past participle, if these
                                    have their own dictionary entries: to retrieve instances of the
                                    related verbal noun and past participle, two additional searches
                                    would need to be conducted, one for the verbal noun and one for
                                    the past participle. For more information, see the FnaG MSS
                                        <i>Editorial Policy</i>.</p>
                            </td>
                        </tr>
                        <xsl:for-each
                            select="//tei:w[not(@type = 'data') and @lemmaRef = $vocabItemRef]">
                            <xsl:variable name="textID"
                                select="ancestor::tei:div[not(ancestor::tei:div)]/@corresp"/>
                            <xsl:variable name="msLine"
                                select="preceding::tei:lb[1][@xml:id]/@xml:id"/>
                            <xsl:variable name="msPage"
                                select="preceding::tei:pb[1][@xml:id]/@xml:id"/>
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
                                                select="ancestor::tei:TEI//tei:sourceDesc/tei:msDesc//tei:msIdentifier/tei:idno"/>,&#160;<xsl:choose>
                                                <xsl:when
                                                  test="contains(preceding::tei:pb[1]/@n, 'r') or contains(preceding::tei:pb[1]/@n, 'v')"
                                                  >fol.&#160;</xsl:when>
                                                <xsl:otherwise>p.&#160;</xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:value-of select="preceding::tei:pb[1]/@n"/>
                                            <xsl:if
                                                test="//tei:pb[@xml:id = $msPage]/following::tei:cb/following::tei:lb[@xml:id = $msLine]">
                                                <xsl:value-of select="preceding::tei:cb[1]/@n"/>
                                            </xsl:if>,&#160;line&#160;<xsl:value-of
                                                select="preceding::tei:lb[1][@xml:id]/@n"
                                                />&#160;(<xsl:value-of select="$msLine"/>)</b>
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
                                        <xsl:when test="ancestor::tei:lg">
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
                                                  <xsl:apply-templates
                                                  select="preceding::tei:lb[1][@xml:id]/preceding::tei:lb[1][@xml:id]/following::*[parent::tei:p and not(descendant-or-self::tei:lg) and not(ancestor::tei:note) and ancestor::tei:div[@corresp = $textID] and preceding::tei:lb[1][@xml:id]/@xml:id = $prevMsLine and not(ancestor::tei:TEI[@xml:id = 'hwData'])]"
                                                  mode="context"/>
                                                  <xsl:apply-templates
                                                  select="preceding::tei:lb[1][@xml:id]/following::*[parent::tei:p and not(descendant-or-self::tei:lg) and not(ancestor::tei:note) and ancestor::tei:div[@corresp = $textID] and preceding::tei:lb[1][@xml:id]/@xml:id = $msLine and not(ancestor::tei:TEI[@xml:id = 'hwData'])]"
                                                  mode="context">
                                                  <xsl:with-param name="formLemRef"
                                                  select="$vocabItemRef"/>
                                                  </xsl:apply-templates>
                                                  <xsl:apply-templates
                                                  select="preceding::tei:lb[1][@xml:id]/following::tei:lb[1][@xml:id]/following::*[parent::tei:p and not(descendant-or-self::tei:lg) and not(ancestor::tei:note) and ancestor::tei:div[@corresp = $textID] and preceding::tei:lb[1][@xml:id]/@xml:id = $nextMsLine and not(ancestor::tei:TEI[@xml:id = 'hwData'])]"
                                                  mode="context"/>
                                                  <br/>
                                                </xsl:otherwise>
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
        <xsl:if test="not(ancestor::tei:w)"><xsl:text xml:space="preserve"> </xsl:text></xsl:if>
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
        <span class="deletion">
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template match="tei:unclear[not(@reason = 'damage') and not(@reason = 'fold')]"
        mode="context">
        <xsl:param name="formLemRef"/>
        <span class="unclear">
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template
        match="tei:supplied | tei:unclear[@reason = 'damage'] | tei:unclear[@reason = 'fold']"
        mode="context">
        <xsl:param name="formLemRef"/>
        <span class="supplied">
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template match="tei:choice" mode="context">
        <xsl:param name="formLemRef"/>
        <xsl:apply-templates select="tei:sic/child::*" mode="context">
            <xsl:with-param name="formLemRef" select="$formLemRef"/>
        </xsl:apply-templates>
        <span class="annotation">[&#160;<i>sic</i><xsl:choose><xsl:when
                    test="tei:corr/descendant::*">&#160;;&#160;<i>leg.</i>&#160;<xsl:apply-templates
                        select="tei:corr/child::*" mode="context">
                        <xsl:with-param name="formLemRef" select="$formLemRef"/>
                    </xsl:apply-templates></xsl:when><xsl:otherwise>&#160;</xsl:otherwise></xsl:choose>]&#160;</span>
    </xsl:template>
    <xsl:template match="tei:seg[@type = 'fragment']" mode="context">
        <span class="fragment">
            <xsl:apply-templates mode="context"/>
        </span>
    </xsl:template>
    <xsl:template match="tei:seg[@type = 'cfe']" mode="context">
        <xsl:param name="formLemRef"/>
        <span class="cfe">
            <xsl:apply-templates mode="context">
                <xsl:with-param name="formLemRef" select="$formLemRef"/>
            </xsl:apply-templates>
        </span>
    </xsl:template>
    <xsl:template match="tei:gap" mode="context">
        <span class="annotation">
            <xsl:text xml:space="preserve">[...] </xsl:text>
        </span>
    </xsl:template>
    <xsl:template match="tei:handShift" mode="context">
        <span class="annotation">[hs]</span>
        <xsl:text xml:space="preserve"> </xsl:text>
    </xsl:template>
    <xsl:template match="tei:space" mode="context">
        <xsl:choose>
            <xsl:when test="@type = 'force'">&#160;</xsl:when>
            <xsl:otherwise>
                <xsl:text/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="tei:lb | tei:cb | tei:pb" mode="context">
        <span class="annotation">[<xsl:if test="name() = 'pb'">
                <xsl:choose>
                    <xsl:when test="contains(@n, 'r') or contains(@n, 'v')">fol.&#160;</xsl:when>
                    <xsl:otherwise>p.&#160;</xsl:otherwise>
                </xsl:choose>
                <xsl:value-of select="@n"/>
            </xsl:if>
            <xsl:if test="name() = 'cb'"> col.&#160;<xsl:value-of select="@n"/>
            </xsl:if>
            <xsl:if test="name() = 'lb'">
                <xsl:value-of select="@n"/>
            </xsl:if>]</span>
    </xsl:template>
</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- Returns a GEXF graph file showing vocab used by indvidual paragraphs and poems within one or more texts. The graph can be filtered for content-bearing vocabulary and, where multiple texts are involved, colour-coded by text. -->
<xsl:stylesheet xmlns:ns="https://dasg.ac.uk/corpus/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:viz="http://www.gexf.net/1.2draft/viz" exclude-result-prefixes="xs xsl ns" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <!-- USER: Enter <div> @corresp value for desired text within single quotes as the value of @select. To return data on multiple texts, enter each @corresp value within its own set of single quotes, separated by commas, 
        with the whole list enclosed by round brackets; e.g. "select=('MS12.5', 'MS30.2', 'MS30.24')".-->
    <xsl:variable name="text_id"
        select="('MS4.1', 'MS4.2', 'MS4.3', 'MS4.4', 'MS4.5', 'MS4.6', 'MS4.7', 'MS4.8', 'MS4.9', 'MS4.10', 'MS4.11', 'MS4.12', 'MS4.13', 'MS4.14', 'MS4.15', 'MS4.16', 'MS4.17', 'MS4.18')"/>


    <xsl:template match="/" exclude-result-prefixes="xs xsl ns">
        <gexf xmlns="http://www.gexf.net/1.2draft" xmlns:viz="http://www.gexf.net/1.2draft/viz"
            version="1.2">
            <graph mode="static" defaultedgetype="directed">
                <attributes class="node">
                    <attribute id="att_3" title="cb" type="string"/>
                    <attribute id="att_4" title="div" type="string"/>
                </attributes>
                <nodes>
                    <xsl:call-template name="nodes"/>
                </nodes>
                <edges>
                    <xsl:call-template name="edges"/>
                </edges>
            </graph>
        </gexf>
    </xsl:template>

    <xsl:template name="nodes">
        <xsl:for-each select="//ns:lg[ancestor::ns:div/@corresp = $text_id and @n]">
            <xsl:variable name="id">
                <xsl:choose>
                    <xsl:when
                        test="not(preceding-sibling::*[1]/name() = 'lg') and not(following-sibling::*[1]/name() = 'lg')">
                        <xsl:value-of select="string(@xml:id)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:variable name="stanza_id_length"
                            select="string-length(string(@xml:id))"/>
                        <xsl:choose>
                            <xsl:when test="@n &lt; 10">
                                <xsl:value-of
                                    select="substring(string(@xml:id), 1, ($stanza_id_length - 2))"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="substring(string(@xml:id), 1, ($stanza_id_length - 3))"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="div_id"
                select="string(ancestor::ns:div[not(ancestor::ns:div)]/@corresp)"/>
            <xsl:element name="node">
                <xsl:attribute name="id" select="$id"/>
                <xsl:attribute name="label" select="$id"/>
                <attValues>
                    <attValue for="att_3" value="null"/>
                    <attValue for="att_4" value="{concat($div_id, '_v')}"/>
                </attValues>
                <viz:size value="120"/>
                <viz:color r="3" g="215" b="252"/>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each
            select="//ns:p[ancestor::ns:div/@corresp = $text_id and not(parent::ns:note) and descendant::ns:w[@lemmaRef and not(ancestor::ns:lg)]]">
            <xsl:variable name="div_id"
                select="string(ancestor::ns:div[not(ancestor::ns:div)]/@corresp)"/>
            <xsl:variable name="id"
                select="concat($div_id, '-para_', count(preceding::ns:p[ancestor::ns:div/@corresp = $div_id]) + 1)"/>
            <xsl:element name="node">
                <xsl:attribute name="id" select="$id"/>
                <xsl:attribute name="label" select="$id"/>
                <attValues>
                    <attValue for="att_3" value="null"/>
                    <attValue for="att_4" value="{concat($div_id, '_p')}"/>
                </attValues>
                <viz:size value="120"/>
                <viz:color r="3" g="140" b="252"/>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each
            select="//ns:w[@lemmaRef and not(@type = 'data') and ancestor::ns:div/@corresp = $text_id]">
            <xsl:variable name="cb">
                <xsl:choose>
                    <xsl:when
                        test="@pos = ('noun', 'verb', 'verbal_noun', 'adjective', 'adverb', 'participle', 'verbal_of_necessity')">
                        <xsl:text>true</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>false</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:element name="node">
                <xsl:attribute name="id" select="@lemmaRef"/>
                <xsl:attribute name="label" select="@lemma"/>
                <attValues>
                    <attValue for="att_3" value="{$cb}"/>
                    <attValue for="att_4" value="null"/>
                </attValues>
                <viz:size value="25"/>
                <viz:color r="0" g="0" b="0"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="edges">
        <xsl:for-each
            select="//ns:w[@lemmaRef and not(@type = 'data') and ancestor::ns:div/@corresp = $text_id and not(ancestor::ns:lg[not(@n)])]">
            <xsl:variable name="word_id" select="@lemmaRef"/>
            <xsl:variable name="section_id">
                <xsl:choose>
                    <xsl:when test="ancestor::ns:lg[@n]">
                        <xsl:choose>
                            <xsl:when
                                test="not(ancestor::ns:lg/preceding-sibling::*[1]/name() = 'lg') and not(ancestor::ns:lg/following-sibling::*[1]/name() = 'lg')">
                                <xsl:value-of select="string(ancestor::ns:lg/@xml:id)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="stanza_id_length"
                                    select="string-length(string(ancestor::ns:lg/@xml:id))"/>
                                <xsl:choose>
                                    <xsl:when test="ancestor::ns:lg/@n &lt; 10">
                                        <xsl:value-of
                                            select="substring(string(ancestor::ns:lg/@xml:id), 1, ($stanza_id_length - 2))"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="substring(string(ancestor::ns:lg/@xml:id), 1, ($stanza_id_length - 3))"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="ancestor::ns:p">
                                <xsl:variable name="div_id"
                                    select="string(ancestor::ns:div[not(ancestor::ns:div)]/@corresp)"/>
                                <xsl:value-of
                                    select="concat($div_id, '-para_', count(ancestor::ns:p/preceding::ns:p[ancestor::ns:div/@corresp = $div_id]) + 1)"
                                />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>misc</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:element name="edge">
                <xsl:attribute name="id" select="generate-id()"/>
                <xsl:attribute name="source" select="$section_id"/>
                <xsl:attribute name="target" select="$word_id"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

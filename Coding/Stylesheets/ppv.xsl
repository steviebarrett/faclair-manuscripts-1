<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:viz="http://www.gexf.net/1.2draft/viz" exclude-result-prefixes="xs xsl tei" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="text_id">
        <xsl:text>MS3.1</xsl:text>
    </xsl:variable>

    <xsl:template match="/" exclude-result-prefixes="xs xsl tei">
        <gexf xmlns="http://www.gexf.net/1.2draft" xmlns:viz="http://www.gexf.net/1.2draft/viz"
            version="1.2">
            <graph mode="static" defaultedgetype="directed">
                <attributes class="node">
                    <attribute id="att_3" title="cb" type="string"/>
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
        <xsl:for-each select="//tei:lg[ancestor::tei:div/@corresp = $text_id and @n]">
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
            <xsl:element name="node">
                <xsl:attribute name="id" select="$id"/>
                <xsl:attribute name="label" select="$id"/>
                <attValues>
                    <attValue for="att_3" value="null"/>
                </attValues>
                <viz:size value="120"/>
                <viz:color r="3" g="215" b="252"/>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each
            select="//tei:p[ancestor::tei:div/@corresp = $text_id and not(parent::tei:note) and descendant::tei:w[@lemmaRef and not(ancestor::tei:lg)]]">
            <xsl:variable name="id"
                select="concat('para_', count(preceding::tei:p[ancestor::tei:div/@corresp = $text_id]) + 1)"/>
            <xsl:element name="node">
                <xsl:attribute name="id" select="$id"/>
                <xsl:attribute name="label" select="$id"/>
                <attValues>
                    <attValue for="att_3" value="null"/>
                </attValues>
                <viz:size value="120"/>
                <viz:color r="3" g="140" b="252"/>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each
            select="//tei:w[@lemmaRef and not(@type = 'data') and ancestor::tei:div/@corresp = $text_id]">
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
                </attValues>
                <viz:size value="25"/>
                <viz:color r="0" g="0" b="0"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="edges">
        <xsl:for-each
            select="//tei:w[@lemmaRef and not(@type = 'data') and ancestor::tei:div/@corresp = $text_id and not(ancestor::tei:lg[not(@n)])]">
            <xsl:variable name="word_id" select="@lemmaRef"/>
            <xsl:variable name="section_id">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:lg[@n]">
                        <xsl:choose>
                            <xsl:when
                                test="not(ancestor::tei:lg/preceding-sibling::*[1]/name() = 'lg') and not(ancestor::tei:lg/following-sibling::*[1]/name() = 'lg')">
                                <xsl:value-of select="string(ancestor::tei:lg/@xml:id)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:variable name="stanza_id_length"
                                    select="string-length(string(ancestor::tei:lg/@xml:id))"/>
                                <xsl:choose>
                                    <xsl:when test="ancestor::tei:lg/@n &lt; 10">
                                        <xsl:value-of
                                            select="substring(string(ancestor::tei:lg/@xml:id), 1, ($stanza_id_length - 2))"
                                        />
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="substring(string(ancestor::tei:lg/@xml:id), 1, ($stanza_id_length - 3))"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="ancestor::tei:p">
                                <xsl:value-of
                                    select="concat('para_', count(ancestor::tei:p/preceding::tei:p[ancestor::tei:div/@corresp = $text_id]) + 1)"
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

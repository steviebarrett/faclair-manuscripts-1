<?xml version="1.0" encoding="UTF-8"?>
<!-- Returns a graph showing identfied Gaelic words connected to following identfied Gaelic words in prose and verse. -->
<!-- Run on corpus.xml with XInclude links to files from which data is sought open. hwData is not needed. -->
<!-- Words will not be connected between metrical lines or between <div> elements. -->
<!-- Edges have a "medium" property showing whether they are from prose or verse (NB: depends on merge strategy) -->
<!-- NB: Data will not be entirely accurate, as links will be made across, for example, <gap> and <date> elements. Also, sentence boundaries are not marked up in prose. -->
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:viz="http://www.gexf.net/1.2draft/viz" exclude-result-prefixes="xs xsl tei" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/" exclude-result-prefixes="xs xsl tei">
        <gexf xmlns="http://www.gexf.net/1.2draft" xmlns:viz="http://www.gexf.net/1.2draft/viz"
            version="1.2">
            <graph mode="static" defaultedgetype="directed">
                <attributes class="node">
                    <attribute id="att_1" title="pos" type="string"/>
                </attributes>
                <attributes class="edge">
                    <attribute id="att_2" title="medium" type="string"/>
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
        <xsl:for-each select="//tei:w[@lemmaRef and not(@lemmaRef = preceding::tei:w/@lemmaRef)]">
            <xsl:variable name="id" select="string(@lemmaRef)"/>
            <xsl:variable name="label" select="string(@lemma)"/>
            <xsl:variable name="pos" select="string(@pos)"/>
            <xsl:element name="node">
                <xsl:attribute name="id" select="$id"/>
                <xsl:attribute name="label" select="$label"/>
                <attValues>
                    <attValue for="att_1" value="{$pos}"/>
                </attValues>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="edges">
        <xsl:for-each select="//tei:w[not(descendant::tei:w) and @lemmaRef]">
            <xsl:variable name="textID"
                select="string(ancestor::tei:div[not(ancestor::tei:div)]/@corresp)"/>
            <xsl:variable name="unitID">
                <xsl:choose>
                    <xsl:when test="ancestor::*[ancestor::tei:body and @xml:id]">
                        <xsl:value-of select="string(ancestor::*[@xml:id][1]/@xml:id)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'NULL'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="word_id" select="string(@lemmaRef)"/>
            <xsl:variable name="context">
                <xsl:choose>
                    <xsl:when test="ancestor::tei:lg">
                        <xsl:value-of select="'verse'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'prose'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:if test="following::tei:w[1]/@lemmaRef">
                <xsl:if test="following::tei:w[1]/ancestor::tei:div[@corresp = $textID]">
                    <xsl:variable name="next_word_id" select="string(following::tei:w[1]/@lemmaRef)"/>
                    <xsl:choose>
                        <xsl:when test="$unitID != 'NULL'">
                            <xsl:if test="following::tei:w[1]/ancestor::*[@xml:id = $unitID]">
                                <xsl:element name="edge">
                                    <xsl:attribute name="id" select="generate-id()"/>
                                    <xsl:attribute name="source" select="$word_id"/>
                                    <xsl:attribute name="target" select="$next_word_id"/>
                                    <attValues>
                                        <attValue for="att_2" value="{$context}"/>
                                    </attValues>
                                </xsl:element>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="edge">
                                <xsl:attribute name="id" select="generate-id()"/>
                                <xsl:attribute name="source" select="$word_id"/>
                                <xsl:attribute name="target" select="$next_word_id"/>
                                <attValues>
                                    <attValue for="att_2" value="{$context}"/>
                                </attValues>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>


</xsl:stylesheet>

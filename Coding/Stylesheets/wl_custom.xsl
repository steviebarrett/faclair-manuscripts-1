<?xml version="1.0" encoding="UTF-8"?>
<!-- Returns a graph with nodes representing headwords and edges linking a word with the following word within the same metrical line. User can specify the text(s) for which data is to be returned. 
    Run on corpus.xml with xInclude links to in-scope file(s) open. -->
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:viz="http://www.gexf.net/1.2draft/viz" exclude-result-prefixes="xs xsl tei" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <!-- USER: Enter <div> @corresp value for desired text within single quotes @select. To return data on multiple texts, enter each @corresp value within its own set of single quotes, separated by commas, 
        with the whole list enclosed by round brackets; e.g. "('MS12.5', 'MS30.2', 'MS30.24')".-->
    <xsl:variable name="target_text" select="('MS12.5', 'MS30.2', 'MS30.24')"/>

    <xsl:template match="/" exclude-result-prefixes="xs xsl tei">
        <gexf xmlns="http://www.gexf.net/1.2draft" xmlns:viz="http://www.gexf.net/1.2draft/viz"
            version="1.2">
            <graph mode="static" defaultedgetype="directed">
                <attributes class="node">
                    <attribute id="att_1" title="pos" type="string"/>
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
        <xsl:for-each
            select="//tei:w[ancestor::tei:div[@corresp = $target_text] and ancestor::tei:l and not(descendant::tei:w) and @lemmaRef]">
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
        <xsl:for-each
            select="//tei:l[ancestor::tei:div[@corresp = $target_text]]//tei:w[not(descendant::tei:w) and @lemmaRef]">
            <xsl:variable name="line_id" select="ancestor::tei:l/@xml:id"/>
            <xsl:if
                test="following::tei:w[not(descendant::tei:w) and @lemmaRef and ancestor::tei:l/@xml:id = $line_id][1]">
                <xsl:variable name="word_id" select="string(@lemmaRef)"/>
                <xsl:variable name="next_word_id"
                    select="string(following::tei:w[not(descendant::tei:w) and @lemmaRef and ancestor::tei:l/@xml:id = $line_id][1]/@lemmaRef)"/>
                <xsl:element name="edge">
                    <xsl:attribute name="id" select="generate-id()"/>
                    <xsl:attribute name="source" select="$word_id"/>
                    <xsl:attribute name="target" select="$next_word_id"/>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

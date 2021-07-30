<?xml version="1.0" encoding="UTF-8"?>
<!-- Run on corpus.xml with requisite XInclude links open. -->
<!-- Returns a GEXF graph file showing vocab used by indvidual paragraphs and verse stanzas ("stanza" + "paragraph" + "vocab") within one or more user-specified texts. -->
<!-- The graph can be filtered for content-bearing vocabulary and, where multiple texts are involved, colour-coded by text. -->
<xsl:stylesheet xmlns:tei="https://dasg.ac.uk/corpus/" xmlns:ns="https://dasg.ac.uk/corpus/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:viz="http://www.gexf.net/1.2draft/viz" exclude-result-prefixes="xs xsl tei" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:variable name="text_id" select="('MS30.1', 'MS30.2', 'MS30.3', 'MS30.4', 'MS30.5', 'MS30.6', 'MS30.7', 'MS30.8', 'MS30.9', 'MS30.10', 'MS30.11', 'MS30.12', 'MS30.13', 'MS30.14', 'MS30.15', 'MS30.16', 'MS30.17', 'MS30.18', 'MS30.19', 'MS30.20', 'MS30.21', 'MS30.22', 'MS30.23', 'MS30.24', 'MS30.25', 'MS30.26', 'MS30.27', 'MS30.28', 'MS30.29', 'MS30.30')"/>

    <xsl:variable name="timestamp">
        <xsl:value-of
            select="
            (current-dateTime() -
            xs:dateTime('1970-01-01T00:00:00'))
            div xs:dayTimeDuration('PT1S') * 1000"
        />
    </xsl:variable>
    
    <xsl:variable name="filename">
        <xsl:value-of select="concat('spv', '-', $timestamp, '.gexf')"/>
    </xsl:variable>

    <xsl:template match="/" exclude-result-prefixes="xs xsl tei">
        <xsl:result-document href="Data\viz\outputs\{$filename}"><gexf xmlns="http://www.gexf.net/1.2draft" xmlns:viz="http://www.gexf.net/1.2draft/viz"
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
        </gexf></xsl:result-document>
    </xsl:template>

    <xsl:template name="nodes">
        <xsl:for-each select="//ns:lg[ancestor::ns:div/@corresp = $text_id]">
            <xsl:variable name="id" select="@xml:id"/>
            <xsl:variable name="div_id"
                select="string(ancestor::ns:div[not(ancestor::ns:div)]/@corresp)"/>
            <xsl:element name="node">
                <xsl:attribute name="id" select="$id"/>
                <xsl:attribute name="label" select="$id"/>
                <attValues>
                    <attValue for="att_3" value="null"/>
                    <attValue for="att_4" value="{concat($div_id, '_v')}"/>
                </attValues>
                <viz:size value="100"/>
                <viz:color r="3" g="215" b="252"/>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each
            select="//ns:p[ancestor::ns:div/@corresp = $text_id and not(parent::ns:note) and descendant::ns:w[@lemmaRef]]">
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
            select="//ns:w[@lemmaRef and not(@type = 'data') and ancestor::ns:div/@corresp = $text_id]">
            <xsl:variable name="word_id" select="@lemmaRef"/>
            <xsl:variable name="section_id">
                <xsl:choose>
                    <xsl:when test="ancestor::ns:lg">
                        <xsl:value-of select="ancestor::ns:lg/@xml:id"/>
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

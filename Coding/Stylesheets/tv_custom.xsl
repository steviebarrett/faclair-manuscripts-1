<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:viz="http://www.gexf.net/1.2draft/viz" exclude-result-prefixes="xs xsl tei" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:template match="/" exclude-result-prefixes="xs xsl tei">
        <gexf xmlns="http://www.gexf.net/1.2draft" xmlns:viz="http://www.gexf.net/1.2draft/viz"
            version="1.2">
            <graph mode="static" defaultedgetype="directed">
                <attributes class="node">
                    <attribute id="att_2" title="pos" type="string"/>
                    <attribute id="att_3" title="cb" type="string"/>
                    <attribute id="att_4" title="genre" type="string"/>
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
        <xsl:for-each select="//tei:div[not(ancestor::tei:div) and @corresp = //tei:msItem[descendant::tei:term = ('bardic')]/@xml:id]"
            exclude-result-prefixes="xs xsl tei">
            <xsl:variable name="text_id" select="string(@corresp)"/>
            <xsl:variable name="scribe"
                select="string(ancestor::tei:TEI//tei:msItem[@xml:id = $text_id]/tei:author[@role = 'scribe'][1]/@corresp)"/>
            <xsl:variable name="affil"
                select="string(//tei:teiCorpus//tei:handNotes/tei:handNote[@xml:id = $scribe]/tei:affiliation)"/>
            <xsl:variable name="genre">
                <xsl:variable name="term_count"
                    select="count(ancestor::tei:TEI//tei:msItem[@xml:id = $text_id]//tei:keywords/tei:term)"/>
                <xsl:for-each
                    select="ancestor::tei:TEI//tei:msItem[@xml:id = $text_id]//tei:keywords/tei:term">
                    <xsl:value-of select="string(.)"/>
                    <xsl:if test="position() &lt; $term_count">
                        <xsl:text xml:space="preserve"> | </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:element name="node">
                <xsl:attribute name="id" select="$text_id"/>
                <xsl:attribute name="label" select="string(ancestor::tei:TEI//tei:msItem[@xml:id = $text_id]/tei:title)"/>
                <attValues>
                    <attValue for="att_2" value="_"/>
                    <attValue for="att_3" value="_"/>
                    <attValue for="att_4" value="{$genre}"/>
                </attValues>
                <viz:size value="100"/>
                <xsl:element namespace="viz" name="color">
                    <xsl:attribute name="r">
                        <xsl:value-of
                            select="string(document('..\..\Transcribing\Data\viz\color_codes.xml')//affiliation[@id = $affil]/r)"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="g">
                        <xsl:value-of
                            select="string(document('..\..\Transcribing\Data\viz\color_codes.xml')//affiliation[@id = $affil]/g)"
                        />
                    </xsl:attribute>
                    <xsl:attribute name="b">
                        <xsl:value-of
                            select="string(document('..\..\Transcribing\Data\viz\color_codes.xml')//affiliation[@id = $affil]/b)"
                        />
                    </xsl:attribute>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each
            select="//tei:w[@lemmaRef and not(@type = 'data') and ancestor::tei:div[not(ancestor::tei:div)]/@corresp = //tei:msItem[descendant::tei:term = ('bardic')]/@xml:id]"
            exclude-result-prefixes="xs xsl tei">
            <xsl:variable name="lemRef" select="string(@lemmaRef)"/>
            <xsl:variable name="lem" select="string(@lemma)"/>
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
            <xsl:variable name="genre"/>
            <xsl:element name="node">
                <xsl:attribute name="id" select="$lemRef"/>
                <xsl:attribute name="label" select="$lem"/>
                <attValues>
                    <attValue for="att_2" value="{@pos}"/>
                    <attValue for="att_3" value="{$cb}"/>
                    <attValue for="att_4" value="_"/>
                </attValues>
                <viz:size value="15"/>
                <viz:color r="0" g="0" b="0"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="edges">
        <xsl:for-each select="//tei:w[@lemmaRef and not(@type = 'data') and ancestor::tei:div[not(ancestor::tei:div)]/@corresp = //tei:msItem[descendant::tei:term = ('bardic')]/@xml:id]"
            exclude-result-prefixes="xs xsl tei">
            <xsl:variable name="word" select="string(@lemmaRef)"/>
            <xsl:variable name="text"
                select="string(ancestor::tei:div[not(ancestor::tei:div)]/@corresp)"/>
            <xsl:element name="edge">
                <xsl:attribute name="id" select="generate-id()"/>
                <xsl:attribute name="source" select="$text"/>
                <xsl:attribute name="target" select="$word"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

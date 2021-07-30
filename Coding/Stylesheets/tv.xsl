<?xml version="1.0" encoding="UTF-8"?>
<!-- This stylesheet ("texts + vocab") should be run on corpus.xml with XInclude links to transcription files open. -->
<!-- It will return a GEXF network graph file showing vocabulary item use by individual text, which will be saved to "faclair-manuscripts\Transcribing\Data\viz". This can be opened directly in Gephi.  -->
<xsl:stylesheet xmlns:ns="https://dasg.ac.uk/corpus/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:viz="http://www.gexf.net/1.2draft/viz" exclude-result-prefixes="xs xsl ns" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

    <xsl:variable name="timestamp">
        <xsl:value-of
            select="
                (current-dateTime() -
                xs:dateTime('1970-01-01T00:00:00'))
                div xs:dayTimeDuration('PT1S') * 1000"
        />
    </xsl:variable>

    <xsl:variable name="filename">
        <xsl:value-of select="concat('tv', '-', $timestamp, '.gexf')"/>
    </xsl:variable>

    <xsl:template match="/" exclude-result-prefixes="xs xsl ns">
        <xsl:result-document href="Data\viz\outputs\{$filename}">
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
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="nodes">
        <xsl:for-each select="//ns:div[not(ancestor::ns:div)]" exclude-result-prefixes="xs xsl ns">
            <xsl:variable name="text_id" select="string(@corresp)"/>
            <xsl:variable name="scribe"
                select="string(ancestor::ns:TEI//ns:msItem[@xml:id = $text_id]/ns:author[@role = 'scribe'][1]/@corresp)"/>
            <xsl:variable name="affil"
                select="string(//ns:teiCorpus//ns:handNotes/ns:handNote[@xml:id = $scribe]/ns:affiliation)"/>
            <xsl:variable name="genre">
                <xsl:variable name="term_count"
                    select="count(ancestor::ns:TEI//ns:msItem[@xml:id = $text_id]//ns:keywords/ns:term)"/>
                <xsl:for-each
                    select="ancestor::ns:TEI//ns:msItem[@xml:id = $text_id]//ns:keywords/ns:term">
                    <xsl:value-of select="string(.)"/>
                    <xsl:if test="position() &lt; $term_count">
                        <xsl:text xml:space="preserve"> | </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </xsl:variable>
            <xsl:element name="node">
                <xsl:attribute name="id" select="$text_id"/>
                <xsl:attribute name="label"
                    select="string(ancestor::ns:TEI//ns:msItem[@xml:id = $text_id]/ns:title)"/>
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
        <xsl:for-each select="//ns:w[@lemmaRef and not(@type = 'data')]"
            exclude-result-prefixes="xs xsl ns">
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
        <xsl:for-each select="//ns:w[@lemmaRef and not(@type = 'data')]"
            exclude-result-prefixes="xs xsl ns">
            <xsl:variable name="word" select="string(@lemmaRef)"/>
            <xsl:variable name="text"
                select="string(ancestor::ns:div[not(ancestor::ns:div)]/@corresp)"/>
            <xsl:element name="edge">
                <xsl:attribute name="id" select="generate-id()"/>
                <xsl:attribute name="source" select="$text"/>
                <xsl:attribute name="target" select="$word"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

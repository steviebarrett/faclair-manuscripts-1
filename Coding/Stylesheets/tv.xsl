<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:viz="http://www.gexf.net/1.2draft/viz" exclude-result-prefixes="xs xsl tei" version="3.0">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    
    <xsl:template match="/" exclude-result-prefixes="xs xsl tei">
        <gexf xmlns="http://www.gexf.net/1.2draft" xmlns:viz="http://www.gexf.net/1.2draft/viz"
            version="1.2">
            <graph mode="static" defaultedgetype="directed">
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
        <xsl:for-each select="//tei:div[not(ancestor::tei:div)]"
            exclude-result-prefixes="xs xsl tei">
            <xsl:variable name="text_id" select="string(@corresp)"/>
            <xsl:variable name="scribe" select="string(ancestor::tei:TEI//tei:msItem[@xml:id = $text_id]/tei:author[@role = 'scribe'][1]/@corresp)"/>
            <xsl:variable name="affil" select="string(//tei:teiCorpus//tei:handNotes/tei:handNote[@xml:id = $scribe]/tei:affiliation)"/>
            <xsl:element name="node">
                <xsl:attribute name="id" select="$text_id"/>
                <xsl:attribute name="label" select="string(ancestor::tei:TEI//tei:msItem[@xml:id = $text_id]/tei:title)"/>
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
            select="//tei:w[@lemmaRef and not(@type = 'data') and not(@lemmaRef = preceding::tei:w[not(@type = 'data')]/@lemmaRef)]"
            exclude-result-prefixes="xs xsl tei">
            <xsl:variable name="lemRef" select="string(@lemmaRef)"/>
            <xsl:variable name="lem" select="string(@lemma)"/>
            <xsl:element name="node">
                <xsl:attribute name="id" select="$lemRef"/>
                <xsl:attribute name="label" select="$lem"/>
                <viz:size value="15"/>
                <viz:color r="0" g="0" b="0"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template name="edges">
        <xsl:for-each select="//tei:w[@lemmaRef and not(@type = 'data')]"
            exclude-result-prefixes="xs xsl tei">
            <xsl:variable name="word" select="string(@lemmaRef)"/>
            <xsl:variable name="text" select="string(ancestor::tei:div[not(ancestor::tei:div)]/@corresp)"/>
            <xsl:element name="edge">
                <xsl:attribute name="id" select="generate-id()"/>
                <xsl:attribute name="source" select="$text"/>
                <xsl:attribute name="target" select="$word"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>

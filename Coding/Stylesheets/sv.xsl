<?xml version="1.0" encoding="UTF-8"?>
<!-- This stylesheet ("scribes + vocab") should be run on corpus.xml with XInclude links to transcription files open. -->
<!-- It will return a GEXF network graph file showing vocabulary item use by scribal hand, which will be saved to "faclair-manuscripts\Transcribing\Data\viz". This can be opened directly in Gephi.  -->
<xsl:stylesheet xmlns:tei="https://dasg.ac.uk/corpus/" xmlns:ns="https://dasg.ac.uk/corpus/"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:viz="http://www.gexf.net/1.2draft/viz" exclude-result-prefixes="xs xsl tei" version="3.0">
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
        <xsl:value-of select="concat('sv', '-', $timestamp, '.gexf')"/>
    </xsl:variable>

    <xsl:template match="/" exclude-result-prefixes="xs xsl tei">
        <xsl:result-document href="Data\viz\outputs\{$filename}"><gexf xmlns="http://www.gexf.net/1.2draft" xmlns:viz="http://www.gexf.net/1.2draft/viz"
            version="1.2">
            <graph mode="static" defaultedgetype="directed">
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
        <xsl:for-each select="//tei:teiCorpus//tei:handNotes/tei:handNote[@xml:id]"
            exclude-result-prefixes="xs xsl tei">
            <xsl:variable name="scribe" select="string(@xml:id)"/>
            <xsl:variable name="affil" select="tei:affiliation"/>
            <xsl:element name="node" namespace="">
                <xsl:attribute name="id" select="$scribe"/>
                <xsl:attribute name="label" select="$scribe"/>
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
            <xsl:element name="node" namespace="">
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
            <xsl:variable name="scribe" select="string(preceding::tei:handShift[1]/@new)"/>
            <xsl:element name="edge" namespace="">
                <xsl:attribute name="id" select="generate-id()"/>
                <xsl:attribute name="source" select="$scribe"/>
                <xsl:attribute name="target" select="$word"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

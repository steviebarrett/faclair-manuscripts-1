<?xml version="1.0" encoding="UTF-8"?>
<!-- This stylesheet ("manuscripts + vocab") should be run on corpus.xml with XInclude links to transcription files open. -->
<!-- It will return a GEXF network graph file showing vocabulary item use by manuscript, which will be saved to "faclair-manuscripts\Transcribing\Data\viz". This can be opened directly in Gephi.  -->
<!-- Note that, for simplicity, the manuscript will be colour-coded according to the identity of the first hand that appears in the transcription therefrom. This may occasionally result in inaccurate colour-coding. -->
<!-- When run on the whole corpus, this transformation can take some time (435 seconds, in July 2021). -->
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
        <xsl:value-of select="concat('mv', '-', $timestamp, '.gexf')"/>
    </xsl:variable>

    <xsl:template match="/" exclude-result-prefixes="xs xsl tei">
        <xsl:result-document href="Data\viz\outputs\{$filename}">
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
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="nodes">
        <xsl:for-each select="//ns:TEI[not(@xml:id='hwData')]" exclude-result-prefixes="xs xsl tei">
            <xsl:variable name="ms_id" select="@xml:id"/>
            <xsl:variable name="scribe" select="string(descendant::ns:handShift[1]/@new)"/>
            <xsl:variable name="affil"
                select="string(//ns:teiCorpus//ns:handNotes/ns:handNote[@xml:id = $scribe]/ns:affiliation)"/>
            <xsl:element name="node">
                <xsl:attribute name="id" select="$ms_id"/>
                <xsl:attribute name="label"
                    select="concat(descendant::ns:msIdentifier/ns:repository, ' ', descendant::ns:msIdentifier/ns:idno)"/>
                <viz:size value="120"/>
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
            select="//ns:w[@lemmaRef and not(@type = 'data') and not(@lemmaRef = preceding::ns:w[not(@type = 'data')]/@lemmaRef)]"
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
        <xsl:for-each select="//ns:w[@lemmaRef and not(@type = 'data')]"
            exclude-result-prefixes="xs xsl tei">
            <xsl:variable name="word" select="string(@lemmaRef)"/>
            <xsl:variable name="ms" select="string(ancestor::ns:TEI/@xml:id)"/>
            <xsl:element name="edge">
                <xsl:attribute name="id" select="generate-id()"/>
                <xsl:attribute name="source" select="$ms"/>
                <xsl:attribute name="target" select="$word"/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- Returns a graph with nodes representing headwords and edges linking a word with the following word within the same metrical line. Run on corpus.xml with xInclude links to in-scope files open. -->
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
        <xsl:value-of select="concat('wl', '-', $timestamp, '.gexf')"/>
    </xsl:variable>

    <xsl:template match="/" exclude-result-prefixes="xs xsl ns">
        <xsl:result-document href="Data\viz\outputs\{$filename}"><gexf xmlns="http://www.gexf.net/1.2draft" xmlns:viz="http://www.gexf.net/1.2draft/viz"
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
        </gexf></xsl:result-document>
    </xsl:template>

    <xsl:template name="nodes">
        <xsl:for-each select="//ns:w[ancestor::ns:l and not(descendant::ns:w) and @lemmaRef]">
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
        <xsl:for-each select="//ns:l//ns:w[not(descendant::ns:w) and @lemmaRef]">
            <xsl:variable name="line_id" select="ancestor::ns:l/@xml:id"/>
            <xsl:if
                test="following::ns:w[not(descendant::ns:w) and @lemmaRef and ancestor::ns:l/@xml:id = $line_id][1]">
                <xsl:variable name="word_id" select="string(@lemmaRef)"/>
                <xsl:variable name="next_word_id"
                    select="string(following::ns:w[not(descendant::ns:w) and @lemmaRef and ancestor::ns:l/@xml:id = $line_id][1]/@lemmaRef)"/>
                <xsl:element name="edge">
                    <xsl:attribute name="id" select="generate-id()"/>
                    <xsl:attribute name="source" select="$word_id"/>
                    <xsl:attribute name="target" select="$next_word_id"/>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

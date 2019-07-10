<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>


    <xsl:template match="/">
        <xsl:variable name="timestamp" select="(current-dateTime() -
            xs:dateTime('1970-01-01T00:00:00') )
            div xs:dayTimeDuration('PT1S') * 1000"/>
        <xsl:result-document
            href="corpus_contexts-{$timestamp}.xml">
            <tei:TEI>
                <xsl:attribute name="xml:id" select="concat('msLines_', $timestamp)"/>
                <tei:teiHeader>
                    <tei:fileDesc>
                        <tei:titleStmt>
                            <tei:title> FnaG MSS Corpus: MS Lines </tei:title>
                        </tei:titleStmt>
                        <tei:publicationStmt >
                            <availability status="restricted" xml:id="availability">
                                <licence><p>For internal use by the Faclair na Gàidhlig/DASG
                                    projects.</p></licence>
                            </availability>
                        </tei:publicationStmt>
                        <tei:sourceDesc>
                            <p> Generated from project TEI transcription files. </p>
                        </tei:sourceDesc>
                    </tei:fileDesc>
                </tei:teiHeader>
                <tei:body>
                    <xsl:for-each select="//tei:lb[@xml:id]">
                        <xsl:variable name="lineID" select="@xml:id"/>
                        <tei:seg>
                            <xsl:attribute name="xml:id" select="$lineID"/>
                            <xsl:attribute name="type">
                                <xsl:text>msLine</xsl:text>
                            </xsl:attribute>
                            <xsl:call-template name="line">
                                <xsl:with-param name="lineID">
                                    <xsl:value-of select="$lineID"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </tei:seg>
                    </xsl:for-each>
                </tei:body>
            </tei:TEI>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="line">
        <xsl:param name="lineID"/>
        <xsl:choose>
            <xsl:when test="//tei:lb[@xml:id = $lineID]/ancestor::tei:p">
                <xsl:apply-templates
                    select="//*[preceding::tei:lb[1]/@xml:id = $lineID and parent::tei:p[parent::tei:div[//tei:lb[@xml:id = $lineID]]]]"
                />
            </xsl:when>
            <xsl:when
                test="//tei:lb[@xml:id = $lineID]/ancestor::tei:l[ancestor::tei:div[//tei:lb[@xml:id = $lineID]]]">
                <xsl:apply-templates
                    select="//*[preceding::tei:lb[1]/@xml:id = $lineID and parent::tei:l]"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:name | tei:w[descendant::tei:w] | tei:seg[not(@type='fragment')] | tei:hi">
        <xsl:apply-templates select="child::*"/>
    </xsl:template>

    <xsl:template match="tei:add">
        <tei:hi>
            <xsl:attribute name="rend">
                <xsl:text>sup</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="child::* | child::text()"/>
        </tei:hi>
    </xsl:template>

    <xsl:template match="tei:w[not(descendant::tei:w) and not(@type = 'data')]">
        <tei:w>
            <xsl:if test="@lemma = 'UNKNOWN'">
                <xsl:attribute name="style">
                    <xsl:value-of select="concat('color:', '#ff0000')"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="xml:id" select="count(preceding::*)"/>
            <xsl:apply-templates select="child::* | child::text()"/>
        </tei:w>
    </xsl:template>

    <xsl:template match="tei:note">
        <xsl:text/>
    </xsl:template>
    
    <xsl:template match="tei:choice">
        <xsl:apply-templates select="child::tei:sic"/>
    </xsl:template>

    <xsl:template match="tei:pc">
        <seg>
            <xsl:attribute name="type">
                <xsl:text>punctuation</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="child::* | child::text()"/>
        </seg>
    </xsl:template>

    <xsl:template match="tei:c">
        <seg>
            <xsl:attribute name="type">
                <xsl:text>character</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="child::* | child::text()"/>
        </seg>
    </xsl:template>

    <xsl:template match="tei:date">
        <seg>
            <xsl:attribute name="type">
                <xsl:text>date</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="child::* | child::text()"/>
        </seg>
    </xsl:template>

    <xsl:template match="tei:num">
        <seg>
            <xsl:attribute name="type">
                <xsl:text>number</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="child::* | child::text()"/>
        </seg>
    </xsl:template>
    
    <xsl:template match="tei:seg[@type = 'fragment']">
        <seg>
            <xsl:attribute name="type">
                <xsl:text>fragment</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="child::* | child::text()"/>
        </seg>
    </xsl:template>

    <xsl:template match="tei:space">
        <tei:space/>
    </xsl:template>

    <xsl:template match="tei:abbr">
        <xsl:apply-templates select="child::* | child::text()"/>
    </xsl:template>

    <xsl:template match="tei:g">
        <tei:expan>
            <xsl:apply-templates/>
        </tei:expan>
    </xsl:template>

    <xsl:template match="tei:del">
        <tei:hi>
            <xsl:attribute name="rend">
                <xsl:text>strikethrough</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="child::* | child::text()"/>
        </tei:hi>
    </xsl:template>

    <xsl:template match="tei:supplied">
        <tei:supplied>
            <xsl:apply-templates select="child::* | child::text()"/>
        </tei:supplied>
    </xsl:template>

    <xsl:template match="tei:gap">
        <tei:gap/>
    </xsl:template>

    <xsl:template match="tei:unclear">
        <tei:seg>
            <xsl:attribute name="style">
                <xsl:choose>
                    <xsl:when test="@cert = 'high'">
                        <xsl:value-of select="concat('color:', '#cccc00')"/>
                    </xsl:when>
                    <xsl:when test="@cert = 'medium'">
                        <xsl:value-of select="concat('color:', '#ff9900')"/>
                    </xsl:when>
                    <xsl:when test="@cert = 'low'">
                        <xsl:value-of select="concat('color:', '#ff0000')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="child::* | child::text()"/>
        </tei:seg>
    </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- Run on corpus.xml with XInclude links open to get a basic formatted text edition of all transcriptions within scope. -->
<!-- Output is saved to faclair-manuscripts\Transcribing\Printouts; one file will be saved per transcription. -->
<!-- File names are formed "t" + [transcription number] + ".html"; if a file for the same transcription already exists, it will be overwritten. -->
<!-- This is intended as an emergency fallback means of retrieving texts from the corpus in case more dynamic systems are unavailable. -->
<xsl:stylesheet xpath-default-namespace="https://dasg.ac.uk/corpus/"
    xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ns="https://dasg.ac.uk/corpus/" exclude-result-prefixes="xs" version="2.0">

    <xsl:strip-space elements="*"/>
    <xsl:output method="html" indent="yes"/>

    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="TEI[not(@xml:id = 'hwData')]">
        <xsl:variable name="timestamp">
            <xsl:value-of select="current-dateTime()"/>
        </xsl:variable>
        <xsl:variable name="filename" select="concat('t', substring(@xml:id, 2), '.html')"/>
        <xsl:result-document href="Printouts\{$filename}">
            <html>
                <head>
                    <style>
                        html,
                        body {
                            width: 100%;
                        }
                        div {
                            width: inherit
                        }
                        p {
                            display: block;
                            width: inherit;
                            max-width: 500px;
                            font-size: 14;
                        }
                        table.stanza {
                            font-size: 14;
                            width: inherit;
                            display: block;
                            margin-left: 4em;
                            border: none;
                            padding-bottom:5px;
                            padding-top:5px;
                        }
                        td.number {
                            width: 40px;
                            text-align: left;
                            vertical-align: top;
                        }
                        sub {
                            font-size: 0.6em;
                            vertical-align: bottom;
                        }
                        sup {
                            vertical-align: top;
                            font-size: 0.6em;
                        }
                        span.unclear {
                            background-color: silver;
                        }
                        span.supplied {
                            font-variant: small-caps;
                            color: red;
                        }
                        ul {
                            font-size: 0.6em;
                        }</style>
                    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
                </head>
                <body>
                    <xsl:variable name="msID" select="@xml:id"/>
                    <xsl:variable name="transTitle"
                        select="concat('Transcription ', substring($msID, 2))"/>
                    <div class="transcription">
                        <h2>
                            <xsl:value-of
                                select="concat($transTitle, ': ', ns:teiHeader/ns:fileDesc/ns:sourceDesc/ns:msDesc/ns:msIdentifier/ns:settlement, ', ', ns:teiHeader/ns:fileDesc/ns:sourceDesc/ns:msDesc/ns:msIdentifier/ns:repository, ' ', ns:teiHeader/ns:fileDesc/ns:sourceDesc/ns:msDesc/ns:msIdentifier/ns:idno)"
                            />
                        </h2>
                        <ul>
                            <li>Generated from the Faclair na Gàidhlig MSS Corpus at <xsl:value-of
                                    select="$timestamp"/>.</li>
                            <li>This document should not be shared beyond the Faclair na Gàidhlig
                                project without permission (contact mail@faclair.ac.uk).</li>
                            <li>All expansions from abbreviations are <i>italicised</i>.</li>
                            <li>Text deleted by a scribe (whether the main scribe or a later scribe)
                                is struck through: <strike>example of text deleted by a
                                    scribe</strike>.</li>
                            <li>Material inserted by a scribe is in superscript, regardless of where
                                the scribe added it: <sup>example of text inserted by a
                                scribe</sup>.</li>
                            <li>Text supplied by an editor is in red small caps: <span
                                    class="supplied">example of text supplied by an
                                editor</span>.</li>
                            <li>Text that has been tagged as unclear is greyed out: <span
                                    class="unclear">example of text that is unclear</span>. This
                                could be due to issues with legibility or because the FnaG MSS
                                transcribers are unsure of its interpretation.</li>
                            <li>"[...]" indicates a lacuna in the manuscript.</li>
                        </ul>
                        <xsl:for-each select="text/body/div">
                            <xsl:apply-templates select="."/>
                        </xsl:for-each>
                    </div>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="div[not(ancestor::ns:div)]">
        <xsl:variable name="textID" select="@corresp"/>
        <div class="text">
            <h3>
                <xsl:if test="@n">
                    <xsl:value-of select="concat('Text ', @n, ': ')"/>
                </xsl:if>
                <xsl:value-of select="//ns:msItem[@xml:id = $textID]/ns:title"/>
            </h3>
        </div>
        <xsl:apply-templates/>
        <hr/>
    </xsl:template>

    <xsl:template match="div[ancestor::ns:div]">
        <xsl:if test="@n">
            <h4>
                <xsl:value-of select="concat('§', @n)"/>
            </h4>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="p">
        <p class="prose">
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="lg">
        <table class="stanza">
            <tr>
                <td class="number">
                    <xsl:value-of select="@n"/>
                </td>
                <td class="text">
                    <xsl:apply-templates select="l"/>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template match="l">
        <span class="metLine">
            <xsl:apply-templates/>
        </span>
        <br/>
    </xsl:template>

    <xsl:template match="name | number | date | abbr">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="w">
        <xsl:choose>
            <xsl:when test="ancestor::ns:w">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
                <xsl:if test="not(following::*[1][not(name() = ('space', 'note'))]/name() = 'pc')">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="g">
        <xsl:choose>
            <xsl:when test="contains(@ref, 'g')">
                <i>
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="pb">
        <b>
            <sub>[<xsl:value-of select="@n"/>]</sub>
        </b>
        <xsl:if test="not(ancestor::w)">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="cb">
        <b>
            <sub>[<xsl:value-of select="@n"/>]</sub>
        </b>
        <xsl:if test="not(ancestor::w)">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="lb">
        <sub>[<xsl:value-of select="@n"/>]</sub>
        <xsl:if test="not(ancestor::w)">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="handShift">
        <b>
            <sub>[<xsl:value-of select="@new"/>]</sub>
        </b>
        <xsl:if test="not(ancestor::w)">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <xsl:template match="c">
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="pc">
        <xsl:choose>
            <xsl:when test="ancestor::ns:w">
                <xsl:text/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="seg">
        <xsl:choose>
            <xsl:when test="@type = ('cfe', 'catchword')">
                <xsl:text/>
            </xsl:when>
            <xsl:when test="@type = 'fragment'">
                <xsl:apply-templates/>
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:when test="@type = 'margNote'">
                <sup>
                    <xsl:apply-templates/>
                </sup>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="add">
        <sup>
            <xsl:if test="@type = 'gloss'">
                <xsl:text>[gl.] </xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <xsl:template match="del">
        <strike>
            <xsl:apply-templates/>
        </strike>
    </xsl:template>

    <xsl:template match="unclear">
        <xsl:choose>
            <xsl:when test="@reason = 'damage'">
                <span class="supplied">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span class="unclear">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="supplied">
        <span class="supplied">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <xsl:template match="choice">
        <xsl:apply-templates select="sic"/>
        <sub>
            <xsl:text>[</xsl:text>
            <i>sic</i>
            <xsl:if test="corr/*">
                <xsl:text>; </xsl:text>
                <i>leg.</i>
                <xsl:text> </xsl:text>
                <xsl:apply-templates select="corr"/>
            </xsl:if>
            <xsl:text>]</xsl:text>
        </sub>
    </xsl:template>

    <xsl:template match="gap">
        <xsl:text>[...] </xsl:text>
    </xsl:template>

    <xsl:template match="note">
        <xsl:text/>
    </xsl:template>

</xsl:stylesheet>

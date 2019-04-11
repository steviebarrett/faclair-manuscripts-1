<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs" version="2.0">

    <xsl:strip-space elements="*"/>

    <xsl:output method="html"/>

    <xsl:template match="/">
        <html>
            <head>
                <h1>Stem and Gender Data</h1>
            </head>
            <body>
                <table border="1px solid black">
                    <thead>
                        <tr>
                            <th> Trans. </th>
                            <th> Ref. </th>
                            <th> Form </th>
                            <th> POS </th>
                            <th> Headword </th>
                            <th> HW ID</th>
                            <th> sga gender </th>
                            <th> sga stem </th>
                            <th> mga gender </th>
                            <th> mga stem </th>
                            <th> ghc gender </th>
                            <th> ghc stem </th>
                            <th> gd gender </th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:for-each
                            select="//tei:w[not(@type = 'data') and @lemmaRef and @ana = 'noun' or not(@type = 'data') and @lemmaRef and @ana = 'vnoun' or not(@type = 'data') and @lemmaRef and @ana = 'adj']">
                            <xsl:call-template name="contentRow"/>
                        </xsl:for-each>
                    </tbody>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="contentRow">
        <xsl:variable name="comDiv" select="ancestor::tei:div[1]/@corresp"/>
        <tr>
            <td>
                <xsl:value-of select="ancestor::tei:TEI/@xml:id"/>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="preceding::tei:lb[1]/@sameAs">
                        <xsl:value-of select="preceding::tei:lb[1]/@sameAs"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="preceding::tei:lb[1]/@xml:id"/>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:call-template name="form"/>
            </td>
            <td>
                <xsl:value-of select="@ana"/>
            </td>
            <td>
                <a href="{@lemmaRef}" target="_blank">
                    <xsl:value-of select="@lemma"/>
                </a>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="contains(@lemmaRef, 'dil.ie')">
                        <xsl:value-of select="substring(@lemmaRef, 19)"/>
                    </xsl:when>
                    <xsl:when test="contains(@lemmaRef, 'faclair.com')">
                        <xsl:value-of select="substring(@lemmaRef, 53)"/>
                    </xsl:when>
                    <xsl:when test="contains(@lemmaRef, 'dasg.ac.uk')">
                        <xsl:value-of select="substring(@lemmaRef, 37)"/>
                    </xsl:when>
                    <xsl:when test="contains(@lemmaRef, 'www.teanglann.ie')">
                        <xsl:value-of select="substring(@lemmaRef, 33)"/>
                    </xsl:when>
                    <xsl:when test="contains(@lemmaRef, 'www.dsl.ac.uk')">
                        <xsl:value-of select="substring(@lemmaRef, 33)"/>
                    </xsl:when>
                    <xsl:when test="contains(@lemmaRef, 'www.logainm.ie')">
                        <xsl:value-of select="substring(@lemmaRef, 27)"/>
                    </xsl:when>
                    <xsl:when test="contains(@lemmaRef, 'www.ainmean-aite.scot')">
                        <xsl:value-of select="substring(@lemmaRef, 41)"/>
                    </xsl:when>
                    <xsl:when
                        test="contains(@lemmaRef, 'https://www.online-latin-dictionary.com/latin-dictionary-flexion.php?lemma=')">
                        <xsl:value-of select="substring(@lemmaRef, 76)"/>
                    </xsl:when>
                    <xsl:when
                        test="contains(@lemmaRef, 'https://www.online-latin-dictionary.com/latin-dictionary-flexion.php?parola=')">
                        <xsl:value-of select="substring(@lemmaRef, 77)"/>
                    </xsl:when>
                    <xsl:when test="contains(@lemmaRef, 'www.oed.com')">
                        <xsl:value-of select="substring(@lemmaRef, 32)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>none</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
            <td>
                <xsl:call-template name="genData">
                    <xsl:with-param name="lang">
                        <xsl:text>sga</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="hwID">
                        <xsl:value-of select="@lemmaRef"/>
                    </xsl:with-param>
                    <xsl:with-param name="POS">
                        <xsl:value-of select="@ana"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="stemData">
                    <xsl:with-param name="lang">
                        <xsl:text>sga</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="hwID">
                        <xsl:value-of select="@lemmaRef"/>
                    </xsl:with-param>
                    <xsl:with-param name="POS">
                        <xsl:value-of select="@ana"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="genData">
                    <xsl:with-param name="lang">
                        <xsl:text>mga</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="hwID">
                        <xsl:value-of select="@lemmaRef"/>
                    </xsl:with-param>
                    <xsl:with-param name="POS">
                        <xsl:value-of select="@ana"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="stemData">
                    <xsl:with-param name="lang">
                        <xsl:text>mga</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="hwID">
                        <xsl:value-of select="@lemmaRef"/>
                    </xsl:with-param>
                    <xsl:with-param name="POS">
                        <xsl:value-of select="@ana"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="genData">
                    <xsl:with-param name="lang">
                        <xsl:text>ghc</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="hwID">
                        <xsl:value-of select="@lemmaRef"/>
                    </xsl:with-param>
                    <xsl:with-param name="POS">
                        <xsl:value-of select="@ana"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="stemData">
                    <xsl:with-param name="lang">
                        <xsl:text>ghc</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="hwID">
                        <xsl:value-of select="@lemmaRef"/>
                    </xsl:with-param>
                    <xsl:with-param name="POS">
                        <xsl:value-of select="@ana"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
            <td>
                <xsl:call-template name="genData">
                    <xsl:with-param name="lang">
                        <xsl:text>gd</xsl:text>
                    </xsl:with-param>
                    <xsl:with-param name="hwID">
                        <xsl:value-of select="@lemmaRef"/>
                    </xsl:with-param>
                    <xsl:with-param name="POS">
                        <xsl:value-of select="@ana"/>
                    </xsl:with-param>
                </xsl:call-template>
            </td>
        </tr>
    </xsl:template>

    <xsl:template name="form">
        <xsl:variable name="comSection">
            <xsl:choose>
                <xsl:when test="ancestor::tei:l">
                    <xsl:value-of select="ancestor::tei:l/@xml:id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="ancestor::tei:div[1]/@corresp"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="ancestor::tei:w">
                <xsl:if test="ancestor::tei:w/preceding::tei:w[1]/ancestor::*[@* = $comSection]">
                    <span style="background-color; grey;">
                        <xsl:apply-templates
                            select="ancestor::tei:w/preceding::tei:w[not(ancestor::tei:w) and ancestor::*[@* = $comSection]][1]"
                        />
                    </span>
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="preceding::tei:w[1]/ancestor::*[@* = $comSection]">
                    <span style="background-color; grey;">
                        <xsl:apply-templates
                            select="preceding::tei:w[1][ancestor::*[@* = $comSection]]"/>
                    </span>
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <span>
            <xsl:attribute name="style">
                <xsl:if test="ancestor::*[@cert] or descendant::*[@cert]">
                    <xsl:choose>
                        <xsl:when test="ancestor::*/@cert = 'low' or descendant::*/@cert = 'low'">
                            <xsl:text>color:#ff0000</xsl:text>
                        </xsl:when>
                        <xsl:when
                            test="ancestor::*/@cert = 'medium' or descendant::*/@cert = 'medium'">
                            <xsl:text>color:#ff9900</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="ancestor::tei:w">
                    <b>
                        <xsl:apply-templates select="ancestor::tei:w"/>
                    </b>
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <b>
                        <xsl:apply-templates/>
                    </b>
                    <xsl:text> </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </span>
        <xsl:choose>
            <xsl:when test="ancestor::tei:w">
                <xsl:if test="ancestor::tei:w/following::tei:w[1]/ancestor::*[@* = $comSection]">
                    <span style="background-color; grey;">
                        <xsl:apply-templates
                            select="ancestor::tei:w/following::tei:w[not(ancestor::tei:w) and ancestor::*[@* = $comSection]][1]"
                        />
                    </span>
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="following::tei:w[1]/ancestor::*[@* = $comSection]">
                    <span style="background-color; grey;">
                        <xsl:apply-templates
                            select="following::tei:w[1][ancestor::*[@* = $comSection]]"/>
                    </span>
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="stemData">
        <xsl:param name="lang"/>
        <xsl:param name="hwID"/>
        <xsl:param name="POS"/>
        <xsl:if
            test="//tei:entryFree[@corresp = $hwID]//tei:iType[@xml:lang = $lang or not(@xml:lang)]">
            <xsl:choose>
                <xsl:when
                    test="//tei:entryFree[@corresp = $hwID]//tei:iType[@xml:lang = $lang or not(@xml:lang)]/parent::tei:gramGrp[@type = $POS]">
                    <xsl:choose>
                        <xsl:when
                            test="count(//tei:entryFree[@corresp = $hwID]//tei:iType[@xml:lang = $lang and parent::tei:gramGrp[@type = $POS] or not(@xml:lang) and parent::tei:gramGrp[@type = $POS]]) > 1">
                            <xsl:variable name="stemCount"
                                select="count(//tei:entryFree[@corresp = $hwID]//tei:iType[@xml:lang = $lang and parent::tei:gramGrp[@type = $POS] or not(@xml:lang) and parent::tei:gramGrp[@type = $POS]])"/>
                            <xsl:for-each
                                select="//tei:entryFree[@corresp = $hwID]//tei:iType[@xml:lang = $lang and parent::tei:gramGrp[@type = $POS] or not(@xml:lang) and parent::tei:gramGrp[@type = $POS]]">
                                <xsl:value-of select="self::*"/>
                                <xsl:text> </xsl:text>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="//tei:entryFree[@corresp = $hwID]//tei:iType[@xml:lang = $lang and parent::tei:gramGrp[@type = $POS] or not(@xml:lang) and parent::tei:gramGrp[@type = $POS]]"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when
                            test="count(//tei:entryFree[@corresp = $hwID]//tei:iType[@xml:lang = $lang] or not(@xml:lang)) > 1">
                            <xsl:variable name="stemCount"
                                select="count(//tei:entryFree[@corresp = $hwID]//tei:iType[@xml:lang = $lang] or not(@xml:lang))"/>
                            <xsl:for-each
                                select="//tei:entryFree[@corresp = $hwID]//tei:iType[@xml:lang = $lang or not(@xml:lang)]">
                                <xsl:value-of select="self::*"/>
                                <xsl:text> </xsl:text>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="//tei:entryFree[@corresp = $hwID]//tei:iType[@xml:lang = $lang or not(@xml:lang)]"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="genData">
        <xsl:param name="lang"/>
        <xsl:param name="hwID"/>
        <xsl:param name="POS"/>
        <xsl:if
            test="//tei:entryFree[@corresp = $hwID]//tei:gen[@xml:lang = $lang or not(@xml:lang)]">
            <xsl:choose>
                <xsl:when
                    test="//tei:entryFree[@corresp = $hwID]//tei:gen[@xml:lang = $lang or not(@xml:lang)]/parent::tei:gramGrp[@type = $POS]">
                    <xsl:choose>
                        <xsl:when
                            test="count(//tei:entryFree[@corresp = $hwID]//tei:gen[@xml:lang = $lang and parent::tei:gramGrp[@type = $POS] or not(@xml:lang) and parent::tei:gramGrp[@type = $POS]]) > 1">
                            <xsl:variable name="stemCount"
                                select="count(//tei:entryFree[@corresp = $hwID]//tei:gen[@xml:lang = $lang and parent::tei:gramGrp[@type = $POS] or not(@xml:lang) and parent::tei:gramGrp[@type = $POS]])"/>
                            <xsl:for-each
                                select="//tei:entryFree[@corresp = $hwID]//tei:gen[@xml:lang = $lang and parent::tei:gramGrp[@type = $POS] or not(@xml:lang) and parent::tei:gramGrp[@type = $POS]]">
                                <xsl:value-of select="self::*"/>
                                <xsl:text> </xsl:text>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="//tei:entryFree[@corresp = $hwID]//tei:gen[@xml:lang = $lang and parent::tei:gramGrp[@type = $POS] or not(@xml:lang) and parent::tei:gramGrp[@type = $POS]]"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when
                            test="count(//tei:entryFree[@corresp = $hwID]//tei:gen[@xml:lang = $lang] or not(@xml:lang)) > 1">
                            <xsl:variable name="stemCount"
                                select="count(//tei:entryFree[@corresp = $hwID]//tei:gen[@xml:lang = $lang] or not(@xml:lang))"/>
                            <xsl:for-each
                                select="//tei:entryFree[@corresp = $hwID]//tei:gen[@xml:lang = $lang or not(@xml:lang)]">
                                <xsl:value-of select="self::*"/>
                                <xsl:text> </xsl:text>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of
                                select="//tei:entryFree[@corresp = $hwID]//tei:gen[@xml:lang = $lang or not(@xml:lang)]"
                            />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template match="tei:cb">
        <sub>
            <b>
                <xsl:text>col. </xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text> </xsl:text>
            </b>
        </sub>
    </xsl:template>

    <xsl:template match="tei:choice">
        <xsl:apply-templates select="tei:sic"/>
    </xsl:template>

    <xsl:template match="tei:del">
        <del rend="strikethrough">
            <xsl:apply-templates/>
        </del>
    </xsl:template>

    <xsl:template match="tei:g">
        <xsl:variable name="color">
            <xsl:choose>
                <xsl:when test="ancestor::tei:abbr/@cert = 'low'">
                    <xsl:text>#ff0000</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor::tei:abbr/@cert = 'medium'">
                    <xsl:text>#ff9900</xsl:text>
                </xsl:when>
                <xsl:when test="ancestor::tei:abbr/@cert = 'unknown'">
                    <xsl:text>#d9d9d9</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains(@ref, 'g')">
                <i style="color:{$color}">
                    <xsl:apply-templates/>
                </i>
            </xsl:when>
            <xsl:otherwise>
                <span style="color:{$color}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:handShift">
        <sub>
            <b>beg. <xsl:value-of select="@new"/></b>
        </sub>
    </xsl:template>

    <xsl:template match="tei:lb">
        <sub>
            <b>
                <xsl:value-of select="@n"/>
                <xsl:text>.</xsl:text>
            </b>
        </sub>
    </xsl:template>

    <xsl:template match="tei:pb">
        <sub>
            <b>
                <xsl:text>p.</xsl:text>
                <xsl:value-of select="@n"/>
                <xsl:text> </xsl:text>
            </b>
        </sub>
    </xsl:template>

    <xsl:template match="tei:supplied">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:unclear">
        <xsl:text>{</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>}</xsl:text>
    </xsl:template>

    <xsl:template match="tei:abbr">
        <xsl:apply-templates/>
    </xsl:template>

</xsl:stylesheet>

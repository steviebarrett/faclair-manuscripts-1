<?xml version="1.0" encoding="UTF-8"?>
<!-- This stylesheet is run on corpus.xml with all XInclude links open. -->
<!-- It returns a table in HTML (saved in faclair-manuscripts\Transcribing\Data\TEI Structure) giving each TEI XML element in use in the corpus (or the portions of it in scope), 
    with all its possible attributes, parents, and children. -->
<!-- The rightmost column is populated from another document ('teiStructure_descs.xml'). This is updated every time this stylesheet is
run with any new elements encountered in the corpus. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:d="https://github.com/conmaol/faclair-manuscripts/blob/master/Transcribing/Data/TEI%20Structure/teiStructure_descs.xml"
    exclude-result-prefixes="xs" version="2.0">
    <xsl:strip-space elements="*"/>

    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="timestamp">
        <xsl:value-of
            select="
                (current-dateTime() -
                xs:dateTime('1970-01-01T00:00:00'))
                div xs:dayTimeDuration('PT1S') * 1000"
        />
    </xsl:variable>

    <xsl:variable name="old_descs">
        <xsl:choose>
            <xsl:when
                test="document('..\..\Transcribing\Data\TEI Structure\teiStructure_descs.xml')">
                <xsl:copy-of
                    select="document('..\..\Transcribing\Data\TEI Structure\teiStructure_descs.xml')"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'null'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:template match="/">
        <xsl:result-document
            href="{concat('Data\TEI Structure\teiStructure_', $timestamp, '.html')}" method="html">
            <xsl:call-template name="main_table"/>
        </xsl:result-document>
        <xsl:result-document href="{'Data\TEI Structure\teiStructure_descs.xml'}" method="xml">
            <xsl:call-template name="descs"/>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="descs">
        <xsl:element name="d:descs">
            <xsl:namespace name="d"
                select="'https://github.com/conmaol/faclair-manuscripts/blob/master/Transcribing/Data/TEI%20Structure/teiStructure_descs.xml'"/>
            <xsl:for-each select="//*">
                <xsl:variable name="element_name" select="name()"/>
                <xsl:variable name="row_id" select="concat('row_', $element_name)"/>
                <xsl:if test="not(preceding::*/name() = $element_name)">
                    <xsl:choose>
                        <xsl:when
                            test="$old_descs != 'null' and $old_descs//d:desc[@corresp = $row_id and descendant::text()]">
                            <xsl:copy-of
                                select="$old_descs//d:desc[@corresp = $row_id and descendant::text()]"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:element name="d:desc">
                                <xsl:attribute name="element">
                                    <xsl:value-of select="$element_name"/>
                                </xsl:attribute>
                                <xsl:attribute name="corresp">
                                    <xsl:value-of select="$row_id"/>
                                </xsl:attribute>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="main_table">
        <html n="{$timestamp}">
            <head>
                <title>FnaG MSS Corpus: TEI XML Structure</title>
                <style>
                    table,
                    th,
                    td {
                        border: 1px solid black;
                        font-size: 11;
                    }</style>
            </head>
            <body>
                <table>
                    <thead>
                        <tr>
                            <xsl:attribute name="id" select="'table_header'"/>
                            <th>Name</th>
                            <th>Attributes</th>
                            <th>Parents</th>
                            <th>Children</th>
                            <th>Description</th>
                        </tr>
                        <xsl:for-each select="//*">
                            <xsl:variable name="element_name" select="name()"/>
                            <xsl:variable name="row_id" select="concat('row_', $element_name)"/>
                            <xsl:if test="not(preceding::*/name() = $element_name)">
                                <tr>
                                    <xsl:attribute name="id" select="$row_id"/>
                                    <!-- 'Name' Column -->
                                    <td>
                                        <b>
                                            <xsl:call-template name="element_name">
                                                <xsl:with-param name="name" select="$element_name"/>
                                            </xsl:call-template>
                                        </b>
                                    </td>
                                    <!-- 'Attributes' Column -->
                                    <td>
                                        <xsl:variable name="attributes_array" as="element()">
                                            <array>
                                                <xsl:for-each
                                                  select="//*[name() = $element_name]/@*">
                                                  <xsl:variable name="attribute_name"
                                                  select="name()"/>
                                                  <item>
                                                  <xsl:value-of select="$attribute_name"/>
                                                  </item>
                                                </xsl:for-each>
                                            </array>
                                        </xsl:variable>
                                        <xsl:for-each select="$attributes_array/*">
                                            <xsl:if
                                                test="not(string(.) = preceding-sibling::*/text())">
                                                <xsl:value-of select="concat('@', string(.))"/>
                                                <br/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </td>
                                    <!-- 'Contained' Column -->
                                    <td>
                                        <xsl:variable name="parents_array" as="element()">
                                            <array>
                                                <xsl:for-each
                                                  select="//*[name() = $element_name]/parent::*">
                                                  <xsl:variable name="parent_name" select="name()"/>
                                                  <item>
                                                  <xsl:value-of select="$parent_name"/>
                                                  </item>
                                                </xsl:for-each>
                                            </array>
                                        </xsl:variable>
                                        <xsl:for-each select="$parents_array/*">
                                            <xsl:if
                                                test="not(string(.) = preceding-sibling::*/text())">
                                                <xsl:call-template name="element_name">
                                                  <xsl:with-param name="name" select="string(.)"/>
                                                </xsl:call-template>
                                                <br/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </td>
                                    <!-- 'Contains' Column -->
                                    <td>
                                        <xsl:variable name="children_array" as="element()">
                                            <array>
                                                <xsl:for-each
                                                  select="//*[name() = $element_name]/child::*">
                                                  <xsl:variable name="child_name" select="name()"/>
                                                  <item>
                                                  <xsl:value-of select="$child_name"/>
                                                  </item>
                                                </xsl:for-each>
                                                <xsl:if test="text()">
                                                  <item>text()</item>
                                                </xsl:if>
                                            </array>
                                        </xsl:variable>
                                        <xsl:for-each select="$children_array/*">
                                            <xsl:if
                                                test="not(string(.) = preceding-sibling::*/text())">
                                                <xsl:call-template name="element_name">
                                                  <xsl:with-param name="name" select="string(.)"/>
                                                </xsl:call-template>
                                                <br/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </td>
                                    <!-- 'Description' Column -->
                                    <td>
                                        <xsl:apply-templates
                                            select="document('..\..\Transcribing\Data\TEI Structure\teiStructure_descs.xml')//d:desc[@corresp = $row_id]"
                                        />
                                    </td>
                                </tr>
                            </xsl:if>
                        </xsl:for-each>
                    </thead>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template name="element_name">
        <xsl:param name="name"/>
        <xsl:choose>
            <xsl:when test="$name = 'text()'">
                <xsl:value-of select="$name"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="url"
                    select="concat('https://www.tei-c.org/release/doc/tei-p5-doc/en/html/ref-', $name, '.html')"
                /> &lt;<a href="{$url}" target="_blank"><xsl:value-of select="$name"/></a>&gt;
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="d:hi">
        <xsl:if test="@rend = 'italics'">
            <i>
                <xsl:apply-templates/>
            </i>
        </xsl:if>
        <xsl:if test="@rend = 'bold'">
            <b>
                <xsl:apply-templates/>
            </b>
        </xsl:if>
        <xsl:if test="@rend = 'underline'">
            <u>
                <xsl:apply-templates/>
            </u>
        </xsl:if>
        <xsl:if test="@rend = 'superscript'">
            <sup>
                <xsl:apply-templates/>
            </sup>
        </xsl:if>
    </xsl:template>

    <xsl:template match="d:ref">
        <xsl:element name="a">
            <xsl:attribute name="href" select="@target"/>
            <xsl:attribute name="target" select="'_blank'"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="d:list">
        <ul>
            <xsl:for-each select="d:item">
                <li>
                    <xsl:apply-templates/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="d:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <xsl:template match="d:c">
        <span
            style="background-color:silver;font-family: 'Lucida Console', 'Courier New', monospace;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

</xsl:stylesheet>

<?xml version="1.0" encoding="UTF-8"?>
<!-- This stylesheet prints out a table in XHTML giving each TEI XML element in use in the corpus (or the portions of it in scope), with all its possible attributes, parents, and children, with a space for further documentation. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <xsl:template match="/">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>FnaG MSS Corpus: TEI XML Structure</title>
                <style>
                    table,
                    th,
                    td {
                        border: 1px solid black;
                        font-size: 11;
                    }
                    span {
                        display: inline;
                    }
                    span.expansion {
                        font-style: italic;
                    }
                    span.unclear {
                        color: #696969;
                    }
                    span.supplied {
                        font-variant: small-caps;
                        color: #ff0000;
                    }
                    span.form_in_context {
                        background-color: #05ffb0;
                        font-weight: bold;
                    }
                    del {
                        text-decoration: line-through;
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
                            <xsl:if test="not(preceding::*/name() = $element_name)">
                                <tr>
                                    <xsl:attribute name="id" select="concat('row_', $element_name)"/>
                                    <!-- 'Name' Column -->
                                    <td>&lt;<xsl:value-of select="$element_name"/>&gt;</td>
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
                                                  &lt;<xsl:value-of select="string(.)"/>&gt; <br/>
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
                                            </array>
                                        </xsl:variable>
                                        <xsl:for-each select="$children_array/*">
                                            <xsl:if
                                                test="not(string(.) = preceding-sibling::*/text())">
                                                  &lt;<xsl:value-of select="string(.)"/>&gt; <br/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </td>
                                    <!-- 'Description' Column -->
                                    <td> </td>
                                </tr>
                            </xsl:if>
                        </xsl:for-each>
                    </thead>
                </table>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>

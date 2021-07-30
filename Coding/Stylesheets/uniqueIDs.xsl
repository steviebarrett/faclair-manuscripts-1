<?xml version="1.0" encoding="UTF-8"?>
<!-- Run this stylesheet on each XML file in the project to get project-wide unique IDs -->
<!-- Due to certain attributes being specified as required in the schema but not in use in the project files themselves, some unexpected attributes will also be added and will need to be manually removed. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:tei="https://dasg.ac.uk/corpus/" xmlns:ns="https://dasg.ac.uk/corpus/">

    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@id"/>

    <!-- add a unique id to each headword element -->
    <xsl:template
        match="ns:w | ns:name | ns:g | ns:pc | ns:date | ns:num | ns:c | ns:gap | ns:seg[@type = 'fragment']">
        <xsl:copy>
            <xsl:attribute name="id">
                <xsl:variable name="id" select="generate-id(.)"/>
                <xsl:value-of
                    select="concat(translate(string(ancestor::ns:TEI/@xml:id), 'DT', 'dt'), $id)"/>
            </xsl:attribute>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>

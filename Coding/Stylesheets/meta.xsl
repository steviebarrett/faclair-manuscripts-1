<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="1.0">

  <xsl:output method="html"/>

  <xsl:template match="/">
    <xsl:apply-templates select="tei:TEI/tei:teiHeader"/>
  </xsl:template>

  <xsl:template match="tei:teiHeader">
    <h1>
      <xsl:value-of select="tei:fileDesc/tei:titleStmt/tei:title"/>
    </h1>
    <ul>
      <xsl:for-each select="tei:fileDesc/tei:titleStmt/tei:respStmt"> 
      <li>
        <xsl:value-of select="tei:name"/>
        <xsl:text>: </xsl:text>
        <xsl:for-each select="tei:resp">
          <xsl:value-of select="."/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </li>
      </xsl:for-each>
      <li>
        <xsl:text>Extent: </xsl:text>
        <xsl:value-of select="tei:fileDesc/tei:extent"/>
      </li>
      <li>
        <xsl:value-of select="tei:fileDesc/tei:publicationStmt/tei:availability/tei:p"/>
      </li>
    </ul>
    <p>
      <xsl:apply-templates select="tei:fileDesc/tei:notesStmt/tei:note/tei:p"/>
    </p>
    <h2>Source:</h2>
    <xsl:apply-templates select="tei:fileDesc/tei:sourceDesc/tei:msDesc"/>
    <xsl:apply-templates select="tei:encodingDesc/tei:refsDecl/tei:p"/>
    <h2>Language:</h2>
    <xsl:apply-templates select="tei:profileDesc/tei:langUsage/tei:p"/>
    <p>Hands</p>
    <p>Keywords</p>
  </xsl:template>
  
  <xsl:template match="tei:msDesc">
    <ul>
      <li>
        <xsl:value-of select="tei:msIdentifier/tei:repository"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="tei:msIdentifier/tei:idno"/>
      </li>
      <li>
        <xsl:text>Contents: </xsl:text>
        <xsl:apply-templates select="tei:msContents/tei:summary"/>
        <ul>
          <xsl:apply-templates select="tei:msContents/tei:msItem"/>
        </ul>
      </li>
      <li>Physical description: </li>
    </ul>
    <xsl:apply-templates select="tei:history/tei:provenance/tei:p"/>
  </xsl:template>
  
  <xsl:template match="tei:msItem">
    <li>
      <strong><xsl:value-of select="tei:title"/></strong>
      <xsl:text> [</xsl:text>
      <xsl:value-of select="tei:locus"/>
      <xsl:text>] </xsl:text>
    </li>
  </xsl:template>
  
  
  <xsl:template match="tei:hi[@rend='italic']">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>
  
  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>




</xsl:stylesheet>

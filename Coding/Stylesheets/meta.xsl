<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
  exclude-result-prefixes="xs" version="1.0">

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
    <h2>Source</h2>
    <xsl:apply-templates select="tei:fileDesc/tei:sourceDesc/tei:msDesc"/>
    <xsl:apply-templates select="tei:encodingDesc/tei:refsDecl/tei:p"/>
    <xsl:if test="tei:profileDesc/tei:langUsage">
      <h2>Language and Style</h2>
      <xsl:apply-templates select="tei:profileDesc/tei:langUsage/tei:p"/>
    </xsl:if>
    <h2>Hands</h2>
    <xsl:apply-templates select="tei:profileDesc/tei:handNotes/tei:handNote"/>
    <h2>Keywords</h2>
    <xsl:apply-templates select="tei:profileDesc/tei:textClass/tei:keywords/tei:term"/>
  </xsl:template>

  <xsl:template match="tei:msDesc">
    <ul>
      <li>
        <xsl:value-of select="tei:msIdentifier/tei:repository"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="tei:msIdentifier/tei:idno"/>
      </li>
      <xsl:if test="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/node()">
        <li>
          <xsl:apply-templates select="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/node()"/>
        </li>
      </xsl:if>
      <xsl:if test="tei:physDesc/tei:objectDesc/tei:layoutDesc/tei:p/node()">
        <li>
          <xsl:apply-templates select="tei:physDesc/tei:objectDesc/tei:layoutDesc/tei:p/node()"/>
        </li>
      </xsl:if>
      <xsl:if test="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:foliation/node()">
        <li>
          <xsl:apply-templates select="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:foliation/node()"/>
        </li>
      </xsl:if>
      <xsl:if test="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:condition/node()">
        <li>
          <xsl:apply-templates select="tei:physDesc/tei:objectDesc/tei:supportDesc/tei:condition/node()"/>
        </li>
      </xsl:if>
      <li>
        <xsl:text>Contents: </xsl:text>
        <xsl:apply-templates select="tei:msContents/tei:summary/tei:p/*"/>
        <ul>
          <xsl:apply-templates select="tei:msContents/tei:msItem"/>
        </ul>
      </li>
    </ul>
    <h3>Physical Description</h3>
    <xsl:apply-templates select="tei:physDesc/tei:p"/>
  </xsl:template>

  <xsl:template match="tei:msItem">
    <li>
      <xsl:value-of select="string(@xml:id)"/><xsl:text> </xsl:text>
      <strong>
        <xsl:value-of select="tei:title"/>
        <xsl:text> [</xsl:text>
        <xsl:value-of select="tei:locus"/>
        <xsl:text>]</xsl:text>
      </strong>
      <xsl:if test="tei:note">
        <strong>
          <xsl:text>: </xsl:text>
        </strong>
        <xsl:apply-templates select="tei:note/text() | tei:note/*"/>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="tei:term">
    <ul>
      <li>
        <xsl:apply-templates/>
      </li>
    </ul>
  </xsl:template>

  <xsl:template match="tei:hi[@rend = 'italics']">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match="tei:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="tei:handNote">
    <xsl:variable name="handID" select="@corresp"/>
    <ul>
      <li>
        <strong>
          <xsl:value-of select="@corresp"/>
          <xsl:text>: </xsl:text>
        </strong>
        <xsl:apply-templates
          select="document('..\..\Transcribing\corpus.xml')//tei:handNotes/tei:handNote[@xml:id = $handID]/tei:note"
        />
      </li>
    </ul>
  </xsl:template>


</xsl:stylesheet>

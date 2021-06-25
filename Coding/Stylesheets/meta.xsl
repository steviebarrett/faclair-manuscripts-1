<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:ns="https://dasg.ac.uk/corpus/"
  exclude-result-prefixes="xs" version="1.0">

  <xsl:output method="html"/>

  <xsl:template match="/">
    <xsl:apply-templates select="ns:TEI/ns:teiHeader"/>
  </xsl:template>

  <xsl:template match="ns:teiHeader">
    <h1>
      <xsl:value-of select="ns:fileDesc/ns:titleStmt/ns:title"/>
    </h1>
    <ul>
      <xsl:for-each select="ns:fileDesc/ns:titleStmt/ns:respStmt">
        <li>
          <xsl:value-of select="ns:name"/>
          <xsl:text>: </xsl:text>
          <xsl:for-each select="ns:resp">
            <xsl:value-of select="."/>
            <xsl:text> </xsl:text>
          </xsl:for-each>
        </li>
      </xsl:for-each>
      <li>
        <xsl:text>Extent: </xsl:text>
        <xsl:value-of select="ns:fileDesc/ns:extent"/>
      </li>
      <li>
        <xsl:value-of select="ns:fileDesc/ns:publicationStmt/ns:availability/ns:p"/>
      </li>
    </ul>
    <p>
      <xsl:apply-templates select="ns:fileDesc/ns:notesStmt/ns:note/ns:p"/>
    </p>
    <h2>Source</h2>
    <xsl:apply-templates select="ns:fileDesc/ns:sourceDesc/ns:msDesc"/>
    <xsl:if test="ns:profileDesc/ns:langUsage">
      <h2>Language and Style</h2>
      <xsl:apply-templates select="ns:profileDesc/ns:langUsage/ns:p"/>
    </xsl:if>
    <h2>Hands</h2>
    <xsl:apply-templates select="ns:profileDesc/ns:handNotes/ns:handNote"/>
    <h2>Keywords</h2>
    <xsl:apply-templates select="ns:profileDesc/ns:textClass/ns:keywords/ns:term"/>
    <xsl:if test="ns:encodingDesc/ns:p/text()">
      <h2>Keywords</h2>
      <xsl:apply-templates select="ns:encodingDesc/ns:p"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ns:msDesc">
    <ul>
      <li>
        <xsl:value-of select="ns:msIdentifier/ns:repository"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="ns:msIdentifier/ns:idno"/>
      </li>
      <xsl:if test="ns:physDesc/ns:objectDesc/ns:supportDesc/ns:support/node()">
        <li>
          <xsl:apply-templates
            select="ns:physDesc/ns:objectDesc/ns:supportDesc/ns:support/node()"/>
        </li>
      </xsl:if>
      <xsl:if test="ns:physDesc/ns:objectDesc/ns:layoutDesc/ns:p">
        <li>
          <xsl:apply-templates select="ns:physDesc/ns:objectDesc/ns:layoutDesc/ns:p/node()"/>
        </li>
      </xsl:if>
      <xsl:if test="ns:physDesc/ns:objectDesc/ns:supportDesc/ns:foliation/node()">
        <li>
          <xsl:apply-templates
            select="ns:physDesc/ns:objectDesc/ns:supportDesc/ns:foliation/node()"/>
        </li>
      </xsl:if>
      <xsl:if test="ns:physDesc/ns:objectDesc/ns:supportDesc/ns:condition/node()">
        <li>
          <xsl:apply-templates
            select="ns:physDesc/ns:objectDesc/ns:supportDesc/ns:condition/node()"/>
        </li>
      </xsl:if>
      <li>
        <xsl:text>Contents: </xsl:text>
        <xsl:apply-templates select="ns:msContents/ns:summary/ns:p"/>
        <ul>
          <xsl:apply-templates select="ns:msContents/ns:msItem"/>
        </ul>
      </li>
    </ul>
    <h3>History</h3>
    <xsl:apply-templates select="ns:history/ns:summary/ns:p"/>
    <h3>Physical Description</h3>
    <xsl:apply-templates select="ns:physDesc/ns:p"/>
  </xsl:template>

  <xsl:template match="ns:msItem">
    <li>
      <xsl:value-of select="string(@xml:id)"/>
      <xsl:text> </xsl:text>
      <strong>
        <xsl:value-of select="ns:title"/>
        <xsl:text> [</xsl:text>
        <xsl:value-of select="ns:locus"/>
        <xsl:text>]</xsl:text>
      </strong>
      <xsl:if test="ns:note">
        <strong>
          <xsl:text>: </xsl:text>
        </strong>
        <xsl:apply-templates select="ns:note/text() | ns:note/*"/>
      </xsl:if>
    </li>
  </xsl:template>

  <xsl:template match="ns:term">
    <ul>
      <li>
        <xsl:apply-templates/>
      </li>
    </ul>
  </xsl:template>

  <xsl:template match="ns:hi">
    <xsl:choose>
      <xsl:when test="@rend = 'italics'">
        <em>
          <xsl:apply-templates/>
        </em>
      </xsl:when>
      <xsl:when test="@rend = 'sup'">
        <sup>
          <xsl:apply-templates/>
        </sup>
      </xsl:when>
      <xsl:when test="@rend = 'bold'">
        <b>
          <xsl:apply-templates/>
        </b>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="ns:ref">
    <a href="{@target}" target="_blank">
      <xsl:apply-templates/>
    </a>
  </xsl:template>

  <xsl:template match="ns:p">
    <p>
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template match="ns:handNote">
    <xsl:variable name="handID" select="@corresp"/>
    <ul>
      <li>
        <strong>
          <xsl:choose>
            <xsl:when
              test="document('..\..\Transcribing\corpus.xml')//ns:handNotes/ns:handNote[@xml:id = $handID]/ns:forename or document('..\..\Transcribing\corpus.xml')//ns:handNotes/ns:handNote[@xml:id = $handID]/ns:surname">
              <xsl:if
                test="document('..\..\Transcribing\corpus.xml')//ns:handNotes/ns:handNote[@xml:id = $handID]/ns:forename">
                <xsl:value-of
                  select="document('..\..\Transcribing\corpus.xml')//ns:handNotes/ns:handNote[@xml:id = $handID]/ns:forename"/>
                <xsl:text> </xsl:text>
              </xsl:if>
              <xsl:if
                test="document('..\..\Transcribing\corpus.xml')//ns:handNotes/ns:handNote[@xml:id = $handID]/ns:surname">
                <xsl:value-of
                  select="document('..\..\Transcribing\corpus.xml')//ns:handNotes/ns:handNote[@xml:id = $handID]/ns:surname"/>
                <xsl:text> </xsl:text>
              </xsl:if>
              <xsl:value-of select="concat('(', @corresp, ')')"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="@corresp"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:text>, </xsl:text>
          <em>saec.</em>
          <xsl:text> </xsl:text>
          <xsl:value-of
            select="document('..\..\Transcribing\corpus.xml')//ns:handNotes/ns:handNote[@xml:id = $handID]/ns:date"/>
          <xsl:if
            test="document('..\..\Transcribing\corpus.xml')//ns:handNotes/ns:handNote[@xml:id = $handID]/ns:region">
            <xsl:text>, </xsl:text>
            <xsl:value-of
              select="document('..\..\Transcribing\corpus.xml')//ns:handNotes/ns:handNote[@xml:id = $handID]/ns:region"
            />
          </xsl:if>
          <xsl:text>: </xsl:text>
        </strong>
        <xsl:apply-templates
          select="document('..\..\Transcribing\corpus.xml')//ns:handNotes/ns:handNote[@xml:id = $handID]/ns:note"
        />
      </li>
    </ul>
  </xsl:template>


</xsl:stylesheet>

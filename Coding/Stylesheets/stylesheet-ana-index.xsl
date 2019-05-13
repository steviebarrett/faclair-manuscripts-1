<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:tei="http://www.tei-c.org/ns/1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs" version="2.0">
	<xsl:strip-space elements="*"/>

	<xsl:output method="html"/>

	<xsl:template match="/">
		<html>
			<head>
				<h1>FnaG MSS Corpus</h1>
			</head>
			<body>
				<h2>MSS Abbreviations</h2>
				<ul>
					<xsl:for-each select="//tei:TEI[not(@xml:id = 'hwData')]">
						<xsl:variable name="msID"
							select="descendant::tei:sourceDesc/tei:msDesc/tei:msIdentifier/@sameAs"/>
						<li style="list-style: none">
							<b>
								<xsl:value-of select="$msID"/>
							</b>
							<xsl:text> = </xsl:text>
							<xsl:value-of
								select="ancestor::tei:teiCorpus//tei:listBibl[@type = 'mss']/tei:msDesc/tei:msIdentifier[@xml:id = $msID]/tei:settlement"/>
							<xsl:text>, </xsl:text>
							<xsl:value-of
								select="ancestor::tei:teiCorpus//tei:listBibl[@type = 'mss']/tei:msDesc/tei:msIdentifier[@xml:id = $msID]/tei:repository"/>
							<xsl:text>, </xsl:text>
							<xsl:value-of
								select="ancestor::tei:teiCorpus//tei:listBibl[@type = 'mss']/tei:msDesc/tei:msIdentifier[@xml:id = $msID]/tei:idno[@type = 'shelfmark']"/>
							<xsl:if
								test="ancestor::tei:teiCorpus//tei:sourceDesc/tei:msDesc/tei:msIdentifier[@xml:id = $msID]/tei:msName">
								<xsl:text> (</xsl:text>
								<i>
									<xsl:value-of
										select="ancestor::tei:teiCorpus//tei:sourceDesc/tei:msDesc/tei:msIdentifier[@xml:id = $msID]/tei:msName"
									/>
								</i>
								<xsl:text>)</xsl:text>
							</xsl:if>
							<xsl:text>, </xsl:text>
							<xsl:value-of
								select="ancestor::tei:teiCorpus//tei:listBibl[@type = 'mss']/tei:msDesc[child::tei:msIdentifier[@xml:id = $msID]]/tei:history/tei:origin/tei:date"/>
							<sup>th</sup>
							<xsl:text> cent.</xsl:text>
						</li>
					</xsl:for-each>
				</ul>
				<h2>Corpus Index</h2>
				<xsl:for-each
					select="//tei:w[@lemma and not(descendant::tei:w) and not(@lemmaRef = preceding::tei:w/@lemmaRef) and not(@xml:lang) and not(@type = 'data') and not(@lemma = 'UNKNOWN')]">
					<xsl:sort
						select="translate(@lemma, 'AÁÀáàBCDEÉÈéèFGHIÍÌíìJKLMNOÓÒóòPQRSTUÚÙúùVWXYZ', 'aaaaabcdeeeeefghiiiiijklmnooooopqrstuuuuuvwxyz')"/>
					<xsl:call-template name="entry"/>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="entry">
		<xsl:variable name="lemRef" select="@lemmaRef"/>
		<xsl:variable name="lem" select="@lemma"/>
		<p>
			<b>
				<xsl:choose>
					<xsl:when test="not($lemRef = '')">
						<a href="{$lemRef}" target="_blank">
							<xsl:value-of select="$lem"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$lem"/>
					</xsl:otherwise>
				</xsl:choose>
			</b>
			<xsl:if
				test="//tei:entryFree[@corresp = $lemRef]/tei:w[not(string-length(@lemmaDW) = 0)]/@lemmaDW">
				<xsl:text> (ScG. </xsl:text>
				<xsl:choose>
					<xsl:when
						test="//tei:entryFree[@corresp = $lemRef]/tei:w[not(string-length(@lemmaDW) = 0)]/@lemmaRefDW">
						<a
							href="{//tei:entryFree[@corresp = $lemRef]/tei:w[not(string-length(@lemmaDW) = 0)]/@lemmaRefDW}"
							target="_blank">
							<xsl:value-of
								select="//tei:entryFree[@corresp = $lemRef]/tei:w/@lemmaDW"/>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="//tei:entryFree[@corresp = $lemRef]/tei:w/@lemmaDW"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>)</xsl:text>
			</xsl:if>
			<xsl:text>: </xsl:text>
			<xsl:if
				test="//tei:entryFree[@corresp = $lemRef]//tei:iType/text() or //tei:entryFree[@corresp = $lemRef]//tei:gen/text()">
				<xsl:text> </xsl:text>
				<xsl:call-template name="morphData">
					<xsl:with-param name="lemRef">
						<xsl:value-of select="$lemRef"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:if>
			<br/>
				<xsl:call-template name="wordBlock">
					<xsl:with-param name="lemRef">
						<xsl:value-of select="$lemRef"/>
					</xsl:with-param>
				</xsl:call-template>
				<xsl:text> </xsl:text>
			
		</p>
	</xsl:template>
	
	<xsl:template name="wordBlock">
		<xsl:param name="lemRef"/>
		<xsl:for-each select="//tei:TEI[not(@xml:id = 'hwData')]//tei:w[@lemmaRef = $lemRef]">
			<xsl:sort>
				<xsl:variable name="msID" select="ancestor::tei:TEI//tei:msIdentifier/@sameAs"/>
				<xsl:value-of select="//tei:teiCorpus//tei:msDesc[child::tei:msIdentifier[@xml:id=$msID]]/tei:history/tei:origin/tei:date/@from-custom"/>
			</xsl:sort>
			<xsl:call-template name="word">
				<xsl:with-param name="lemRef">
					<xsl:value-of select="$lemRef"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="word">
		<xsl:param name="lemRef"/>
		<xsl:variable name="lemRef" select="@lemmaRef"/>
		<xsl:variable name="wordCount"
			select="count(//tei:TEI[not(@xml:id = 'hwData')]//tei:w[@lemmaRef = $lemRef])"/>
		<xsl:variable name="msRef">
			<xsl:choose>
				<xsl:when test="preceding::tei:lb[1]/@sameAs">
					<xsl:value-of select="preceding::tei:lb[1]/@sameAs"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="preceding::tei:lb[1]/@xml:id"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="ancestor::tei:w">
				<xsl:if test="preceding-sibling::tei:w or preceding-sibling::*[descendant::tei:w]">
					<xsl:text>-</xsl:text>
				</xsl:if>
				<xsl:apply-templates/>
				<xsl:if test="following-sibling::tei:w or following-sibling::*[descendant::tei:w]">
					<xsl:text>-</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:text> (</xsl:text>
		<xsl:value-of select="@ana"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="$msRef"/>
		<xsl:text>); </xsl:text>
	</xsl:template>

	<xsl:template name="morphData">
		<xsl:param name="lemRef"/>
		<xsl:choose>
			<xsl:when
				test="count(tei:entryFree[@corresp = $lemRef]//tei:gen) = 1 and count(//tei:entryFree[@corresp = $lemRef]//tei:iType) = 1">
				<xsl:value-of select="//tei:entryFree[@corresp = $lemRef]//tei:iType"/>

				<xsl:if
					test="//tei:entryFree[@corresp = $lemRef]//tei:gen and //tei:entryFree[@corresp = $lemRef]//tei:iType">
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:value-of select="//tei:entryFree[@corresp = $lemRef]//tei:gen[not(@xml:lang)]"/>
				<xsl:if test="//tei:entryFree[@corresp = $lemRef]/tei:gramGrp">
					<xsl:text> (</xsl:text>
					<xsl:value-of select="//tei:entryFree[@corresp = $lemRef]/tei:gramGrp/@type"/>
					<xsl:text>)</xsl:text>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="//tei:entryFree[@corresp = $lemRef]/tei:gramGrp">
						<xsl:for-each select="//tei:entryFree[@corresp = $lemRef]/tei:gramGrp">
							<xsl:if test="*[@xml:lang = 'sga' or not(@xml:lang)]">
								<xsl:text>OIr. </xsl:text>
								<xsl:choose>
									<xsl:when
										test="not(child::*[not(@n)]) and count(tei:gen[@xml:lang = 'sga' or not(@xml:lang)]) > 1 or not(child::*[not(@n)]) and count(tei:iType[@xml:lang = 'sga' or not(@xml:lang)]) > 1">
										<xsl:for-each
											select="*[@xml:lang = 'sga' and not(@n = preceding-sibling::*/@n) or not(@xml:lang) and not(@n = preceding-sibling::*/@n)]">
											<xsl:variable name="num" select="number(@n)"/>
											<xsl:variable name="max"
												select="count(ancestor::tei:gramGrp/*[@xml:lang = 'sga' or not(@xml:lang)])"/>
											<xsl:value-of
												select="ancestor::tei:gramGrp/tei:iType[@xml:lang = 'sga' and number(@n) = $num or not(@xml:lang) and number(@n) = $num]"/>
											<xsl:if
												test="ancestor::tei:gramGrp/tei:gen[@xml:lang = 'sga' and number(@n) = $num or not(@xml:lang) and number(@n) = $num] and ancestor::tei:gramGrp/tei:iType[@xml:lang = 'sga' and number(@n) = $num or not(@xml:lang) and number(@n) = $num]">
												<xsl:text>, </xsl:text>
											</xsl:if>
											<xsl:value-of
												select="ancestor::tei:gramGrp/tei:gen[@xml:lang = 'sga' and number(@n) = $num or not(@xml:lang) and number(@n) = $num]"/>
											<xsl:if test="not($num = $max)">
												<xsl:text>/</xsl:text>
											</xsl:if>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="tei:iType[@xml:lang = 'sga']">
											<xsl:value-of select="self::*"/><xsl:text> </xsl:text>
										</xsl:for-each>
										<xsl:if
											test="tei:gen[@xml:lang = 'sga'] and tei:iType[@xml:lang = 'sga']">
											<xsl:text>, </xsl:text>
										</xsl:if>
										<xsl:for-each select="tei:gen[@xml:lang = 'sga']"><xsl:value-of
											select="self::*"
										/><xsl:text> </xsl:text></xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="*[@xml:lang = 'mga']">
								<xsl:text>MidIr. </xsl:text>
								<xsl:choose>
									<xsl:when
										test="not(child::*[not(@n)]) and count(tei:gen[@xml:lang = 'mga']) > 1 or not(child::*[not(@n)]) and count(tei:iType[@xml:lang = 'mga']) > 1">
										<xsl:for-each
											select="*[@xml:lang = 'mga' and not(@n = preceding-sibling::*/@n)]">
											<xsl:variable name="num" select="number(@n)"/>
											<xsl:variable name="max"
												select="count(ancestor::tei:gramGrp/*[@xml:lang = 'mga'])"/>
											<xsl:value-of
												select="ancestor::tei:gramGrp/tei:iType[@xml:lang = 'mga' and number(@n) = $num]"/>
											<xsl:if
												test="ancestor::tei:gramGrp/tei:gen[@xml:lang = 'mga' and number(@n) = $num] and ancestor::tei:gramGrp/tei:iType[@xml:lang = 'mga' and number(@n) = $num]">
												<xsl:text>, </xsl:text>
											</xsl:if>
											<xsl:value-of
												select="ancestor::tei:gramGrp/tei:gen[@xml:lang = 'mga' and number(@n) = $num]"/>
											<xsl:if test="not($num = $max)">
												<xsl:text>/</xsl:text>
											</xsl:if>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="tei:iType[@xml:lang = 'mga']">
											<xsl:value-of select="self::*"/><xsl:text> </xsl:text>
										</xsl:for-each>
										<xsl:if
											test="tei:gen[@xml:lang = 'mga'] and tei:iType[@xml:lang = 'mga']">
											<xsl:text>, </xsl:text>
										</xsl:if>
										<xsl:for-each select="tei:gen[@xml:lang = 'mga']"><xsl:value-of
											select="self::*"
										/><xsl:text> </xsl:text></xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="*[@xml:lang = 'ghc']">
								<xsl:text>EModIr. </xsl:text>
								<xsl:choose>
									<xsl:when
										test="not(child::*[not(@n)]) and count(tei:gen[@xml:lang = 'ghc']) > 1 or not(child::*[not(@n)]) and count(tei:iType[@xml:lang = 'ghc']) > 1">
										<xsl:for-each
											select="*[@xml:lang = 'ghc' and not(@n = preceding-sibling::*/@n)]">
											<xsl:variable name="num" select="number(@n)"/>
											<xsl:variable name="max"
												select="count(ancestor::tei:gramGrp/*[@xml:lang = 'ghc'])"/>
											<xsl:value-of
												select="ancestor::tei:gramGrp/tei:iType[@xml:lang = 'ghc' and number(@n) = $num]"/>
											<xsl:if
												test="ancestor::tei:gramGrp/tei:gen[@xml:lang = 'ghc' and number(@n) = $num] and ancestor::tei:gramGrp/tei:iType[@xml:lang = 'ghc' and number(@n) = $num]">
												<xsl:text>, </xsl:text>
											</xsl:if>
											<xsl:value-of
												select="ancestor::tei:gramGrp/tei:gen[@xml:lang = 'ghc' and number(@n) = $num]"/>
											<xsl:if test="not($num = $max)">
												<xsl:text>/</xsl:text>
											</xsl:if>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="tei:iType[@xml:lang = 'ghc']">
											<xsl:value-of select="self::*"/><xsl:text> </xsl:text>
										</xsl:for-each>
										<xsl:if
											test="tei:gen[@xml:lang = 'ghc'] and tei:iType[@xml:lang = 'ghc']">
											<xsl:text>, </xsl:text>
										</xsl:if>
										<xsl:for-each select="tei:gen[@xml:lang = 'ghc']"><xsl:value-of
											select="self::*"
										/><xsl:text> </xsl:text></xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:if test="*[@xml:lang = 'gd']">
								<xsl:text>ScG. </xsl:text>
								<xsl:choose>
									<xsl:when
										test="not(child::*[not(@n)]) and count(tei:gen[@xml:lang = 'gd']) > 1 or not(child::*[not(@n)]) and count(tei:iType[@xml:lang = 'gd']) > 1">
										<xsl:for-each
											select="*[@xml:lang = 'gd' and not(@n = preceding-sibling::*/@n)]">
											<xsl:variable name="num" select="number(@n)"/>
											<xsl:variable name="max"
												select="count(ancestor::tei:gramGrp/*[@xml:lang = 'gd'])"/>
											<xsl:value-of
												select="ancestor::tei:gramGrp/tei:iType[@xml:lang = 'gd' and number(@n) = $num]"/>
											<xsl:if
												test="ancestor::tei:gramGrp/tei:gen[@xml:lang = 'gd' and number(@n) = $num] and ancestor::tei:gramGrp/tei:iType[@xml:lang = 'gd' and number(@n) = $num]">
												<xsl:text>, </xsl:text>
											</xsl:if>
											<xsl:value-of
												select="ancestor::tei:gramGrp/tei:gen[@xml:lang = 'gd' and number(@n) = $num]"/>
											<xsl:if test="not($num = $max)">
												<xsl:text>/</xsl:text>
											</xsl:if>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:for-each select="tei:iType[@xml:lang = 'gd']">
											<xsl:value-of select="self::*"/><xsl:text> </xsl:text>
										</xsl:for-each>
										<xsl:if
											test="tei:gen[@xml:lang = 'gd'] and tei:iType[@xml:lang = 'gd']">
											<xsl:text>, </xsl:text>
										</xsl:if>
										<xsl:for-each select="tei:gen[@xml:lang = 'gd']"><xsl:value-of
											select="self::*"
										/><xsl:text> </xsl:text></xsl:for-each>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
							<xsl:text> (</xsl:text>
							<xsl:value-of select="@type"/>
							<xsl:text>) </xsl:text>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:if test="//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'sga']">
							<xsl:text>OIr. </xsl:text>
							<xsl:choose>
								<xsl:when
									test="not(//tei:entryFree[@corresp = $lemRef]/child::*[not(@n)]) and count(//tei:entryFree[@corresp = $lemRef]/tei:gen[@xml:lang = 'sga'] and @n) > 1 or not(//tei:entryFree[@corresp = $lemRef]/child::*[not(@n)]) and count(//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'sga'] and @n) > 1">
									<xsl:for-each
										select="//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'sga' and not(@n = preceding-sibling::*/@n)]">
										<xsl:variable name="num" select="number(@n)"/>
										<xsl:variable name="max"
											select="count(//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'sga'])"/>
										<xsl:value-of
											select="//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'sga' and number(@n) = $num]"/>
										<xsl:if
											test="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'sga' and number(@n) = $num] and //tei:entryFree[@corresp = $lemRef]//tei:iType[@xml:lang = 'sga' and number(@n) = $num]">
											<xsl:text>, </xsl:text>
										</xsl:if>
										<xsl:value-of
											select="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'sga' and number(@n) = $num]"/>
										<xsl:if test="not($num = $max)">
											<xsl:text>/</xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'sga']">
										<xsl:value-of select="self::*"/><xsl:text> </xsl:text>
									</xsl:for-each>
									<xsl:if
										test="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'sga'] and //tei:entryFree[@corresp = $lemRef]//tei:iType[@xml:lang = 'sga']">
										<xsl:text>, </xsl:text>
									</xsl:if>
									<xsl:for-each select="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'sga']"><xsl:value-of
										select="self::*"
									/><xsl:text> </xsl:text></xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="following-sibling::*">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:if>
						<xsl:if test="//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'mga']">
							<xsl:text>MidIr. </xsl:text>
							<xsl:choose>
								<xsl:when
									test="not(//tei:entryFree[@corresp = $lemRef]/child::*[not(@n)]) and count(//tei:entryFree[@corresp = $lemRef]/tei:gen[@xml:lang = 'mga']) > 1 or not(//tei:entryFree[@corresp = $lemRef]/child::*[not(@n)]) and count(//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'mga']) > 1">
									<xsl:for-each
										select="//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'mga' and not(@n = preceding-sibling::*/@n)]">
										<xsl:variable name="num" select="number(@n)"/>
										<xsl:variable name="max"
											select="count(//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'mga'])"/>
										<xsl:value-of
											select="//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'mga' and number(@n) = $num]"/>

										<xsl:if
											test="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'mga' and number(@n) = $num] and //tei:entryFree[@corresp = $lemRef]//tei:iType[@xml:lang = 'mga' and number(@n) = $num]">
											<xsl:text>, </xsl:text>
										</xsl:if>
										<xsl:value-of
											select="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'mga' and number(@n) = $num]"/>
										<xsl:if test="not($num = $max)">
											<xsl:text>/</xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'mga']">
										<xsl:value-of select="self::*"/><xsl:text> </xsl:text>
									</xsl:for-each>
									<xsl:if
										test="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'mga'] and //tei:entryFree[@corresp = $lemRef]//tei:iType[@xml:lang = 'mga']">
										<xsl:text>, </xsl:text>
									</xsl:if>
									<xsl:for-each select="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'mga']"><xsl:value-of
										select="self::*"
									/><xsl:text> </xsl:text></xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="following-sibling::*">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:if>
						<xsl:if test="//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'ghc']">
							<xsl:text>EModIr. </xsl:text>
							<xsl:choose>
								<xsl:when
									test="not(//tei:entryFree[@corresp = $lemRef]/child::*[not(@n)]) and count(//tei:entryFree[@corresp = $lemRef]/tei:gen[@xml:lang = 'ghc']) > 1 or not(//tei:entryFree[@corresp = $lemRef]/child::*[not(@n)]) and count(//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'ghc']) > 1">
									<xsl:for-each
										select="//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'ghc' and not(@n = preceding-sibling::*/@n)]">
										<xsl:variable name="num" select="number(@n)"/>
										<xsl:variable name="max"
											select="count(//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'ghc'])"/>
										<xsl:value-of
											select="//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'ghc' and number(@n) = $num]"/>
										<xsl:if
											test="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'ghc' and number(@n) = $num] and //tei:entryFree[@corresp = $lemRef]//tei:iType[@xml:lang = 'ghc' and number(@n) = $num]">
											<xsl:text>, </xsl:text>
										</xsl:if>
										<xsl:value-of
											select="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'ghc' and number(@n) = $num]"/>
										<xsl:if test="not($num = $max)">
											<xsl:text>/</xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'ghc']">
										<xsl:value-of select="self::*"/><xsl:text> </xsl:text>
									</xsl:for-each>
									<xsl:if
										test="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'ghc'] and //tei:entryFree[@corresp = $lemRef]//tei:iType[@xml:lang = 'ghc']">
										<xsl:text>, </xsl:text>
									</xsl:if>
									<xsl:for-each select="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'ghc']"><xsl:value-of
										select="self::*"
									/><xsl:text> </xsl:text></xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="following-sibling::*">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:if>
						<xsl:if test="//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'gd']">
							<xsl:text>ScG. </xsl:text>
							<xsl:choose>
								<xsl:when
									test="not(//tei:entryFree[@corresp = $lemRef]/child::*[not(@n)]) and count(//tei:entryFree[@corresp = $lemRef]/tei:gen[@xml:lang = 'gd']) > 1 or not(//tei:entryFree[@corresp = $lemRef]/child::*[not(@n)]) and count(//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'gd']) > 1">
									<xsl:for-each
										select="//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'gd' and not(@n = preceding-sibling::*/@n)]">
										<xsl:variable name="num" select="number(@n)"/>
										<xsl:variable name="max"
											select="count(//tei:entryFree[@corresp = $lemRef]/*[@xml:lang = 'gd'])"/>
										<xsl:value-of
											select="//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'gd' and number(@n) = $num]"/>

										<xsl:if
											test="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'gd' and number(@n) = $num] and //tei:entryFree[@corresp = $lemRef]//tei:iType[@xml:lang = 'gd' and number(@n) = $num]">
											<xsl:text>, </xsl:text>
										</xsl:if>
										<xsl:value-of
											select="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'gd' and number(@n) = $num]"/>
										<xsl:if test="not($num = $max)">
											<xsl:text>/</xsl:text>
										</xsl:if>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="//tei:entryFree[@corresp = $lemRef]/tei:iType[@xml:lang = 'gd']">
										<xsl:value-of select="self::*"/><xsl:text> </xsl:text>
									</xsl:for-each>
									<xsl:if
										test="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'gd'] and //tei:entryFree[@corresp = $lemRef]//tei:iType[@xml:lang = 'gd']">
										<xsl:text>, </xsl:text>
									</xsl:if>
									<xsl:for-each select="//tei:entryFree[@corresp = $lemRef]//tei:gen[@xml:lang = 'gd']"><xsl:value-of
										select="self::*"
									/><xsl:text> </xsl:text></xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
							<xsl:if test="following-sibling::*">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="tei:g">
		<i>
			<xsl:apply-templates/>
		</i>
	</xsl:template>

	<xsl:template match="tei:unclear">
		<xsl:text>{</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>}</xsl:text>
	</xsl:template>

	<xsl:template match="tei:supplied">
		<xsl:text>[</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>]</xsl:text>
	</xsl:template>

	<xsl:template match="tei:del">
		<del rend="strikethrough">
			<xsl:apply-templates/>
		</del>
	</xsl:template>

	<xsl:template match="tei:add">
		<xsl:text>\</xsl:text>
		<xsl:apply-templates/>
		<xsl:text>/</xsl:text>
	</xsl:template>

</xsl:stylesheet>

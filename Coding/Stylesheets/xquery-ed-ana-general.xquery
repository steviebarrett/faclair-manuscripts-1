declare namespace xsl = "http://www.w3.org/1999/XSL/Transform";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
<html
    xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta
            http-equiv="Content-Type"
            content="text/html; charset=UTF-8"/>
    </head>
    <body>
        <table>
            <tr>
                <th>Headword</th>
                <th>Form</th>
                <th>Context</th>
            </tr>
            {
                for $x in //tei:w[not(descendant::tei:w) and not(@xml:lang) and not(@type = "data") and @lemmaRef]
                let $hw := string($x/@lemma)
                let $hwRef := $x/@lemmaRef
                let $form := $x/string(self::*)
                let $lineRef := $x/preceding::tei:lb[1]/@xml:id
                let $line := string(//*[preceding::tei:lb[1]/@xml:id = $lineRef])
                let $stylesheet :=
                <xsl:stylesheet
                    version="2.0">
                    <xsl:template
                        match="tei:space[@type = 'scriba' and @type = 'editorial']">
                        <xsl:text>
                        </xsl:text>
                    </xsl:template>
                    <xsl:template
                        match="tei:w[not(descendant::tei:w)]">
                        <xsl:value-of
                            select="string(self::*)"/>
                    </xsl:template>
                </xsl:stylesheet>
                return
                    <tr><td><a
                                href="{$hwRef}"
                                target="_blank">{$hw}</a></td><td>{$form}</td><td>{$line}</td></tr>
            }
        </table>
    </body>
</html>

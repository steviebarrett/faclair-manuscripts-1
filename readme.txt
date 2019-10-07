The TEI Structure of a text is as follows:

TEI
  > text
      > body
          > div+ @n @type @corresp @hand
              > p*

p elements can contain the following, chunk-level elements:

> handshift @new
> pb @n @xml:id @facs?
> lb @n @xml:id
> cb @n
> space @type
> name @type @corresp?
    > w+
    > pc*
> w @lemma @lemmaRef @pos @lemmaSL? @slipRef
    > #PCDATA
    > abbr @cert
        > #PCDATA
        > g @ref
            > #PCDATA
    > w
    > lb
    > unclear @reason="damage" @resp @cert #PCDATA
    > del @hand #PCDATA
    > handShift @new
    > add @type="insertion" @hand @place #PCDATA
    > supplied @resp #PCDATA
> pc
> data
> c
> num
> add @type="insertion" @hand @place
    > w+ etc.
> supplied @resp 
    > w+ etc.
> choice
    > sic  #wordcontent
    > corr #wordcontent



lg? l?



del, add, supplied, choice, note, seg, gap, head>title

The HTML structure of a (diplomatic) text is as follows:

div .text @data-hand @data-n @data-corresp @data-type @data-ms
  > div .textAnchor
      > button .addComment @type="button" @data-toggle="modal" @data-target="#commentForm" @data-s="div" @data-n> +
      > /button .viewComment .greyedOut @data-s="div" @data-n ?  
      > small .text-muted [start of Text ...]
  > p+
      > span+
  > div .textAnchor
      > small .textMuted [end of text ...]

p elements can contain the following chunk-level spans (as well as br elements, punctuation and spaces):

> .handShift @data-hand
    > small .textMuted [hs]
> .pageAnchor
    > br
    > small .textMuted [start of page/column ...] // the page number may be an a.page link
> .lineBreak @data-number @id="line_...">
    > br
    > button .addComment @type="button" @data-toggle="modal" @data-target="#commentForm" @data-s="lb" data-n> +
    > button .viewComment .greyedOut @type="button" @data-s="lb" @data-n ?
> .chunk .syntagm .name @data-nametype @data-corresp
    > .syntagm .name*
    > .syntagm .word+
> .chunk .syntagm .word @xml:lang? @data-headword? @data-pos? @data-edil? @data-lemmasl? @data-slipref?
    > .syntagm .word*
    > #PCDATA
> .chunk .syntagm
    > #PCDATA
> .punct 
    > #PCDATA
> .insertion @data-hand @data-place
    > w+ etc.
> .correction @title #wordcontent

.word spans can contain .expansion spans with @data-cert, @data-glyphref and @id attributes.
.word spans can contain .ligature spans with @data-glyphref and @id attributes.
.word spans can contain .unclearDamage spans with @data-cert, @data-resp and @data-add attributes
.word spans can contain .deletion spans with @data-hand attribute
.word spans can contain .handShift spans with @data-hand attribute
.word spans can contain .insertion spans with @data-hand and @data-place attributes








mss/index.php

This page is simply an index of the transcribed manuscripts, with links to diplomatic and semi-diplomatic views of each.
These links target /Coding/Scripts/viewTranscription.php with two obligatory parameters:
  t – transcription number, i.e. 1, 2, 3
  diplo – yes (diplomatic view) or no (semi-diplomatic view)

/Coding/Scripts/viewTranscription.php

This script takes two obligatory input parameters:
  t – transcription number, i.e. 1, 2, 3
  diplo – yes (diplomatic view) or no (semi-diplomatic view)
Dependent files are:
  /Coding/Stylesheets/common.css (styles relevant to page as a whole, or to both MS views) 
  /Coding/Stylesheets/comments.css (styles relevant to the comments system) 
  /Coding/Stylesheets/diplomatic.css | /Coding/Stylesheets/semiDiplomatic.css (MS view specific styles)
  /Coding/Scripts/common.js (event handlers relevant to page as a whole, or to both MS views)
  /Coding/Scripts/diplomatic.js | /Coding/Scripts/semiDiplomatic.js (MS view specific event handlers)
  /Coding/Scripts/comments.js (event handlers relevant to the comment system only)
  /Coding/Stylesheets/diplomatic.xsl | /Coding/Stylesheets/semiDiplomatic.xsl (MS view specific XSLT scripts)

The PHP creates a three-column Bootstrap page:
  a headword index
  a MSS view (diplomatic or semi-diplomatic) #midl
  an information panel #rhs
There is one extra, default hidden panel as well: 
  a form for adding comments #commentForm.
The headword index contains divs with the following structure:
  div
    > span .indexHeadword data-uri="..." ...
    > span .hwCount [3]
    > a .implode [-]
    > a .explode [+]
All but the first element are by default hidden, and appear only when the user clicks on the first one.
The MSS view panel contains a diplomatic or semi-diplomatic view of the manuscript, generated using either: 
  /Coding/Stylesheets/diplomatic.xsl
  /Coding/Stylesheets/semiDiplomatic.xsl

/Coding/Stylesheets/diplomatic.xsl

div @data-docid
  > div .text @data-hand @data-n= @data-corresp @data-type @data-ms
      > div .textAnchor 
          > button .addComment .textAnchor [+]
          > button .viewComment .textAnchor [?]
          > small [Start of text ...]
      > [text content]
      > div .textAnchor 
        > small [End of text ...]

div.text elements can contain the following sub-elements:
  > div.text
  > div.pageAnchor
      > small [Start of page ...]
  > span.handShift.textAnchor
  > p
  

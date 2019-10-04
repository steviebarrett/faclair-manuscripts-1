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
  

declare default element namespace "https://dasg.ac.uk/corpus/";
(: USER: input text via ID to be searched here :)
declare variable $text := "MS7.1";
declare option saxon:output "method=html";
<html>
    <head>
        <title>New Words</title>
    </head>
    <body>
        <table>
            <thead>
                <tr>
                    <th>MS Line</th>
                    <th>New Word Count</th>
                </tr>
            </thead>
            <tbody>
                {
                    for $x in //lb[ancestor::div[@corresp = $text]]
                    let $id := if ($x/@sameAs) then
                        $x/@sameAs
                    else
                        $x/@xml:id
                    let $nwords := count(//w[preceding::lb[1]/@* = $id and @lemmaRef and ancestor::div/@corresp = $text and not(@lemmaRef = preceding::w[ancestor::div/@corresp = $text]/@lemmaRef)])
                    return
                        <tr><td>{string($id)}</td><td>{$nwords}</td></tr>
                }
            </tbody>
        </table>
    </body>
</html>
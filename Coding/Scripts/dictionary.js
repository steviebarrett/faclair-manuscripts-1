$(function() {
  
  $('.entryLink').click(function() {
    //alert($(this).attr('data-lemmaRef'));
    //$('#midl').html($(this).attr('data-lemmaRef'));
    var html = 'ooo';
    $.getJSON('Coding/Scripts/dictionaryAjax.php?action=getEntry&lemmaRef=' + $(this).attr('data-lemmaRef'), function (g) {
      alert(g.headword);
      html += '<h1>Poooo';
      //html += g.headword;
      html += '</h1>';
      
      
      //li = '<li><a class="glyphShow" href="' + g.corresp + '" target="_new" data-src="' + g.id + '" data-id="' + id + '">' + g.name;
      //li += '</a>: ' + g.note + ' (' + c + ' certainty)'; //<a style="font-size: small;" href="#" class="glyphShow" data-id="' + elementId + '" data-corresp="'+/*prevCorresp+*/'">[show]</a></li>';
      //html += li + '</li>';
      
    });
    $('#midl').html(html);
    return null;
  });
  
});
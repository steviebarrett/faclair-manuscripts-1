$(function() {
  
  $('.entryLink').click(function() {
    var html = '';
    $.getJSON('Coding/Scripts/dictionaryAjax.php?action=getEntry&lemmaRef=' + $(this).attr('data-lemmaRef'), function (g) {
      //alert(g.headword);
      html += '<h1><a href="' + g.lemmaRef + '" target="_new">' + g.lemma + '</a>';
      if (g.lemmaDW!='') { 
        html += ' / <a href="' + g.lemmaRefDW + '" target="_new">' + g.lemmaDW + '</a>';
      }
      html += '</h1>';
      html += '<p>POS: ' + g.pos + '</p>';
      if (g.forms.length>0) {
        html += '<p>Other forms: ' + g.forms + '</p>';
      }
      $('#midl').html(html); // right place for this?
    });
    
    return null;
  });
  
});
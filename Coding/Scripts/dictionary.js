$(function() {
  
  $('.entryLink').click(function() {
    var html = '';
    $.getJSON('Coding/Scripts/dictionaryAjax.php?action=getEntry&lemmaRef=' + $(this).attr('data-lemmaRef'), function (g) {
      //alert(g.headword);
      html += '<h1>'
      html += g.headword;
      html += '</h1>';
      $('#midl').html(html); // right place for this?
    });
    
    return null;
  });
  
});
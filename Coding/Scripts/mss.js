$(function() {

  $('.chunk').mouseenter(function(){
    if ($(this).hasClass('name')) {
      $(this).css('color', 'white');
      $(this).css('background-color', 'green');
    }
    else {
      $(this).css('color', 'white');
      $(this).css('background-color', 'blue');
    }
  });

  $('.chunk').mouseleave(function(){
    $(this).css('color', 'black');
    $(this).css('background-color', 'white');
  });

  $('.chunk').click(function(){
    $('#right-panel').html(makeDescription($(this),false));
  });

  function makeDescription(span, rec) {
    html = '<span style="color:red;">' + $(span).text() + '</span><ul>';
    if ($(span).hasClass('name')) {
      html = html + '<li>is the name of a ';
      if ($(span).attr('data-nametype')=='personal') {
        html = html + 'person</li>';
      }
      else if ($(span).attr('data-nametype')=='place') {
        html = html + 'place</li>';
      }
    }
    if ($(span).attr('data-pos')) {
      var poss = $(span).attr('data-pos').split(', ');
      for (var i = 0; i < poss.length; i++) { 
        html = html + '<li>is a ' + eval('pos_' + poss[i]) + '</li>';
      }
    }
    if ($(span).attr('data-headword')) {
      html = html + '<li>is a form of the headword <a href="' + $(span).attr('data-edil') + '" target="_new">' + $(span).attr('data-headword') + '</a></li>';
    }
    if ($(span).children('.word, .name').length>1) {
      html += '<li>is a syntactically complex form containing the following elements:';      
      html += '<ul>';
      $(span).children('.word, .name').each(function() {
        html = html + '<li>' + makeDescription($(this),true) + '</li>';
      });
      html += '</ul>';
      html += '</li>';
    }
    else {
      html += '<li>is a syntactically simple form</li>';
    }
    if (!rec && $(span).find('.glyph').length>0) {
      html += '<li>contains the following scribal abbreviations:<ul id="abbreviationList">';
      $(span).find('.glyph').each(function() {
        var g = eval('glyph_' + $(this).attr('data-glyphref'));
        txt = '<a href="http://' + g.url + '" target="_new" data-src="' + $(this).attr('id') + '">' + g.name;
        txt = txt + '</a>: ' + g.description;
        html = html + '<li class="glyphItem">' + txt +'</li>';
      });
      html += '</ul></li>';
    }
    html += '</ul>';
    return html;
  }

  $('.glyphItem').mouseenter(function(){
    //console.log($(this).attr('data-src'));
    //goo = $(this).attr('data-src');
    //gee = '#' + goo;
    $(this).css('color', 'white');
    $(this).css('background-color', 'red');
    return false;
  });

/*
  $('.glyphLink').mouseleave(function(){
    goo = $(this).attr('data-src');
    gee = '#' + goo;
    $(gee).css('color', 'black');
    $(gee).css('background-color', 'white');
  });  
*/

/*
   
  $('#clear-slips-button').on('click', function() {
    console.log('pressed');
  });
            
  $('.word').on('click', function(){
    var abbrevs = ""; 
    $.each($(this).contents().find('.abbreviation-glyph'), function(i, v) {
      abbrevs = abbrevs + $(this).html() + ' ';
    });
    $('#slips-table > tbody').append('<tr><td>'+ $(this).html() + '</td><td>' + abbrevs + '</td></tr>');
  });

   */

  
  
});

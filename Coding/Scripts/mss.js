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
      html = html + '<li>is ' + expand($(span).attr('data-pos')) + '</li>';
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
      html += '<li>contains the following scribal abbreviations:<ul>';
      $(span).find('.glyph').each(function() {
        html = html + '<li>' + $(this).attr('data-glyphref') + '</li>';
        /* 
        html += '<li>'; 
        $.ajax({
          type: "GET",
          url: "../corpus.xml",
          dataType: "xml",
          success: function(xml) {
            $(xml).find('glyph').each(function() {
              if ($(this).attr('xml:id') == $(span).attr('data-glyphref')) {
                console.log('Dunnit!');
                console.log($(this).attr('corresp'));
                html += $(this).attr('corresp');
              }
            });
          },       
          error: function() {
            alert("The XML File could not be processed correctly.");
          }
        });
        
        html += '</li>';
         */
      });
      html += '</ul></li>';
    }
    html += '</ul>';
    return html;
  }



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

  function expand(pos) {
    if (pos == 'conj') {
      return 'a conjunction';
    }
    else if (pos == 'poss') {
      return 'a possessive article';
    }
    else if (pos == 'prep') {
      return 'a preposition';
    }
    else if (pos == 'adj') {
      return 'an adjective';
    }
    else if (pos == 'pron') {
      return 'a pronoun';
    }
    else if (pos == 'part') {
      return 'a particle';
    }
    else if (pos == 'art') {
      return 'an article';
    }
    else if (pos == 'prep, pron') {
      return 'a prepositional pronoun';
    }
    else {
      return 'a ' + pos;
    }
  }
  
  
});

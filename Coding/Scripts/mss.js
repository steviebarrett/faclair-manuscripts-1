$(function() {

  $('#showHeader').click(function(){
    $('#headerInformation').show();
    $('#diplomaticTranscription').hide();
    $('#semiDiplomaticTranscription').hide();
  });
  
  $('#showDiplomatic').click(function(){
    $('#headerInformation').hide();
    $('#diplomaticTranscription').show();
    $('#semiDiplomaticTranscription').hide();
  });
  
  $('#showSemiDiplomatic').click(function(){
    $('#headerInformation').hide();
    $('#diplomaticTranscription').hide();
    $('#semiDiplomaticTranscription').show();
  });  
  
  $('.chunk').mouseenter(function(){
    $(this).css('text-decoration', 'underline');
  });

  $('.chunk').mouseleave(function(){
    $(this).css('text-decoration', 'inherit');
  });

  $('.chunk').click(function(){
    $('.chunk').css('background-color', 'inherit');
    $(this).css('background-color', 'yellow');
    $('#right-panel').html(makeDescription($(this),false));
  });

  function makeDescription(span, rec) {
    html = '<span style="color:red;">' + $(span).text() + '</span><ul>';

    /* Added by SB to handle compound words - to be revised by MM */
      console.log($(span).attr('data-compound'));
      console.log($(span));
    if ($(span).attr('data-compound')=='1') {
      html = html + '<li>is a compound word</li>';
    }
    /* /// */

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
    if ($(span).children('.word').length>1) {
      html += '<li>is a syntactically complex form containing the following elements:';      
      html += '<ul>';
      $(span).children('.word').each(function() {
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
    if (!rec && $(span).find('.unclear').length>0) {
      html += '<li>contains the following unclear sequences:<ul id="unclearList">';
      $(span).find('.unclear').each(function() {
        html = html + '<li><span style="color: green;">{</span>' + $(this).text() + '<span style="color: green;">}</span> – ';
        html = html + 'certainty: ' + $(this).attr('data-cert') + ', reason: ' + $(this).attr('data-reason');
        html += '</li>';
      });
      html += '</ul></li>';
    }
    if (!rec && $(span).find('.deletion').length>0) {
      html += '<li>contains the following deleted sequences:<ul id="deletionList">';
      $(span).find('.deletion').each(function() {
        html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> – ';
        html = html + 'deleted by: ' + $(this).attr('data-hand');
        html += '</li>';
      });
      html += '</ul></li>';
    }
    if (!rec && $(span).find('.addition').length>0) {
      html += '<li>contains the following added sequences:<ul id="additionList">';
      $(span).find('.addition').each(function() {
        html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> – ';
        html = html + 'added by: ' + $(this).attr('data-hand') + ', place: ' + $(this).attr('data-place') + ', type: ' + $(this).attr('data-type');
        html += '</li>';
      });
      html += '</ul></li>';
    }
    if (!rec && $(span).parents('.addition').length>0) {
      html += '<li>is part of the addition ';
      html = html + '<span style="color:red;">' + $(span).parents('.addition').text() + '</span> ';
      html = html + '[' + 'added by: ' + $(span).parents('.addition').attr('data-hand') + ', place: ' + $(span).parents('.addition').attr('data-place') + ', type: ' + $(span).parents('.addition').attr('data-type') + ']';
      html += '</li>';
    }
    if (!rec && $(span).find('.supplied').length>0) {
      html += '<li>contains the following supplied sequences:<ul id="suppliedList">';
      $(span).find('.supplied').each(function() {
        html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> ';
        html += '</li>';
      });
      html += '</ul></li>';
    }
    html = html + '<li>Location: ' + $(span).prev('.lineBreak').attr('id') + '</li>'; // note working yet
    
    html += '</ul>';
    return html;
  }


  /*
    Restyle glyphs that are ligatures in normal font (not italics)
    Added by SB
  */
  $('.glyph').each(function() {
      if ($(this).attr('data-glyphref').charAt(0) == 'l') {
          $(this).css('font-style', 'normal');
      }
  });

  /*
    Restyle additions that are placed below in subscript
    Added by SB
   */
  $('.addition').each(function() {
      if ($(this).attr('data-place') == 'below') {
        $(this).css('vertical-align', 'sub');
      }
  });

  /*
    Show/hide marginal notes
    Added by Sb
   */
  $('.marginalNoteLink').on('click', function() {
    var id = $(this).attr('data-id').replace(/\./g, '\\.');
    $('#'+id).toggle();
  });


});

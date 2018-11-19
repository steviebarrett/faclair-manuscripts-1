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
    html = '<span style="color:red;">' + clean($(span).text()) + '</span><ul>';
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
    else if ($(span).hasClass('name') && $(span).children('.word').length==1 && $(span).children('.word').children('.word').length==0) {
      var poss = $(span).children('.word').attr('data-pos').split(', ');
      for (var i = 0; i < poss.length; i++) { 
        html = html + '<li>is a ' + eval('pos_' + poss[i]) + '</li>';
      }
    }
    if ($(span).attr('data-headword')) {
      html = html + '<li>is a form of the headword <a href="' + $(span).attr('data-edil') + '" target="_new">' + $(span).attr('data-headword') + '</a></li>';
    }
    else if ($(span).hasClass('name') && $(span).children('.word').length==1 && $(span).children('.word').attr('data-headword')) {
      html = html + '<li>is a form of the headword <a href="' + $(span).children('.word').attr('data-edil') + '" target="_new">' + $(span).children('.word').attr('data-headword') + '</a></li>';
    }
    if ($(span).children('.syntagm').length>1) {
      html += '<li>is a syntactically complex form containing the following elements:';      
      html += '<ul>';
      $(span).children('.syntagm').each(function() {
        html = html + '<li>' + makeDescription($(this),true) + '</li>';
      });
      html += '</ul>';
      html += '</li>';
    }
    else if ($(span).children('.syntagm').length==1 && $(span).children('.syntagm').children('.syntagm').length>0) {
      html += '<li>is a syntactically complex form containing the following elements:';      
      html += '<ul>';
      $(span).children('.syntagm').children('.syntagm').each(function() {
        html = html + '<li>' + makeDescription($(this),true) + '</li>';
      });
      html += '</ul>';
      html += '</li>';
    }
    else if ($(span).children('.addition, .deletion').length>0) {
      html += '<li>is a syntactically complex form containing the following elements:';      
      html += '<ul>';
      $(span).children('.syntagm').add($(span).children('.addition').add($(span).children('.deletion')).children('.syntagm')).each(function() {
        html = html + '<li>' + makeDescription($(this),true) + '</li>';
      });
      html += '</ul>';
      html += '</li>';
    }
    else {
      html += '<li>is a syntactically simple form</li>';
    }    
    if (!rec && $(span).find('.expansion').length>0) {
      html = html + '<li>' + extractExpansions($(span)) + ' contains the following scribal expansions:<ul id="expansionList">';
      $(span).find('.expansion').each(function() {
        var g = eval('glyph_' + $(this).attr('data-glyphref'));
        txt = '<a href="http://' + g.url + '" target="_new" data-src="' + $(this).attr('id') + '">' + g.name;
        txt = txt + '</a>: ' + g.description.replace(/%/g,"'");
        html = html + '<li class="glyphItem">' + txt +'</li>';
      });
      html += '</ul></li>';
    }
    if (!rec && $(span).find('.ligature').length>0) {
      html += '<li>contains the following scribal ligatures:<ul id="ligatureList">';
      $(span).find('.ligature').each(function() {
        var g = eval('glyph_' + $(this).attr('data-glyphref'));
        txt = '<a href="http://' + g.url + '" target="_new" data-src="' + $(this).attr('id') + '">' + g.name;
        txt = txt + '</a>: ' + g.description.replace(/%/g,"'");
        html = html + '<li class="glyphItem">' + txt +'</li>';
      });
      html += '</ul></li>';
    }
    if (!rec && $(span).find('.expansion').length>0) {
      // SB
    }
    if (!rec && $(span).find('.ligature').length>0) {
      // SB
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
    if (!rec && $(span).find('.suppliedDiplo').length>0) {
      html += '<li>contains the following supplied sequences:<ul>';
      $(span).find('.suppliedDiplo').each(function() {
        html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> ';
        html += '</li>';
      });
      html += '</ul></li>';
    }
    if (!rec && $(span).find('.suppliedSemi').length>0) {
      html += '<li>contains the following supplied sequences:<ul>';
      $(span).find('.suppliedSemi').each(function() {
        html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> ';
        html += '</li>';
      });
      html += '</ul></li>';
    }
    if (!rec && $(span).find('.damagedDiplo').length>0) {
      html += '<li>contains the following damaged sequences:<ul>';
      $(span).find('.damagedDiplo').each(function() {
        html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> ';
        html += '</li>';
      });
      html += '</ul></li>';
    }
    if (!rec && $(span).find('.damagedSemi').length>0) {
      html += '<li>contains the following damaged sequences:<ul>';
      $(span).find('.damagedSemi').each(function() {
        html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> ';
        html += '</li>';
      });
      html += '</ul></li>';
    }
    if (!rec && $(span).find('.obscureTextDiplo').length>0) {
      html += '<li>contains the following sequences of obscured text:<ul>';
      $(span).find('.obscureTextDiplo').each(function() {
        html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> ';
        html += '</li>';
      });
      html += '</ul></li>';
    }
    else if (!rec && $(span).parents('.obscureTextDiplo').length>0) {
      html += '<li>part of the following sequence of obscured text:<ul>';
      html = html + '<li><span style="color: green;">[</span>' + $(span).parents('.obscureTextDiplo').text() + '<span style="color: green;">]</span> ';
      html += '</li>';
      html += '</ul></li>';
    }
    else if (!rec && $(span).find('.obscureTextSemi').length>0) { 
      html += '<li>contains the following sequences of obscured text:<ul>';
      $(span).find('.obscureTextSemi').each(function() {
        html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> ';
        html += '</li>';
      });
      html += '</ul></li>';
    }
    else if (!rec && $(span).parents('.obscureTextSemi').length>0) {
      html += '<li>part of the following sequence of obscured text:<ul>';
      html = html + '<li><span style="color: green;">[</span>' + $(span).parents('.obscureTextSemi').text() + '<span style="color: green;">]</span> ';
      html += '</li>';
      html += '</ul></li>';
    }
    html += '</ul>';
    return html;
  }

  function clean(str) { // remove form content from headword strings at linebreaks
    var i = str.indexOf('[+]');
    var k = str.indexOf(' (');
    if (i != -1) {
      var j = str.indexOf('[?]');
      str2 = str.slice(0,i) + str.slice(j+4, str.length);
    }
    else if (k != -1) {
      var j = str.indexOf(') ');
      str2 = str.slice(0,k) + str.slice(j+2, str.length);
    }
    else str2 = str;
    str = str2.replace(/[:=]/g,'');
    return str;
  }

  function extractExpansions(html) {
  /*  
    oot = '';
    if ($(html).hasClass('expansion')) {
      var id = 'exp' + Math.floor((Math.random() * 10000) + 1);
      console.log(id);
      oot = '<span class="expansion" id="' + id + '">';
      oot += $(html).text();
      oot += '</span>';
    }
    else {
      $(html).children().each();
    }
    */
    return clean($(html).text());
  }

  /*
    Show/hide marginal notes
    Added by Sb
   */
  $('.marginalNoteLink').on('click', function() {
    var id = $(this).attr('data-id').replace(/\./g, '\\.');
    $('#'+id).toggle();
  });


});

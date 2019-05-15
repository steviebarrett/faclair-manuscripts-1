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
    $('.gapDamageDiplo').css('background-color', 'inherit');
    $(this).css('background-color', 'yellow');
    $('#headword').text(clean($(this).text()));
    $('#syntaxInfo').html(makeDescription($(this),false));
    $('#expansionList').html('');
    if ($(this).find('.expansion').length>0) {
      $('#expansionInfo').show();
      html = '';
      $(this).find('.expansion').each(function() {
        cert = $(this).attr('data-cert');
        var xmlId = $(this).attr('data-glyphref');  
        //$.getJSON('/~mark/faclair-manuscripts/Coding/Scripts/ajax.php?action=getGlyph&xmlId=' + xmlId, function (g) {
        $.getJSON('/ajax/manuscripts.php?action=getGlyph&xmlId=' + xmlId, function (g) {
          txt = '<li class="glyphItem"><a href="http://' + g.corresp + '" target="_new" data-src="' + g.id + '">' + g.name;
          txt = txt + '</a>: ' + g.note + ' (' + cert + ' certainty)</li>';
          html = html + txt;
        })
        .done(function() {
          $('#expansionList').html(html);
        });
      }); 
    }
    else {
      $('#expansionInfo').hide();
    }
    $('#damagedInfo').html(getDamage($(this)));
    $('#deletionInfo').html(getDeletions($(this)));
  });
  
  $('.gapDamageDiplo').click(function(){
    $('.chunk').css('background-color', 'inherit');
    $('.gapDamageDiplo').css('background-color', 'inherit');
    $(this).css('background-color', 'yellow');
    $('#expansionList').html('');
    $('#headword').html('');
    $('#damagedInfo').html('');
    $('#expansionInfo').hide();
    html = 'This is a damaged section of text: ';
    html = html + $(this).attr('data-extent') + ' ' + $(this).attr('data-unit') + ' (' + $(this).attr('data-resp') + ')';
    $('#syntaxInfo').html(html);
  });
  
  function makeDescription(span, rec) {
    html = '';
    if (rec) {
      html = html + '<span style="color:red;">' + clean($(span).text()) + '</span><ul>';
    }
    if ($(span).hasClass('name')) {
      if ($(span).attr('data-nametype')=='personal') {
        html = html + '<li>is the name of a person</li>';
      }
      else if ($(span).attr('data-nametype')=='place') {
        html = html + '<li>is the name of a place</li>';
      }
      else if ($(span).attr('data-nametype')=='population') {
        html = html + '<li>is the name of a group of people</li>';
      }
      else {
        html = html + '<li>is a name</li>';
      }
    }
    if ($(span).attr('data-pos')) {
      html = html + '<li>is a ' + $(span).attr('data-pos') + '</li>';
    }
    else if ($(span).hasClass('name') && $(span).children('.word').length==1 && $(span).children('.word').children('.word').length==0) {
      var poss = $(span).children('.word').attr('data-pos').split(', ');
      for (var i = 0; i < poss.length; i++) { 
        html = html + '<li>is a ' + poss[i] + '</li>';
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
    if (rec) {
      html += '</ul>';
    }
    return html;
    
    /*
    if (!rec && $(span).find('.ligature').length>0) {
      html += '<li>contains the following scribal ligatures:<ul id="ligatureList">';
      $(span).find('.ligature').each(function() {
          var xmlId = $(this).attr('data-glyphref');
          var id = $(this).attr('id');    //!! this is undefined
          $.ajaxSetup({async: false});    //!! we should not be using this !!
          $.getJSON('/ajax/manuscripts.php?action=getGlyph&xmlId=' + xmlId, function (g) {
              txt = '<a href="http://' + g.corresp + '" target="_new" data-src="' + id + '">' + g.name;
              txt = txt + '</a>: ' + g.note;
              html = html + '<li class="glyphItem">' + txt +'</li>';
          });
      });
      $.ajaxSetup({async: true}); //!! we should not be using this !!
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
      html += '<li>contains editorial supplements:<ul>';
      //html += $(span).text();  
      $(span).find('.suppliedDiplo').each(function() {
        html = html + '<li><span style="color: green;">' + $(this).text() + '</span> ';
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
     */
  }

  function getDamage(span) {
    html2 = '';
    if ($(span).find('.unclearDamageDiplo').length>0) {
      html2 += 'Contains the following damaged sections:<ul>';
      $(span).find('.unclearDamageDiplo').each(function() {
        html2 = html2 + '<li>[' + $(this).attr('data-add') + '] ';
        html2 = html2 + '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
        html2 += ' certainty)</li>';
      }); 
      html2 += '</ul>';
    }
    if ($(span).find('.unclearTextObscureDiplo').length>0) {
      html2 += 'Contains the following obscured sections:<ul>';
      $(span).find('.unclearTextObscureDiplo').each(function() {
        html2 = html2 + '<li>[' + $(this).text() + '] ';
        html2 = html2 + '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
        html2 += ' certainty)</li>';
      }); 
      html2 += '</ul>';
    }
    if ($(span).find('.unclearCharDiplo').length>0) {
      html2 += 'Contains the following unclear characters:<ul>';
      $(span).find('.unclearCharDiplo').each(function() {
        html2 = html2 + '<li>[' + $(this).text() + '] ';
        html2 = html2 + '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
        html2 += ' certainty)</li>';
      }); 
      html2 += '</ul>';
    }
    if ($(span).parents('.unclearTextObscureDiplo').length>0) {
      html2 += 'This is part of an obscured section.'; 
    }
    if ($(span).parents('.unclearInterpObscureDiplo').length>0) {
      html2 += 'This is part of a section whose interpretation is obscure.'; 
    }
    return html2;
  }

  function getDeletions(span) {
    html2 = '';
    if ($(span).find('.deletionDiplo').length>0) {
      html2 += 'Contains the following deletions:<ul>';
      $(span).find('.deletionDiplo').each(function() {
        html2 = html2 + '<li>[' + $(this).text() + '] ';
        html2 = html2 + '(' + $(this).attr('data-hand');
        html2 += ')</li>';
      }); 
      html2 += '</ul>';
    }
    return html2;
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

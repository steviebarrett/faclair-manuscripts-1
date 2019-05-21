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
    //$('#headword').text(clean($(this).text()));
    $('#headword').html(reindex($(this).html()));
    $('#syntaxInfo').html(makeDescription($(this),false));
    $('#expansionList').html('');
    if ($(this).find('.expansion, .ligature').length>0) {
      $('#expansionInfo').show();
      html = '';
      $(this).find('.expansion, .ligature').each(function() {
        cert = $(this).attr('data-cert');
        var xmlId = $(this).attr('data-glyphref');
        var elementId = $(this).attr('id');
        //$.getJSON('/~mark/faclair-manuscripts/Coding/Scripts/ajax.php?action=getGlyph&xmlId=' + xmlId, function (g) {
        $.getJSON('/ajax/manuscripts.php?action=getGlyph&xmlId=' + xmlId, function (g) {
          txt = '<li class="glyphItem"><a href="' + g.corresp + '" target="_new" data-src="' + g.id + '">' + g.name;
          txt = txt + '</a>: ' + g.note + ' (' + cert + ' certainty) <a style="font-size: small;" href="#" class="glyphShow" data-id="' + elementId + '">[show]</a></li>';
          html = html + txt;
        })
        .done(function() {
          $('#expansionList').html(html);
          $('.glyphShow').hover(
            function(){
              $('#'+$(this).attr('data-id')).css('text-decoration', 'underline');
              $('#xx'+$(this).attr('data-id')).css('background-color', 'yellow');
            },
            function() {
              $('#'+$(this).attr('data-id')).css('text-decoration', 'inherit');
              $('#xx'+$(this).attr('data-id')).css('background-color', 'inherit');
            }
          );
        });
      }); 
    }
    else {
      $('#expansionInfo').hide();
    }
    $('#damagedInfo').html(getDamage($(this)));
    $('#deletionInfo').html(getDeletions($(this)));
    $('#additionInfo').html(getAdditions($(this)));
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
    htmlx = '';
    if (rec) {
      htmlx = htmlx + '<span style="color:red;">' + clean($(span).text()) + '</span><ul>';
    }
    if ($(span).hasClass('name')) {
      if ($(span).attr('data-nametype')=='personal') {
        htmlx = htmlx + '<li>is the name of a person</li>';
      }
      else if ($(span).attr('data-nametype')=='place') {
        htmlx = htmlx + '<li>is the name of a place</li>';
      }
      else if ($(span).attr('data-nametype')=='population') {
        htmlx = htmlx + '<li>is the name of a group of people</li>';
      }
      else {
        htmlx = htmlx + '<li>is a name</li>';
      }
    }
    if ($(span).attr('xml:lang') || ($(span).hasClass('name') && $(span).children('.word').length==1 && $(span).children('.word').attr('xml:lang'))) {
      htmlx = htmlx + '<li>is not a Gaelic word: ';
      if ($(span).attr('xml:lang')) {
        htmlx += decode($(span).attr('xml:lang'));
      }
      else {
        htmlx += decode($(span).children('.word').attr('xml:lang'));
      }
      htmlx += '</li>';
    }
    else {
      if ($(span).attr('data-pos')) {
        htmlx = htmlx + '<li>is a ' + $(span).attr('data-pos') + '</li>';
      }
      else if ($(span).hasClass('name') && $(span).children('.word').length==1 && $(span).children('.word').children('.word').length==0) {
        var poss = $(span).children('.word').attr('data-pos').split(', ');
        for (var i = 0; i < poss.length; i++) { 
          htmlx = htmlx + '<li>is a ' + poss[i] + '</li>';
        }
      }
      if ($(span).attr('data-headword')) {
        htmlx += '<li>is a form of the headword ';
        htmlx = htmlx + '<a href="' + $(span).attr('data-edil') + '" target="_new">' + $(span).attr('data-headword') + '</a>';
        if ($(span).attr('data-edil').indexOf('dil.ie')>0) {
          htmlx += ' (eDIL)';
        }
        else if ($(span).attr('data-edil').indexOf('faclair.com')>0) {
          htmlx += ' (Dwelly)';
        }
        $.ajaxSetup({async: false});
        //$.getJSON('/~mark/faclair-manuscripts/Coding/Scripts/ajax.php?action=getDwelly&edil=' + $(span).attr('data-edil'), function (g) {
        $.getJSON('/ajax/manuscripts.php?action=getDwelly&edil=' + $(span).attr('data-edil'), function (g) {
          if (g.hw != '') {
            htmlx = htmlx + ', <a href="' + g.url + '" target="_new">' + g.hw + '</a> (Dwelly)';
          }
        });
        htmlx += '</li>';
      }
      else if ($(span).hasClass('name') && $(span).children('.word').length==1 && $(span).children('.word').attr('data-headword')) { // add extra headwords here too
        htmlx = htmlx + '<li>is a form of the headword <a href="' + $(span).children('.word').attr('data-edil') + '" target="_new">' + $(span).children('.word').attr('data-headword') + '</a></li>';
      }
    
    if ($(span).children('.syntagm').length>1) {
      htmlx += '<li>is a syntactically complex form containing the following elements:';      
      htmlx += '<ul>';
      $(span).children('.syntagm').each(function() {
        htmlx = htmlx + '<li>' + makeDescription($(this),true) + '</li>';
      });
      htmlx += '</ul>';
      htmlx += '</li>';
    }
    else if ($(span).children('.syntagm').length==1 && $(span).children('.syntagm').children('.syntagm').length>0) {
      htmlx += '<li>is a syntactically complex form containing the following elements:';      
      htmlx += '<ul>';
      $(span).children('.syntagm').children('.syntagm').each(function() {
        htmlx = htmlx + '<li>' + makeDescription($(this),true) + '</li>';
      });
      htmlx += '</ul>';
      htmlx += '</li>';
    }
    else if ($(span).children('.addition, .deletion').length>0) {
      htmlx += '<li>is a syntactically complex form containing the following elements:';      
      htmlx += '<ul>';
      $(span).children('.syntagm').add($(span).children('.addition').add($(span).children('.deletion')).children('.syntagm')).each(function() {
        htmlx = htmlx + '<li>' + makeDescription($(this),true) + '</li>';
      });
      htmlx += '</ul>';
      htmlx += '</li>';
    }
    else {
      htmlx += '<li>is a syntactically simple form</li>';
    }
    if($(span).attr('data-lemmasl')) {
      htmlx = htmlx + '<li>appears in the HDSG/RB collection of headwords: <a href="' + $(span).attr('data-slipref') + '" target="_new">' + $(span).attr('data-lemmasl') + '</a></li>';
    }
    }
    if (rec) {
      htmlx += '</ul>';
    }
    return htmlx;
    
    /*
    
    
   
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
   
    if (!rec && $(span).find('.damagedSemi').length>0) {
      html += '<li>contains the following damaged sequences:<ul>';
      $(span).find('.damagedSemi').each(function() {
        html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> ';
        html += '</li>';
      });
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
  
  function decode(lang) {
    switch(lang) {
      case 'la': return 'Latin';
      case 'sco': return 'Scots';
      default: return lang;
    }
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

  function getAdditions(span) {
    html2 = '';
    if ($(span).find('.insertion').length>0) {
      html2 += 'Contains the following insertions:<ul>';
      $(span).find('.insertion').each(function() {
        html2 = html2 + '<li>[' + $(this).text() + '] ';
        html2 = html2 + '(' + $(this).attr('data-hand');
        html2 = html2 + ', '  + $(this).attr('data-place');
        html2 += ')</li>';
      }); 
      html2 += '</ul>';
    }
    else if ($(span).parents('.insertion').length>0) {
      html2 += 'Is part of the following insertion:<ul>';
      html2 = html2 + '<li>[' + $(span).parents('.insertion').text() + '] ';
      html2 = html2 + '(' + $(span).parents('.insertion').attr('data-hand');
      html2 = html2 + ', ' + $(span).parents('.insertion').attr('data-place');
      html2 += ')</li>';
      html2 += '</ul>';
    }
    return html2;
  }

  function reindex(span) { // prefixes all ids in some html
    return span.replace(/id="/g, 'id="xx');
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

/* 
This script is called by viewTranscription.php
It contains event handlers relevant to that page as a whole, and to both MS views.
*/

$(function() {
  
  $('.indexHeadword').click(function(){ // called whenever a new headword is selected
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    $('.syntagm').css({'background-color': 'inherit', 'color': 'inherit', 'font-weight': 'normal'}); // unhighlight all words and phrases
    $('#rhs').html(''); // clear RHS
    $('.temp').remove(); // remove all temporary hr elements
    $('#midl').find('span').show(); // unhide all spans
    $('#midl').find('.corr').hide();
    $('.textAnchor').show();
    $('.pageAnchor').show();
    $('.indexHeadword').parent().css({'background-color': 'inherit'});
    $('.hwCount').hide();
    $('.implode').hide();
    $('.explode').hide();
    $('[data-edil="'+ $(this).attr('data-uri') + '"]').css({'color': 'orange', 'font-weight': 'bold'});
    $(this).parent().css('background-color', 'orange');
    $(this).nextAll('.hwCount').show();
    $(this).nextAll('.implode').show();
    var x = $('[data-edil="'+ $(this).attr('data-uri') + '"]').first();
    $('#midl').animate({scrollTop: x.offset().top - 100},500);
    return null;
  });

  $('.implode').click(function(){
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    $(this).hide();
    $(this).nextAll('.explode').show();
    $('#midl').find('span').hide();
    $('.temp').remove();
    $('[data-edil="'+ $(this).prevAll('.indexHeadword').attr('data-uri') + '"]').each(function(){
      $(this).show();
      $(this).find('span').show();
      if ($(this).parents('span').length>0) {
        $(this).parents('span').show();
        $(this).parents('span').find('span').show();
        $(this).parents('span').prevAll().slice(0,10).show();
        $(this).parents('span').prevAll().slice(0,10).find('*').show();
        $(this).parents('span').nextAll().slice(0,10).show();
        $(this).parents('span').nextAll().slice(0,10).find('*').show();
        $('<hr class="temp"/>').insertAfter($(this).parents('span').nextAll().slice(0,10).last());
      }
      else {
        $(this).prevAll().slice(0,10).show();
        $(this).prevAll().slice(0,10).find('*').show();
        $(this).nextAll().slice(0,10).show();
        $(this).nextAll().slice(0,10).find('*').show();
        $('<hr class="temp"/>').insertAfter($(this).nextAll().slice(0,10).last());
      }
    });
    $('.textAnchor').hide();
    //$('.pageAnchor').show();
    //$('#midl').find('.pageAnchor').hide();
    //$(this).parents().prevAll('.pageAnchor').first().show(); // not working
    $('#midl').find('.greyedOut').hide();
    return null;
  });
  
  $('.explode').click(function(){
    $(this).hide();
    $(this).prevAll('.implode').show();
    $('#midl').find('span').show();
    $('#midl').find('.corr').hide();
    $('#midl').find('.textAnchor').show();
    $('#midl').find('.pageAnchor').show();
    $('.temp').remove();
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    var x = $('[data-edil="'+ $(this).prevAll('.indexHeadword').attr('data-uri') + '"]').first();
    $('#midl').animate({scrollTop: x.offset().top - 100},500);
    return null;
  });
  
  $('.chunk').hover(
    function(){ $(this).css('text-decoration', 'underline'); },
    function(){ $(this).css('text-decoration', 'inherit'); }
  );
  
  $('.chunk').click(function(){
    $('.chunk').css('background-color', 'inherit');
    $(this).css('background-color', 'yellow'); 
    var prevCorresp = ''; // better name?
    html = '<h1>';
    this2 = $(this).clone();
    $(this2).find('.lineBreak').remove();
    $(this2).find('.pageAnchor').remove();
    $(this2).find('.punct').remove();
    $(this2).find('[id]').each(function(){
      $(this).attr('id', 'xx-' + $(this).attr('id'));
    });
    html += '<span class="syntagm">' + $(this2).html() + '</span>';
    //html = html.replace(/\n/g,'');
    html += '</h1><ul>';
    html += makeSyntax($(this),false);
    html += '</ul>';
    if ($(this).find('.expansion, .ligature').length > 0) {
      html += 'Contains, or is formed from, the following scribal abbreviations and/or ligatures:<ul>';
      $(this).find('.expansion, .ligature').each(function() {
        var corresp;
        if (corresp = $(this).attr('data-corresp')) {
          if (corresp === prevCorresp) {
            return true;    //SB: prevents >1 example being shown for elements with the same corresp; MM: not sure about any of this
          } else { prevCorresp = corresp; }
        } else { prevCorresp = ''; }
        cert = $(this).attr('data-cert');
        var xmlId = $(this).attr('data-glyphref');
        var elementId = $(this).attr('id');
        //$.ajaxSetup({async: false});
        $.getJSON('ajax.php?action=getGlyph&xmlId=' + xmlId, function (g) {
          txt = '<li class="glyphItem"><a href="' + g.corresp + '" target="_new" data-src="' + g.id + '">' + g.name;
          txt = txt + '</a>: ' + g.note + ' (' + cert + ' certainty) <a style="font-size: small;" href="#" class="glyphShow" data-id="' + elementId + '" data-corresp="'+prevCorresp+'">[show]</a></li>';
          html += txt;
        });
      });
      html += '</ul>';
    }
    html += getDamage($(this));
    html +=getDeletions($(this));
    html += getAdditions($(this));
    $('#rhs').html(html);
    $('.glyphShow').hover( //maybe move up to just after the ajax call?
      function(){
        $('#'+$(this).attr('data-id')).css('text-decoration', 'underline');
        $('#xx-'+$(this).attr('data-id')).css('background-color', 'yellow');
        $('.corresp-'+$(this).attr('data-corresp')).css({'text-decoration': 'underline', 'background-color': 'yellow'});
      },
      function() {
        $('#'+$(this).attr('data-id')).css('text-decoration', 'inherit');
        $('#xx-'+$(this).attr('data-id')).css('background-color', 'inherit');
        $('.corresp-'+$(this).attr('data-corresp')).css({'text-decoration': 'inherit', 'background-color': 'inherit'});
      }
    );
  });
  
});

function makeSyntax(span, rec) {
  html = '';
  if (rec) {
    html += $(span).text().replace(/[\+\?\:]/g, '');
    html += '<ul>';
  }
  if ($(span).children('.syntagm').length < 2) { html += handInfo(span); } // syntactically simple? maybe some bugs here?
  if ($(span).hasClass('name')) { html += onomastics(span); }
  if ($(span).attr('xml:lang') || ($(span).hasClass('name') && $(span).children('.word').attr('xml:lang')==1 && $(span).children('.word').attr('xml:lang'))) {
    html += '<li>is not a Gaelic word: '; // maybe simplify above line?
    if ($(span).attr('xml:lang')) { html += decode($(span).attr('xml:lang')); }
    else { html += decode($(span).children('.word').attr('xml:lang')); }
    html += '</li>';
  }
  else {
    html += partOfSpeech(span); 
    html += structure(span); 
    if ($(span).attr('data-headword')) {
      html += '<li>is a form of the headword ';
      html += '<a href="' + $(span).attr('data-edil') + '" target="_new">' + $(span).attr('data-headword') + '</a>';
      if ($(span).attr('data-edil').indexOf('dil.ie')>0) { html += ' (eDIL)'; }
      else if ($(span).attr('data-edil').indexOf('faclair.com')>0) { html += ' (Dwelly)'; }
      $.ajaxSetup({async: false});
      $.getJSON('ajax.php?action=getDwelly&edil=' + $(span).attr('data-edil'), function (g) {
        if (g.hw != '') { html += ', <a href="' + g.url + '" target="_new">' + g.hw + '</a> (Dwelly)'; }
      });
      html += '</li>';
    }
    else if ($(span).hasClass('name') && $(span).children('.word').length==1 && $(span).children('.word').attr('data-headword')) { // add extra headwords here too?
                html += '<li>is a form of the headword ';
                html += '<a href="' + $(span).children('.word').attr('data-edil') + '" target="_new">' + $(span).children('.word').attr('data-headword') + '</a>';
                if ($(span).children('.word').attr('data-edil').indexOf('dil.ie')>0) { html += ' (eDIL)'; }
                else if ($(span).children('.word').attr('data-edil').indexOf('faclair.com')>0) {
                    html += ' (Dwelly)';
                }
                $.ajaxSetup({async: false});
                $.getJSON('ajax.php?action=getDwelly&edil=' + $(span).children('.word').attr('data-edil'), function (g) {
                    if (g.hw != '') { html += ', <a href="' + g.url + '" target="_new">' + g.hw + '</a> (Dwelly)'; }
                });
                html += '</li>';
    }  
    if($(span).attr('data-lemmasl')) {
      html += '<li>appears in the HDSG/RB collection of headwords: <a href="' + $(span).attr('data-slipref') + '" target="_new">' + $(span).attr('data-lemmasl') + '</a></li>';
    }
  }
  html += getCorrection(span);
  if (rec) {
    html += '</ul>';
  }
  return html;

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

function handInfo(span) {
  html = '';
  var h;
  h = $(span).prevAll('.handshift').first().attr('data-hand');
  if (typeof h == 'undefined') { // handshift is not a sibling but rather an auntie
    h = $(span).parents().prevAll('.handshift').first().attr('data-hand');
  }
  if (typeof h == 'undefined') {
    h = $(span).parentsUntil('.text').parent().attr('data-hand'); // this will break!
  }
  html += getHandInfoDiv(h);
  html += '<li>was written by ';
  html += '<a href="#" data-toggle="modal" data-target="#handInfo_' + h +'">' + getHandName(h) + '</a>';
  html += '</li>';
  //a handShift within a word ?????
  /* 
  $(span).find('.handShift').each(function() {
    html += '<li>contains a hand shift to ';
    html += '<a href="#" onclick="$(\'#handInfo_'+ $(this).attr('data-hand') + '\').bPopup();">' + getHandInfo($(this).attr('data-hand')) + '</a>';
    html += '</li>';
  });
  */
  return html;  
}

function getHandName(handId) {
  var name = '';
  $.getJSON('ajax.php?action=getHandInfo&hand=' + handId, function (g) {
    if (g.forename + g.surname != '') { name = g.forename + ' ' + g.surname; } 
    else { name = 'Anonymous (' + handId + ')'; }
  });
  return name;
}

/*
  Uses an AJAX request to fetch the detailed hand info for a hand IDs
  Returns an HTML formatted string
*/
function getHandInfoDiv(h) {
  var html = '';
  $.ajaxSetup({async: false});
  html += '<div class="modal" tabindex="-1" role="dialog" id="handInfo_' + h + '">\n' +
            '  <div class="modal-dialog" role="document">\n' +
            '    <div class="modal-content">\n' +
            '      <div class="modal-body">\n';
  $.getJSON('ajax.php?action=getHandInfo&hand=' + h, function (g) {
    html += '<p>';
    if (g.forename + g.surname != '') {
      html += g.forename + ' ' + g.surname;
    } else {
      html += 'Anonymous (' + h + ')';
    }
    html += '</p><p>';
    html += g.from;
    if (g.min != g.from) {
      html += '/' + g.min;
    }
    html += ' – ' + g.to;
    if (g.max != g.to) {
      html += '/' + g.max;
    }
    html += '</p><p>'
    html += g.region;
    html += '</p>';
    for (j = 0; j < g.notes.length; j++) {
      var xml = $.parseXML(g.notes[j]);
      $xml = $(xml);
      $xml.find('p').each(function (index, element) {
        $(element).find('hi').each(function () {
          $(this).replaceWith(function () {
            return $('<em />', {html: $(this).html()});
          });
        });
        html += '<p>' + $(element).html() + '</p>';
      });
    }
  });
  html += '      </div>\n' +
            '      <div class="modal-footer">\n' +
            '        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>\n' +
            '      </div>\n' +
            '    </div>\n' +
            '  </div>\n' +
            '</div>' +
        '</div>';
  return html;
}

function onomastics(span){
    html = '<li>is ';
    type = $(span).attr('data-nametype');
    if (type=='personal') html += 'an anthroponym';
    else if (type=='place') { 
      html += 'a toponym';
      if ($(span).attr('data-corresp') != '') {
        html += ' (further information can be found <a href="' + $(span).attr('data-corresp') + '" target="_blank">here</a>)';
      }
    }
    else if (type=='population') html += 'a demonym';
    else html += 'a name';
    return html + '</li>';
}

function decode(lang) {
  switch (lang) { case 'la': return 'Latin'; case 'sco': return 'Scots'; case "gk": return 'Greek'; case 'hbo': return 'Ancient Hebrew';
                  case 'jpa': return 'Aramaic'; case 'en': return 'English'; case 'und': return 'unknown';
                  default:return lang;
  }
}

function partOfSpeech(span) {
    html = '';
    if ($(span).attr('data-pos')) html += '<li>is a ' + $(span).attr('data-pos') + '</li>';
    else if ($(span).hasClass('name') && $(span).children('.word').length==1 && $(span).children('.word').children('.word').length==0) html += '<li>is a ' + $(span).children('.word').attr('data-pos') + '</li>';
    return html; // maybe simplify above line?
}

function structure(span) {
  html = '';
  if ($(span).children('.syntagm').length > 1) {
    html += '<li>is a syntactically complex form containing the following elements:';
    html += '<ul>';
    $(span).children('.syntagm').each(function() {
      html = html + '<li>' + makeSyntax($(this),true) + '</li>';
    });
    html += '</ul>';
    html += '</li>';
  }
  else if ($(span).children('.syntagm').length==1 && $(span).children('.syntagm').children('.syntagm').length>0) {
           html += '<li>is a syntactically complex form containing the following elements:';
           html += '<ul>';
           $(span).children('.syntagm').children('.syntagm').each(function() {
             html = html + '<li>' + makeSyntax($(this),true) + '</li>';
           });
           html += '</ul>';
           html += '</li>';
  }
  else if ($(span).children('.insertion, .deletion').length>0) {
    html += '<li>is a syntactically complex form containing the following elements:';
    html += '<ul>';
    $(span).children('.syntagm').add($(span).children('.insertion').add($(span).children('.deletion')).children('.syntagm')).each(function() {
      html += '<li>' + makeSyntax($(this),true) + '</li>';
    });
    html += '</ul>';
    html += '</li>';
  }
  else html += '<li>is a syntactically simple form</li>';
  return html;
}

function getDamage(span) { // all this needs checked
  html2 = '<div>';
  if ($(span).find('.unclearDamage').length>0) { // simplify all this
    html2 += 'Contains the following damaged sections:<ul>';
    $(span).find('.unclearDamage').each(function() {
      html2 = html2 + '<li>[' + $(this).attr('data-add') + '] ';
      html2 = html2 + '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
      html2 += ' certainty)</li>';
    });
    html2 += '</ul>';
  }
        if ($(span).find('.unclearTextObscure').length>0) {
            html2 += 'Contains the following obscured sections:<ul>';
            $(span).find('.unclearTextObscure').each(function() {
                html2 = html2 + '<li>[' + $(this).text() + '] ';
                html2 = html2 + '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
                html2 += ' certainty)</li>';
            });
            html2 += '</ul>';
        }
        if ($(span).find('.unclearChar').length>0) {
            html2 += 'Contains the following unclear characters:<ul>';
            $(span).find('.unclearChar').each(function() {
                html2 = html2 + '<li>[' + $(this).text() + '] ';
                html2 = html2 + '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
                html2 += ' certainty)</li>';
            });
            html2 += '</ul>';
        }
        if ($(span).parents('.unclearTextObscure').length>0) {
            html2 += 'This is part of an obscured section.';
        }
        if ($(span).parents('.unclearInterpObscure').length>0) {
            html2 += 'This is part of a section whose interpretation is obscure.';
        }
        return html2 + '</div>';
}

function getDeletions(span) {
  html = '<div>';
  var x = $(span).find('.deletion'); // contains a deletion
  if (x.length>0) {
    html += 'Contains the following deletions:<ul>';
    x.each(function() {
      html += '<li>[' + $(this).text() + '] ';
      html += '(<a href="#" onclick="$(\'#handInfo_'+ $(this).attr('data-hand') + '\').bPopup();">' + getHandName($(this).attr('data-hand')) + '</a>)</li>';
    });
    html += '</ul>';
  }
  else {
    x = $(span).parents('.deletion');
    if (x.length>0) {
      html += 'Is part of the following deletion:<ul>';
      html += '<li>[' + x.text() + '] (';
      html += '<a href="#" onclick="$(\'#handInfo_'+ x.attr('data-hand') + '\').bPopup();">' + getHandName(x.attr('data-hand')) + '</a>';
      html += ')</li>';
      html += '</ul>';
    }
  }
  return html + '</div>';
}

function getAdditions(span) {
        html2 = '<div>';
        if ($(span).find('.insertion').length>0) {
            html2 += 'Contains the following insertions:<ul>';
            $(span).find('.insertion').each(function() {
                html2 = html2 + '<li>[' + $(this).text() + '] (';
                html2 += '<a href="#" onclick="$(\'#handInfo_'+ $(this).attr('data-hand') + '\').bPopup();">' + getHandName($(this).attr('data-hand')) + '</a>';
                html2 = html2 + ', '  + $(this).attr('data-place');
                html2 += ')</li>';
            });
            html2 += '</ul>';
        }
        else if ($(span).parents('.insertion').length>0) {
            html2 += 'Is part of the following insertion:<ul>';
            html2 = html2 + '<li>[' + $(span).parents('.insertion').text() + '] (';
            html2 += '<a href="#" onclick="$(\'#handInfo_'+ $(this).attr('data-hand') + '\').bPopup();">' + getHandName($(this).attr('data-hand')) + '</a>'; // what is 'this'?
            html2 = html2 + ', ' + $(span).parents('.insertion').attr('data-place');
            html2 += ')</li>';
            html2 += '</ul>';
        }
        return html2 + '</div>';
}

function getCorrection(span) {
  html = '';
  var x = $(span).parents('.choice');
  if(x.length > 0) {
    html += '<li>';
    html += 'Note that \'';
    html += x.children('.sic').text().replace(/[\+\?]/g, '');
    html += '\' should probably be read as \'';
    y = x.children('.corr');
    html += y.text().replace(/[\+\?]/g, '');
    html += '\' (' + y.attr('data-resp') + ').</li>';
  }
  else {
    x = $(span).find('.choice');
    if (x.length > 0) {
      html += '<li>';
      html += 'Note that \'';
      html += x.children('.sic').text().replace(/[\+\?]/g, '');
      html += '\' should probably be read as \'';
      y = x.children('.corr');
      html += y.text().replace(/[\+\?]/g, '');
      html += '\' (' + y.attr('data-resp') + ').</li>';
    }
  }
  return html;
}


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
    if ($('#midl').children('div').attr('data-diplo')=='yes') { $('.supplied').hide(); }
    $('.textAnchor').show();
    $('.pageAnchor').show();
    $('.indexHeadword').parent().css({'background-color': 'inherit'});
    $('.hwCount').hide();
    $('.implode').hide();
    $('.explode').hide();
    $('[data-lemmaRef="'+ $(this).attr('data-uri') + '"]').css({'color': 'orange', 'font-weight': 'bold'});
    $(this).parent().css('background-color', 'orange');
    $(this).nextAll('.hwCount').show();
    $(this).nextAll('.implode').show();
    var x = $('[data-lemmaRef="'+ $(this).attr('data-uri') + '"]').first();
    $('#midl').animate({scrollTop: x.offset().top - 100},500);
    return null;
  });

  $('.implode').click(function(){
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    $(this).hide();
    $(this).nextAll('.explode').show();
    $('#midl').find('span').hide();
    $('.temp').remove();
    $('[data-lemmaRef="'+ $(this).prevAll('.indexHeadword').attr('data-uri') + '"]').each(function(){
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
    if ($('#midl').children('div').attr('data-diplo')=='yes') { $('.supplied').hide(); }
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
    if ($('#midl').children('div').attr('data-diplo')=='yes') { $('.supplied').hide(); }
    $('#midl').find('.textAnchor').show();
    $('#midl').find('.pageAnchor').show();
    $('.temp').remove();
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    var x = $('[data-lemmaRef="'+ $(this).prevAll('.indexHeadword').attr('data-uri') + '"]').first();
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
    html = makeHeading($(this));
    html += '<ul class="rhs">' + makeSyntax($(this),false) + '</ul>';
    $('#rhs').html(html);
    $('.glyphShow').hover(
      function(){
        $('#'+$(this).attr('data-id')).css('text-decoration', 'underline');
        $('#xx-'+$(this).attr('data-id')).css('background-color', 'yellow');
        //$('.corresp-'+$(this).attr('data-corresp')).css({'text-decoration': 'underline', 'background-color': 'yellow'});
      },
      function() {
        $('#'+$(this).attr('data-id')).css('text-decoration', 'inherit');
        $('#xx-'+$(this).attr('data-id')).css('background-color', 'inherit');
        //$('.corresp-'+$(this).attr('data-corresp')).css({'text-decoration': 'inherit', 'background-color': 'inherit'});
      }
    );
  });
});

function makeHeading(span, rec) {
  html = '<h1>';
  clone = $(span).clone();
  $(clone).find('.lineBreak').remove();
  $(clone).find('.pageAnchor').remove();
  $(clone).find('.punct').remove();
  $(clone).find('[id]').each(function(){
    $(this).attr('id', 'xx-' + $(this).attr('id'));
  });
  $(clone).find('.supplied').css('display', 'inline');
  //$(clone).find('span:not(.deletion)').css('text-decoration', 'inherit');
  html += '<span class="syntagm">' + $(clone).html() + '</span>';
  return html + '</h1>';
}

function makeSyntax(span, rec) {
  html = '';
  if (rec) {
    html += '<strong class="syntagm" style="font-size: large;">' + $(span).text().replace(/[\+\?\:]/g, '') + '</strong>';
    html += '<ul class="rhs">';
  }
  if (span.hasClass('name')) { html += getOnomastics(span); }
  if (span.hasClass('word')) {
    html += handInfo(span); 
    html += getGlygatures(span);
    html += getCorrections(span);
    html += getSupplied(span);
    html += getLemmas(span);
    html += getDamage(span);
    html += getDeletions(span);
    html += getAdditions(span);
  }
  if ($(span).attr('xml:lang')) {
    html += '<li>is a ' + decodeLang($(span).attr('xml:lang')) + ' word</li>';
  }
  html += getPOS(span); 
  html += getStructure(span);
  if (rec) {
    html += '</ul>';
  }
  return html;
}

function getGlygatures(span) {
  html = '';
  var x = span.find('.expansion, .ligature');
  if (x.length > 0) {
    html += '<li>contains the following scribal abbreviations and ligatures:<ul class="rhs">';
    x.each(function() {
        /* DISCUSS WITH SB
        var corresp;
        if (corresp = $(span).attr('data-corresp')) {
          if (corresp === prevCorresp) {
            return true;    //SB: prevents >1 example being shown for elements with the same corresp; MM: not sure about any of this
          } else { prevCorresp = corresp; }
        } else { prevCorresp = ''; }
        */
      var id = $(this).attr('id');
      var c = $(this).attr('data-cert');
      $.ajaxSetup({async: false});
      $.getJSON('ajax.php?action=getGlyph&xmlId=' + $(this).attr('data-glyphref'), function (g) {
        li = '<li><a class="glyphShow" href="' + g.corresp + '" target="_new" data-src="' + g.id + '" data-id="' + id + '">' + g.name;
        li += '</a>: ' + g.note + ' (' + c + ' certainty)'; //<a style="font-size: small;" href="#" class="glyphShow" data-id="' + elementId + '" data-corresp="'+/*prevCorresp+*/'">[show]</a></li>';
        html += li + '</li>';
      });
    });
    html += '</ul></li>';
  }
  return html;
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
  $.ajaxSetup({async: false});
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

function getOnomastics(span){
  html = '<li>is ';
  type = $(span).attr('data-nametype');
  if (type=='personal') { html += 'an anthroponym'; }
  else if (type=='place') { 
    html += 'a toponym';
    if ($(span).attr('data-corresp') != '') {
      html += ' (<a href="' + $(span).attr('data-corresp') + '" target="_blank">info</a>)';
    }
  }
  else if (type=='population') { html += 'a demonym'; }
  else { html += 'a name'; }
  return html + '</li>';
}

function decodeLang(lang) {
  switch (lang) { case 'la': return 'Latin'; case 'sco': return 'Scots'; case "gk": return 'Greek'; case 'hbo': return 'Ancient Hebrew';
                  case 'jpa': return 'Aramaic'; case 'en': return 'English'; case 'und': return 'unknown';
                  default:return lang;
  }
}

function getPOS(span) {
  html = '';
  if ($(span).attr('data-pos')) { html += '<li>is a ' + $(span).attr('data-pos') + '</li>'; }
  return html;
}

function getStructure(span) {
  html = '';
  if (!span.hasClass('word')) {
    html += '<li>is a syntactically complex form containing:';
    html += '<ul class="rhs">';
    span.find('.word').each(function() {
      html = html + '<li>' + makeSyntax($(this),true) + '</li>';
    });
    html += '</ul>';
    html += '</li>';
  }
  /* LEAVE THIS UNTIL WE ARE CLEAR IT IS NOT NEEDED
  else if ($(span).children('.syntagm').length==1 && $(span).children('.syntagm').children('.syntagm').length>0) {
           html += '<li>is a syntactically complex form containing the following elements:';
           html += '<ul class="rhs">';
           $(span).children('.syntagm').children('.syntagm').each(function() {
             html = html + '<li>' + makeSyntax($(this),true) + '</li>';
           });
           html += '</ul>';
           html += '</li>';
  }
  else if ($(span).children('.insertion, .deletion').length>0) {
    html += '<li>is a syntactically complex form containing the following elements:';
    html += '<ul class="rhs">';
    $(span).children('.syntagm').add($(span).children('.insertion').add($(span).children('.deletion')).children('.syntagm')).each(function() {
      html += '<li>' + makeSyntax($(this),true) + '</li>';
    });
    html += '</ul>';
    html += '</li>';
  }
  */
  else html += '<li>is a syntactically simple form</li>';
  return html;
}

function getLemmas(span) {
  var html = '';
  var x = span.attr('data-lemmaRef');
  if (x && span.attr('data-lemmaRef').indexOf('dil.ie')>0) { 
    if (span.attr('data-source')) {
      html += '<li>eDIL: ' + span.attr('data-lemma') + ' (from <a href="' + span.attr('data-lemmaRef') + '" target="_new">' + span.attr('data-source') + '</a>)</li>';
    }
    else {
      html += '<li>eDIL: <a href="' + span.attr('data-lemmaRef') + '" target="_new">' + span.attr('data-lemma') + '</a></li>';
    }
    $.getJSON('ajax.php?action=getDwelly&edil=' + span.attr('data-lemmaRef'), function (g) {
        if (g.hw != '') { html += '<li>Dwelly: <a href="' + g.url + '" target="_new">' + g.hw + '</a>'; }
    });
  }
  else if (x && span.attr('data-lemmaRef').indexOf('faclair.com')>0) {
    html += '<li>Dwelly: <a href="' + $(span).attr('data-lemmaRef') + '" target="_new">' + span.attr('data-lemma') + '</a></li>';
  }
  else if (x && span.attr('data-lemmaRef').indexOf('teanglann.ie')>0) {
    html += '<li>Teangleann: <a href="' + $(span).attr('data-lemmaRef') + '" target="_new">' + span.attr('data-lemma') + '</a></li>';
  }
  else if (x && span.attr('data-lemmaRef').indexOf('dasg.ac.uk')>0) {
    html += '<li>HDSG slips: <a href="' + $(span).attr('data-lemmaRef') + '" target="_new">' + span.attr('data-lemma') + '</a></li>';
  }
  if (span.attr('data-lemmaSl')) {
      html += '<li>HDSG slips: <a href="' + span.attr('data-slipRef') + '" target="_new">' + span.attr('data-lemmaSl') + '</a></li>';
  }
  return html;
}

function getDamage(span) { // all this needs checked
  html = '';
  var x = span.find('.unclearDamage');
  if (x.length>0) { // simplify all this  
    html += '<li>Contains the following damaged sections:<ul class="rhs">';
    x.each(function() {
      html += '<li>[' + $(this).html() + '] ';
      html += '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
      html += ' certainty)</li>';
    });
    html += '</ul></li>';
  }
        if ($(span).find('.unclearTextObscure').length>0) {
            html += 'Contains the following obscured sections:<ul class="rhs">';
            $(span).find('.unclearTextObscure').each(function() {
                html = html + '<li>[' + $(this).text() + '] ';
                html = html + '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
                html += ' certainty)</li>';
            });
            html += '</ul>';
        }
        if ($(span).find('.unclearChar').length>0) {
            html += 'Contains the following unclear characters:<ul class="rhs">';
            $(span).find('.unclearChar').each(function() {
                html = html + '<li>[' + $(this).text() + '] ';
                html = html + '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
                html += ' certainty)</li>';
            });
            html += '</ul>';
        }
        if ($(span).parents('.unclearTextObscure').length>0) {
            html += 'This is part of an obscured section.';
        }
        if ($(span).parents('.unclearInterpObscure').length>0) {
            html += 'This is part of a section whose interpretation is obscure.';
        }
  return html;
}

function getDeletions(span) {
  html = '';
  var x = $(span).find('.deletion'); // contains a deletion
  if (x.length>0) {
    html += '<li>contains the following deletions:<ul class="rhs">';
    x.each(function() {
      html += '<li>[' + $(this).text() + '] ';
      html += '(<a href="#" onclick="$(\'#handInfo_'+ $(this).attr('data-hand') + '\').bPopup();">' + getHandName($(this).attr('data-hand')) + '</a>)</li>';
    });
    html += '</ul></li>';
  }
  else {
    x = $(span).parents('.deletion');
    if (x.length>0) {
      html += '<li>is part of the following deletion:<ul class="rhs">';
      html += '<li>[' + x.text() + '] (';
      html += '<a href="#" onclick="$(\'#handInfo_'+ x.attr('data-hand') + '\').bPopup();">' + getHandName(x.attr('data-hand')) + '</a>';
      html += ')</li>';
      html += '</ul></li>';
    }
  }
  return html;
}

function getAdditions(span) {
  html = '';
  var x = span.find('.insertion')
  if (x.length>0) {
    html += '<li>contains the following insertions:<ul class="rhs">';
    x.each(function() {
      html += '<li>[' + $(this).text() + '] (';
      html += '<a href="#" onclick="$(\'#handInfo_'+ $(this).attr('data-hand') + '\').bPopup();">' + getHandName($(this).attr('data-hand')) + '</a>';
      html += ', '  + $(this).attr('data-place');
      html += ')</li>';
    });
    html += '</ul></li>';
  }
  else {
    x = $(span).parents('.insertion');
    if (x.length>0) {
      html += '<li>is part of the following insertion:<ul class="rhs">';
      html += '<li>[' + x.text() + '] (';
      html += '<a href="#" onclick="$(\'#handInfo_'+ x.attr('data-hand') + '\').bPopup();">' + getHandName(x.attr('data-hand')) + '</a>'; // what is 'this'?
      html += ', ' + x.attr('data-place');
      html += ')</li>';
      html += '</ul></li>';
    }
  }
  return html;
}

function getCorrections(span) {
  html = '';
  var x = $(span).parents('.sic');
  if(x.length == 0) { x = $(span).find('.sic'); }
  if (x.length > 0) {
    html += '<li>editorial emendation – \'';
    html += x.text().replace(/[\+\?]/g, '');
    html += '\' '; 
    if ($('#midl').children('div').attr('data-diplo')=='yes') { html += 'to'; }
    else { html += 'from original'; }
    html += ' \'';
    html+= x.attr('data-alt');
    //html += y.text().replace(/[\+\?]/g, '');
    html += '\' (' + x.attr('data-resp') + ')</li>';
  }
  return html;
}

function getSupplied(span) {
  html = '';
  var x = $(span).find('.supplied'); // contains a supplied element
  if (x.length>0) {
    html += '<li>contains text supplied by an editor:<ul class="rhs">';
    x.each(function() {
      html += '<li>';
      html += $(this).text();
      html += ' (' + $(this).attr('data-resp') + ')</li>';
    });
    html += '</ul></li>';
  }
  else {
    x = $(span).parents('.supplied'); // part of a supplied element
    if (x.length>0) {
      html += '<li>has been supplied by an editor (';
      html += x.attr('data-resp');
      html += ')</li>';
    }
  }
  return html;
}

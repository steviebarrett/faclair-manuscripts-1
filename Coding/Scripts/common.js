/* 
This script is called by viewTranscription.php
It contains event handlers relevant to that page as a whole, and to both MS views.
*/

$(function() {
  
  $('#numbersToggle').click(function() {
    var x = $('#midl');
    x.find('.pageAnchor, .pageAnchorHR, .handShift').toggle();
    var b = x.children('div').attr('data-diplo');
    if (b=='yes') {
      x.find('.lineBreak').toggleClass('lineBreakDiplo');
      x.find('.expansion').toggle();
      x.children('div').attr('data-diplo','super');
    }
    else if (b=='super') {
      x.find('.lineBreak').toggleClass('lineBreakDiplo');
      x.children('div').attr('data-diplo','yes');
    }
    else {
      x.find('.lineBreak').toggleClass('lineBreakSemi');
    }
    $('.gapDamageCharsDiplo, .gapDamageCharsSuperDiplo').toggle();
  });
  
  $('.page').click(function(e){
    e.stopImmediatePropagation();   //prevents outer link (e.g. word across pages) from overriding this one
    //$('.chunk, .gapDamageDiplo').css('background-color', 'inherit');
    var html = '';
    var url = $(this).attr('data-facs');
    var regex = /^((http[s]?|ftp):\/)?\/?([^:\/\s]+)((\/\w+)*\/)([\w\-\.]+[^#?\s]+)(.*)?(#[\w\-]+)?$/
    var urlElems = regex.exec(url);
    if (urlElems[3] == 'cudl.lib.cam.ac.uk') {  //complex case: write the viewer code
      var paramElems = urlElems[6].split('/');
      var mssNo = paramElems[0];
      var pageNo = paramElems[1];
      html = "<div style='position: relative; width: 100%; padding-bottom: 80%;'>";
      html += "<iframe type='text/html' width='600' height='410' style='position: absolute; width: 100%; height: 100%;'";
      html += " src='https://cudl.lib.cam.ac.uk/embed/#item="+mssNo+"&page="+pageNo+"&hide-info=true'";
      html += " frameborder='0' allowfullscreen='' onmousewheel=''></iframe></div>";
    } 
    else {    //simple case: just stick the url in an image tag
      html = '<img width="100%" src="';
      html += url;
      html += '"/>'
    }
    $('#rhs').html(html);
  });
    
  /* Show/hide marginal notes. Added by SB. MM: might be interfered with by hw search now. */
  $('.marginalNoteLink').on('click', function() {
    var id = $(this).attr('data-id').replace(/\./g, '\\.');
    $('#'+id).toggle();
  });
  
  $('.indexHeadword').click(function(){ // called whenever a new headword is selected
    // reset midl and rhs
    $('#midl').animate({scrollTop: 0},0);
    $('#midl').find('.syntagm').css({'background-color': 'inherit', 'color': 'inherit', 'font-weight': 'normal'});
    $('#midl').find('.gapDamageCharsDiplo').css('color', 'gray');
    $('#midl').find('.gapDamageCharsSuperDiplo').css({'color': 'lightgray', 'background-color': 'lightgray'});
    $('.temp').remove(); // remove all temporary hr elements
    $('#midl').find('span', '.textAnchor', '.pageAnchor').show();
    $('#midl').find('.suppliedDiplo').hide();
    if ($('#midl').children('div').attr('data-diplo')=='super') { 
      $('#midl').find('.gapDamageCharsDiplo').hide(); 
      $('.pageAnchor').hide();
      //$('.pageAnchorHR').toggle();
      $('.handshift').hide();
    }
    else { $('#midl').find('.gapDamageCharsSuperDiplo').hide(); }
    //$('#rhs').html('');
    // reset lhs
    $('.indexHeadword').parent().css({'background-color': 'inherit'});
    $('.hwCount').hide();
    $('.implode').hide();
    $('.explode').hide();
    // do stuff
    $('#midl').find('[data-lemmaRef="'+ $(this).attr('data-lemmaRef') + '"]').css({'color': 'orange', 'font-weight': 'bold'});
    $(this).parent().css('background-color', 'orange');
    $(this).nextAll('.hwCount').show();
    $(this).nextAll('.implode').show();
    var x = $('#midl').find('[data-lemmaRef="'+ $(this).attr('data-lemmaRef') + '"]').first();
    $('#midl').animate({scrollTop: x.offset().top - 180},500);
    return null;
  });

  $('.implode').click(function(){
    //reset midl
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    $('.temp').remove();
    // do stuff
    $(this).hide();
    $(this).nextAll('.explode').show();
    $('#midl').find('span').hide();
    $('#midl').find('[data-lemmaRef="'+ $(this).prevAll('.indexHeadword').attr('data-lemmaRef') + '"]').each(function(){
      $(this).show();
      $(this).find('span').show();
      var x = $(this).parents('span');
      if (x.length>0) {
        x.show(); x.find('span').show();
        var y = x.prevAll().slice(0,10);
        y.show(); y.find('*').show();
        y = x.nextAll().slice(0,10);
        y.show(); y.find('*').show();
        $('<hr class="temp"/>').insertAfter(y.last());
      }
      else {
        var y = $(this).prevAll().slice(0,10);
        y.show(); y.find('*').show();
        y = $(this).nextAll().slice(0,10);
        y.show(); y.find('*').show();
        $('<hr class="temp"/>').insertAfter(y.last());
      }
    });
    $('.textAnchor').hide();
    $('#midl').find('.suppliedDiplo').hide();
    if ($('#midl').children('div').attr('data-diplo')=='super') { $('#midl').find('.gapDamageCharsDiplo').hide(); }
    else { $('#midl').find('.gapDamageCharsSuperDiplo').hide(); }
    //$('.pageAnchor').show();
    //$('#midl').find('.pageAnchor').hide();
    //$(this).parents().prevAll('.pageAnchor').first().show(); // not working
    //$('#midl').find('.greyedOut').hide();
    return null;
  });
  
  $('.explode').click(function(){
    $(this).hide();
    $(this).prevAll('.implode').show();
    $('#midl').find('span').show();
    $('#midl').find('.suppliedDiplo').hide();
    if ($('#midl').children('div').attr('data-diplo')=='super') { $('#midl').find('.gapDamageCharsDiplo').hide(); }
    else { $('#midl').find('.gapDamageCharsSuperDiplo').hide(); }
    $('#midl').find('.textAnchor').show();
    $('#midl').find('.pageAnchor').show();
    $('.temp').remove();
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    var x = $('#midl').find('[data-lemmaRef="'+ $(this).prevAll('.indexHeadword').attr('data-lemmaRef') + '"]').first();
    $('#midl').animate({scrollTop: x.offset().top - 100},500);
    return null;
  });
  
  $('.chunk').hover(
    function(){ $(this).css('text-decoration', 'underline'); },
    function(){ $(this).css('text-decoration', 'inherit'); }
  );
  
  $('.chunk').click(function(){
    $('.selected').removeClass('selected');
    $('.chunk').css('background-color', 'inherit');
    $(this).css('background-color', 'yellow'); 
    $(this).addClass('selected');
    var prevCorresp = ''; // better name?
    html = '<h1>' + makeHeading($(this)) + '</h1>';
    html += '<ul class="rhs">' + makeSyntax($(this),false) + '</ul>';
    html += '<a href="#" id="saveSlip">[save]</a>';
    $('#rhs').html(html);
    $('#rhs').css('font-size', 'small');
    $('.glyphShow').hover(
      function(){
        $('#'+$(this).attr('data-id')).css('text-decoration', 'underline');
        $('#xx-'+$(this).attr('data-id')).css('background-color', 'yellow');
        $('#yy-'+$(this).attr('data-id')).css('background-color', 'yellow');
        //$('.corresp-'+$(this).attr('data-corresp')).css({'text-decoration': 'underline', 'background-color': 'yellow'});
      },
      function() {
        $('#'+$(this).attr('data-id')).css('text-decoration', 'inherit');
        $('#xx-'+$(this).attr('data-id')).css('background-color', 'inherit');
        $('#yy-'+$(this).attr('data-id')).css('background-color', 'inherit');
        //$('.corresp-'+$(this).attr('data-corresp')).css({'text-decoration': 'inherit', 'background-color': 'inherit'});
      }
    );
    $('.headwordSearch').click(function() {
      var x = $('.indexHeadword[data-lemmaRef="' + $(this).attr('data-lemmaRef') + '"]');
      setTimeout(function(){x.trigger('click')}, 100);  //Giving the 'click' some time to process
      var y = $('#lhs');
      y.animate({scrollTop: 0},0);
      y.animate({scrollTop: x.offset().top - 300},500); // NOT WORKING CONSISTENTLY
    });
    $('#saveSlip').click(function() {
      var html = '<tr><td>';
      var x = $('.selected');
      html += x.parents('[data-docid]').first().attr('data-docid') + '.';
      var p = x.prevAll('.pageAnchor').first();
      html += p.attr('data-n') + '.';
      var l = x.prevAll('.lineBreak').first();
      html += l.attr('data-number');
      html += '</td><td>'; // START HERE
      html += x.prevAll().slice(0,3).text() + ' '; 
      html += x.text() + ' ';
      html += x.nextAll().slice(0,3).text();
      html += '</td><td>';
      var h;
      h = x.prevAll('.handshift').first().attr('data-hand');
      if (typeof h == 'undefined') { // handshift is not a sibling but rather an auntie of some type
        h = x.parent().prevAll('.handshift').first().attr('data-hand');
      }
      if (typeof h == 'undefined') { // handshift is not a sibling or a first generation but rather a great auntie of some type
        h = x.parent().parent().prevAll('.handshift').first().attr('data-hand');
      }
      html += getHandName(h);
      html += '</td><td>';
      x.find('[data-lemma]').each(function(){
        html += $(this).attr('data-lemma') + ' ';
      });
      html += '</td></tr>';
      $('#basket').children('tbody').append(html);
      alert('added to basket');
      return null;
    });
  });
  
  
  
});

function makeHeading(span, rec) {
  html = '';
  var simplex = span.find('.word').length == 0;
  if (simplex && span.attr('data-lemmaRef')) { 
    html += '<a href="#" class="headwordSearch" data-lemmaRef="'; 
    html += span.attr('data-lemmaRef');
    html += '">'
  }
  clone = span.clone();
  clone.find('.lineBreak, .pageAnchor, .punct, .handshift').remove();
  clone.find('[id]').each(function(){
    if (rec) { $(this).attr('id', 'yy-' + $(this).attr('id')); }
    else { $(this).attr('id', 'xx-' + $(this).attr('id')); }
  });
  clone.find('.suppliedDiplo').css('display', 'inline');
  if (!rec) {
    clone.find('span').css({'color': 'inherit', 'font-weight': 'normal'});
  }
  html += '<span class="syntagm">' + clone.html() + '</span>';
  if (simplex) { html += '</a>'; }
  return html;
}

function makeSyntax(span, rec) {
  html = '';
  if (rec) {
    html += '<h4>' + makeHeading(span,true) + '</h4>';
    html += '<ul class="rhs">';
  }
  if (span.hasClass('name')) { html += getOnomastics(span); }
  if (span.hasClass('word')) {
    html += getHandInfo(span); 
    html += getGlygatures(span);
    html += getCorrections(span);
    html += getSupplied(span);
    html += getLemmas(span);
    html += getDamage(span);
    html += getDeletions(span);
    html += getAdditions(span);
  }
  if ($(span).attr('xml:lang')) {
    html += '<li>language: ' + decodeLang($(span).attr('xml:lang')) + '</li>';
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
    html += '<li>scribal abbreviations and ligatures:<ul class="rhs">';
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

function getHandInfo(span) {
  html = '';
  var h = searchBackwards(span,'handshift').attr('data-hand');
  html += getHandInfoDiv(h);
  html += '<li>scribe: ';
  html += '<a href="#" data-toggle="modal" data-target="#handInfo_' + h +'">' + getHandName(h) + '</a>'; // are two ajax calls necessary?
  span.find('.handshift').each(function() {
    hh = $(this).attr('data-hand');
    html += getHandInfoDiv(hh);
    html += ', ';
    html += '<a href="#" data-toggle="modal" data-target="#handInfo_' + hh +'">' + getHandName(hh) + '</a>';
  });
  html += '</li>';
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

function searchBackwards(span,c) { // depth-first
  var out;
  var jqs = span.prevAll();
  jqs.each(function(){
    if ($(this).hasClass(c)) { 
      out = $(this);
      return false;
    }
    var y = $(this).find('.'+c); 
    if (y.length>0) {
      out = y.last();
      return false;
    }
  });
  if (typeof out == 'undefined' && span.parent()) {
    return searchBackwards(span.parent(),c);
  }
  return out;
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

function getDamage(span) {
  html = '';
  var x = span.find('.unclearDamageDiplo, .unclearDamageSemi');
  if (x.length>0) { 
    html += '<li>damaged sections:<ul class="rhs">';
    x.each(function() {
      html += '<li>[' + $(this).html() + '] ';
      html += '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
      html += ' certainty)</li>';
    });
    html += '</ul></li>';
  }
  x = span.find('.unclearTextObscureDiplo, .unclearTextObscureSemi');
  if (x.length>0) {
    html += '<li>obscured sections:<ul class="rhs">';
    x.each(function() {
      html += '<li>[' + $(this).text() + '] ';
      html += '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
      html += ' certainty)</li>';
    });
    html += '</ul></li>';
  }
  x = span.find('.unclearCharDiplo, .unclearCharSemi');
  if (x.length>0) {
    html += '<li>unclear characters:<ul class="rhs">';
    x.each(function() {
      html += '<li>[' + $(this).text() + '] ';
      html += '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
      html += ' certainty)</li>';
    });
    html += '</ul></li>';
  }
  x = span.parents('.unclearTextObscureDiplo, .unclearTextObscureSemi');
  if (x.length>0) {
    html += '<li>part of an obscured section (' + x.first().attr('data-resp') + ', ' + x.first().attr('data-cert') + ' certainty)</li>';
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
  var x = $(span).find('.suppliedDiplo, .suppliedSemi'); // contains a supplied element
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
    x = $(span).parents('.suppliedDiplo, .suppliedSemi'); // part of a supplied element
    if (x.length>0) {
      html += '<li>has been supplied by an editor (';
      html += x.attr('data-resp');
      html += ')</li>';
    }
  }
  return html;
}

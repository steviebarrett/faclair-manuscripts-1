/* 
This script is called by viewTranscription.php
It contains event handlers relevant to that page as a whole, and to both MS views.
*/

$(function() {

  $('#numbersToggle').click(function() {
    var x = $('#midl');
    x.find('.pageBreak, .pageBreakSuper, .columnBreak, .handShift').toggle();
    var b = $('body').attr('data-ed');
    if (b=='diplo' || b=='both') {
      x.find('.lineBreak').toggleClass('lineBreakDiplo');
      //x.find('.expansion').toggle();
      //$('body').attr('data-ed','super');
      //x.children('div').attr('data-diplo','super');
    }
    else {
      x.find('.lineBreak').toggleClass('lineBreakSemi');
      //x.children('div').attr('data-diplo','yes');
    }
    $('.gapDamageCharsDiplo, .gapDamageCharsSuperDiplo, .unclearDamageDiplo, .unclearDamageSuperDiplo').toggle();
  });
  
  $('#commentsToggle').click(function() {
    var docid = 'T' + $('#docid').val();   //the MS ID
    $('#midl').find('.addComment').toggle();
    if ($('.addComment').is(':visible')) {
      $.getJSON('ajax.php?action=getPopulatedSections&docid='+docid, function(data) { // MAYBE START HERE?
        $.each(data, function(k, v) {
          $.each(v, function (key, val) {
            var section = val.section;
            var sectionId = val.section_id;
            sectionId = sectionId.replace(/\./g, '\\.');
            $('button.viewComment[data-s='+section+'][data-n='+sectionId+']').show();
            //remove greyedOut class if there is a non-deleted comment here
            if (val.deleted == "0") {
              $('button.viewComment[data-s='+section+'][data-n='+sectionId+']').removeClass('greyedOut');
            }
          });
        });
      });
    } else {
      $('.viewComment').hide();
    }
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
      $('#rhs').html(html);
    }
    else {    //simple case: just stick the url in an image tag for image viewer
      $('#msImage').attr('src', url);
      $('#msImage').show();
    }
  });
    
  /* Show/hide marginal notes. Added by SB. MM: might be interfered with by hw search now. */
  $('.marginalNoteLink').on('click', function() {
    var id = $(this).attr('data-id').replace(/\./g, '\\.');
    $('#'+id).toggle();
  });
  
  $('.indexHeadword').click(function(){ // called whenever a new headword is selected
    // reset midl
    var m = $('#midl');
    m.animate({scrollTop: 0},0);
    m.find('.syntagm').css({'background-color': 'inherit', 'color': 'inherit', 'font-weight': 'normal'});
    m.find('.gapDamageCharsDiplo, .unclearDamageDiplo').css('color', 'gray');
    m.find('.gapDamageCharsSuperDiplo, .unclearDamageSuperDiplo').css({'color': 'lightgray', 'background-color': 'lightgray'});
    m.find('.temp').remove(); // remove all temporary hr elements
    m.find('span,.textAnchor,.pageBreak,.columnBreak').show();
    m.find('.suppliedDiplo').hide();
    if (m.children('div').attr('data-diplo')=='super') { // ??????
      m.find('.gapDamageCharsDiplo').hide(); 
      $('.pageBreak,.columnBreak').hide();
      //$('.pageBreakSuper').toggle();
      $('.handShift').hide();
    }
    else { m.find('.gapDamageCharsSuperDiplo, .unclearDamageSuperDiplo').hide(); }
    // reset lhs
    $('.indexHeadword').parent().css({'background-color': 'inherit'});
    $('.hwCount,.implode,.explode,.reset').hide();
    // do stuff
    m.find('[data-lemmaRef="'+ $(this).attr('data-lemmaRef') + '"]').css({'color': 'orange', 'font-weight': 'bold'});
    $(this).parent().css('background-color', 'orange');
    $(this).nextAll('.hwCount,.implode,.reset').show();
    var x = m.find('[data-lemmaRef="'+ $(this).attr('data-lemmaRef') + '"]').first();
    m.animate({scrollTop: x.offset().top - 180},500);
    return null;
  });

  $('.implode').click(function(){
    //reset midl
    var x = $('#midl');
    x.animate({scrollTop: 0},0); // move middle back to top
    $('.temp').remove();
    // do stuff
    $(this).hide();
    $(this).nextAll('.explode').show();
    x.find('span').hide();
    x.find('[data-lemmaRef="'+ $(this).prevAll('.indexHeadword').attr('data-lemmaRef') + '"]').each(function(){
      $(this).show();
      $(this).find('span').show();
      if ($(this).hasClass('chunk')) {
        var y = $(this).prevAll('.chunk, .lineBreak').slice(0,5);
        y.show(); 
        y.find('*').show();
        var z = y.last();
        var w = searchBackwards(z,'lineBreak');
        if (typeof w != 'undefined') {
          w.show();
          var u = w.parents('.chunk');
          if (u.length>0) { // embedded in chunk
            u.show();
            u.nextUntil($(this)).show();
            u.nextUntil($(this)).find('*').show();
          }
          else {
            w.nextUntil($(this)).show();
            w.nextUntil($(this)).find('*').show();
          }
        }
        searchBackwards($(this),'pageBreak').show();
        y = $(this).nextAll('.chunk, .lineBreak').slice(0,5);
        y.show(); 
        y.find('*').show();
        z = y.last();
        w = searchForwards(z,'lineBreak');
        if (typeof w != 'undefined') {
          //w.show();
          var u = w.parents('.chunk');
          if (u.length>0) { // embedded in chunk
            u.show();
            u.prevUntil($(this)).show();
            u.prevUntil($(this)).find('*').show();
          }
          else {
            w.prevUntil($(this)).show();
            w.prevUntil($(this)).find('*').show();
          }
        }
        //$('<hr class="temp"/>').insertAfter(y.last());
      }
      else {
        var a = $(this).parents('.chunk');
        a.show(); 
        a.find('span').show();
        var y = a.prevAll('.chunk, .lineBreak').slice(0,5);
        y.show(); 
        y.find('*').show();
        var z = y.last();
        var w = searchBackwards(z,'lineBreak');
        if (typeof w != 'undefined') {
          w.show();
          var u = w.parents('.chunk');
          if (u.length>0) { // embedded in chunk
            u.show();
            u.nextUntil(a).show();
            u.nextUntil(a).find('*').show();
          }
          else {
            w.nextUntil(a).show();
            w.nextUntil(a).find('*').show();
          }
        }
        searchBackwards(a,'pageBreak').show();
        y = a.nextAll('.chunk, .lineBreak').slice(0,5);
        y.show(); 
        y.find('*').show();
        var z = y.last();
        var w = searchForwards(z,'lineBreak');
        if (typeof w != 'undefined') {
          //w.show();
          var u = w.parents('.chunk');
          if (u.length>0) { // embedded in chunk
            u.show();
            u.prevUntil(a).show();
            u.prevUntil(a).find('*').show();
          }
          else {
            w.prevUntil(a).show();
            w.prevUntil(a).find('*').show();
          }
        }
        //$('<hr class="temp"/>').insertAfter(y.last());
      }
    });
    $('.textAnchor').hide();
    x.find('.suppliedDiplo, .addComment, .viewComment').hide();
    if (x.children('div').attr('data-diplo')=='super') { x.find('.gapDamageCharsDiplo').hide(); } //??????????????????????
    else { x.find('.gapDamageCharsSuperDiplo').hide(); }
    return null;
  });
  
  $('.explode').click(function(){
    $(this).hide();
    $(this).prevAll('.implode').show();
    $('#midl').find('span').show();
    $('#midl').find('.suppliedDiplo').hide();
    if ($('#midl').children('div').attr('data-diplo')=='super') { $('#midl').find('.gapDamageCharsDiplo').hide(); } //???????????????????
    else { $('#midl').find('.gapDamageCharsSuperDiplo').hide(); }
    $('#midl').find('.textAnchor').show();
    $('#midl').find('.pageBreak, .columnBreak').show();
    $('.temp').remove();
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    var x = $('#midl').find('[data-lemmaRef="'+ $(this).prevAll('.indexHeadword').attr('data-lemmaRef') + '"]').first();
    $('#midl').animate({scrollTop: x.offset().top - 100},500);
    return null;
  });
  
  $('.reset').click(function(){
    $(this).prevAll('.explode').trigger('click');
    $(this).hide();
    $(this).prevAll('.implode,.explode,.hwCount').hide();
    $(this).parent().css({'background-color': 'inherit'});
    $('#midl').find('.syntagm').css({'background-color': 'inherit', 'color': 'inherit', 'font-weight': 'normal'});
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
    //var prevCorresp = '';
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
        $('#midl').find('span[data-corresp=' + $(this).attr('data-corresp') + ']').css('text-decoration', 'underline');
        $('#rhs').find('span[data-corresp=' + $(this).attr('data-corresp') + ']').css('background-color', 'yellow');
      },
      function() {
        $('#'+$(this).attr('data-id')).css('text-decoration', 'inherit');
        $('#xx-'+$(this).attr('data-id')).css('background-color', 'inherit');
        $('#yy-'+$(this).attr('data-id')).css('background-color', 'inherit');
        $('#midl').find('span[data-corresp=' + $(this).attr('data-corresp') + ']').css('text-decoration', 'inherit');
        $('#rhs').find('span[data-corresp=' + $(this).attr('data-corresp') + ']').css('background-color', 'inherit');
      }
    );
    $('.headwordSearch').click(function() {
      var x = $('.indexHeadword[data-lemmaRef="' + $(this).attr('data-lemmaRef') + '"]');
      setTimeout(function(){x.trigger('click')}, 100);  //Giving the 'click' some time to process
      var y = $('#lhs');
      y.animate({scrollTop: 0},0);
      y.animate({scrollTop: x.offset().top - 300},500);
    });
    $('#saveSlip').click(function() {
      var x = $('.selected');
      var docid = x.parents('[data-docid]').first().attr('data-docid') + '.';
      var page = searchBackwards(x,'pageBreak').attr('data-n') + '.';
      var line = searchBackwards(x,'lineBreak').attr('data-n') + '.';
      var id = docid + page + line;
      var slip = new Object();
      slip.id = id;

      var p = x.prev().clone();
      p.find('button, .lineBreak, .pageBreak, .columnBreak, .handShift').remove(); // remove all ids as well!
      var syntagm = p.html() + ' ';
      var t = x.clone();
      t.find('button, .lineBreak, .pageBreak, .columnBreak, .handShift').remove();
      syntagm += '<span style="background-color: yellow;">' + t.html() + '</span>'; //SB: should we strip the HTML here?
      var n = x.next().clone();
      n.find('button, .lineBreak, .pageBreak, .columnBreak, .handShift').remove();
      syntagm += ' ' + n.html();
      slip.syntagm = syntagm;

      var h = searchBackwards(x,'handShift').attr('data-new');
      slip.hand = getHandName(h);
      var lemma = '';
      if (x.attr('data-lemma')) { lemma += x.attr('data-lemma'); }
      else {
        x.find('[data-lemma]').each(function(){
          lemma += $(this).attr('data-lemma') + ' ';
        });
      }
      slip.lemma = lemma;
      $.post('ajax.php',
          {
            action: "addToBasket",
            contents: slip
          });
      alert('added to basket');
      return null;
    });
  });

  $('#basketToggle').click(function () {
      var html = '';
      $.getJSON("ajax.php?action=getBasket", function( data ) {
            $.each(data, function (key, value) {
              html += '<tr id="basket_' + value.id + '">';
              html += '<td>' + value.id + '</td>';
              html += '<td>' + value.syntagm + '</td>';
              html += '<td>' + value.hand + '</td>';
              html += '<td>' + value.lemma + '</td>';
              html += '<td><a href="#" id="' + value.id + '" class="deleteSlip">delete</a></td>';
              html += '</tr>';
            });
      }).done(function () {
          $("#basket").children('tbody').html(html);
      });

  });

  $('#emptyBasket').click(function () {
    $.ajax({
      url: 'ajax.php?action=emptyBasket'
    })
        .done(function () {
          $("#basket").children('tbody').remove();
          alert('basket emptied');
        });
  });

  $('#msImage').zoomio({
    fadeduration: 500
  });

  //removeSpaces();

});

function removeSpaces() {
  var x = $('#midl').find('.sic');
  x.each(function() {
    var y = $(this).find('.word');
    var z = y.first();
    z.css('background-color', 'red');
    console.log('m' + z.text() + 'm');
  });
}

//Delete a slip from the basket
$(document).on('click', '.deleteSlip', function () {
  var id = $(this).attr('id');
  console.log(id);
  $(this).parent().parent().remove();  //delete from the table
  $.post('ajax.php',
      {
        action: "deleteFromBasket",
        id: id
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
  clone.find('.lineBreak, .pageBreak, .columnBreak, .punct, .handShift, .pageBreakSuper').remove();
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
  if (span.hasClass('characterString')) {
    html += '<li>is a character string</li>';
  }
  else {
    html += getPOS(span); 
    html += getStructure(span);
  }
  if (rec) {
    html += '</ul>';
  }
  return html;
}

function getGlygatures(span) {
  //var prevCorresp = '';
  html = '';
  var x = span.find('.expansion, .ligature');
  if (x.length > 0) {
    html += '<li>scribal abbreviations and ligatures:<ul class="rhs">';
    x.each(function() {
      var corresp;
      if ($(this).attr('data-corresp')) {
        corresp = $(this).attr('data-corresp');
        if ($(this).attr('data-copy')) {
          return true;    //SB: prevents >1 example being shown for elements with the same corresp
        } 
        //else { prevCorresp = corresp; }
      } 
      //else { prevCorresp = '';}
      var id = $(this).attr('id');
      var c = $(this).attr('data-cert');
      var cr = $(this).attr('data-corresp');
      $.ajaxSetup({async: false});
      $.getJSON('ajax.php?action=getGlyph&xmlId=' + $(this).attr('data-glyphref'), function (g) {
        li = '<li><a class="glyphShow" href="' + g.corresp + '" target="_new" data-src="' + g.id + '" data-id="' + id + '" data-corresp="' + cr + '">' + g.name;
        li += '</a>: ' + g.note + ' (' + c + ' certainty)';
        html += li + '</li>';
      });
    });
    html += '</ul></li>';
  }
  return html;
}

function getHandInfo(span) {
  html = '';
  var h = searchBackwards(span,'handShift').attr('data-new');
  html += getHandInfoDiv(h);
  html += '<li>scribe: ';
  html += '<a href="#" data-toggle="modal" data-target="#handInfo_' + h +'">' + getHandName(h) + '</a>'; // are two ajax calls necessary?
  span.find('.handShift').each(function() {
    hh = $(this).attr('data-new');
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
  var z = span.parent();
  if (typeof out == 'undefined' && !z.is('body')) {
    return searchBackwards(z,c);
  }
  return out;
}

function searchForwards(span,c) { // depth-first
  var out;
  var jqs = span.nextAll();
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
  var z = span.parent();
  if (typeof out == 'undefined' && !z.is('body')) {
    return searchForwards(z,c);
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
    /*html += g.from;           //SB: should be clear to delete this chunk (and associated data in ajax.php
    if (g.min != g.from) {
      html += '/' + g.min;
    }
    html += ' – ' + g.to;
    if (g.max != g.to) {
      html += '/' + g.max;
    }*/
    html += 'Century: ' + g.date;
    html += '</p><p>'
    html += g.region;
    html += '</p>';
    for (j = 0; j < g.notes.length; j++) {
      var xml = $.parseXML(g.notes[j]);
      $xml = $(xml);
      $xml.find('p').each(function (index, element) {
        $(element).find('hi').each(function () {
          $(this).replaceWith(function () {
            var rend = $(this).attr('rend');
            if (rend=='italics') { return $('<em />', {html: $(this).html()}); }
            if (rend=='sup') { return $('<sup />', {html: $(this).html()}); }
            if (rend=='sub') { return $('<sub />', {html: $(this).html()}); }
            if (rend=='bold') { return $('<strong />', {html: $(this).html()}); }
            if (rend=='underline') { return $('<u />', {html: $(this).html()}); }
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
    if ($(span).attr('data-corresp')) {
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
  if ($(span).attr('data-pos')) { html += '<li>is a ' + $(span).attr('data-pos').replace('_',' ') + '</li>'; }
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
  if (span.attr('data-corresp')) {
      html += '<li>HDSG slips: <a href="' + span.attr('data-corresp') + '" target="_new">' + span.attr('data-lemma') + '</a></li>';
  }
  return html;
}

function getDamage(span) {
  html = '';
  var x = span.find('.unclearDamageSuperDiplo, .unclearDamageSemi');
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
      //html += '(<a href="#" onclick="$(\'#handInfo_'+ $(this).attr('data-hand') + '\').bPopup();">' + getHandName($(this).attr('data-hand')) + '</a>)</li>';
      var h = $(this).attr('data-hand');
      html += getHandInfoDiv(h);
      html += '(<a href="#" data-toggle="modal" data-target="#handInfo_' + h +'">' + getHandName(h) + '</a>)</li>'; 
    });
    html += '</ul></li>';
  }
  else {
    x = $(span).parents('.deletion');
    if (x.length>0) {
      html += '<li>is part of the following deletion:<ul class="rhs">';
      html += '<li>[' + x.text() + '] (';
      var h = x.attr('data-hand');
      html += getHandInfoDiv(h);
      html += '<a href="#" data-toggle="modal" data-target="#handInfo_' + h +'">' + getHandName(h) + '</a>';
      //html += '<a href="#" onclick="$(\'#handInfo_'+ x.attr('data-hand') + '\').bPopup();">' + getHandName(x.attr('data-hand')) + '</a>';
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
      var h = $(this).attr('data-hand');
      html += getHandInfoDiv(h);
      html += '<a href="#" data-toggle="modal" data-target="#handInfo_' + h +'">' + getHandName(h) + '</a>';
      //html += '<a href="#" onclick="$(\'#handInfo_'+ $(this).attr('data-hand') + '\').bPopup();">' + getHandName($(this).attr('data-hand')) + '</a>';
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
      var h = x.attr('data-hand');
      html += getHandInfoDiv(h);
      html += '<a href="#" data-toggle="modal" data-target="#handInfo_' + h +'">' + getHandName(h) + '</a>';
      //html += '<a href="#" onclick="$(\'#handInfo_'+ x.attr('data-hand') + '\').bPopup();">' + getHandName(x.attr('data-hand')) + '</a>'; // what is 'this'?
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

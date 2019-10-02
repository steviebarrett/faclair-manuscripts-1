/* 
This script is called by viewTranscription.php
It contains event handlers relevant to the diplomatic MS view only.
*/

$(function() {

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
    } else {    //simple case: just stick the url in an image tag
      html = '<img width="100%" src="';
      html += url;
      html += '"/>'
    }
    $('#rhs').html(html);
  });  
    
  $('.chunk').hover(
    function(){$(this).css('text-decoration', 'underline');},
    function(){$(this).css('text-decoration', 'inherit');}
  );

  $('.chunk').click(function(){
    $('.chunk').css('background-color', 'inherit');
    $(this).css('background-color', 'yellow');
    //html = '<h1>' + $(this).text() + '</h1>'; 
        var prevCorresp = '';
        //$('#headword').text(clean($(this).text()));
        html = '<h1>';
        this2 = $(this).clone();
        $(this2).find('div').remove();  //delete any divs (e.g. 'start of page ...')
        html += reindex(this2);
        html = html.replace(/\n/g,'');
        html += '</h1><ul>';
    html += makeSyntax($(this),false);
    html += '</ul>';

        if ($(this).find('.expansion, .ligature').length>0) {
            html += 'Contains, or is formed from, the following scribal abbreviations and/or ligatures:<ul>';
            $(this).find('.expansion, .ligature').each(function() {
                var corresp;
                if (corresp = $(this).attr('data-corresp')) {
                    if (corresp === prevCorresp) {
                        return true;    //SB: prevents >1 example being shown for elements with the same corresp
                    } else {
                        prevCorresp = corresp;
                    }
                } else {
                    prevCorresp = '';
                }
                cert = $(this).attr('data-cert');
                var xmlId = $(this).attr('data-glyphref');
                var elementId = $(this).attr('id');
                //$.ajaxSetup({async: false});
                $.getJSON('ajax.php?action=getGlyph&xmlId=' + xmlId, function (g) {
                    txt = '<li class="glyphItem"><a href="' + g.corresp + '" target="_new" data-src="' + g.id + '">' + g.name;
                    txt = txt + '</a>: ' + g.note + ' (' + cert + ' certainty) <a style="font-size: small;" href="#" class="glyphShow" data-id="' + elementId + '" data-corresp="'+prevCorresp+'">[show]</a></li>';
                    html += txt;
                })
            });
            html += '</ul>';
        }

        /*
        $('#damagedInfo').html(getDamage($(this)));
        $('#deletionInfo').html(getDeletions($(this)));
        $('#additionInfo').html(getAdditions($(this)));
         */
         /* 
        if ($(this2).attr('data-hand') != undefined) {
            var hands = [$(this2).attr('data-hand')];
            $(this2).find('.handShift').each(function() {
                hands.push($(this).attr('data-hand'));
            });
            html += getHandInfoDivs(hands);    //get the hand info if available
        }
         */
    // hand info     
    
    $('#rhs').html(html);
    $('.glyphShow').hover(
            function(){
                $('#'+$(this).attr('data-id')).css('text-decoration', 'underline');
                $('#xx'+$(this).attr('data-id')).css('background-color', 'yellow');
                $('.corresp-'+$(this).attr('data-corresp')).css({'text-decoration': 'underline', 'background-color': 'yellow'});
            },
            function() {
                $('#'+$(this).attr('data-id')).css('text-decoration', 'inherit');
                $('#xx'+$(this).attr('data-id')).css('background-color', 'inherit');
                $('.corresp-'+$(this).attr('data-corresp')).css({'text-decoration': 'inherit', 'background-color': 'inherit'});
            }
        );
    
  });

  function makeSyntax(span, rec) {
    html = '';
    if (rec) {
      html += $(span).text();
      html += '<ul>';
    }
    html += handInfo(span);
    if ($(span).hasClass('name')) html += onomastics(span);
    /*
    if ($(span).attr('xml:lang') || ($(span).hasClass('name') && $(span).children('.word').attr('xml:lang')==1 && $(span).children('.word').attr('xml:lang'))) {
      html += '<li>is not a Gaelic word: ';
      if ($(span).attr('xml:lang')) { html += decode($(span).attr('xml:lang')); }
      else { html += decode($(span).children('.word').attr('xml:lang')); }
      html += '</li>';
    }
    else {
     */
    html += partOfSpeech(span); 
    html += structure(span); 
      /*
            if ($(span).attr('data-headword')) {
                html += '<li>is a form of the headword ';
                html += '<a href="' + $(span).attr('data-edil') + '" target="_new">' + $(span).attr('data-headword') + '</a>';
                if ($(span).attr('data-edil').indexOf('dil.ie')>0) { html += ' (eDIL)'; }
                else if ($(span).attr('data-edil').indexOf('faclair.com')>0) {
                    html += ' (Dwelly)';
                }
                $.ajaxSetup({async: false});
                $.getJSON('../../Coding/Scripts/ajax.php?action=getDwelly&edil=' + $(span).attr('data-edil'), function (g) {
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
                $.getJSON('../../Coding/Scripts/ajax.php?action=getDwelly&edil=' + $(span).children('.word').attr('data-edil'), function (g) {
                    if (g.hw != '') { html += ', <a href="' + g.url + '" target="_new">' + g.hw + '</a> (Dwelly)'; }
                });
                html += '</li>';
            }
             */
             /*
      
            if($(span).attr('data-lemmasl')) {
                html += '<li>appears in the HDSG/RB collection of headwords: <a href="' + $(span).attr('data-slipref') + '" target="_new">' + $(span).attr('data-lemmasl') + '</a></li>';
            }
        }

        if ($(span).find('.insertion').length != 0) {
            html += getAdditions(span);
        }
        
        */
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
  if (typeof h == 'undefined') {
    h = $(span).parents('.text').first().attr('data-hand');
  }
  var handIds = [h];
  html += getHandInfoDivs(handIds);
  html += '<li>was written by ';
  html += '<a href="#" data-toggle="modal" data-target="#handInfo_' + handIds[0] +'">' + getHandInfo(h) + '</a>';
  html += '</li>';
  //a handShift within a word
  /* 
  $(span).find('.handShift').each(function() {
    html += '<li>contains a hand shift to ';
    html += '<a href="#" onclick="$(\'#handInfo_'+ $(this).attr('data-hand') + '\').bPopup();">' + getHandInfo($(this).attr('data-hand')) + '</a>';
    html += '</li>';
  });
  */
  return html;  
}

  function onomastics(span){
    html = '<li>is ';
    type = $(span).attr('data-nametype');
    if (type=='personal') html += 'an anthroponym';
    else if (type=='place') { 
      html += 'a toponym';
        /* 
        if ($(span).attr('data-corresp') != '') {
          html += '<li>further information on this placename can be found <a href="' + $(span).attr('data-corresp') + '" target="_blank">here</a></li>';
        }
        */
    }
    else if (type=='population') html += 'a demonym';
    else html += 'a name';
    return html + '</li>';
  }
  
  function partOfSpeech(span) {
    html = '';
    if ($(span).attr('data-pos')) html += '<li>is a ' + $(span).attr('data-pos') + '</li>';
    else if ($(span).hasClass('name') && $(span).children('.word').length==1 && $(span).children('.word').children('.word').length==0) html += '<li>is a ' + $(span).children('.word').attr('data-pos') + '</li>';
    return html;
  }
  
  function structure(span) {
    html = '';
    if ($(span).children('.syntagm').length>1) {
      html += '<li>is a syntactically complex form containing the following elements:';
      html += '<ul>';
      $(span).children('.syntagm').each(function() {
          html = html + '<li>' + makeSyntax($(this),true) + '</li>';
      });
      html += '</ul>';
      html += '</li>';
    }
    /* }
         else if ($(span).children('.syntagm').length==1 && $(span).children('.syntagm').children('.syntagm').length>0) {
           htmlx += '<li>is a syntactically complex form containing the following elements:';
           htmlx += '<ul>';
           $(span).children('.syntagm').children('.syntagm').each(function() {
             htmlx = htmlx + '<li>' + makeSyntax($(this),true) + '</li>';
           });
           htmlx += '</ul>';
           htmlx += '</li>';
         }
         else if ($(span).children('.addition, .deletion').length>0) {
           htmlx += '<li>is a syntactically complex form containing the following elements:';
           htmlx += '<ul>';
           $(span).children('.syntagm').add($(span).children('.addition').add($(span).children('.deletion')).children('.syntagm')).each(function() {
             htmlx = htmlx + '<li>' + makeSyntax($(this),true) + '</li>';
           });
           htmlx += '</ul>';
           htmlx += '</li>';
         }
          */
    else html += '<li>is a syntactically simple form</li>';
    return html;
  }

  function reindex(span) { // prefixes all ids in some html
        //console.log(span.html());
        //dom = $.parseHTML(span);
        //console.log(typeof span);
        //span2 = $('#rightPanel').find('.lineBreak').remove();
        $(span).find('.lineBreak').remove();
        //console.log(span);
        //$('.lineBreak').remove()
        //console.log(span2.html());
        //delete all <span class="lineBreak"> elements from inside span;
        return $(span).html().replace(/id="/g, 'id="xx');
    }

/*
      Show/hide marginal notes
      Added by SB
     */
    $('.marginalNoteLink').on('click', function() {
        var id = $(this).attr('data-id').replace(/\./g, '\\.');
        $('#'+id).toggle();
    });

});

function getHandInfo(handId) {
    var name = '';
    $.getJSON('ajax.php?action=getHandInfo&hand=' + handId, function (g) {
        if (g.forename + g.surname != '') {
            name = g.forename + ' ' + g.surname;
        } else {
            name = 'Anonymous (' + handId + ')';
        }
    });
    return name;
}
/*
    Uses an AJAX request to fetch the detailed hand info for an array of hand IDs
    Returns an HTML formatted string
 */
function getHandInfoDivs(handIds) {
    var html = '';
    $.ajaxSetup({async: false});
    for (i=0;i<(handIds.length);i++) {
        html += '<div class="modal" tabindex="-1" role="dialog" id="handInfo_' + handIds[i] + '">\n' +
            '  <div class="modal-dialog" role="document">\n' +
            '    <div class="modal-content">\n' +
            '      <div class="modal-body">\n';
        $.getJSON('ajax.php?action=getHandInfo&hand=' + handIds[i], function (g) {
            html += '<p>';
            if (g.forename + g.surname != '') {
                html += g.forename + ' ' + g.surname;
            } else {
                html += 'Anonymous (' + handIds[i] + ')';
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
    }
    return html;
}




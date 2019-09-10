$(function() {
  
    $('.indexHeadword').click(function(){
      $('#midl').animate({
        scrollTop: 0
      },0);
      $('.syntagm').css('background-color', 'inherit');
      $('[data-headword="'+ $(this).attr('data-uri') + '"]').css('background-color', 'yellow');
      var x = $('[data-headword="'+ $(this).attr('data-uri') + '"]').first();
      //alert(x.offset().top);
      $('#midl').animate({
        scrollTop: x.offset().top - 100
      },500);
      return null;
    });
    
  $('.chunk').hover(
        function(){$(this).css('text-decoration', 'underline');},
        function(){$(this).css('text-decoration', 'inherit');}
    );

  $('.chunk').click(function(){
    //alert($(this).text());
    $('#rhs').text($(this).text());
    return null;
        var prevCorresp = '';
        $('.chunk, .gapDamageDiplo').css('background-color', 'inherit');
        $(this).css('background-color', 'yellow');
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
                $.getJSON('../../Coding/Scripts/ajax.php?action=getGlyph&xmlId=' + xmlId, function (g) {
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
        if ($(this2).attr('data-hand') != undefined) {
            var hands = [$(this2).attr('data-hand')];
            $(this2).find('.handShift').each(function() {
                hands.push($(this).attr('data-hand'));
            });
            html += getHandInfoDivs(hands);    //get the hand info if available
        }
        $('#rightPanel').html(html);
   });

});




/* 
This script is called by viewTranscription.php
It contains event handlers relevant to that page as a whole, and to both MS views.
*/

$(function() {
  
  $('.indexHeadword').click(function(){ // called whenever a new headword is selected
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    $('.syntagm').css({'background-color': 'inherit', 'color': 'inherit', 'font-weight': 'normal'}); // unhighlight all words and phrases
    $('#rhs').html(''); // clear RHS
    $('.temp').remove();
    $('#midl').find('span').show();
    $('.textAnchor').show();
    $('.indexHeadword').parent().css({'background-color': 'inherit'});
    $('.hwCount').hide();
    $('.implode').hide();
    $('.explode').hide();
    $('[data-headword="'+ $(this).attr('data-uri') + '"]').css({'color': 'orange', 'font-weight': 'bold'});
    $(this).parent().css('background-color', 'orange');
    $(this).nextAll('.hwCount').show();
    $(this).nextAll('.implode').show();
    var x = $('[data-headword="'+ $(this).attr('data-uri') + '"]').first();
    $('#midl').animate({scrollTop: x.offset().top - 100},500);
    return null;
  });

  $('.implode').click(function(){
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    $(this).hide();
    $(this).nextAll('.explode').show();
    $('#midl').find('span').hide();
    $('.temp').remove();
    $('[data-headword="'+ $(this).prevAll('.indexHeadword').attr('data-uri') + '"]').each(function(){
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
    $('#midl').find('.textAnchor').hide();
    $('#midl').find('.pageAnchor').hide();
    $(this).parents().prevAll('.pageAnchor').first().show(); // not working
    $('#midl').find('.greyedOut').hide();
    return null;
  });
  
  $('.explode').click(function(){
    $(this).hide();
    $(this).prevAll('.implode').show();
    $('#midl').find('span').show();
    $('#midl').find('.textAnchor').show();
    $('#midl').find('.pageAnchor').show();
    $('.temp').remove();
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    var x = $('[data-headword="'+ $(this).prevAll('.indexHeadword').attr('data-uri') + '"]').first();
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
    //var prevCorresp = ''; // WTF?
    html = '<h1>';
    this2 = $(this).clone();
    $(this2).find('.lineBreak').remove();
    $(this2).find('.pageAnchor').remove();
    $(this2).find('[id]').each(function(){
      $(this).attr('id', 'xx-' + $(this).attr('id'));
    });
    html += '<span class="syntagm">' + $(this2).html() + '</span>';
    //html = html.replace(/\n/g,'');
    html += '</h1><ul>';
    //html += makeSyntax($(this),false); START HERE!!!!!
    html += '</ul>';

/*
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
*/
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
    /*
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
    */
  });

});

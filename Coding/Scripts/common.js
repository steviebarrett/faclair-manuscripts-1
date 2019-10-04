/* 
This script is called by viewTranscription.php
It contains event handlers relevant to that page as a whole, and to both MS views.
*/

$(function() {
  
  $('.indexHeadword').click(function(){ // called whenever a new headword is selected
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    $('.syntagm').css({'background-color': 'inherit', 'color': 'inherit', 'font-weight': 'normal'}); // unhighlight all words and phrases
    $('#rhs').html(''); // clear RHS
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
    $(this).hide();
    $(this).nextAll('.explode').show();
    $('#midl').find('span').hide();
    $('[data-headword="'+ $(this).prevAll('.indexHeadword').attr('data-uri') + '"]').each(function(){
      $(this).show();
      $(this).parents('span').show();
      $(this).prevAll().slice(0,10).show();
      $(this).prevAll().slice(0,10).find('*').show();
      $(this).nextAll().slice(0,10).show();
      $(this).nextAll().slice(0,10).find('*').show();
      $(this).parents('span').prevAll().slice(0,10).show();
      $(this).parents('span').prevAll().slice(0,10).find('*').show();
      $(this).parents('span').nextAll().slice(0,10).show();
      $(this).parents('span').nextAll().slice(0,10).find('*').show();
    });
    $('#midl').find('.textAnchor').hide();
    $('#midl').find('.greyedOut').hide();
    return null;
  });
  
  $('.explode').click(function(){
    $(this).hide();
    $(this).prevAll('.implode').show();
    $('#midl').find('span').show();
    $('#midl').find('.textAnchor').show();
    return null;
  });

});


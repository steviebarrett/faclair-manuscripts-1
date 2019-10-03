/* 
This script is called by viewTranscription.php
It contains event handlers relevant to that page as a whole, and to both MS views.
*/

$(function() {
  
  $('.indexHeadword').click(function(){ // called whenever a new headword is selected
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    $('.syntagm').css({'background-color': 'inherit', 'color': 'inherit', 'font-weight': 'normal'}); // unhighlight all words and phrases
    $('#rhs').html(''); // clear RHS
    $('.indexHeadword').css({'background-color': 'inherit'});
    $('.hwCount').hide();
    $('[data-headword="'+ $(this).attr('data-uri') + '"]').css({'color': 'orange', 'font-weight': 'bold'});
    $(this).css('background-color', 'orange');
    $(this).children('.hwCount').show();
    var x = $('[data-headword="'+ $(this).attr('data-uri') + '"]').first();
    $('#midl').animate({scrollTop: x.offset().top - 100},500);
    return null;
  });

});


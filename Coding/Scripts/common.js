$(function() {
  
  $('.indexHeadword').click(function(){ // called whenever a new headword is selected
    $('#midl').animate({scrollTop: 0},0); // move middle back to top
    $('.syntagm').css({'background-color': 'inherit', 'color': 'inherit'}); // unhighlight all words and phrases
    $('#rhs').html(''); // clear RHS
    $('.indexHeadword').css({'color': 'inherit'});
    $('[data-headword="'+ $(this).attr('data-uri') + '"]').css({'color': 'red'});
    $(this).css('color', 'red');
    var x = $('[data-headword="'+ $(this).attr('data-uri') + '"]').first();
    $('#midl').animate({scrollTop: x.offset().top - 100},500);
    return null;
  });

});


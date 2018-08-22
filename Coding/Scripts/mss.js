$(function() {

  $('.word').mouseenter(function(){
    $(this).css('color', 'white');
    if ($(this).parent().hasClass('name')) {
      $(this).css('background-color', 'green');  
      $(this).siblings().css('color', 'green');
      $(this).siblings().css('text-decoration', 'underline');
    }
    else {
      $(this).css('background-color', 'blue');
      if ($(this).parent().hasClass('compound')) {  
        $(this).siblings().css('color', 'blue');
        $(this).siblings().css('text-decoration', 'underline');
      }
    }
  });

  $('.word').mouseleave(function(){
    $(this).css('background-color', 'white');
    $(this).css('color', 'black');
    if ($(this).parent().hasClass('name') || $(this).parent().hasClass('compound')) {
      $(this).siblings().css('color', 'black');
      $(this).siblings().css('text-decoration', 'none');
    }
  });






  $('#clear-slips-button').on('click', function() {
    console.log('pressed');
  });
            
  $('.word').on('click', function(){
    var abbrevs = ""; 
    $.each($(this).contents().find('.abbreviation-glyph'), function(i, v) {
      abbrevs = abbrevs + $(this).html() + ' ';
    });
    $('#slips-table > tbody').append('<tr><td>'+ $(this).html() + '</td><td>' + abbrevs + '</td></tr>');
  });



  
});

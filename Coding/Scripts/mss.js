$(function() {

  $('.word').mouseenter(function(){
    $(this).css('color', 'white');
    if ($(this).parent().hasClass('name')) {
      $(this).css('background-color', 'green');  
      $(this).siblings().css('color', 'green');
    }
    else {
      $(this).css('background-color', 'blue');
    }
  });

  $('.word').mouseleave(function(){
    $(this).css('background-color', 'white');
    $(this).css('color', 'black');
    if ($(this).parent().hasClass('name')) {
      $(this).siblings().css('color', 'black');
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

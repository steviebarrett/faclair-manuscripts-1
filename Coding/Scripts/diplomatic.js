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
    } 
    else {    //simple case: just stick the url in an image tag
      html = '<img width="100%" src="';
      html += url;
      html += '"/>'
    }
    $('#rhs').html(html);
  });
    
  

  

  



  

/*
      Show/hide marginal notes
      Added by SB
     */
    $('.marginalNoteLink').on('click', function() {
        var id = $(this).attr('data-id').replace(/\./g, '\\.');
        $('#'+id).toggle();
    });

});








$(function() {

    /*
        Flag the sections that have comments
     */
    $.getJSON('/ajax/manuscripts.php?action=getPopulatedSections&docid='+docid, function(data) {
        console.log(data);
        $.each(data, function(k, v) {
            $.each(v, function (key, val) {
                console.log(key + ' - ' + val + '\n');
            });
        });
    });

    /*
        Show/hide comment form
     */
    $('.addComment').on('click', function () {
        var s = $(this).attr('data-s');
        var sid = $(this).attr('data-n');
        sid = sid.replace(/\./g, '\\.');
        $('#cf__' + s + '__' + sid).bPopup();
    });

    /*
        Save a comment
     */
    $('.saveComment').on('click', function() {
        var docid = $('html').attr('data-docid');   //the MS ID
        var formId = $(this).parent().attr('id');
        var parts = formId.split('__');
        var s = parts[1];                           //the section type (e.g. div or lb)
        var sid = parts[2];                         //the section ID
        var user = $(this).siblings('select').val();
        var comment = $(this).siblings('input').val();
        var feedbackHtml = '';
        $.getJSON('/ajax/manuscripts.php?action=saveComment&docid='+docid+'&s='+s+'&sid='+sid+'&user='+user+'&comment='+comment, function(data) {
            console.log(data);
            if (data.saved == true) {
                feedbackHtml = '<strong>Your comment has been saved</strong>';
            } else { //there was an error saving the comment
                feedbackHtml = '<em>There was an error saving the comment</em>';
            }
        });
        //reset the form elements
        $(this).siblings('select').val(''); //reset the user
        $(this).siblings('textarea').val(''); //reset the comment
        $(this).parent().bPopup().close();   //close the popup
    });

    /*
        Cancel comment entry
     */
    $('.cancelComment').on('click', function () {
        $(this).siblings('select').val(''); //reset the user
        $(this).siblings('textarea').val(''); //reset the comment
        $(this).parent().bPopup().close();   //close the popup
    });

    /*
        Get comments
     */
    $('.viewComment').on('click', function() {
        var docid = $('html').attr('data-docid');   //the MS ID
        var s = $(this).attr('data-s');             //the section type (e.g. div/lb)
        var sid = $(this).attr('data-n');           //the section ID
        var html = '<ul>';
        $.getJSON('/ajax/manuscripts.php?action=getComment&docid='+docid+'&s='+s+'&sid='+sid, function(data) {
            console.log(data);
            $.each(data, function(k, v) {
                $.each(v, function (key, val) {
                    html += '<li>' + val.comment + ' (' + val.user + ') - ' + val.last_updated + '</li>';
                });
            });
            html += '</ul>';
            $('#right-panel').html(html);
        });
    });

});
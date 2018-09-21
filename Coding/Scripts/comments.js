
$(function() {

    /*
        Show/hide comment form
     */
    $('.addComment').on('click', function () {
        var sid = $(this).attr('data-n');
        $('#cf__'+sid).toggle();
    });

    /*
        Save a comment
     */
    $('.saveComment').on('click', function() {
        var docid = $('html').attr('data-docid');   //the MS ID
        var formId = $(this).parent().attr('id');
        var parts = formId.split('__');
        var sid = parts[1];                         //the section ID
        var user = $(this).siblings('select').val();
        var comment = $(this).siblings('input').val();
        var feedbackHtml = '';
        $.getJSON('/ajax/manuscripts.php?action=saveComment&docid='+docid+'&sid='+sid+'&user='+user+'&comment='+comment, function(data) {
            console.log(data);
            if (data.saved == true) {
                feedbackHtml = '<strong>Your comment has been saved</strong>';
            } else { //there was an error saving the comment
                feedbackHtml = '<em>There was an error saving the comment';
            }
            $('#'+formId).html(feedbackHtml);
        });
    });

    /*
        Cancel comment entry
     */
    $('.cancelComment').on('click', function () {
        var formId = $(this).parent().attr('id');
        $('#'+formId).hide();
    });

    /*
        Get comments
     */
    $('.viewComment').on('click', function() {
        var docid = $('html').attr('data-docid');   //the MS IS
        var sid = $(this).attr('data-n');           //the section ID
        $('#cv__'+sid).toggle();
        var html = '<div id="cv__'+sid+'"><ul>';
        $.getJSON('/ajax/manuscripts.php?action=getComment&docid='+docid+'&sid='+sid, function(data) {
            $.each(data, function(k, v) {
                $.each(v, function (key, val) {
                    html += '<li>' + val.comment + ' (' + val.user + ') - ' + val.last_updated + '</li>';
                });
            });
            html += '</ul></div>';
            $('#right-panel').html(html);
            console.log(data);
        });
    });

});
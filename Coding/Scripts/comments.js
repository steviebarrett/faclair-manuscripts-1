
$(function() {

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
        var comment = $(this).siblings('textarea').val();
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
        Delete comment
     */
    $('body').on('click', '.deleteComment', function () {   //event delegation as the calling tag is AJAX generated
        var parts = $(this).attr('id').split('__');
        var cid = parts[1];     //the DB comment ID
        $.getJSON('/ajax/manuscripts.php?action=deleteComment&cid='+cid, function(data) {
            console.log(data);
            if (data.deleted == true) {
                feedbackHtml = '<strong>The comment has been deleted</strong>';
            } else { //there was an error deleting the comment
                feedbackHtml = '<em>There was an error deleting the comment</em>';
            }
        });
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
            $.each(data, function(k, v) {
                $.each(v, function (key, val) {
                    html += '<li>' + val.comment + ' (' + val.user + ') - ' + val.last_updated;
                    html += ' <a id="cid__' + val.id + '" class="deleteComment" href="#">X</a>';  //the delete link
                    html += '</li>';
                });
            });
            html += '</ul>';
            $('#right-panel').html(html);
        });
    });

    /*
        Flag the sections that have comments
     */
    var docid = $('html').attr('data-docid');   //the MS ID
    $.getJSON('/ajax/manuscripts.php?action=getPopulatedSections&docid='+docid, function(data) {
        $.each(data, function(k, v) {
            $.each(v, function (key, val) {
                var section = val.section;
                var sectionId = val.section_id;
                sectionId = sectionId.replace(/\./g, '\\.');
                $('a[data-s='+section+'][data-n='+sectionId+'][class="viewComment"]').css('color', 'red' );
            });
        });
    });
});
/* 
This script is called by viewTranscription.php
It contains event handlers relevant to the comment system, and hence should only be edited by SB.
It sends a lot of calls to ajax.php to access/update the comments database (maybe rename this comments.php?).
*/

$(function() {

    //local variables to hold the section type and section ID
    var s, sid;
    var docid = 'T' + $('#docid').val();   //the MS ID

    /*
        Set the variables for comment saving
     */
    $('.addComment').on('click', function () {
        s = $(this).attr('data-s');
        sid = $(this).attr('data-n');
    });

    /*
        Save a comment
     */
    $('.saveComment').on('click', function() {
        var escapedSid = sid.replace(/\./g, '\\.');
        var user = $('#commentUser').val();
        var comment = $('#commentContent').val();
        var feedbackHtml = '';
        $.getJSON('ajax.php?action=saveComment&docid='+docid+'&s='+s+'&sid='+sid+'&user='+user+'&comment='+comment, function(data) {
            console.log(data);
            if (data.saved == true) {
                feedbackHtml = '<strong>Your comment has been saved</strong>';
            } else { //there was an error saving the comment
                feedbackHtml = '<em>There was an error saving the comment</em>';
            }
        })
            .done(function () {
                $('button[data-s='+s+'][data-n='+escapedSid+']').removeClass('greyedOut');   //remove the greyed out status of viewComment link
                $('button[data-s='+s+'][data-n='+escapedSid+']').show();   //show the viewComment link
                updateComments(docid, s, sid);              //update the comments list to the current section
            });
        //reset the form elements
        $('#commentUser').val(''); //reset the user
        $('#commentContent').val(''); //reset the comment
        $('#commentForm').modal('toggle');   //close the popup
    });

    /*
        Cancel comment entry
     */
    $('.cancelComment').on('click', function () {
        $('#commentUser').val(''); //reset the user
        $('#commentContent').val(''); //reset the comment
        $('#commentForm').modal('toggle');   //close the popup
    });

    /*
        Delete comment
     */
    $('body').on('click', '.deleteComment', function () {   //event delegation as the calling tag is AJAX generated
        $(this).hide();     //hide the delete link
        $(this).parent().addClass('greyedOut');   //fade the comment
        var parts = $(this).attr('id').split('__');
        var cid = parts[1];     //the DB comment ID
        var feedbackHtml;
        $.getJSON('ajax.php?action=deleteComment&cid='+cid, function() {})
            .done(function(data) {
                console.log(data);
                feedbackHtml = '<strong>The comment has been deleted</strong>';
                if (data.empty == true) { //if the number of deleted comments = the total number of comments
                    $.getJSON('ajax.php?action=getCommentInfo&cid=' + cid, function () {})
                        .done(function (cdata) {
                            console.log(cdata);
                            var sectionId = cdata.section_id.replace(/\./g, '\\.');
                            $('button[class="viewComment"][data-s=' + cdata.section + '][data-n=' + sectionId + ']').addClass('greyedOut');  //fade the viewcComment link
                        });
                }
            })
            .fail(function() {
                feedbackHtml = '<em>There was an error deleting the comment</em>';
            });
    });

    /*
        Get comments
     */
    $('.viewComment').on('click', function() {
        var s = $(this).attr('data-s');             //the section type (e.g. div/lb)
        var sid = $(this).attr('data-n');           //the section ID
        updateComments(docid, s, sid);
    });

    /*
        Flag the sections that have comments
     */
    $.getJSON('ajax.php?action=getPopulatedSections&docid='+docid, function(data) {
        $.each(data, function(k, v) {
            $.each(v, function (key, val) {
                var section = val.section;
                var sectionId = val.section_id;
                sectionId = sectionId.replace(/\./g, '\\.');
                //$('button[data-s='+section+'][data-n='+sectionId+']').show();
                //remove greyedOut class if there is a non-deleted comment here
                if (val.deleted == "0") {
                    $('button[data-s='+section+'][data-n='+sectionId+']').removeClass('greyedOut');
                }
            });
        });
    });
});

/*
    Retrieve the comments from the database and update the HTML in the right-panel
 */
function updateComments(docid, s, sid) {
    var html = '<ul class="commentsList">';
    $.getJSON('ajax.php?action=getComment&docid='+docid+'&s='+s+'&sid='+sid, function(data) {
        $.each(data, function(k, v) {
            $.each(v, function (key, val) {
                var displayClass = "";
                if (val.deleted == 1) {
                    displayClass = "greyedOut"; //fade deleted comments
                }
                html += '<li class="'+ displayClass +'">' + val.comment + ' (' + val.user + ') - ';
                html += '<span class="greyedOut">' + val.last_updated + '</span>';
                if (val.deleted == 0) {     //show the delete link
                    html += ' <a id="cid__' + val.id + '" class="deleteComment" href="#">X</a>';
                }
                html += '</li>';
            });
        });
        html += '</ul>';
        $('#viewCommentDiv').find('.modal-body').html(html);
        
    })
        .done(function() {
           return;          //wait for completion before return
        });
}
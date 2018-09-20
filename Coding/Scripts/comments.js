
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
        var docid = $('html').attr('data-docid');
        var formId = $(this).parent().attr('id');
        var parts = formId.split('__');
        var sid = parts[1];
        var user = $(this).siblings('select').val();
        var comment = $(this).siblings('input').val();
        $.getJSON('/ajax/manuscripts.php?action=saveComment&docid='+docid+'&sid='+sid+'&user='+user+'&comment='+comment, function(data) {
            console.log(data)
        });
    });

    /*
        Get comments
     */
    $('.viewComment').on('click', function() {
        var docid = $('html').attr('data-docid');
        var sid = $(this).attr('data-n');
        $('#cv__'+sid).toggle();
        var html = '<ul>';
        $.getJSON('/ajax/manuscripts.php?action=getComment&docid='+docid+'&sid='+sid, function(data) {
            $.each(data, function(k, v) {
                $.each(v, function (key, val) {
                    html += '<li>' + key + ' : ' + val + '</li>';
                });
                /*html += '<li>' + val.comment + ' (' + val.user + ') - ' + val.last_updated + '</li>';*/

            });
            html += '</ul>';
            $('#cv__'+sid).html(html);
            console.log(data);
        });
    });

});
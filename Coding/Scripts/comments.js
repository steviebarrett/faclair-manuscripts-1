
$(function() {

    /*
        Show/hide comment form
     */
    $('.addComment').on('click', function () {
        var sid = $(this).attr('data-n');
        $('#cf|' + sid).toggle();
    });

    /*
        Save a comment
     */
    $('.saveComment').on('click', function() {
        var formId = $(this).parent().attr('id');
        var parts = formId.split('|');
        var sid = parts[1];
        var user = $(this).siblings('select').val();
        var comment = $(this).siblings('input').val();
        $.getJSON('/ajax/manuscripts.php?action=saveComment&sid='+sid+'&user='+user+'&comment='+comment, function(data) {
            console.log(data)
        });
    });

    /*
        Get comments
     */
    $('.viewComment').on('click', function() {
        var sid = $(this).attr('data-n');
        $('#cv|'+sid).toggle();
        var html = '<ul>';
        $.getJSON('/ajax/manuscripts.php?action=getComment&sid='+sid, function(data) {
            $.each(data, function(key, val) {
                html += '<li>' + val.comment + ' (' + val.user + ') - ' + val.last_updated + '</li>';
            });
            html += '</ul>';
            $('#cv|'+sid).html(html);
            console.log(data);
        });
    });

});
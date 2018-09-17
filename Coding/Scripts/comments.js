
$(function() {

    /*
        Add a comment
     */
    $('.addComment').on('click', function() {
        var sid = $(this).attr('data-n');
        var comment = 'This is a test comment';
        $.getJSON('https://dasg.ac.uk/ajax/manuscripts.php?action=saveComment&sid='+sid+'&comment='+comment, function(data) {
            console.log(data)
        })
    })

    /*
        Get comments
     */
    $('.viewComment').on('click', function() {
        var sid = $(this).attr('data-n');
        $.getJSON('https://dasg.uk/ajax/manuscripts.php?action=getComment&sid='+sid, function(data) {
            console.log(data)
        })
    })

});
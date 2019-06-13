$(function() {

    $('#showHeader').click(function(){
        $('#headerInformation').show();
        $('#diplomaticTranscription').hide();
        $('#semiDiplomaticTranscription').hide();
    });

    $('#showDiplomatic').click(function(){
        $('#headerInformation').hide();
        $('#diplomaticTranscription').show();
        $('#semiDiplomaticTranscription').hide();
    });

    $('#showSemiDiplomatic').click(function(){
        $('#headerInformation').hide();
        $('#diplomaticTranscription').hide();
        $('#semiDiplomaticTranscription').show();
    });

    $('.textLink').click(function(){
        $('.chunk, .gapDamageDiplo').css('background-color', 'inherit');
        granny =  $(this).parent().parent();
        html = '<p>Text ' + granny.attr('data-n') + ': ';
        $.ajaxSetup({async: false});
        $.getJSON('../../Coding/Scripts/ajax.php?action=getTextInfo&ms=' + granny.attr('data-ms') + '&text=' + granny.attr('data-corresp'), function (g) {
            html += g.title;
        })
        html += ' (' + granny.attr('data-type') + ')</p><p>Hand:</p><ul>';
        $.getJSON('../../Coding/Scripts/ajax.php?action=getHandInfo&hand=' + granny.attr('data-hand'), function (g) {
            html += '<li>';
            if (g.forename + g.surname != '') { html +=  g.forename + ' ' + g.surname; }
            else { html += 'Anonymous'; }
            html += '</li><li>';
            html += g.from;
            if (g.min != g.from) { html += '/' + g.min; }
            html += ' – ' + g.to;
            if (g.max != g.to) { html += '/' + g.max; }
            html += '</li><li>'
            html += g.region;
            html += '</li>';
            for (i=0;i<g.notes.length; i++) { html += '<li>' + g.notes[i] + '</li>'; }
        })
        html += '</ul>';
        $('#rightPanel').html(html);
    });

    /*
        MSS Image handling on page click
        SB - added functionality to handle embedded viewer required for links to cudl.lib.cam.ac.uk
     */
    $('.page').click(function(){
        $('.chunk, .gapDamageDiplo').css('background-color', 'inherit');
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
        } else {    //simple case: just wrap the url in an image tag
            html = '<img width="1000" src="';
            html += url;
            html += '"/>'
        }
        $('#rightPanel').html(html);
        $('#rightPanel').css('overflow-x', 'scroll');
    });

    $('.chunk').hover(
        function(){$(this).css('text-decoration', 'underline');},
        function(){$(this).css('text-decoration', 'inherit');}
    );

    $('.chunk').click(function(){
        var prevCorresp = '';
        $('.chunk, .gapDamageDiplo').css('background-color', 'inherit');
        $(this).css('background-color', 'yellow');
        //$('#headword').text(clean($(this).text()));
        html = '<h1>';
        this2 = $(this).clone();
        html += reindex(this2);
        html += '</h1><ul>';
        html += makeSyntax($(this),false);
        html += '</ul>';
        if ($(this).find('.expansion, .ligature').length>0) {
            html += 'Contains, or is formed from, the following scribal abbreviations and/or ligatures:<ul>';
            $(this).find('.expansion, .ligature').each(function() {
                var corresp;
                if (corresp = $(this).attr('data-corresp')) {
                    if (corresp === prevCorresp) {
                        return true;    //SB: prevents >1 example being shown for elements with the same corresp
                    } else {
                        prevCorresp = corresp;
                    }
                }
                cert = $(this).attr('data-cert');
                var xmlId = $(this).attr('data-glyphref');
                var elementId = $(this).attr('id');
                //$.ajaxSetup({async: false});
                $.getJSON('../../Coding/Scripts/ajax.php?action=getGlyph&xmlId=' + xmlId, function (g) {
                    txt = '<li class="glyphItem"><a href="' + g.corresp + '" target="_new" data-src="' + g.id + '">' + g.name;
                    txt = txt + '</a>: ' + g.note + ' (' + cert + ' certainty) <a style="font-size: small;" href="#" class="glyphShow" data-id="' + elementId + '" data-corresp="'+prevCorresp+'">[show]</a></li>';
                    html += txt;
                })
            });
            html += '</ul>';

        }
        /*
        $('#damagedInfo').html(getDamage($(this)));
        $('#deletionInfo').html(getDeletions($(this)));
        $('#additionInfo').html(getAdditions($(this)));
         */
        $('#rightPanel').html(html);

        //SB - moved following glyph handler from deleted .done due to the synchronous call
        $('.glyphShow').hover(
            function(){
                $('#'+$(this).attr('data-id')).css('text-decoration', 'underline');
                $('#xx'+$(this).attr('data-id')).css('background-color', 'yellow');
                $('.corresp-'+$(this).attr('data-corresp')).css({'text-decoration': 'underline', 'background-color': 'yellow'});
            },
            function() {
                $('#'+$(this).attr('data-id')).css('text-decoration', 'inherit');
                $('#xx'+$(this).attr('data-id')).css('background-color', 'inherit');
                $('.corresp-'+$(this).attr('data-corresp')).css({'text-decoration': 'inherit', 'background-color': 'inherit'});
            }
        );
    });

    $('.gapDamageDiplo').click(function(){
        $('.chunk').css('background-color', 'inherit');
        $('.gapDamageDiplo').css('background-color', 'inherit');
        $(this).css('background-color', 'yellow');
        $('#expansionList').html('');
        $('#headword').html('');
        $('#damagedInfo').html('');
        $('#expansionInfo').hide();
        html = 'This is a damaged section of text: ';
        html = html + $(this).attr('data-extent') + ' ' + $(this).attr('data-unit') + ' (' + $(this).attr('data-resp') + ')';
        $('#syntaxInfo').html(html);

    });

    function makeSyntax(span, rec) {
        html = '';
        if (rec) { html += '<span style="color:red;">' + clean($(span).text()) + '</span><ul>'; }
        if ($(span).hasClass('name')) {
            type = $(span).attr('data-nametype');
            if (type=='personal') { html += '<li>is the name of a person</li>'; }
            else if (type=='place') { html += '<li>is the name of a place</li>'; }
            else if (type=='population') { html += '<li>is the name of a group of people</li>'; }
            else { html += '<li>is a name</li>'; }
        }
        if ($(span).attr('xml:lang') || ($(span).hasClass('name') && $(span).children('.word').attr('xml:lang')==1 && $(span).children('.word').attr('xml:lang'))) {
            html += '<li>is not a Gaelic word: ';
            if ($(span).attr('xml:lang')) { html += decode($(span).attr('xml:lang')); }
            else { html += decode($(span).children('.word').attr('xml:lang')); }
            html += '</li>';
        }
        else {
            if ($(span).attr('data-pos')) { html += '<li>is a ' + $(span).attr('data-pos') + '</li>'; }
            else if ($(span).hasClass('name') && $(span).children('.word').length==1 && $(span).children('.word').children('.word').length==0) {
                html += '<li>is a ' + $(span).children('.word').attr('data-pos') + '</li>';
            }
            if ($(span).attr('data-headword')) {
                html += '<li>is a form of the headword ';
                html += '<a href="' + $(span).attr('data-edil') + '" target="_new">' + $(span).attr('data-headword') + '</a>';
                if ($(span).attr('data-edil').indexOf('dil.ie')>0) { html += ' (eDIL)'; }
                else if ($(span).attr('data-edil').indexOf('faclair.com')>0) {
                    html += ' (Dwelly)';
                }
                $.ajaxSetup({async: false});
                $.getJSON('../../Coding/Scripts/ajax.php?action=getDwelly&edil=' + $(span).attr('data-edil'), function (g) {
                    if (g.hw != '') { html += ', <a href="' + g.url + '" target="_new">' + g.hw + '</a> (Dwelly)'; }
                });
                html += '</li>';
            }
            else if ($(span).hasClass('name') && $(span).children('.word').length==1 && $(span).children('.word').attr('data-headword')) { // add extra headwords here too?
                html += '<li>is a form of the headword ';
                html += '<a href="' + $(span).children('.word').attr('data-edil') + '" target="_new">' + $(span).children('.word').attr('data-headword') + '</a>';
                if ($(span).children('.word').attr('data-edil').indexOf('dil.ie')>0) { html += ' (eDIL)'; }
                else if ($(span).children('.word').attr('data-edil').indexOf('faclair.com')>0) {
                    html += ' (Dwelly)';
                }
                $.ajaxSetup({async: false});
                $.getJSON('../../Coding/Scripts/ajax.php?action=getDwelly&edil=' + $(span).children('.word').attr('data-edil'), function (g) {
                    if (g.hw != '') { html += ', <a href="' + g.url + '" target="_new">' + g.hw + '</a> (Dwelly)'; }
                });
                html += '</li>';
            }
            if ($(span).children('.syntagm').length>1) {
                html += '<li>is a syntactically complex form containing the following elements:';
                html += '<ul>';
                $(span).children('.syntagm').each(function() {
                    html = html + '<li>' + makeSyntax($(this),true) + '</li>';
                });
                html += '</ul>';
                html += '</li>';
            }
            /*
         else if ($(span).children('.syntagm').length==1 && $(span).children('.syntagm').children('.syntagm').length>0) {
           htmlx += '<li>is a syntactically complex form containing the following elements:';
           htmlx += '<ul>';
           $(span).children('.syntagm').children('.syntagm').each(function() {
             htmlx = htmlx + '<li>' + makeSyntax($(this),true) + '</li>';
           });
           htmlx += '</ul>';
           htmlx += '</li>';
         }
         else if ($(span).children('.addition, .deletion').length>0) {
           htmlx += '<li>is a syntactically complex form containing the following elements:';
           htmlx += '<ul>';
           $(span).children('.syntagm').add($(span).children('.addition').add($(span).children('.deletion')).children('.syntagm')).each(function() {
             htmlx = htmlx + '<li>' + makeSyntax($(this),true) + '</li>';
           });
           htmlx += '</ul>';
           htmlx += '</li>';
         }
          */
            else {
                html += '<li>is a syntactically simple form</li>';
            }
            if($(span).attr('data-lemmasl')) {
                html += '<li>appears in the HDSG/RB collection of headwords: <a href="' + $(span).attr('data-slipref') + '" target="_new">' + $(span).attr('data-lemmasl') + '</a></li>';
            }
        }
        if (rec) {
            html += '</ul>';
        }
        return html;

        /*
        if (!rec && $(span).find('.suppliedDiplo').length>0) {
          html += '<li>contains editorial supplements:<ul>';
          //html += $(span).text();
          $(span).find('.suppliedDiplo').each(function() {
            html = html + '<li><span style="color: green;">' + $(this).text() + '</span> ';
            html += '</li>';
          });
          html += '</ul></li>';
        }
        if (!rec && $(span).find('.suppliedSemi').length>0) {
          html += '<li>contains the following supplied sequences:<ul>';
          $(span).find('.suppliedSemi').each(function() {
            html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> ';
            html += '</li>';
          });
          html += '</ul></li>';
        }

        if (!rec && $(span).find('.damagedSemi').length>0) {
          html += '<li>contains the following damaged sequences:<ul>';
          $(span).find('.damagedSemi').each(function() {
            html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> ';
            html += '</li>';
          });
          html += '</ul></li>';
        }

        else if (!rec && $(span).find('.obscureTextSemi').length>0) {
          html += '<li>contains the following sequences of obscured text:<ul>';
          $(span).find('.obscureTextSemi').each(function() {
            html = html + '<li><span style="color: green;">[</span>' + $(this).text() + '<span style="color: green;">]</span> ';
            html += '</li>';
          });
          html += '</ul></li>';
        }
        else if (!rec && $(span).parents('.obscureTextSemi').length>0) {
          html += '<li>part of the following sequence of obscured text:<ul>';
          html = html + '<li><span style="color: green;">[</span>' + $(span).parents('.obscureTextSemi').text() + '<span style="color: green;">]</span> ';
          html += '</li>';
          html += '</ul></li>';
        }
        html += '</ul>';
         */
    }

    function decode(lang) {
        switch (lang) {
            case 'la':
                return 'Latin';
            case 'sco':
                return 'Scots';
            case "gk":
                return 'Greek';
            case 'hbo':
                return 'Ancient Hebrew';
            case 'jpa':
                return 'Aramaic';
            case 'en':
                return 'English';
            case 'und':
                return 'unknown';
            default:
                return lang;
        }
    }

    function getDamage(span) {
        html2 = '';
        if ($(span).find('.unclearDamageDiplo').length>0) {
            html2 += 'Contains the following damaged sections:<ul>';
            $(span).find('.unclearDamageDiplo').each(function() {
                html2 = html2 + '<li>[' + $(this).attr('data-add') + '] ';
                html2 = html2 + '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
                html2 += ' certainty)</li>';
            });
            html2 += '</ul>';
        }
        if ($(span).find('.unclearTextObscureDiplo').length>0) {
            html2 += 'Contains the following obscured sections:<ul>';
            $(span).find('.unclearTextObscureDiplo').each(function() {
                html2 = html2 + '<li>[' + $(this).text() + '] ';
                html2 = html2 + '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
                html2 += ' certainty)</li>';
            });
            html2 += '</ul>';
        }
        if ($(span).find('.unclearCharDiplo').length>0) {
            html2 += 'Contains the following unclear characters:<ul>';
            $(span).find('.unclearCharDiplo').each(function() {
                html2 = html2 + '<li>[' + $(this).text() + '] ';
                html2 = html2 + '(' + $(this).attr('data-resp') + ', ' + $(this).attr('data-cert');
                html2 += ' certainty)</li>';
            });
            html2 += '</ul>';
        }
        if ($(span).parents('.unclearTextObscureDiplo').length>0) {
            html2 += 'This is part of an obscured section.';
        }
        if ($(span).parents('.unclearInterpObscureDiplo').length>0) {
            html2 += 'This is part of a section whose interpretation is obscure.';
        }
        return html2;
    }

    function getDeletions(span) {
        html2 = '';
        if ($(span).find('.deletionDiplo').length>0) {
            html2 += 'Contains the following deletions:<ul>';
            $(span).find('.deletionDiplo').each(function() {
                html2 = html2 + '<li>[' + $(this).text() + '] ';
                html2 = html2 + '(' + $(this).attr('data-hand');
                html2 += ')</li>';
            });
            html2 += '</ul>';
        }
        return html2;
    }

    function getAdditions(span) {
        html2 = '';
        if ($(span).find('.insertion').length>0) {
            html2 += 'Contains the following insertions:<ul>';
            $(span).find('.insertion').each(function() {
                html2 = html2 + '<li>[' + $(this).text() + '] ';
                html2 = html2 + '(' + $(this).attr('data-hand');
                html2 = html2 + ', '  + $(this).attr('data-place');
                html2 += ')</li>';
            });
            html2 += '</ul>';
        }
        else if ($(span).parents('.insertion').length>0) {
            html2 += 'Is part of the following insertion:<ul>';
            html2 = html2 + '<li>[' + $(span).parents('.insertion').text() + '] ';
            html2 = html2 + '(' + $(span).parents('.insertion').attr('data-hand');
            html2 = html2 + ', ' + $(span).parents('.insertion').attr('data-place');
            html2 += ')</li>';
            html2 += '</ul>';
        }
        return html2;
    }

    function reindex(span) { // prefixes all ids in some html
        //console.log(span.html());
        //dom = $.parseHTML(span);
        //console.log(typeof span);
        //span2 = $('#rightPanel').find('.lineBreak').remove();
        $(span).find('.lineBreak').remove();
        console.log(span);
        //$('.lineBreak').remove()
        //console.log(span2.html());
        //delete all <span class="lineBreak"> elements from inside span;
        return $(span).html().replace(/id="/g, 'id="xx');
    }

    function clean(str) { // remove form content from headword strings at linebreaks
        var i = str.indexOf('[+]');
        var k = str.indexOf(' (');
        if (i != -1) {
            var j = str.indexOf('[?]');
            str2 = str.slice(0,i) + str.slice(j+4, str.length);
        }
        else if (k != -1) {
            var j = str.indexOf(') ');
            str2 = str.slice(0,k) + str.slice(j+2, str.length);
        }
        else str2 = str;
        str = str2.replace(/[:=]/g,'');
        return str;
    }

    function extractExpansions(html) {
        /*
          oot = '';
          if ($(html).hasClass('expansion')) {
            var id = 'exp' + Math.floor((Math.random() * 10000) + 1);
            console.log(id);
            oot = '<span class="expansion" id="' + id + '">';
            oot += $(html).text();
            oot += '</span>';
          }
          else {
            $(html).children().each();
          }
          */
        return clean($(html).text());
    }

    /*
      Show/hide marginal notes
      Added by Sb
     */
    $('.marginalNoteLink').on('click', function() {
        var id = $(this).attr('data-id').replace(/\./g, '\\.');
        $('#'+id).toggle();
    });

});


// gives the selected laisse the class you want.
//takes the input field and turns it into a laisse number

function hide_footer(){
    // hides the footer
    if(document.getElementById('TEI_reader') !== null){
        $(".footer").css('display','none');
    }
}


function assign_note_numbers(){
    // gets the xml id of the nodes and assigns them once the page has loaded.
        $.each($('sup'), function(item){
        var xml_id = this.parentNode.getAttribute('rightnum');
        var the_num = String($("note[xml=" + String(xml_id) + "]").attr("n"));
        $('note[rightnum="' + String(xml_id) +'"] sup').prepend(the_num);
    });
}

$(function annotation_reveal(){
    // reveal an annotation when clicked
    $('sup').click(function(){
        var annotation_number = this.parentNode.getAttribute('rightnum');
        $('#TEI_reader').unwrap();
        $("footnote").removeClass('visible');
        $('#note-header').addClass('visible');
        $('note').removeClass('visible');
        $('.note-contents note').addClass('hidden');
        // var anno_number = $("this").attr('n');
        $("note[xml=" + String(annotation_number) + "]").addClass("visible");
        $('#back_to_intro').addClass('visible');
        $('#note-header').removeClass('hidden');
        $('.note-contents').removeClass('hidden');
        $('#notes').css('display', 'block');
        $('#TEI_reader').css('margin-left', '0%');
    });
});

$(function close_sidepanel(){
    // close the notes panel when the x is clicked
    $('#note-close').click(function(){
       var notePanel = document.getElementById("notes");
       var bibToggle = document.getElementById("bibToggle");
       if (notePanel.style.display != "none") {
          notePanel.style.display = "none";
          $('#TEI_reader').wrap('<div id="reader-center-div">');
       } else {
          notePanel.style.display = "block";
       }
    });
});

// Not implementing yet, but will be used for the diplomatic/scribal bits.
function toggle_sic_on(){
    $("corr").removeClass('visible');
    $('sic').addClass('visible');
}

function toggle_sic_off(){
    $('sic').removeClass('visible');
    $("corr").addClass('visible');
}

function page_prep(){
    // prepare the page on load
    var current_laisse_long = $('.translation_missing').text();
    if(current_laisse_long){
         var re = new RegExp('[0-9]*\/');
        var current_laisse = re.exec(current_laisse_long)[0].slice(0,-1);
        $("#selected_laisse").val(current_laisse);
        $("#bot_laisse").val(current_laisse);
    }
    else{
        $("#selected_laisse").val(1);
        $("#bot_laisse").val(1);
    }
    // reveal_laisse();
    assign_note_numbers();
    hide_footer();
}

$(function corr_toggle(){
    // if the corrections checkbox is checked, corr tags get highlighted
    $('#corrCheckbox').click(function(){
        console.log('hi');
        var checked = $('#corrCheckbox').prop('checked');
        if (checked) {
            console.log('on');
            $('corr').css('color', 'red');
        }
        else {
            console.log('off');
            $('corr').css('color', 'black');
        }
    });
});

$(function image_reveal(){
    $('#image-reveal').click(function(){
    $('#ms-image-container').css('display', 'inline');
    });
});

$(document).ready(function(){
    page_prep();
});

$(document).on("page:load", function() {
    page_prep();
});

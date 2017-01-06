
// gives the selected laisse the class you want.
//takes the input field and turns it into a laisse number
function display_intro(){
    $('#notes').removeClass('visible');
    $('#hidden-introduction').addClass('visible');
    $('#note-header').removeClass('visible');
    $('#note-header').addClass('hidden');
    $('.note-contents').addClass('hidden');
    $('.note-contents').removeClass('visible');
}

function hide_footer(){
    if(document.getElementById('TEI_reader') !== null){
        $(".footer").css('display','none');
    }
}

function annotation_reveal(annotation_number){
    $('#hidden-introduction').css('display','none');
    $('#hidden-introduction').removeClass('visible');
    $("footnote").removeClass('visible');
    $('#note-header').addClass('visible');
    $('note').removeClass('visible');
    $('.note-contents note').addClass('hidden');
    // var anno_number = $("this").attr('n');
    $("note[xml=" + String(annotation_number) + "]").addClass("visible");
    $('#back_to_intro').addClass('visible');
    $('#note-header').removeClass('hidden');
    $('.note-contents').removeClass('hidden');
}

function toggle_sic_on(){
    $("corr").removeClass('visible');
    $('sic').addClass('visible');
}

function toggle_sic_off(){
    $('sic').removeClass('visible');
    $("corr").addClass('visible');
}

function page_prep(){
    $("#selected_laisse").val(1);
    $("#bot_laisse").val(1);
    // reveal_laisse();
    hide_footer();
}

$(document).ready(function(){
    page_prep();
});

$(document).on("page:load", function() {
    page_prep();
});

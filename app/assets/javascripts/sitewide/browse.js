
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

function link_note_numbers(xml_id){
    console.log('===');
    console.log(xml_id);
    console.log($("note[xml=" + String(xml_id) + "]"));
    var the_num = String($("note[xml=" + String(xml_id) + "]").attr("n"));
    console.log(the_num);
    $('note[rightnum="' + String(xml_id) +'"] sup').prepend(the_num);
}

function annotation_reveal(annotation_number){
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
}

function hideNotes() {
   var notePanel = document.getElementById("notes");
   var bibToggle = document.getElementById("bibToggle");
   if (notePanel.style.display != "none") {
      notePanel.style.display = "none";
      $('#TEI_reader').wrap('<div id="reader-center-div">');
   } else {
      notePanel.style.display = "block";
   }
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

function reveal_corrections(){
    var checked = $('#corrCheckbox').prop('checked');
    if (checked) {
        console.log('on');
        $('corr').css('color', 'red');
    }
    else {
        console.log('off');
        $('corr').css('color', 'black');
    }
}


$(document).ready(function(){
    page_prep();
});

$(document).on("page:load", function() {
    page_prep();
});

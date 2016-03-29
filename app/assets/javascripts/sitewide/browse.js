
// gives the selected laisse the class you want.
//takes the input field and turns it into a laisse number
function select_laisse(){
    if (document.getElementById("selected_laisse") == null){
        var laisse = 1;
    }
    else{ 
        var laisse = document.getElementById("selected_laisse").value;
    }
    return parseInt(laisse);
};

function hide_laisse(){
    // cleans out previously visible laisses if they exist.
    $(document).find(".visible").removeClass("visible");

}

function reveal_laisse(){
    hide_laisse();

    // looks to the input field to and loads that in to select the appropiate laisse.
    var selected_laisse = select_laisse();

    // makes that laisse vissible.
    if(selected_laisse > 0 && selected_laisse <= $("lg").length){
        $("lg[n=" + selected_laisse + "], #bottom-buttons, #tei-hr-1").addClass("visible");
    } else if ($("lg").length !== 0){
        window.alert("Please type a number between 1 and " + $("lg").length + ", the number of laisses in this edition.");
    };
};

function reveal_all(){
    // makes all laisses visible
    $("lg, #bottom-buttons, #tei-hr-1").addClass('visible');
};

function hide_all(){
    // hides all laisses
    $("lg, #bottom-buttons, #tei-hr-1").removeClass("visible");
};

function browse_next(){
    var current_laisse = document.getElementById("selected_laisse").value;
    if((parseInt(current_laisse)+1) <= $("lg").length){
        hide_laisse();
        $("lg[n=" + (parseInt(current_laisse) + 1) + "], #bottom-buttons,#tei-hr-1").addClass("visible");
        $("#selected_laisse").val(parseInt(current_laisse)+1);
    };
};

function browse_previous(){
    var current_laisse = document.getElementById("selected_laisse").value;
    if((parseInt(current_laisse)-1) >=1){
        hide_laisse();
        //reveal the new laisse
         $("lg[n=" + (parseInt(current_laisse) - 1) + "], #bottom-buttons,#tei-hr-1").addClass("visible");
        
        // change the old value
        $("#selected_laisse").val(parseInt(current_laisse)-1);
    }
};


function display_laisse_num(){
    var num_laisses =  $("lg").length + " laisses in this edition.";
    $("#num_laisses").text(num_laisses);
};

function hide_footer(){
    if(document.getElementById('TEI_reader') != null){
        $(".footer").css('display','none');
    };
};

function annotation_reveal(annotation_number){
    $("footnote").removeClass('visible');
    // var anno_number = $("this").attr('n');
    $("footnote[id=" + annotation_number + "]").addClass("visible");
};

function toggle_sic_on(){
    $("corr").removeClass('visible');
    $('sic').addClass('visible');
}

function toggle_sic_off(){
    $('sic').removeClass('visible');
    $("corr").addClass('visible');
}


$(document).ready(function(){
    display_laisse_num();
    $("#selected_laisse").val(1);
    reveal_laisse();
    hide_footer();
});
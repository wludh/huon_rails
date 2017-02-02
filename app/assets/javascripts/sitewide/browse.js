var ready;
    ready = function(){
        function hide_footer(){
        // hides the footer
        if(document.getElementById('TEI_reader') !== null){
            $(".footer").hide();
        }
    }

    // function hide_footer(){
    //     // hides the footer
    //     if(document.getElementById('TEI_reader') !== null){
    //         $(".footer").css('display','none');
    //     }
    // }

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
            hide_non_active_panels();
            $('.note-contents note').hide();
            var annotation_number = this.parentNode.getAttribute('rightnum');
            $('#note-header').show();
            $("note[xml=" + String(annotation_number) + "]").show();
            $("note[xml=" + String(annotation_number) + "]").addClass('active-element');
            $('.note-contents.hidden').show();
            $('#side-panel').css('display', 'block');
            open_sidepanel();
        });
    });

    // $(function annotation_reveal(){
    //     // reveal an annotation when clicked
    //     $('sup').click(function(){
    //         hide_non_active_panels();
    //         $('.note-contents note').addClass('hidden');
    //         var annotation_number = this.parentNode.getAttribute('rightnum');
    //         $('#note-header').addClass('visible');
    //         $("note[xml=" + String(annotation_number) + "]").addClass("visible");
    //         $('.note-contents.hidden').removeClass('hidden');
    //         $('#side-panel').css('display', 'block');
    //         open_sidepanel();
    //     });
    // });

    function open_sidepanel(){
        $('#TEI_reader').unwrap();
        $('#TEI_reader').css('margin-left', '0%');
        $('#tei_wrapper').css('border-right', '1px #DDDDDD solid');
    }

    function hide_image(){
        $('#image-header').hide();
        $('#ms-image').hide();
        $('#image-header').removeClass('active-element');
        $('#ms-image-container').hide();
    }

  // function hide_image(){
  //       $('#image-header').removeClass('visible');
  //       $('#ms-image').removeClass('visible');
  //       $('#ms-image-container').removeClass('visible');
  //   }

    function hide_notes(){
        $('note.active-element').hide();
        $('note.active-element').removeClass('active-element');
        $('#note-header').hide();
    }

    // function hide_notes(){
    //     $('note.visible').removeClass('visible');
    //     $('#note-header').removeClass('visible');
    // }

    function hide_tei(){
        $('#tei-embed-container').hide();
        $('#tei-embed-header').hide();
        $('#tei-embed-header').removeClass('active-element');
        $('#tei-embed').hide();
    }

    // function hide_tei(){
    //     $('#tei-embed-container').removeClass('visible');
    //     $('#tei-embed-header').removeClass('visible');
    //     $('#tei-embed').removeClass('visible');
    // }


    $(function close_sidepanel(){
        // close the notes panel when the x is clicked
        $('#note-close').click(function(){
            hide_tei();
            hide_notes();
            hide_image();
           var notePanel = document.getElementById("side-panel");
           var bibToggle = document.getElementById("bibToggle");
           if (notePanel.style.display != "none") {
                notePanel.style.display = "none";
                $('#TEI_reader').wrap('<div id="reader-center-div">');
                $('#tei_wrapper').css('border-right', 'none');
           } else {
              notePanel.style.display = "block";
           }
        });
    });

    function hide_non_active_panels(){
        if ($('#image-header.active-element').length > 0){
            hide_image();
        }
        if ($('note.active-element').length > 0){
            hide_notes();
        }
        if ($('#tei-embed-header.active-element').length > 0){
            hide_tei();
        }
    }

    // Not implementing yet, but will be used for the diplomatic/scribal bits.
    function toggle_sic_on(){
        $("corr").hide();
        $('sic').show();
    }

    // function toggle_sic_on(){
    //     $("corr").removeClass('visible');
    //     $('sic').addClass('visible');
    // }


    function toggle_sic_off(){
        $('sic').hide();
        $("corr").show();
    }


    // function toggle_sic_off(){
    //     $('sic').removeClass('visible');
    //     $("corr").addClass('visible');
    // }


    function page_prep(){
        // prepare the page on load
        assign_note_numbers();
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
        hide_footer();
    }

    $(function corr_toggle(){
        // if the corrections checkbox is checked, corr tags get highlighted
        $('#corrCheckbox').click(function(){
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
            hide_non_active_panels();
            $('#image-header').addClass('active-element');
            $('#image-header').show();
            $('#ms-image-container').show();
            $('#ms-image').show();
            $('#side-panel').css('display', 'block');
            // $('#ms-image').css('display', 'block !important');
            open_sidepanel();
        });
    });

    // $(function image_reveal(){
    //     $('#image-reveal').click(function(){
    //         hide_non_active_panels();
    //         $('#image-header').addClass('visible');
    //         $('#ms-image-container').addClass('visible');
    //         $('#ms-image').addClass('visible');
    //         $('#side-panel').css('display', 'block');
    //         $('#ms-image').css('display', 'block !important');
    //         open_sidepanel();
    //     });
    // });

    // $('#tei-reveal').click(function(){
    //         $('#loading-gif').css('display', 'inline');
    //         $('#loading-gif').addClass('visible');
    // });

    $(function tei_reveal(){
        $('#tei-reveal').click(function(){
            // $('#loading-gif').css('display', 'inline');
            // $('#loading-gif').addClass('visible');
            // $('#loading-gif').html('<img src="https://raw.githubusercontent.com/wludh/huon_rails/master/app/assets/images/ajax-loader.gif" />');
            hide_non_active_panels();
            // this is not working quite right
            $('#tei-embed-header').show();
            $('#tei-embed-header').addClass('active-element');
            $('#side-panel').show();
            $('#tei-embed-container').show();
            console.log('hi');
            $('#tei-embed-header').text('Loading TEI');
            $('#tei-embed-container').css('display', 'inline');
            open_sidepanel();

            $.ajax({
                success: function(){
                    $('#tei-embed-header').text('TEI');
                    $('#tei-embed').show();
                }
            });
            $.ajax({
                success:function(){
                    $('#loading-gif').hide();
                }
            });
        });
    });

    // $(function tei_reveal(){
    //     $('#tei-reveal').click(function(){
    //         // $('#loading-gif').css('display', 'inline');
    //         // $('#loading-gif').addClass('visible');
    //         // $('#loading-gif').html('<img src="https://raw.githubusercontent.com/wludh/huon_rails/master/app/assets/images/ajax-loader.gif" />');
    //         $('#tei-embed-header').addClass('visible');
    //         $('#side-panel').css('display', 'block');
    //         $('#tei-embed-container').addClass('visible');
    //         $('#tei-embed-header').text('Loading TEI');
    //         $('#tei-embed-container').css('display', 'inline');
    //         hide_non_active_panels();
    //         open_sidepanel();

    //         $.ajax({
    //             success: function(){
    //                 $('#tei-embed-header').text('TEI');
    //                 $('#tei-embed').addClass('visible');
    //                 $('#tei-embed').css('display', 'block');
    //             }
    //         });
    //         $.ajax({
    //             success:function(){
    //                 $('#loading-gif').removeClass('visible');
    //                 $('#loading-gif').css('display', 'none');
    //             }
    //         });
    //     });
    // });
    page_prep();
};

$(document).ready(ready);
$(document).on("page:load", ready);

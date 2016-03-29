$(document).on "turbolinks:load", ->
    display_laisse_num()
    $("#selected_laisse").val(1)
    reveal_laisse()
    hide_footer()
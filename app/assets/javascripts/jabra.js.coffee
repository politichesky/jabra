$ ->
    $('.item').click -> # expand/turn items
        $(this).nextAll(".item-info:first").fadeToggle(500)
    setTimeout("$('.flash').fadeOut(1000)",5000) #hide flash message after 5 seconds

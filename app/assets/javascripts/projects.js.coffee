# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
    if $('#project_public').attr("checked") == undefined
        $('.allow-users').show()

    $('#project_public').click ->
        $('.allow-users').fadeToggle(1000)

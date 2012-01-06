# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
    $(".reply-link").click ->
        parent_id = $(this).prev().val()
        parent_DIV = $(this).parents(".right")
        parent_DIV.children("#new_comment").children("#comment_parent_id").val(parent_id)
        return false

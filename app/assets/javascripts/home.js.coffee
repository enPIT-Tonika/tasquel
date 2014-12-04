# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  $('textarea').autosize();

  $("#descArea input").click ->
      $('#desc_text').css('border', '0px');
      $('#desc_text').css('background', '#eeeeee');
     
  $("#desc_text").blur ->  
      $('#desc_text').css('border', '0px');
      $('#desc_text').css('background', '#eeeeee');

   $("#desc_text").click ->
     $('#desc_text').css('border', '1px');
     $("#desc_text").css('background', '#ffffff');
     $("#desc_text").focus();
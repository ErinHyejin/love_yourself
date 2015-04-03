$(document).ready(function() {
  $(".complete-button").on('click', function(event){
    event.preventDefault();

    $.ajax({
      type: 'PUT',
      url: $(this).attr("href"),
    })
    .done(function(response) {
      if (response['completed']) {
        $("#"+response['id']+" .complete-button").addClass('completed');
      } else {
        $("#"+response['id']+" .complete-button").removeClass('completed');
      }
    })
  });

});

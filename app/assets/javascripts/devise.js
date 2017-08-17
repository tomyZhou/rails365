$(function($) {
  $("#new_comment").bind('ajax:error', function (e, xhr, settings) {
    if (xhr.status == 401) {
      swal({title: xhr.responseText}, function() {
        window.location.replace('/users/sign_in')
      });
    }
  });
});

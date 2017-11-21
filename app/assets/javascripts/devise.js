$(function($) {
  $("#new_comment, a[data-remote]").bind('ajax:error', function (e, xhr, settings) {
    if (xhr.status == 401) {
      swal({title: xhr.responseText}, function() {
        window.location.replace('/users/sign_in')
      });
    }
  });
});

// $.ajaxSetup({
//   statusCode: {
//     401: function() {
//
//       // Redirect the to the login page.
//       location.href = "/login";
//
//     }
//   }
// });

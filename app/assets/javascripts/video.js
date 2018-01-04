$(window).keypress(function(e) {
  var video = document.getElementById("vid");
  if (e.which == 32) {
    if (video.paused == true) {
      video.play();
    } else {
      video.pause();
    }
    e.preventDefault();
  }
});

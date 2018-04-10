$(document).on('ready', function () {
  var isLoading = false;
  if ($('.my-pagination').size() > 0) {
    $(window).on('scroll', function() {
      var more_posts_url = $('.my-pagination a').attr('href');
      if (!isLoading && more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 682) {
        isLoading = true;
        $('.pagination-text').html("正在加载下一页 <img src='/ajax-loader.gif' />");
        setTimeout(function() {
          $.getScript(more_posts_url).done(function (data,textStatus,jqxhr) {
            isLoading = false;
          }).fail(function() {
            isLoading = false;
          });
        }, 1000);
      }
    });
  }
});

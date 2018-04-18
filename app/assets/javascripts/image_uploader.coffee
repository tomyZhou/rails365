(($) ->
  $.fn.image_uploader = () ->
    _this = $(this)
    _this.on 'click', ->
      $("#image").click()
    $("#image").bind('fileuploadadd', (e, data) ->
      _this.find(".fa").removeClass('fa-image').addClass('fa-circle-o-notch fa-spin')
    ).bind('fileuploaddone', (e, data) ->
      _this.find(".fa").removeClass('fa-circle-o-notch fa-spin').addClass('fa-image')
      _this.closest('form').find('textarea').insertAtCaret("![]" + "(" + data.result + ")");
    ).bind('fileuploadfail', (e, data) ->
      new PNotify
        text: data._response.errorThrown
        type: 'error'
      _this.find(".fa").removeClass('fa-circle-o-notch fa-spin').addClass('fa-image')
    ).fileupload
      url: "/photos"
      type: "PATCH"
      formData: {}
      
) jQuery

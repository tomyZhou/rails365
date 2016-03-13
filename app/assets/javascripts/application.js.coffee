#= require jquery
#= require jquery_ujs
#= require jquery-fileupload/basic
#= require jquery.caret
#= require form_storage
#= require bootstrap/dropdown
#= require bootstrap/collapse
#= require bootstrap/alert
#= require jquery.checkall
#= require qrcode
#= require jquery.fluidbox.min
#= require jquery.lazyload
#= require rails-timeago
#= require locales/jquery.timeago.zh-CN.js

jQuery ->
  $("img.lazy").lazyload()

# jQuery ->
#   flash = [
#     "info"
#     "success"
#     "danger"
#     "warning"
#   ]
#   for key of flash
#     select = ".alert-autocloseable-" + flash[key]
#     $(select).delay(5000).fadeOut()  if $(select).length > 0

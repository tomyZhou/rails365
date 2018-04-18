App.web = App.cable.subscriptions.create "WebChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    if data.length
      json_data = JSON.parse(data)
      notice = new PNotify
        title: json_data["title"]
        text: json_data["content"]
        icon: 'fa fa-bullhorn'
        buttons:
          closer: false,
          sticker: false
        desktop:
          desktop: false
      notice.get().click ->
        notice.remove()

App.notification = App.cable.subscriptions.create "NotificationChannel",
  connected: ->
    Notification.requestPermission()
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    console.log(data)
    if data.length
      json_data = JSON.parse(data)

      notification = new Notification json_data["title"],
        # body: "#{event.data}"
        body: json_data["content"]
        icon: "https://www.rails365.net/favicon.ico"
      notification.onclick = () ->
        window.location.href = json_data["url"]

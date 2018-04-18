class WebChannel < ApplicationCable::Channel
  def subscribed
    stream_from "web_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end

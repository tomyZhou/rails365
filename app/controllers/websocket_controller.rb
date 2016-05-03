class WebsocketController < ApplicationController
  include Tubesock::Hijack
  def ws
    hijack do |tubesock|
      redis_thread = Thread.new do
        Redis.new.subscribe "ws" do |on|
          on.message do |channel, message|
            tubesock.send_data message
          end
        end
      end

      tubesock.onclose do
        redis_thread.kill
      end
    end
  end
end

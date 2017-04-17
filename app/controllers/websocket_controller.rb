class WebsocketController < ActionController::Base
  include Tubesock::Hijack
  def ws
    hijack do |tubesock|
      redis_thread = Thread.new do
        Redis.new.subscribe 'ws' do |on|
          on.message do |channel, message|
            tubesock.send_data message
          end
        end
      end

      tubesock.onmessage do |m|
        # pub the message when we get one
        # note: this echoes through the sub above
        Redis.new.publish "ws", m
      end

      tubesock.onclose do
        redis_thread.kill
      end
    end
  end
end

# BLOCK_MESSAGE = ['你请求过快，超过了频率限制，暂时屏蔽一段时间。'.freeze]
#
# class Rack::Attack
#   Rack::Attack.cache.store = Rails.cache
#
#   ### Throttle Spammy Clients ###
#   throttle('req/ip', limit: 300, period: 5.minutes) do |req|
#     req.ip unless req.path.start_with?('/mini-profiler-resources')
#   end
#
#   ### Custom Throttle Response ###
#   self.throttled_response = lambda do |_env|
#     [503, {}, BLOCK_MESSAGE]
#   end
# end
#
# ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, request_id, req|
#   Rails.logger.info "  RackAttack: #{req.ip} #{request_id} blocked."
# end

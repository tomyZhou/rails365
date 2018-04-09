module SendSystemHistory
  def self.send_system_history(username, notify_type, target)
    system_history = $redis.lrange "system_history", 0, -1
    message = "#{username} #{notify_type} #{target}"
    if system_history.present? && !system_history.include?(message)
      $redis.lpush "system_history", message
      $redis.ltrim "system_history", 0, 19
    end
  end
end

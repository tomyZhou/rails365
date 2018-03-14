class UserPayExpiredWorker
  include Sidekiq::Worker

  def perform
    User.set_expired_time
  end
end


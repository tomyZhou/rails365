class BgSaveUserMovieHistoryWorker
  include Sidekiq::Worker

  def perform
    User.bg_save_movie_history
    User.bg_send_aliyun_avatar
  end
end

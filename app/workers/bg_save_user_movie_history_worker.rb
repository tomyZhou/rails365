class BgSaveUserMovieHistoryWorker
  include Sidekiq::Worker

  def perform
    User.bg_save_movie_history
  end
end

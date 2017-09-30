class CreateMovieWorker
  include Sidekiq::Worker

  def perform(user_id, movie_params)
    Movie.async_create(user_id, movie_params)
  end
end

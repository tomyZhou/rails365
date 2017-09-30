class UpdateMovieWorker
  include Sidekiq::Worker

  def perform(movie_id, movie_params)
    Movie.async_update(movie_id, movie_params)
  end
end

class UpdateMovieWorker
  include Sidekiq::Worker

  def perform(movie_id, movie_params)
    movie = Movie.find(movie_id)
    Redis.new.publish 'ws', {title: 'rails365 更新了视频', content: movie.title}.to_json
    Movie.async_update(movie_id, movie_params)
  end
end

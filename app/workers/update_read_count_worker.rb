class UpdateReadCountWorker
  include Sidekiq::Worker

  def perform
    Article.update_visit_count
    Movie.update_visit_count
    Movie.increment_random_read_count
    Article.increment_random_read_count
    Soft.update_visit_count
  end
end

class UpdateReadCountWorker
  include Sidekiq::Worker

  def perform
    Article.update_visit_count
    Movie.update_visit_count
    Soft.update_visit_count
  end
end

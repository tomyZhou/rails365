class UpdateReadCountWorker
  include Sidekiq::Worker

  def perform
    Article.update_visit_count
    Movie.update_visit_count
    Soft.update_visit_count

    # Top 10 点击自动随机增长
    top_10_video_auto_increment = Admin::SiteInfo.fetch_by_key('top_10_video_auto_increment').try(:value)
    if top_10_video_auto_increment.present? && top_10_video_auto_increment != "空"
      Movie.increment_random_read_count
    end

    top_10_article_auto_increment = Admin::SiteInfo.fetch_by_key('top_10_article_auto_increment').try(:value)
    if top_10_article_auto_increment.present? && top_10_article_auto_increment != "空"
      Article.increment_random_read_count
    end
  end
end

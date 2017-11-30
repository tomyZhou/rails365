include Rails.application.routes.url_helpers

namespace :baidu_article do
  desc "baidu article"
  task puts: :environment do
    Article.all.each do |article|
      puts "https://www.rails365.net" + article_path(article)
    end
  end
end

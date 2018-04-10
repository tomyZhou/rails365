class BackfillArticlesActivity < ActiveRecord::Migration
  def up
    Article.find_each do |article|
      puts "处理 article #{article.title}"
      article.create_activity :create, created_at: article.created_at, updated_at: article.updated_at, owner: article.user
      puts "处理 article 完毕"
      puts "--------------"
      if article.comments.present?
        article.comments.each do |comment|
          puts "处理 comment #{comment.body}"
          comment.create_activity :create, owner: comment.user, recipient: article, created_at: comment.created_at, updated_at: comment.updated_at
        end
      end
      puts "处理 comment 完毕"
      puts "--------------"
    end
  end

  def down
    PublicActivity::Activity.delete_all
  end
end

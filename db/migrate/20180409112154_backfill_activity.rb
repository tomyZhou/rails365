class BackfillActivity < ActiveRecord::Migration
  def up
    Movie.where(is_original: true).find_each do |movie|
      puts "处理 movie #{movie.title}"
      movie.create_activity :create, created_at: movie.created_at, updated_at: movie.updated_at, owner: movie.user
      puts "处理 movie 完毕"
      puts "--------------"
      if movie.comments.present?
        movie.comments.each do |comment|
          puts "处理 comment #{comment.body}"
          comment.create_activity :create, owner: comment.user, recipient: movie, created_at: comment.created_at, updated_at: comment.updated_at
        end
      end
      puts "处理 comment 完毕"
      puts "--------------"

      if movie.likers_by(User).present?
        movie.likers_by(User).each do |like|
          puts "处理 like #{like.likee.title}"
          movie.create_activity key: 'movie.like', owner: like.liker, created_at: like.created_at, updated_at: like.updated_at
        end
      end
      puts "处理 like 完毕"
      puts "--------------"
    end
  end

  def down
    PublicActivity::Activity.delete_all
  end
end

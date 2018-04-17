class Cache
  # 最新视频
  def self.movies(count = 10)
    Rails.cache.fetch "movies_#{count}" do
      Movie.except_body_with_default.where(is_original: true).order('id DESC').limit(count).to_a
    end
  end

  def self.new_articles
    Rails.cache.fetch "new_articles" do
      Article.except_body_with_default.order('id DESC').limit(3).to_a
    end
  end

  # 置顶的文章
  def self.top_articles
    Rails.cache.fetch "top_articles" do
      Article.except_body_with_default.where(is_top: true).order(weight: :asc)
    end
  end

  # 热门播放列表
  def self.article_playlists
    Rails.cache.fetch "article_playlists" do
      Playlist.where(is_original: true).order(weight: :desc).limit(4).to_a
    end
  end

  # 新用户
  def self.new_users
    Rails.cache.fetch "new_users" do
      User.order(id: :desc).limit(5).to_a
    end
  end

  # 活跃用户
  def self.active_weight_users
    Rails.cache.fetch "active_weight_users" do
      User.order(active_weight: :desc, id: :desc).limit(5).to_a
    end
  end

  # 所有分类
  def self.group_all
    Rails.cache.fetch 'group_all' do
      Group.order(weight: :desc).to_a
    end
  end
end

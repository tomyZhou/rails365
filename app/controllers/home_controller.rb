class HomeController < ApplicationController
  def index
    ahoy.track "首页", {language: "Ruby"}

    @articles =
      if params[:search].present?
        Article.search params[:search], fields: [:title, :body], highlight: true, misspellings: false, includes: [:group, :user], page: params[:page], per_page: 20
      elsif params[:find].present? && params[:find] == 'hot'
        Article.except_body_with_default.order('visit_count DESC').page(params[:page])
      else
        Article.except_body_with_default.order('id DESC').page(params[:page])
      end

    @groups = Cache.group_all

    # 置顶的文章
    @top_articles = Cache.top_articles

    # 新用户
    @new_users = Cache.new_users

    # 活跃用户
    @active_weight_users = Cache.active_weight_users

    # 文章原创用户
    @users = User.where(id: Article.pluck(:user_id).uniq)

    # 热门播放列表
    @playlists = Cache.article_playlists

    @movies = Cache.movies

    # @activities = PublicActivity::Activity.where("trackable_type != 'Article' AND (trackable_type = 'Movie' OR (trackable_type = 'Comment' AND recipient_type != 'Article')) ").order(created_at: :desc).limit(5)
    # 高好的写法如下:
    @activities = PublicActivity::Activity.where.not("trackable_type = 'Article' OR (trackable_type = 'Comment' AND recipient_type = 'Article') ").order(created_at: :desc).limit(5)

    # banner说明文
    @site_info_home_desc = Admin::SiteInfo.fetch_by_key('home_desc').try(:value)

    @system_history = $redis.lrange "system_history", 0, -1

    if request.xhr?
      render 'articles/index.js.erb'
    end

    # respond_to do |format|
    #   format.all { render :index, formats: [:html, :js] }
    # end
  end

  def find
    if params[:tp] == "articles"
      redirect_to articles_path(tp: 'articles', search: params[:search])
    else
      redirect_to movies_path(tp: 'movies', search: params[:search])
    end
  end

  def about_us
    @title = '关于'
  end

  def vip
    @title = '订阅本站'
  end
end

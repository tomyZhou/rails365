require 'babosa'
class Soft < ActiveRecord::Base
  searchkick highlight: [:title, :body]

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  include IdentityCache
  cache_index :slug, unique: true

  act_as_likee

  belongs_to :user
  has_many :comments, as: 'commentable'
  cache_has_many :comments, :inverse_name => :commentable

  scope :except_body_with_default, -> { select(:title, :like_count, :name, :image, :tag, :id, :updated_at, :slug, :created_at) }

  mount_uploader :image, SoftUploader

  def self.async_create(user_id, soft_params)
    user = User.find(user_id)
    soft = self.new(soft_params)
    soft.user_id = user.id
    soft.save!
  end

  def self.async_update(soft_id, soft_params)
    soft = self.find(soft_id)
    user_id = soft.user_id
    soft.update!(soft_params)
    soft.user_id = user_id
    soft.save(validate: false)
  end

  validates :title, :body, :user_id, :name, :tag, presence: true
  validates :title, uniqueness: true
  validates :image, presence: true, on: :create

  def recommend_softs
  end

  def normalize_friendly_id(input)
    PinYin.of_string(input).to_s.to_slug.normalize.to_s
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

  after_commit :clear_cache
  after_update :clear_after_updated_cache
  after_create :publish_create

  before_save do
    # 引发 ActiveModel::Dirty 的 change
    self.title_will_change!
    self.title.auto_correct!
  end

  def baidu_download?
    self.download_url.present? && self.download_url.include?('baidu') ? true : false
  end

  def actual_download_url
    if baidu_download?
      self.download_url.partition(' ').first.partition(':').last
    end
  end

  def actual_download_password
    if baidu_download?
      self.download_url.partition(' ').last.partition(':').last
    end
  end

  private

  def publish_create
    unless Rails.env.test?
      Redis.new.publish 'ws', { title: 'rails365 上传了资源', content: self.title }.to_json
    end
  end

  def clear_cache
    # 首页
    Rails.cache.delete 'softs'
  end

  def clear_after_updated_cache
    unless Rails.env.test?
      Redis.new.publish 'ws', { title: 'rails365 更新了资源', content: self.title }.to_json
    end
  end
end

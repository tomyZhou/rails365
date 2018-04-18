require 'babosa'
class Soft < ApplicationRecord
  searchkick highlight: [:title, :body]

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  include IdentityCache
  cache_index :slug, unique: true

  act_as_likee
  include LikeConcern

  belongs_to :user
  has_many :comments, as: 'commentable'
  cache_has_many :comments, :inverse_name => :commentable

  mount_uploader :image, SoftUploader

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
  # after_update :clear_after_updated_cache
  after_create :publish_create

  before_save do
    # 引发 ActiveModel::Dirty 的 change
    self.title_will_change!
    self.title.auto_correct!
  end

  include ReadCountConcern

  include BaiduDownloadConcern

  private

  def publish_create
    unless Rails.env.test?
      # Redis.new.publish 'ws', { title: 'rails365 上传了资源', content: self.title }.to_json
    end
  end

  def clear_cache
    # 首页
    Rails.cache.delete 'softs'
  end

  def clear_after_updated_cache
  end
end

require "babosa"
class Article < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_title_or_body,
                  :against => {
                    :title => 'A',
                    :body => 'B'
                  },
                  :using => {
                    :tsearch => {:dictionary => "testzhcfg", :prefix => true, :negation => true}
                  }

  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :history]

  belongs_to :group, counter_cache: true

  scope :except_body_with_default, -> { select(:title, :created_at, :updated_at, :group_id, :slug, :id).includes(:group) }

  validates :title, :body, presence: true
  validates :title, uniqueness: true

  def normalize_friendly_id(input)
    "#{PinYin.of_string(input).to_s.to_slug.normalize.to_s}"
  end

  def should_generate_new_friendly_id?
    title_changed? || super
  end

end

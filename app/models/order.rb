class Order < ActiveRecord::Base
  belongs_to :user
  by_star_field :created_at
end

class Order < ApplicationRecord
  belongs_to :user
  by_star_field :created_at

  def make_order_and_user_paid
    Rails.cache.delete "current_user_[#{self.user.id}]"
    if self.user.pay_expired_at && self.user.pay_expired_at > Time.now
      self.user.pay_expired_at = self.user.pay_expired_at + self.month.to_i.months
    else
      self.user.pay_expired_at = Time.now + self.month.to_i.months
    end
    self.expired_at = self.user.pay_expired_at
    self.user.is_paid = true
    self.save && self.user.save
  end
end

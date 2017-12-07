module LikeConcern
  extend ActiveSupport::Concern

  included do
    include InstanceMethods
  end

  module ClassMethods
    def init_like_count
      self.find_each do |article|
        article.update_like_count
      end
    end
  end

  module InstanceMethods
    def update_like_count
      self.like_count = self.likers_by(User).count
      self.save validate: false
    end
  end
end

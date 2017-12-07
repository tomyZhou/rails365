module ReadCountConcern
  extend ActiveSupport::Concern

  included do
    include InstanceMethods
  end

  module ClassMethods
    def update_visit_count
      self.find_each do |object|
        if object.visit_count != object.read_count.to_i
          object.visit_count = object.read_count.to_i
          object.save validate: false
        end
      end
    end

    def init_random_read_count
      self.find_each do |object|
        object.visit_count = rand(1000)
        object.save validate: false
        if object.his_class_name.to_s == 'article'
          $redis.set("user_#{object.id}_count", object.visit_count)
        else
          $redis.set("user_#{object.his_class_name}_#{object.id}_count", object.visit_count)
        end
      end
    end
  end

  module InstanceMethods
    def his_class_name
      self.class.table_name.singularize
    end

    def read_count
      if self.his_class_name.to_s == 'article'
        $redis.get("user_#{self.id}_count") || 0
      else
        $redis.get("user_#{self.his_class_name}_#{self.id}_count") || 0
      end
    end

    def increment_read_count
      if self.his_class_name.to_s == 'article'
        $redis.incr "user_#{self.id}_count"
      else
        $redis.incr "user_#{self.his_class_name}_#{self.id}_count"
      end
    end
  end
end

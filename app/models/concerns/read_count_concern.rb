module ReadCountConcern
  extend ActiveSupport::Concern

  included do
    include InstanceMethods
  end

  module ClassMethods
    # 修改访问量
    def update_visit_count
      # 找出被浏览过的文章和视频的 id
      redis_name = "#{self.table_name.singularize}_view_ids"
      ids = $redis.lrange redis_name, 0, -1

      self.where(id: ids).find_each do |object|
        if object.visit_count != object.read_count.to_i
          object.visit_count = object.read_count.to_i
          object.save validate: false
        end
      end

      $redis.del redis_name
    end

    # 只用户过一次，现在不用
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
        $redis.get("user_#{self.id}_count") || self.visit_count || 0
      else
        $redis.get("user_#{self.his_class_name}_#{self.id}_count") || self.visit_count || 0
      end
    end

    def increment_read_count
      if self.his_class_name.to_s == 'article'
        $redis.incr "user_#{self.id}_count"
      else
        $redis.incr "user_#{self.his_class_name}_#{self.id}_count"
      end
    end

    def remember_visit_id
      redis_name = "#{his_class_name.to_s}_view_ids"

      ids = $redis.lrange redis_name, 0, -1

      if !ids.present? || (ids.present? && !ids.include?(self.id.to_s))
        $redis.lpush redis_name, self.id
      end
    end
  end
end

module BaiduDownloadConcern
  extend ActiveSupport::Concern

  included do
    include InstanceMethods
  end

  module ClassMethods
  end

  module InstanceMethods
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
  end
end

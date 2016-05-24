# coding: utf-8
# 异常通知
module ExceptionNotifier
  class DatabaseNotifier
    def initialize(options)
      # do something with the options...
    end

    def call(exception, options={})
      # send the notification
      @title = exception.message
      body = []
      body << exception.inspect
      if !exception.backtrace.blank?
        body << "\n"
        body << exception.backtrace[0,100]
      end

      env = options[:env]

      link = env['HTTP_HOST'] + env['REQUEST_URI']
      title = "#{env['REQUEST_METHOD']} <http://#{link}>\n"

      message = "------------------------------------------------------------------------------------------\n"
      message += "*Project:* #{Rails.application.class.parent_name}\n"
      message += "*Environment:* #{Rails.env}\n"
      message += "*Time:* #{Time.zone.now.strftime('%Y-%m-%d %H:%M:%S')}\n"
      message += "*Exception:* `#{exception.message}`\n"

      unless env.nil?
        request = ActionDispatch::Request.new(env)

        request_items = {:url => request.original_url,
                         :http_method => request.method,
                         :ip_address => request.remote_ip,
                         :parameters => request.filtered_parameters,
                         :timestamp => Time.current }
        message += "*HTTP Method:* #{request_items[:http_method].to_s}\n"
        message += "*Parameters:* #{request_items[:parameters].to_s}\n"
      end
      req = Rack::Request.new(env)
      unless req.params.empty?
        message += "*Parameters:*\n"
        message += req.params.map { |k, v| ">#{k}=#{v}" }.join("\n")
        message += "\n"
      end
      message += "*Backtrace*: \n"
      message += "`#{exception.backtrace.first}`"

      if Rails.env.production?
        Admin::ExceptionLog.delay.create(title: @title, body: body.join("\n"), message: message, request_url: title)
      else
        Rails.logger.info "\n exception begin======================"
        Rails.logger.info "title: #{title}"
        Rails.logger.info "message: #{message}"
        Rails.logger.info body.join("\n")
        Rails.logger.info "======================exception end\n"
      end
    end
  end
end

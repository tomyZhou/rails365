class DeviseRememberableWorker
  include Sidekiq::Worker
  def perform(record, warden, options)
    scope = options[:scope]
    if record.respond_to?(:remember_me) && options[:store] != false &&
       record.remember_me && warden.authenticated?(scope)
      Devise::Hooks::Proxy.new(warden).remember_me(record)
    end 
  end
end

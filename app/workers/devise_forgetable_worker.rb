class DeviseForgetableWorker
  include Sidekiq::Worker
  def perform(record, warden, options)
    if record.respond_to?(:forget_me!)
      Devise::Hooks::Proxy.new(warden).forget_me(record)
    end 
  end
end

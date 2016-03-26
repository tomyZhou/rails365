Warden::Manager.after_set_user except: :fetch do |record, warden, options|
  DeviseRememberableWorker.perform_async(record, warden, options)
end

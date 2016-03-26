Warden::Manager.before_logout do |record, warden, options|
  DeviseForgetableWorker.perform_async(record, warden, options)
end

Warden::Manager.after_set_user except: :fetch do |record, warden, options|
  DeviseTrackableWorker.perform_async(record, warden, options)
end

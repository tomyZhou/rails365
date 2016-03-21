class DeviseTrackableWorker
  include Sidekiq::Worker
  def perform(record, warden, options)
    if record.respond_to?(:update_tracked_fields!) && warden.authenticated?(options[:scope]) && !warden.request.env['devise.skip_trackable']
      record.update_tracked_fields!(warden.request)
    end
  end
end

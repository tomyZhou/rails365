class UpdateSoftWorker
  include Sidekiq::Worker

  def perform(soft_id, soft_params)
    Soft.async_update(soft_id, soft_params)
  end
end

class CreateSoftWorker
  include Sidekiq::Worker

  def perform(user_id, soft_params)
    Soft.async_create(user_id, soft_params)
  end
end

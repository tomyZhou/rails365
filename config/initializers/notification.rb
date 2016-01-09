ActiveSupport::Notifications.subscribe "process_action.action_controller" do |name, started, finished, unique_id, payload|
  Rails.logger.info payload
  if payload[:controller] == "ArticlesController" && payload[:action] == "show"
    UpdateArticleVisitCountJob.perform_later(payload[:params]["id"]) if payload[:params]["id"].present?
  end
end

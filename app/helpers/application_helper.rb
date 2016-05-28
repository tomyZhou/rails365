module ApplicationHelper
  def markdown(text)
    MyMarkdown.render(text)
  end

  def bootstrap_form_for(object, options = {}, &block)
    options[:builder] = BootstrapFormBuilder
    form_for(object, options, &block)
  end

  def deivse_form_for(object, options = {}, &block)
    options[:builder] = DeviseFormBuilder
    form_for(object, options, &block)
  end

  def custom_timeago_tag(datetime)
    timeago_tag datetime, lang: "zh-CN", limit: 1.years.ago
  end
end

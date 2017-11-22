class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, :pluralize, :image_tag, to: :@template

  %w( text_field text_area select file_field url_field check_box email_field).each do |method_name|
    define_method(method_name) do |method, *tag_value|
      content_tag(:div, class: 'form-group') do
        label(method, class: 'col-sm-2 control-label') +
          content_tag(:div, class: 'col-sm-10') do
            super(method, *tag_value)
          end
      end
    end
  end

  def image_file_field(method, *tag_value)
    image_method = "#{method}_url".to_sym
    image_cache = "#{method}_cache".to_sym
    if object.send(image_method)
      image_version = tag_value.first[:image_version].to_sym if tag_value.first && tag_value.first[:image_version].present?
      content_tag(:div, class: 'form-group') do
        label(method, "&nbsp;".html_safe, class: 'col-sm-2 control-label') +
          content_tag(:div, class: 'col-sm-10') do
            if image_version
              image_tag object.send(image_method, image_method), width: '100', height: '100'
            else
              image_tag object.send(image_method), width: '100', height: '100'
            end
          end
      end +
      file_field(method, *tag_value) + hidden_field(image_cache)
    else
      file_field(method, *tag_value)
    end
  end

  # def check_box(method)
  #   content_tag(:div, class: 'form-group') do
  #     label(method, class: 'col-sm-2 control-label') +
  #       content_tag(:div, class: 'col-sm-10') do
  #         super
  #       end
  #   end
  # end

  def error_messages
    if object && object.errors.any?
      content_tag(:div, id: 'error_explanation') do
        content_tag(:h2, "#{pluralize(object.errors.count, 'error')} prohibited this article from being saved:") +
          content_tag(:ul) do
            object.errors.full_messages.map do |msg|
              content_tag(:li, msg)
            end.join.html_safe
          end
      end
    end
  end

  def submit(*tag_value)
    content_tag(:div, class: 'form-group') do
      content_tag(:div, class: 'col-sm-10 col-sm-offset-2') do
        super
      end
    end
  end
end

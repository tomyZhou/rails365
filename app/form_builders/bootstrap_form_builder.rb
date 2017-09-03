class BootstrapFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, :pluralize, to: :@template

  %w( text_field text_area select file_field url_field check_box).each do |method_name|
    define_method(method_name) do |method, *tag_value|
      content_tag(:div, class: 'form-group') do
        label(method, class: 'col-sm-2 control-label') +
          content_tag(:div, class: 'col-sm-10') do
            super(method, *tag_value)
          end
      end
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

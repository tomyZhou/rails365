class DeviseFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, :pluralize, to: :@template

  %w( email_field password_field text_field file_field ).each do |method_name|
    define_method(method_name) do |method, *tag_value|
      content_tag(:div, class: 'form-group') do
        label(method, class: 'col-sm-3 control-label') +
          content_tag(:div, class: 'col-sm-7') do
            super(method, *tag_value)
          end
      end
    end
  end

  def image_file_field(method, *tag_value)
    image_method = "#{method}_url".to_sym
    
      file_field(method, *tag_value)
  end

  def submit(*tag_value)
    content_tag(:div, class: 'form-group') do
      content_tag(:div, class: 'col-sm-7 col-sm-offset-3') do
        super
      end
    end
  end
end

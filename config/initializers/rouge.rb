# need to be required to use Rouge with Redcarpet
require 'rouge/plugins/redcarpet'

module Redcarpet
  module Render
    class CodeHTML < HTML
      # to use Rouge with Redcarpet
      include Rouge::Plugins::Redcarpet
      # overriding Redcarpet method
      # github.com/vmg/redcarpet/blob/master/lib/redcarpet/render_man.rb#L9

      def initialize(extensions = {})
        super extensions.merge(link_attributes: { target: '_blank' })
      end

      # rouge redcarpet plugin已有相应的功能
      # def block_code(code, language)
      #   Rouge.highlight(code, language || 'text', 'html')
      # end

      def table(header, body)
        "<table class=\"table table-bordered\">" \
          "#{header}#{body}" \
        "</table>"
      end

      def image(link, title, content)
        content &&= content + ' '
        "<a href='#{link.sub('preview_', '')}' class='fluidbox-link'>" \
          "<img src='#{content}#{link}' />" \
        "</a>"
      end

      def header(text, header_level)
        "<h#{header_level} class='markdown_header'>#{text}</h#{header_level}>"
      end
    end
  end
end

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'markdown' do
    it 'should sanitize_markdown' do
      expect(helper.markdown('#### h1')).to eq "<h4 class='markdown_header'>h1</h4>"
    end
  end
end

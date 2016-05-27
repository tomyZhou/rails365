require 'rails_helper'

RSpec.describe MyMarkdown do
  describe "#format" do
    context "header" do
      let(:raw) { "#### h1" }
      it { expect(MyMarkdown.render(raw)).to eq("<h4 class='markdown_header'>h1</h4>") }
    end

    context "table" do
      let(:raw) do
        %(
| header 1 | header 3 |
| -------- | -------- |
| cell 1   | cell 2   |
| cell 3   | cell 4   |)
      end
      it { expect(MyMarkdown.render(raw)).to eq("<table class=\"table table-bordered\"><tr>\n<th>header 1</th>\n<th>header 3</th>\n</tr>\n<tr>\n<td>cell 1</td>\n<td>cell 2</td>\n</tr>\n<tr>\n<td>cell 3</td>\n<td>cell 4</td>\n</tr>\n</table>") }
    end

    context "image" do
      let(:raw) { "![](http://aliyun.rails365.net/example.png)" }
      it { expect(MyMarkdown.render(raw)).to eq("<p><a href='http://aliyun.rails365.net/example.png' class='fluidbox-link'><img src='http://aliyun.rails365.net/example.png' /></a></p>\n") }
    end
  end
end

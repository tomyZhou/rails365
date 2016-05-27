require 'rails_helper'

RSpec.describe Article, type: :model do

  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:article) { create(:article) }

  describe "#title" do
    context "正常" do
      let(:article) { build(:article, title: "ttt") }
      it { expect(article.valid?).to eq true }
    end

    context "为空" do
      let(:article) { build(:article, title: "") }
      it { expect(article.valid?).to eq false }
    end
  end

  it "should not be have same title" do
    article_same_title = article.dup
    article_same_title.title = article.title
    article_same_title.save
    expect(article_same_title.valid?).to eq false
  end

  describe "#content" do
    context "正常" do
      let(:article) { build(:article, body: "cccc") }
      it { expect(article.valid?).to eq true }
    end

    context "为空" do
      let(:article) { build(:article, body: "") }
      it { expect(article.valid?).to eq false }
    end
  end

  describe "#user" do
    it "should get user username" do
      expect(create(:article, user: user).user.username).to eq user.username
    end

    it "should not be blank" do
      article = build(:article, user: nil)
      expect(article.valid?).to eq false
    end
  end

  describe "#group" do
    it "should get group name" do
      expect(create(:article, group: group).group.name).to eq group.name
    end

    it "should not be blank" do
      article = build(:article, group: nil)
      expect(article.valid?).to eq false
    end

    it "should get group count" do
      article = create(:article, group: group)
      expect(group.articles.count).to eq 1

      article.destroy
      expect(group.articles.count).to eq 0
    end
  end

  it 'should covert body with Markdown on create' do
    article = create(:article, body: '*foo*')
    expect(MyMarkdown.render(article.body)).to eq("<p><em>foo</em></p>\n")
  end
end

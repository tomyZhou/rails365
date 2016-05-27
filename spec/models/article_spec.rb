require 'rails_helper'

RSpec.describe Article, type: :model do

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
      user = create(:user)
      expect(create(:article, user: user).user.username).to eq user.username
    end

    it "should not be blank" do
      article = build(:article, user: nil)
      expect(article.valid?).to eq false
    end
  end
end

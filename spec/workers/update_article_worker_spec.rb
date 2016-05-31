require 'rails_helper'

RSpec.describe UpdateArticleWorker do
  describe '.perform' do
    let(:user) { create :user }
    let(:group) { create :group }
    let(:article) { create :article, user: user, group: group }
    let(:valid_article_attributes) { attributes_for :article, group: group, user: user }

    it 'should work' do
      expect(Article).to receive(:async_update).with(article.id, valid_article_attributes)
      UpdateArticleWorker.new.perform(article.id, valid_article_attributes)
    end
  end
end

require 'rails_helper'

RSpec.describe UpdateArticleWorker do
  describe '.perform' do
    let(:user) { create :user }
    let(:article) { create :article, user: user }

    it 'should work' do
      expect(Article).to receive(:async_update).with(article.id, user.id, article.attributes)
      UpdateArticleWorker.new.perform(article.id, user.id, article.attributes)
    end
  end
end

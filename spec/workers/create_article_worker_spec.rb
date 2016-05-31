require 'rails_helper'

RSpec.describe CreateArticleWorker do
  describe '.perform' do
    let(:user) { create :user }
    let(:article_attributes) { build_stubbed :article }

    it 'should work' do
      expect(Article).to receive(:async_create).with(article_attributes, user.id).once
      CreateArticleWorker.new.perform(article_attributes, user.id)
    end
  end
end

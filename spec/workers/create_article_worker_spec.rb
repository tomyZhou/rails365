require 'rails_helper'

RSpec.describe CreateArticleWorker do
  describe '.perform' do
    let(:user) { create :user }
    let(:group) { create :group }
    let(:valid_article_attributes) { attributes_for :article, group: group, user: user }

    it 'should work' do
      expect(Article).to receive(:async_create).with(valid_article_attributes, user.id).once
      CreateArticleWorker.new.perform(valid_article_attributes, user.id)
    end
  end
end

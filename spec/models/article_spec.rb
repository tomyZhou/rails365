require 'rails_helper'

RSpec.describe Article, type: :model do
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:article) { create(:article, user: user, group: group) }

  describe '#title' do
    context 'normal' do
      let(:article) { build(:article, title: 'ttt') }
      it { expect(article.valid?).to eq true }
    end

    context 'blank' do
      let(:article) { build(:article, title: '') }
      it { expect(article.valid?).to eq false }
    end

    context 'duplicate' do
      let(:article_with_same_title) { build_stubbed(:article, title: article.title) }
      it { expect(article_with_same_title.valid?).to eq false }
    end
  end

  describe '#content' do
    context 'normal' do
      let(:article) { build(:article, body: 'cccc') }
      it { expect(article.valid?).to eq true }
    end

    context 'blank' do
      let(:article) { build(:article, body: '') }
      it { expect(article.valid?).to eq false }
    end
  end

  describe '#user' do
    it 'should get user username' do
      expect(create(:article, user: user).user.username).to eq user.username
    end

    it 'should not be blank' do
      article = build(:article, user: nil)
      expect(article.valid?).to eq false
    end
  end

  describe '#group' do
    it 'should get group name' do
      expect(create(:article, group: group).group.name).to eq group.name
    end

    it 'should not be blank' do
      article = build(:article, group: nil)
      expect(article.valid?).to eq false
    end

    it 'should get group count' do
      article = create(:article, group: group)
      expect(group.articles.count).to eq 1
      expect(group.reload.articles_count).to eq 1

      article.destroy
      expect(group.articles.count).to eq 0
      expect(group.reload.articles_count).to eq 0
    end
  end

  it 'should covert body with Markdown on create' do
    article = create(:article, body: '*foo*')
    expect(MyMarkdown.render(article.body)).to eq("<p><em>foo</em></p>\n")
  end

  describe '#friendly_id' do
    context 'slug' do
      it { expect(article.slug.present?).to eq true }
    end

    context '第一篇文章' do
      let(:article) { create(:article, title: '第一篇文章') }
      it { expect(article.slug).to eq('di-yi-pian-wen-zhang') }
    end

    context '第一篇文章(一)' do
      let(:article) { create(:article, title: '第一篇文章(一)') }
      it { expect(article.slug).to eq('di-yi-pian-wen-zhang-yi') }
    end

    context 'redis第一篇文章(一)' do
      let(:article) { create(:article, title: 'redis第一篇文章(一)') }
      it { expect(article.slug).to eq 'redis-di-yi-pian-wen-zhang-yi' }
    end

    context 'finders' do
      it { expect(Article.find(article.slug)).to eq Article.find(article.id) }
    end
  end

  it 'should have friendly_id history' do
    old_slug = article.slug
    article.title = article.title + '(一)'
    article.save
    new_slug = article.slug
    expect(Article.find(new_slug)).to eq Article.find(old_slug)
  end

  it 'should change slug when only title change' do
    old_slug = article.slug
    article.title = article.title + '(一)'
    article.save
    new_slug = article.slug
    expect(new_slug).not_to eq old_slug

    article.body = article.body + '**'
    article.save
    new_slug_1 = article.slug
    expect(new_slug_1).to eq new_slug
  end

  describe '#async_create' do
    let(:creator) { create :user, email: 'other_user@email.com', username: 'other_user' }
    let(:valid_article_attributes) { attributes_for :article, group_id: group.id, user_id: creator.id }

    it 'should work' do
      Article.async_create(user.id, valid_article_attributes)
      expect(Article.count).to eq 1

      article = Article.find_by(title: valid_article_attributes[:title])
      expect(article.user_id).to eq user.id
      expect(article.user_id).not_to eq creator.id
    end
  end

  describe '#async_update' do
    let(:editor) { create :user, email: 'other_user@email.com', username: 'other_user' }
    let(:valid_article_attributes) { attributes_for :article, group_id: group.id, user_id: editor.id, body: 'changed_body' }

    it 'should work' do
      Article.async_update(article.id, valid_article_attributes)
      updated_article = Article.find_by(body: 'changed_body')
      expect(updated_article).to eq article
      expect(updated_article.user_id).to eq user.id
      expect(updated_article.user_id).not_to eq editor.id
    end
  end
end

require 'rails_helper'

RSpec.describe Group, type: :model do
  let(:group) { create(:group) }

  describe '#name' do
    context 'blank' do
      let(:group) { build :group, name: '' }
      it { expect(group.valid?).to eq false }
    end

    context 'duplicate' do
      let(:group_with_same_name) { build :group, name: group.name }
      it { expect(group_with_same_name.valid?).to eq false }
    end
  end

  describe '#image' do
    context 'blank' do
      let(:group) { build :group, image: '' }
      it { expect(group.valid?).to eq false }
    end
  end

  it 'shoud have many articles' do
    article = create :article, group: group
    expect(group.articles.count).to eq 1
    article.destroy
    expect(group.articles.count).to eq 0
  end

  describe '#friendly_id' do
    context 'slug' do
      it { expect(group.slug.present?).to eq true }
    end

    context '服务器部署' do
      let(:group) { create :group, name: '服务器部署' }
      it { expect(group.slug).to eq 'fu-wu-qi-bu-shu' }
    end

    context 'finders' do
      it { expect(Group.find(group.slug)).to eq(Group.find(group.id)) }
    end
  end

  it 'should have friendly_id history' do
    old_slug = group.slug
    group.name = group.name + '(一)'
    group.save
    new_slug = group.slug
    expect(Group.find(new_slug)).to eq(Group.find(old_slug))
  end

  it 'should change slug when only name change' do
    old_slug = group.slug
    group.name = group.name + '(一)'
    group.save
    new_slug = group.slug
    expect(new_slug).not_to eq old_slug

    group.image = File.new(Rails.root.join('spec', 'photos', 'weixin.jpg'))
    group.save
    new_slug_1 = group.slug
    expect(new_slug_1).to eq new_slug
  end
end

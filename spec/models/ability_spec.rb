require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  subject { ability }

  context 'Admin manage all' do
    let(:admin) { create :admin }
    let(:ability) { Ability.new(admin) }

    it { is_expected.to be_able_to(:manage, Article) }
    it { is_expected.to be_able_to(:manage, Photo) }
    it { is_expected.to be_able_to(:manage, Group) }
    it { is_expected.to be_able_to(:manage, User) }
    it { is_expected.to be_able_to(:manage, Admin::ExceptionLog) }
    it { is_expected.to be_able_to(:manage, Admin::SidekiqException) }
    it { is_expected.to be_able_to(:manage, Admin::Site) }
    it { is_expected.to be_able_to(:manage, Admin::SiteInfo) }
  end

  context 'Login user' do
    let(:user) { create :user }
    let(:ability) { Ability.new(user) }

    context 'Article' do
      it { is_expected.to be_able_to(:read, Article) }
      it { is_expected.to be_able_to(:create, Article) }
      it { is_expected.to be_able_to(:update, Article) }
      it { is_expected.to be_able_to(:destroy, Article) }
    end

    context 'Group' do
      it { is_expected.to be_able_to(:read, Group) }
      it { is_expected.not_to be_able_to(:create, Group) }
      it { is_expected.not_to be_able_to(:update, Group) }
      it { is_expected.not_to be_able_to(:destroy, Group) }
    end
  end
  
  context 'Guest user' do
    let(:ability) { Ability.new(nil) }

    context 'Article' do
      it { is_expected.to be_able_to(:read, Article) }
      it { is_expected.not_to be_able_to(:create, Article) }
      it { is_expected.not_to be_able_to(:update, Article) }
      it { is_expected.not_to be_able_to(:destroy, Article) }
    end
    
    context 'Group' do
      it { is_expected.to be_able_to(:read, Group) }
      it { is_expected.not_to be_able_to(:create, Group) }
      it { is_expected.not_to be_able_to(:update, Group) }
      it { is_expected.not_to be_able_to(:destroy, Group) }
    end
  end
end

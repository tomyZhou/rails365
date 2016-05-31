require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  describe '#email' do
    context '有效的地址' do
      addresses = %w( user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn )
      addresses.each do |valid_address|
        let(:user) { build(:user, email: valid_address) }
        it { expect(user.valid?).to eq true }
      end
    end

    context '空' do
      let(:user) { build(:user, email: '') }
      it { expect(user.valid?).to eq false }
    end

    context '错误邮箱格式' do
      addresses = %w{ invalid_email_format 123 $$$ () ☃ bla@bla. }
      addresses.each do |invalid_address|
        let(:user) { build(:user, email: invalid_address) }
        it { expect(user.valid?).to eq false }
      end
    end

    context '重复' do
      let(:user_with_same_username) { build :user, username: user.username }
      it { expect(user_with_same_username.valid?).to eq false }
    end
  end

  describe '#username' do
    context 'user1' do
      let(:user) { build(:user, username: 'user1') }
      it { expect(user.valid?).to eq true }
    end

    context '中文名' do
      let(:user) { build(:user, username: '中文名') }
      it { expect(user.valid?).to eq false }
    end

    context '空' do
      let(:user) { build(:user, username: '') }
      it { expect(user.valid?).to eq false }
    end

    context '特殊字符' do
      usernames = %w( ###user### %user user. user+ )
      usernames.each do |username|
        let(:user) { build(:user, username: username) }
        it { expect(user.valid?).to eq false }
      end
    end

    context '太短' do
      let(:user) { build(:user, username: 'us') }
      it { expect(user.valid?).to eq false }
    end

    context '太长' do
      let(:user) { build(:user, username: 'user1' * 5) }
      it { expect(user.valid?).to eq false }
    end

    context '重复' do
      let(:user_with_same_email) { build :user, email: user.email }
      it { expect(user_with_same_email.valid?).to eq false }
    end
  end

  describe '#login' do
    context 'user1' do
      let(:user) { build(:user, username: 'user1') }
      it { expect(user.login).to eq 'user1' }
    end
  end

  describe '#password' do
    context '正常' do
      let(:user) { build(:user, password: '12345678') }
      it { expect(user.valid?).to eq true }
    end

    context '少于8位' do
      let(:user) { build(:user, password: '1231231') }
      it { expect(user.valid?).to eq false }
    end

    context '和确认密码不匹配' do
      let(:user) { build(:user, password: '12345678', password_confirmation: '123') }
      it { expect(user.valid?).to eq false }
    end
  end

  describe '#validate_username' do
    let(:user_with_wrong_email) { build(:user, email: user.username) }
    it { expect(user_with_wrong_email.valid?).to eq false }
  end

  describe '#super_admin?' do
    let(:admin) { create(:admin) }
    it '管理员' do
      expect(admin).to be_super_admin
    end

    it '普通用户' do
      expect(user).not_to be_super_admin
    end
  end
end

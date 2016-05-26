require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  describe "校验电子邮箱" do
    context "电子邮箱为user1@email.com" do
      let(:user) { build(:user, email: "user1@email.com") }
      it { expect(user.valid?).to eq true }
    end
  end

  describe "校验用户名" do
    context "用户名为user1" do
      let(:user) { build(:user, username: 'user1') }
      it { expect(user.valid?).to eq true }
    end

    context "用户名为中文名" do
      let(:user) { build(:user, username: "中文名") }
      it { expect(user.valid?).to eq false }
    end

    context "用户名为空" do
      let(:user) { build(:user, username: "") }
      it { expect(user.valid?).to eq false }
    end

    context "用户名为特殊字符" do
      let(:user) { build(:user, username: "###user###") }
      it { expect(user.valid?).to eq false }
    end

    context "用户名重复" do
      let(:user_with_same_username) { build(:user, username: user.username) }
      it { expect(user_with_same_username.valid?).to eq false }
    end
  end

end

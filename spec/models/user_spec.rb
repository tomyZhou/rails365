require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  describe "#email" do
    context "user1@email.com" do
      let(:user) { build(:user, email: "user1@email.com") }
      it { expect(user.valid?).to eq true }
    end

    context "空" do
      let(:user) { build(:user, email: "") }
      it { expect(user.valid?).to eq false }
    end

    context "错误邮箱格式" do
      let(:user) { build(:user, email: "user1@") }
      it { expect(user.valid?).to eq false }
    end

    context "重复" do
      let(:user_with_same_email) { build(:user, email: user.email)}
      it { expect(user_with_same_email.valid?).to equal false }
    end
  end

  describe "#username" do
    context "user1" do
      let(:user) { build(:user, username: 'user1') }
      it { expect(user.valid?).to eq true }
    end

    context "中文名" do
      let(:user) { build(:user, username: "中文名") }
      it { expect(user.valid?).to eq false }
    end

    context "空" do
      let(:user) { build(:user, username: "") }
      it { expect(user.valid?).to eq false }
    end

    context "特殊字符" do
      let(:user) { build(:user, username: "###user###") }
      it { expect(user.valid?).to eq false }
    end

    context "重复" do
      let(:user_with_same_username) { build(:user, username: user.username) }
      it { expect(user_with_same_username.valid?).to eq false }
    end

    context "太短" do
      let(:user) { build(:user, username: "us") }
      it { expect(user.valid?).to eq false }
    end

    context "太长" do
      let(:user) { build(:user, username: "user1uuuuuuuuuuuuuuuu")}
      it { expect(user.valid?).to eq false }
    end
  end

  describe "#login" do
    context "user1" do
      let(:user) { build(:user, username: "user1") }
      it { expect(user.login).to eq "user1" }
    end
  end

  describe "#password" do
    context "正常" do
      let(:user) { build(:user, password: "12345678") }
      it { expect(user.valid?).to eq true }
    end
    context "少于8位" do
      let(:user) { build(:user, password: "1231231") }
      it { expect(user.valid?).to eq false }
    end
  end

  describe "#validate_username" do
    let(:user_with_wrong_email) { build(:user, email: user.username)}
    it { expect(user_with_wrong_email.valid?).to eq false }
  end

  describe "#super_admin?" do
    let(:admin) { create(:admin) }
    it "管理员" do
      expect(admin).to be_super_admin
    end

    it "普通用户" do
      expect(user).not_to be_super_admin
    end
  end

end

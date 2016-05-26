require 'rails_helper'

describe "登录和注册功能", :type => :feature do
  let(:user) { FactoryGirl.create(:user) }

  before do
    allow_any_instance_of(ActionController::Base).to receive(:verify_rucaptcha?).and_return(true)
  end

  it "成功登录" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_login', :with => user.email
      fill_in 'user_password', :with => user.password
    end
    click_button '登录'
    expect(page).to have_content '登录成功'
    expect(page).to have_current_path(root_path)
  end

  it "密码错误的失败登录" do
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'user_login', :with => user.email
      fill_in 'user_password', :with => 'wrong_password'
    end
    click_button '登录'
    expect(page).to have_content '登录账号或密码错误'
    expect(page).to have_current_path("/users/sign_in")
  end

  it "正常注册" do
    visit "/users/sign_up"
    within("#new_user") do
      fill_in 'user_email', :with => "user1@email.com"
      fill_in 'user_username', :with => "user1"
      fill_in 'user_password', :with => "password"
      fill_in 'user_password_confirmation', :with => "password"
    end
    click_button "注册"
    expect(page).to have_current_path(root_path)
    expect(page).to have_content "您已注册成功"
  end

  it "当用户已经被注册时" do
    visit "/users/sign_up"
    within("#new_user") do
      fill_in 'user_email', :with => user.email
      fill_in 'user_username', :with => "user1"
      fill_in 'user_password', :with => "password"
      fill_in 'user_password_confirmation', :with => "password"
    end
    click_button "注册"
    expect(page).to have_current_path("/users")
    expect(page).to have_content "因为1个错误导致此用户保存失败: 电子邮箱已经被使用"
  end

  it "当用户注册时的密码不少于8位数" do
    visit "/users/sign_up"
    within("#new_user") do
      fill_in 'user_email', :with => "user2@email.com"
      fill_in 'user_username', :with => "user2"
      fill_in 'user_password', :with => "123"
      fill_in 'user_password_confirmation', :with => "123"
    end
    click_button "注册"
    expect(page).to have_current_path("/users")
    expect(page).to have_content "因为1个错误导致此用户保存失败: 密码过短"
  end

  it "不填邮箱时不能注册" do
    visit "/users/sign_up"
    within("#new_user") do
      fill_in 'user_username', :with => "user3"
      fill_in 'user_password', :with => "password"
      fill_in 'user_password_confirmation', :with => "password"
    end
    click_button "注册"
    expect(page).to have_current_path("/users")
    expect(page).to have_content "因为1个错误导致此用户保存失败: 电子邮箱不能为空字符"
  end

end

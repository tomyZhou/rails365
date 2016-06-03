Given(/^用户查看登录页面$/) do
  visit new_user_session_path
end

When(/^提交无效的信息$/) do
  click_button '登录'
end

Then(/^应该看到错误显示$/) do
  expect(page).to have_content('登录账号或密码错误')
end

Given(/^用户已经有登录账号$/) do
  @user = create(:user)
end

When(/^用户提交有效的登录信息$/) do
  fill_in 'user_login', with: @user.username
  fill_in 'user_password', with: @user.password
  click_button '登录'
end

Then(/^用户应该看到成功的消息$/) do
  expect(page).to have_content '登录成功'
end

Then(/^应该看到注销按钮$/) do
  expect(page).to have_link('注销')
end

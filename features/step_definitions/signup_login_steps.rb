Given(/^a user visits the signin page$/) do
  visit new_user_session_path
end

When(/^they submit invalid signin information$/) do
  click_button '登录'
end

Then(/^they should see an error message$/) do
  expect(page).to have_content('登录账号或密码错误')
end

Given(/^the user has an account$/) do
  @user = create(:user)
end

When(/^the user submits valid signin information$/) do
  fill_in 'user_login', with: @user.username
  fill_in 'user_password', with: @user.password
  click_button '登录'
end

Then(/^they should see successful information$/) do
  expect(page).to have_content '登录成功'
end

Then(/^they should see a signout link$/) do
  expect(page).to have_link('注销')
end

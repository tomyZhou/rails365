require 'rails_helper'

describe '创建文章', type: :feature do
  let(:user) { create :user }

  describe '文章列表页面' do
    it '没有登录时没有添加新文章的链接' do
      visit articles_path
      expect(page).to have_selector('h2', text: '所有文章')
      expect(page).not_to have_link('添加新文章')
    end

    it '登录之后就可以看到添加新文章的链接' do
      login_as(user, scope: :user)
      visit articles_path
      expect(page).to have_link('添加新文章')
    end
  end # 文章列表页面

  describe '创建新文章功能' do
    before do
      login_as(user, scope: :user)
      @group = create(:group)
      visit new_article_path
    end

    it { expect(page).to have_selector('h2', text: '发表文章') }

    it '正常提交' do
      within('#new_article') do
        fill_in 'article_title', with: 'title1'
        fill_in 'article_body', with: 'body1'
        select @group.name, from: 'article_group_id'
      end
      click_button '保存'
      expect(page).to have_current_path(articles_path)
      expect(page).to have_content '文章正在后台创建中，如果创建成功将会有消息提醒'
    end

    it '当标题存在时' do
      @article = create(:article, group: @group, user: user)

      within('#new_article') do
        fill_in 'article_title', with: @article.title
        fill_in 'article_body', with: 'body1'
        select @group.name, from: 'article_group_id'
      end
      click_button '保存'
      expect(page).to have_current_path(articles_path)
      expect(page).to have_content '标题已经被使用'
    end
  end # 创建新文章功能
end

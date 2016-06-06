require 'rails_helper'

describe HomeController, type: :controller do
  describe ':index' do
    let(:user) { create :user }

    before do
      @group = create :group
      @article = create :article, user: user, group: @group
      @admin_site_info = create :admin_site_info
    end

    it 'should show register link if user not signed in' do
      get :index
      expect(response).to be_success
      expect(response.body).to match(/注册/)
    end

    it 'should have user login name if user is signed in' do
      sign_in user

      get :index
      expect(response.body).to match(/#{user.login}/)
    end

    it 'should have article title' do
      get :index
      expect(response.body).to match(/#{@article.title}/)
    end

    it 'should have group name' do
      get :index
      expect(response.body).to match(/#{@group.name}/)
    end

    it 'should have site_info_home_desc' do
      get :index
      expect(response.body).to match(/#{@admin_site_info.value}/)
    end
  end
end

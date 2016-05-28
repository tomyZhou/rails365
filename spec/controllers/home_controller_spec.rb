require 'rails_helper'

describe HomeController, type: :controller do
  describe ':index' do
    let(:user) { create :user }

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
  end
end

require 'rails_helper'

describe ArticlesController do
  describe ':index' do
    let(:user) { create(:user) }

    it 'should work' do
      get :index
      expect(response).to be_success
      expect(response).to render_template('index')
    end

    it 'should have new article link if user is signed in' do
      sign_in user
      get :index
      expect(response.body).to match(/添加新文章/)
    end
  end
end

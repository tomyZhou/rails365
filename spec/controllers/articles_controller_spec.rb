require 'rails_helper'

describe ArticlesController, type: :controller do
  let(:user) { create(:user) }
  let(:group) { create :group }
  let(:article) { create :article, user: user, group: group }

  describe ':index' do
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

  describe ':show' do
    it 'should work' do
      get :show, id: article.slug
      expect(response).to be_success
      expect(response.body).to match(/#{article.title}/)
    end
  end

  describe ':new' do
    it 'should not work when user does not sign in' do
      get :new
      expect(response).not_to be_success
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eq '继续操作前请确保您已登录.'
    end

    it 'should work when user sign in' do
      sign_in user
      get :new
      expect(response).to be_success
      expect(response.body).to match(/发表文章/)
    end
  end
  
  describe ':create' do
    let(:valid_article_attributes) { attributes_for :article, group_id: group.id, user_id: user.id }

    it 'should not work when user does not sign in' do
      post :create, article: valid_article_attributes
      expect(response).not_to be_success
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eq '继续操作前请确保您已登录.'
    end

    it 'should work when user sign in' do
      sign_in user
      post :create, article: valid_article_attributes
      expect(response.status).to eq 302
      expect(response).to redirect_to(articles_path)
      expect(flash[:notice]).to eq '文章正在后台创建中，如果创建成功将会有消息提醒!'
    end

    it 'should not work when sumbit invalid article data' do
      sign_in user
      article = create :article, user: user, group: group
      article.body = article.body + '###'
      post :create, article: article.attributes
      expect(response).to be_success
      expect(response.body).to match /标题已经被使用/
    end
  end

  describe ':edit' do
    let(:other_user) { create(:user, email: 'other_user@eamil.com', username: 'other_user') }

    it 'should not work when user does not sign in' do
      get :edit, id: article.slug
      expect(response).not_to be_success
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eq '继续操作前请确保您已登录.'
    end

    it 'should work when user sign in' do
      sign_in user
      get :edit, id: article.slug
      expect(response).to be_success
      expect(response.body).to match(/更新文章/)
    end

    it 'should only edit own article when user sign in' do
      sign_in other_user
      get :edit, id: article.slug
      expect(response).not_to be_success
      expect(response).to redirect_to(root_path)
      expect(flash[:warning]).to eq('You are not authorized to access this page.')
    end
  end

  describe ':update' do
    let(:valid_article_attributes) { attributes_for :article, group_id: group.id, user_id: user.id }

    it 'should not work when user does not sign in' do
      valid_article_attributes[:body] = valid_article_attributes[:body] + '###'
      patch :update, article: valid_article_attributes, id: article.slug
      expect(response).not_to be_success
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eq '继续操作前请确保您已登录.'
    end

    it 'should work when user sign in' do
      sign_in user
      valid_article_attributes[:body] = valid_article_attributes[:body] + '###'
      patch :update, article: valid_article_attributes, id: article.slug
      expect(response).to redirect_to(article_path(article))
      expect(flash[:notice]).to eq '文章正在后台更新中，如果更新成功将会有消息提醒!'
    end
  end

  describe ':destroy' do
    let(:other_user) { create(:user, email: 'other_user@eamil.com', username: 'other_user') }

    it 'should not work when user does not sign in' do
      delete :destroy, id: article.slug
      expect(response).not_to be_success
      expect(response).to redirect_to(new_user_session_path)
      expect(flash[:alert]).to eq '继续操作前请确保您已登录.'
    end

    it 'should work when user sign in' do
      sign_in user
      delete :destroy, id: article.slug
      expect(response).to redirect_to(articles_path)
      expect(flash[:notice]).to eq '文章成功删除!'
      expect(Article.count).to eq 0
    end

    it 'should only destroy own article when user sign in' do
      sign_in other_user
      delete :destroy, id: article.slug
      expect(response).not_to be_success
      expect(response).to redirect_to(root_path)
      expect(flash[:warning]).to eq('You are not authorized to access this page.')
    end
  end
end

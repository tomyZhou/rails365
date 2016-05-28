require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create(:user) }

  describe ':show' do
    it 'should show user' do
      get :show, id: user.id
      expect(response).to be_success
      expect(response).to have_http_status(200)
      expect(response).to render_template('show')
    end
  end
end

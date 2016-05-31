require 'rails_helper'

describe PhotosController, type: :controller do
  describe ':create' do
    it 'should work' do
      post :create, image: fixture_file_upload(Rails.root.join('spec', 'photos', 'test.png'), 'image/png')
      expect(response).to be_success
      expect(response.body).to match /#{Digest::MD5.hexdigest("test.png")}/
    end
  end
end

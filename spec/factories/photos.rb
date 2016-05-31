FactoryGirl.define do
  factory :photo do
    image { fixture_file_upload(Rails.root.join('spec', 'photos', 'test.png'), 'image/png') }
  end
end

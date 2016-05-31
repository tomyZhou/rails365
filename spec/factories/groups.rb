include ActionDispatch::TestProcess
FactoryGirl.define do
  factory :group do
    name 'MyString'
    image { fixture_file_upload(Rails.root.join('spec', 'photos', 'test.png'), 'image/png') }
  end
end

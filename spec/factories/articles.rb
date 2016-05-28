FactoryGirl.define do
  factory :article do
    title 'MyString'
    body 'MyText'
    association :user
    association :group
  end
end

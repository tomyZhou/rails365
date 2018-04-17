FactoryBot.define do
  factory :user do
    email                    'user@example.com'
    username                 'name'
    password                 'password'
  end

  factory :admin, parent: :user do
    email Settings.admin_emails.first
  end
end

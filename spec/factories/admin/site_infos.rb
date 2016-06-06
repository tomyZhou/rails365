FactoryGirl.define do
  factory :admin_site_info, class: Admin::SiteInfo do
    key 'MyString'
    value 'MyString'
    desc 'MyString'
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ad_resourcex_resource, :class => 'AdResourcex::Resource' do
    name "MyString"
    location "MyText"
    category_id 1
    status_id 1
    resource_desp "MyText"
    standard_price 1
    about_price "MyString"
    dimension "MyString"
    in_service true
  end
end

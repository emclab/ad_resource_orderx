# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ad_resource_orderx_order, :class => 'AdResourceOrderx::Order' do
    resource_id 1
    order_date "2014-06-17"
    customer_po "MyString"
    sales_id 1
    order_total "9.99"
    unit_price "9.99"
    tax "9.99"
    other_charge "9.99"
    standard_price "9.99"
    order_detail "MyText"
    wf_state "MyString"
    gm_approved_by_id 1
    gm_approve_date "2014-06-17"
    gm_approved false
    order_start_date "2014-06-17"
    order_end_date "2014-06-17"
    #last_updated_by_id 1
    customer_id 1
  end
end

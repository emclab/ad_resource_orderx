require 'spec_helper'

module AdResourceOrderx
  describe Order do
    it "should be OK" do
      c = FactoryGirl.build(:ad_resource_orderx_order)
      c.should be_valid
    end
    
    it "should reject nil total" do
      c = FactoryGirl.build(:ad_resource_orderx_order, :order_total => nil)
      c.should_not be_valid
    end
    
    it "should take 0 total" do
      c = FactoryGirl.build(:ad_resource_orderx_order, :order_total => 0)
      c.should be_valid
    end
    
    it "should reject 0 resource id" do
      c = FactoryGirl.build(:ad_resource_orderx_order, :resource_id => 0)
      c.should_not be_valid
    end
    
    it "should reject 0 customer id" do
      c = FactoryGirl.build(:ad_resource_orderx_order, :customer_id => 0)
      c.should_not be_valid
    end
    
    it "should reject nil order detail" do
      c = FactoryGirl.build(:ad_resource_orderx_order, :order_detail => nil)
      c.should_not be_valid
    end
    
    it "should reject nil order date" do
      c = FactoryGirl.build(:ad_resource_orderx_order, :order_date => nil)
      c.should_not be_valid
    end
    
    it "should reject dup customer po for the same customer and resource" do
      c = FactoryGirl.create(:ad_resource_orderx_order, :customer_id => 1, :resource_id => 1, :customer_po => 'Anb')
      c = FactoryGirl.build(:ad_resource_orderx_order, :customer_id => 1, :resource_id => 1, :customer_po => 'anb')
      c.should_not be_valid
    end

  end
end

require "ad_resource_orderx/engine"

module AdResourceOrderx
  mattr_accessor :customer_class, :resource_class
  
  def self.customer_class
    @@customer_class.constantize
  end
  
  def self.resource_class
    @@resource_class.constantize
  end
end

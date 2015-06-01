module AdResourceOrderx
  require 'workflow'
  class Order < ActiveRecord::Base
    include Workflow
    workflow_column :wf_state
    
    workflow do
      wf = Authentify::AuthentifyUtility.find_config_const('order_wf_pdef', 'ad_resource_orderx')
      if Authentify::AuthentifyUtility.find_config_const('wf_pdef_in_config') == 'true' && wf.present?
        eval(wf) 
      elsif Rails.env.test?  
        state :initial_state do
          event :submit, :transitions_to => :cso_reviewing
        end
        state :cso_reviewing do
          event :cso_approve, :transitions_to => :gm_reviewing
          event :cso_reject, :transitions_to => :initial_state
        end
        state :gm_reviewing do
          event :gm_approve, :transitions_to => :approved
          event :gm_reject, :transitions_to => :rejected
          event :gm_rewind, :transitions_to => :initial_state
        end
        state :approved do
          event :sign_contract, :transitions_to => :contract_signed
        end
        state :contract_signed
        state :rejected
        
      end
    end
    
    attr_accessor :sales_name, :last_updated_by_name, :customer_name, :resource_name, :wf_comment, :id_noupdate, :wf_state_noupdate, :wf_event
=begin
    attr_accessible :customer_id, :customer_po, :gm_approved, :gm_approve_date, :gm_approved_by_id, :order_date, :order_detail, :customer_name_autocomplete,
                    :order_end_date, :order_start_date, :order_total, :other_charge, :resource_id, :sales_id, :standard_price, :tax, :unit_price, :wf_state,
                    :as => :role_new
    attr_accessible :customer_id, :customer_po, :gm_approved, :gm_approve_date, :gm_approved_by_id, :order_date, :order_detail, 
                    :order_end_date, :order_start_date, :order_total, :other_charge, :resource_id, :sales_id, :standard_price, :tax, :unit_price, :wf_state,
                    :sales_name, :last_updated_by_name, :customer_name, :resource_name, :customer_name_autocomplete, :wf_comment, :id_noupdate, :wf_state_noupdate, 
                    :as => :role_update
    
    attr_accessor :start_date_s, :end_date_s, :customer_id_s, :sales_id_s, :resource_id_s, :wf_state_s, :gm_approved_s, :time_frame_s

    attr_accessible :start_date_s, :end_date_s, :customer_id_s, :sales_id_s, :resource_id_s, :wf_state_s, :gm_approved_s, :time_frame_s,
                  :as => :role_search_stats
=end                  
    belongs_to :customer, :class_name => AdResourceOrderx.customer_class.to_s
    belongs_to :resource, :class_name => AdResourceOrderx.resource_class.to_s
    belongs_to :sales, :class_name => 'Authentify::User'
    belongs_to :last_updated_by, :class_name => 'Authentify::User'

    validates :customer_id, :resource_id, :sales_id, :presence => true, :numericality => {:greater_than => 0}
    validates :order_total, :presence => true, :numericality => {:greater_than_or_equal_to => 0}
    validates :order_detail, :order_date, :presence => true
    validates :gm_approved_by_id, :numericality => {:greater_than => 0, :only_integer => true, :if => 'gm_approved_by_id.present?'}
    validates :customer_po, :uniqueness => {:scope => [:resource_id, :customer_id], :case_sensitive => false, :message => 'Duplidate customer po'}, :if => 'customer_po.present?'
    validate :dynamic_validate 
    #for workflow input validation  
    validate :validate_wf_input_data, :if => 'wf_state.present?' 
    
    def dynamic_validate
      wf = Authentify::AuthentifyUtility.find_config_const('dynamic_validate', 'ad_resource_orderx_orders')
      eval(wf) if wf.present?
    end
       
    def validate_wf_input_data
      wf = Authentify::AuthentifyUtility.find_config_const('validate_order_' + self.wf_event, 'ad_resource_orderx') if self.wf_event.present?
      if Authentify::AuthentifyUtility.find_config_const('wf_validate_in_config') == 'true' && wf.present? 
        eval(wf) 
      end
    end      
    
    def customer_name_autocomplete
      self.customer.try(:name)
    end

    def customer_name_autocomplete=(name)
      self.customer = AdResourceOrderx.customer_class.find_by_name(name) if name.present?
    end     
  end
end

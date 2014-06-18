require 'spec_helper'

describe "LinkTests" do
  describe "GET /ad_resource_orderx_link_tests" do
    mini_btn = 'btn btn-mini '
    ActionView::CompiledTemplates::BUTTONS_CLS =
        {'default' => 'btn',
         'mini-default' => mini_btn + 'btn',
         'action'       => 'btn btn-primary',
         'mini-action'  => mini_btn + 'btn btn-primary',
         'info'         => 'btn btn-info',
         'mini-info'    => mini_btn + 'btn btn-info',
         'success'      => 'btn btn-success',
         'mini-success' => mini_btn + 'btn btn-success',
         'warning'      => 'btn btn-warning',
         'mini-warning' => mini_btn + 'btn btn-warning',
         'danger'       => 'btn btn-danger',
         'mini-danger'  => mini_btn + 'btn btn-danger',
         'inverse'      => 'btn btn-inverse',
         'mini-inverse' => mini_btn + 'btn btn-inverse',
         'link'         => 'btn btn-link',
         'mini-link'    => mini_btn +  'btn btn-link'
        }
    before(:each) do
      wf = "def submit
          wf_common_action('initial_state', 'cso_reviewing', 'submit')
        end   
        def cso_approve
          wf_common_action('cso_reviewing', 'acct_reviewing', 'cso_approve')
        end 
        def cso_reject
          wf_common_action('cso_reviewing', 'initial_state', 'cso_reject')
        end
        def gm_approve
          wf_common_action('gm_reviewing', 'approved', 'gm_approve')
        end
        def gm_reject
          wf_common_action('gm_reviewing', 'rejected', 'gm_reject')
        end
        def gm_rewind
          wf_common_action('gm_reviewing', 'initial_state', 'gm_rewind')
        end
        def sign_contract
          wf_common_action('approved', 'contract_signed', 'sign_contract')
        end"
      FactoryGirl.create(:engine_config, :engine_name => 'ad_resource_orderx', :engine_version => nil, :argument_name => 'order_wf_action_def', :argument_value => wf)
      str = 'rejected, contract_signed'
      FactoryGirl.create(:engine_config, :engine_name => 'ad_resource_orderx', :engine_version => nil, :argument_name => 'order_wf_final_state_string', :argument_value => str)
      
      FactoryGirl.create(:engine_config, :engine_name => 'ad_resource_orderx', :engine_version => nil, :argument_name => 'order_gm_approve_inline', 
                         :argument_value => "<%= f.input :gm_approve_date, :label => t('Approve Date') , :as => :string %>
                                             <%= f.input :gm_approved_by_id, :as => :hidden, :input_html => {:value => session[:user_id]}%>
                                             <%= f.input :gm_approved, :as => :hidden, :input_html => {:value => true} %>")
      FactoryGirl.create(:engine_config, :engine_name => 'ad_resource_orderx', :engine_version => nil, :argument_name => 'validate_order_gm_approve', 
                         :argument_value => " errors.add(:gm_approve_date, I18n.t('Not be blank')) if gm_approve_date.blank?
                                               ") 
      pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)                                         
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_pdef_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_route_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_validate_in_config', :argument_value => 'true')
      FactoryGirl.create(:engine_config, :engine_name => '', :engine_version => nil, :argument_name => 'wf_list_open_process_in_day', :argument_value => '45')
      z = FactoryGirl.create(:zone, :zone_name => 'hq')
      type = FactoryGirl.create(:group_type, :name => 'employee')
      ug = FactoryGirl.create(:sys_user_group, :user_group_name => 'ceo', :group_type_id => type.id, :zone_id => z.id)
      @role = FactoryGirl.create(:role_definition)
      ur = FactoryGirl.create(:user_role, :role_definition_id => @role.id)
      ul = FactoryGirl.build(:user_level, :sys_user_group_id => ug.id)
      @u = FactoryGirl.create(:user, :user_levels => [ul], :user_roles => [ur])
      @res = FactoryGirl.create(:ad_resourcex_resource)
      @res1 = FactoryGirl.create(:ad_resourcex_resource, :name => 'res1')
      @cust = FactoryGirl.create(:kustomerx_customer, :name => 'customer1')
      @cust1 = FactoryGirl.create(:kustomerx_customer, :name => 'new name', :short_name => 'a new one')
      
      user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "AdResourceOrderx::Order.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.sales_id == session[:user_id]")
      #  
      user_access = FactoryGirl.create(:user_access, :action => 'event_action', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "AdResourceOrderx::Order.scoped.order('created_at DESC')")
      user_access = FactoryGirl.create(:user_access, :action => 'submit', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'gm_approve', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'sign_contract', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'cso_approve', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      user_access = FactoryGirl.create(:user_access, :action => 'sales', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
      
      visit '/'
      #save_and_open_page
      fill_in "login", :with => @u.login
      fill_in "password", :with => @u.password
      click_button 'Login'
    end
    it "works! (now write some real specs)" do
      visit orders_path
      save_and_open_page
      task = FactoryGirl.create(:ad_resource_orderx_order,:gm_approved_by_id => nil, :sales_id => @u.id, :customer_id => @cust.id, :resource_id => @res.id)
      visit orders_path
      save_and_open_page
      page.should have_content('Orders')
      page.should have_content('Initial State')  #for workflow
      page.should have_content('Submit Order')
      click_link 'Edit'
      #save_and_open_page
      page.should have_content('Update Order')
      #save_and_open_page
      fill_in 'order_order_total', :with => 230
      click_button "Save"
      #bad data
      visit orders_path
      click_link 'Edit'
      fill_in 'order_order_date', :with => nil
      click_button "Save"
      #save_and_open_page
      
      #show
      visit orders_path
      #save_and_open_page
      click_link task.id.to_s
      #save_and_open_page
      page.should have_content('Order Info')
      
      #new
      visit orders_path
      click_link 'New Order'
      save_and_open_page
      page.should have_content('New Order')
      #fill_autocomplete('order_customer_name_autocomplete', with: 'customer1')
      fill_in 'order_order_date', :with => '2014-04-11'
      fill_in 'order_order_total', :with =>  230
      fill_in 'order_order_detail', :with => 'for biz trip'
      select('customer1', :from => 'order_customer_id')
      select('res1', :from => 'order_resource_id')
      select('Test User', :from => 'order_sales_id')
      click_button 'Save'
      save_and_open_page
      #bad data
      visit orders_path()
      click_link 'New Order'
      fill_in 'order_order_date', :with => '2014-04-11'
      fill_in 'order_order_total', :with =>  230
      fill_in 'order_order_detail', :with => ''
      select('customer1', :from => 'order_customer_id')
      select('res1', :from => 'order_resource_id')
      select('Test User', :from => 'order_sales_id')
      click_button 'Save'
      save_and_open_page
      
    end
    
    it "should create a order with initial stat and submit" do
      visit orders_path  #allow to redirect after save new below
      save_and_open_page
      click_link 'New Order'
      save_and_open_page
      page.should have_content('New Order')
      fill_in 'order_order_date', :with => '2014-04-11'
      fill_in 'order_order_total', :with =>  230
      fill_in 'order_order_detail', :with => 'for biz trip'
      select('customer1', :from => 'order_customer_id')
      select('res1', :from => 'order_resource_id')
      select('Test User', :from => 'order_sales_id')
      click_button 'Save'
      save_and_open_page
      
      #
      visit orders_path()
      save_and_open_page
      page.should have_content('Submit Order')
      click_link 'Submit Order'
      save_and_open_page
      fill_in 'order_wf_comment', :with => 'this is first submission'
      click_button 'Save'
      save_and_open_page
    end
    
    it "work for workflow from gm_reviewing to approved" do
      task = FactoryGirl.create(:ad_resource_orderx_order, :gm_approved_by_id => @u.id, :wf_state => 'gm_reviewing', :sales_id => @u.id, :customer_id => @cust.id, :resource_id => @res.id)
      visit orders_path
      save_and_open_page
      click_link 'GM Approve'
      save_and_open_page
      fill_in 'order_wf_comment', :with => 'this line tests workflow'
      fill_in 'order_gm_approve_date', :with => Date.today - 2.days
      #save_and_open_page
      click_button 'Save'
      #
      visit orders_path
      #save_and_open_page
      click_link 'Open Process'
      page.should have_content('Orders')
      
      visit orders_path
      click_link task.id.to_s
      #save_and_open_page
      page.should have_content('this line tests workflow')
      page.should have_content((Date.today - 2.days).to_s.gsub('-', '/'))
    end
    
    it "should validate for workflow" do
      #task = FactoryGirl.create(:ad_resource_orderx_order,:gm_approved_by_id => nil, :wf_state => 'approved', :sales_id => @u.id, :customer_id => @cust.id, :resource_id => @res.id)
      task = FactoryGirl.create(:ad_resource_orderx_order, :gm_approved_by_id => @u.id, :wf_state => 'gm_reviewing', :sales_id => @u.id, :customer_id => @cust.id, :resource_id => @res.id)
      visit orders_path
      click_link 'GM Approve'
      #save_and_open_page
      fill_in 'order_wf_comment', :with => 'this line tests workflow'
      fill_in 'order_gm_approve_date', :with => nil #Date.today - 2.days
      #save_and_open_page
      click_button 'Save'
      #
      
      visit orders_path
      click_link task.id.to_s
      #save_and_open_page
      page.should_not have_content('this line tests workflow')
    end
  end
end

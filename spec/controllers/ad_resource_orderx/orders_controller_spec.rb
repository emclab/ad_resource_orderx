require 'spec_helper'

module AdResourceOrderx
  describe OrdersController do
    before(:each) do
      controller.should_receive(:require_signin)
      controller.should_receive(:require_employee)
      @pagination_config = FactoryGirl.create(:engine_config, :engine_name => nil, :engine_version => nil, :argument_name => 'pagination', :argument_value => 30)
    end
    
    before(:each) do
      #wf_common_action(from, to, event)
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
      @res1 = FactoryGirl.create(:ad_resourcex_resource, :name => 'new name')
      @cust = FactoryGirl.create(:kustomerx_customer)
      @cust1 = FactoryGirl.create(:kustomerx_customer, :name => 'new name', :short_name => 'a new one')
    end
    
    render_views
    
    describe "GET 'index'" do
      it "returns all orders" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "AdResourceOrderx::Order.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:ad_resource_orderx_order)
        q1 = FactoryGirl.create(:ad_resource_orderx_order, :customer_po => '')
        get 'index', {:use_route => :ad_resource_orderx}
        assigns(:orders).should =~ [q, q1]
      end
      
      it "should only return the order which belongs to resource id" do       
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "AdResourceOrderx::Order.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:ad_resource_orderx_order, :resource_id => @res1.id)
        q1 = FactoryGirl.create(:ad_resource_orderx_order, :resource_id => @res.id, :customer_po => '')
        get 'index', {:use_route => :ad_resource_orderx, :resource_id => @res.id}
        assigns(:orders).should =~ [q1]
      end
      
      it "should only return the order which belongs to customer id" do       
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "AdResourceOrderx::Order.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:ad_resource_orderx_order, :resource_id => @res1.id, :customer_id => @cust.id)
        q1 = FactoryGirl.create(:ad_resource_orderx_order, :resource_id => @res.id, :customer_po => '', :customer_id => @cust1.id)
        get 'index', {:use_route => :ad_resource_orderx, :customer_id => @cust.id}
        assigns(:orders).should =~ [q]
      end
      
      it "should return orders in params order_ids" do
        user_access = FactoryGirl.create(:user_access, :action => 'index', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "AdResourceOrderx::Order.scoped.order('created_at DESC')")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:ad_resource_orderx_order, :resource_id => @res1.id, :customer_id => @cust.id)
        q1 = FactoryGirl.create(:ad_resource_orderx_order, :resource_id => @res.id, :customer_po => '', :customer_id => @cust1.id)
        get 'index', {:use_route => :ad_resource_orderx, :order_ids => [q.id, q1.id]}
        assigns(:orders).should =~ [q, q1]
      end
    end
  
    describe "GET 'new'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        get 'new', {:use_route => :ad_resource_orderx}
        response.should be_success
      end
    end
  
    describe "GET 'create'" do
      it "returns redirect with success" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:ad_resource_orderx_order)
        get 'create', {:use_route => :ad_resource_orderx, :order => q}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      end
      
      it "should render new with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'create', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.attributes_for(:ad_resource_orderx_order, :order_detail => nil)
        get 'create', {:use_route => :ad_resource_orderx, :order => q}
        response.should render_template('new')
      end
      
    end
  
    describe "GET 'edit'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:ad_resource_orderx_order,:wf_state => '', :sales_id => @u.id)
        get 'edit', {:use_route => :ad_resource_orderx, :id => q.id}
        response.should be_success
      end
      
      it "should redirect to previous page for an open process" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:ad_resource_orderx_order, :wf_state => 'cso_reviewing')  
        get 'edit', {:use_route => :ad_resource_orderx, :id => q.id}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end
  
    describe "GET 'update'" do
      it "should redirect successfully" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:ad_resource_orderx_order)
        get 'update', {:use_route => :ad_resource_orderx, :id => q.id, :order => {:order_detail => 'for biz trip on 4/20'}}
        response.should redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      end
      
      it "should render edit with data error" do
        user_access = FactoryGirl.create(:user_access, :action => 'update', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:ad_resource_orderx_order)
        get 'update', {:use_route => :ad_resource_orderx, :id => q.id, :order => {:order_total => nil}}
        response.should render_template('edit')
      end
    end
  
    describe "GET 'show'" do
      it "returns http success" do
        user_access = FactoryGirl.create(:user_access, :action => 'show', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "record.sales_id == session[:user_id]")
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:ad_resource_orderx_order, :sales_id => @u.id, :customer_id => @cust.id, :resource_id => @res1.id)
        get 'show', {:use_route => :ad_resource_orderx, :id => q.id }
        response.should be_success
      end
    end
    
    describe "GET 'list open process" do
      it "return open process only" do
        user_access = FactoryGirl.create(:user_access, :action => 'list_open_process', :resource =>'ad_resource_orderx_orders', :role_definition_id => @role.id, :rank => 1,
        :sql_code => "AdResourceOrderx::Order.scoped.order('created_at DESC')")        
        session[:user_id] = @u.id
        session[:user_privilege] = Authentify::UserPrivilegeHelper::UserPrivilege.new(@u.id)
        q = FactoryGirl.create(:ad_resource_orderx_order, :created_at => 50.days.ago, :wf_state => 'initial_state', :customer_id => @cust.id, :resource_id => @res.id)  #created too long ago to show
        q1 = FactoryGirl.create(:ad_resource_orderx_order, :wf_state => 'gm_reviewing', :customer_po => nil)
        q2 = FactoryGirl.create(:ad_resource_orderx_order, :wf_state => 'initial_state', :customer_id => @cust1.id, :resource_id => @res.id)
        q3 = FactoryGirl.create(:ad_resource_orderx_order, :wf_state => 'rejected', :customer_id => @cust.id, :resource_id => @res1.id)  #wf_state can't be what was defined.
        get 'list_open_process', {:use_route => :ad_resource_orderx}
        assigns(:orders).should =~ [q1, q2]
      end
    end
  
  end
end

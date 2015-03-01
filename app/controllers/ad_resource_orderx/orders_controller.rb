require_dependency "ad_resource_orderx/application_controller"

module AdResourceOrderx
  class OrdersController < ApplicationController
    before_action :require_employee
    before_action :load_parent_record
    
    def index
      @title = t('Orders')
      @orders = params[:ad_resource_orderx_orders][:model_ar_r]
      @orders = @orders.where(:customer_id => @customer.id) if @customer
      @orders = @orders.where(:resource_id => @resource.id) if @resource
      @orders = @orders.where(:id => @order_ids) if @order_ids
      @orders = @orders.page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('order_index_view', 'ad_resource_orderx')
    end
  
    def new
      @title = t('New Order')
      @order = AdResourceOrderx::Order.new()
      @erb_code = find_config_const('order_new_view', 'ad_resource_orderx')
    end
  
    def create
      @order = AdResourceOrderx::Order.new(params[:order], :as => :role_new)
      @order.last_updated_by_id = session[:user_id]
      if @order.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        @customer = AdResourceOrderx.customer_class.find_by_id(params[:order][:customer_id]) if params[:order][:customer_id].present?
        @resource = AdResourceOrderx.resource_class.find_by_id(params[:order][:resource_id]) if params[:order][:resource_id].present?
        @erb_code = find_config_const('order_new_view', 'ad_resource_orderx')
        flash[:notice] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = t('Update Order')
      @order = AdResourceOrderx::Order.find_by_id(params[:id])
      @erb_code = find_config_const('order_edit_view', 'ad_resource_orderx')
      if @order.wf_state.present? && @order.current_state != :initial_state
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO Update. Record Being Processed!")
      end
    end
  
    def update
      @order = AdResourceOrderx::Order.find_by_id(params[:id])
      @order.last_updated_by_id = session[:user_id]
      if @order.update_attributes(params[:order], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        @erb_code = find_config_const('order_edit_view', 'ad_resource_orderx')
        flash[:notice] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = t('Order Info')
      @order = AdResourceOrderx::Order.find_by_id(params[:id])
      @erb_code = find_config_const('order_show_view', 'ad_resource_orderx')
    end
    
    def list_open_process  
      index()
      @orders = return_open_process(@orders, find_config_const('order_wf_final_state_string', 'ad_resource_orderx'))  # ModelName_wf_final_state_string
    end
    
    protected
    def load_parent_record
      @customer = AdResourceOrderx.customer_class.find_by_id(params[:customer_id]) if params[:customer_id].present?
      @customer = AdResourceOrderx.customer_class.find_by_id(AdResourceOrderx::Order.find_by_id(params[:id]).customer_id) if params[:id].present?
      @resource = AdResourceOrderx.resource_class.find_by_id(params[:resource_id]) if params[:resource_id].present?
      @resource = AdResourceOrderx.resource_class.find_by_id(AdResourceOrderx::Order.find_by_id(params[:id]).resource_id) if params[:id].present?
      @order_ids = params[:order_ids] if params[:order_ids].present?  #should be array
    end
  end
end

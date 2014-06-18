AdResourceOrderx::Engine.routes.draw do
  resources :orders do
    collection do
      get :search
      get :search_results
      get :stats
      get :stats_results    
    end
    
#=begin    
    workflow_routes = Authentify::AuthentifyUtility.find_config_const('order_wf_route', 'ad_resource_orderx')
    if Authentify::AuthentifyUtility.find_config_const('wf_route_in_config') == 'true' && workflow_routes.present?
      eval(workflow_routes) 
    elsif Rails.env.test?
      member do
        get :event_action
        put :submit
        put :cso_approve
        put :cso_reject
        put :gm_approve
        put :gm_reject
        put :gm_rewind
        put :sign_contract
        
      end
      
      collection do
        get :list_open_process
      end
    end
#=end
  end
  

end

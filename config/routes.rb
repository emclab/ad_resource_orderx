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
        patch :submit
        patch :cso_approve
        patch :cso_reject
        patch :gm_approve
        patch :gm_reject
        patch :gm_rewind
        patch :sign_contract
        
      end
      
      collection do
        get :list_open_process
      end
    end
#=end
  end
  

end

Rails.application.routes.draw do

  get "user_menus/index"

  mount AdResourceOrderx::Engine => "/ad_resource_orderx"
  mount AdResourcex::Engine => "/ad_resourcex"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount Searchx::Engine => '/search'
  mount StateMachineLogx::Engine => '/sm_log'
  mount BizWorkflowx::Engine => '/biz_wf'
  mount Kustomerx::Engine => '/customer'
  mount MultiItemContractx::Engine => '/contract'
  mount Supplierx::Engine => '/supplier'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end

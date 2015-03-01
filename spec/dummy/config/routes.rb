Rails.application.routes.draw do

  
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
  
  
  root :to => "authentify/sessions#new"
  get '/signin',  :to => 'authentify/sessions#new'
  get '/signout', :to => 'authentify/sessions#destroy'
  get '/user_menus', :to => 'user_menus#index'
  get '/view_handler', :to => 'authentify/application#view_handler'
end

RatingsExporter::Application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  get 'export'                  => 'export#export'
  get 'export_callback'         => 'export#export_callback'
  get 'welcome'                 => 'welcome#index'
  get 'sign_out'                => 'welcome#sign_out'
  get 'progress'                => 'welcome#progress'
  get 'download'                => 'welcome#download'
  get 'continue'                => 'welcome#continue'
  get 'ignore'                  => 'welcome#ignore'
  root :to => "welcome#index"
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  namespace :api do
    namespace :v1 do
      resources :breeds, except: [:new, :edit]
      resources :tags, except: [:new, :edit]
    end
  end
end

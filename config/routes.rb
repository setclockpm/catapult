Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  namespace :api do
    namespace :v1 do
      resources :tags, except: [:new, :edit] do
        collection do
          get :stats
        end
      end
      resources :breeds, except: [:new, :edit] do
        collection do
          get :stats
        end
        
        resources :tags, only: [:index, :create]
      end
    end
  end
end

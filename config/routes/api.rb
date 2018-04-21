namespace :api, defaults: { format: :json } do

  namespace :wxmp do
    resources :mp_users, only: [] do
      member do
        match :callback, via: [:post, :get], action: :callback
      end
    end
  end

end
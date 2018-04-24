class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  draw :api

  namespace :wxmp do
    get ":id/home", to: "dashboard#home"
    get "home", to: "dashboard#home"
    get "dashboard", to: "dashboard#index"
  end

  namespace :alipay do
    get "home", to: "dashboard#home"
    get "dashboard", to: "dashboard#index"
    get "authorization", to: "dashboard#authorization"
  end

end

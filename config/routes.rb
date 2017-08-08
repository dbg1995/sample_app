Rails.application.routes.draw do
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :account_activations, only: :edit
  resources :password_resets, except: [:show, :destroy, :index]
  resources :microposts, only: [:create, :destroy]
  # edit_account_activation_url(@user.activation_token, email: @user.email)
  # activation link follow REST URL is patch request to update action but
  # activation link in an email, so use get request to edit action to instead
  # the first argument follow REST URL that same role as /users/1/edit.
  # the second argument is include email by query parameter return
  # account_activations/q5lt38hQDc_959PVoo6b7A/edit?email=danh13t2%40gmail.com,
  # %40 as @ for a valid url, email will be available via params[:email] in controller
end

Rails.application.routes.draw do
  devise_for :users

  # Dashboard (root)
  root "dashboard#index"
  get "/dashboard" => "dashboard#index", as: :dashboard

  # Workouts
  get "/workouts" => "workouts#index", as: :workouts
  get "/workouts/upload" => "workouts#upload_form", as: :upload_form_workouts
  post "/workouts/upload" => "workouts#upload", as: :upload_workouts
  get "/workouts/new" => "workouts#new_form", as: :new_workout
  post "/workouts" => "workouts#create", as: :create_workout
  get "/workouts/:id" => "workouts#show", as: :workout
  get "/workouts/:id/edit" => "workouts#edit_form", as: :edit_workout
  patch "/workouts/:id" => "workouts#update", as: :update_workout
  delete "/workouts/:id" => "workouts#destroy", as: :destroy_workout

  # Leaderboards
  get "/leaderboards" => "leaderboards#index", as: :leaderboards

  # Users (profiles & discovery)
  get "/users" => "users#index", as: :users
  get "/users/:id" => "users#show", as: :user

  # Friendships (follow/unfollow)
  post "/friendships" => "friendships#create", as: :friendships
  delete "/friendships/:id" => "friendships#destroy", as: :friendship
end


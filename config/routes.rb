Rails.application.routes.draw do
  # Routes for the Friendship resource:

  # CREATE
  post("/insert_friendship", { :controller => "friendships", :action => "create" })

  # READ
  get("/friendships", { :controller => "friendships", :action => "index" })

  get("/friendships/:path_id", { :controller => "friendships", :action => "show" })

  # UPDATE

  post("/modify_friendship/:path_id", { :controller => "friendships", :action => "update" })

  # DELETE
  get("/delete_friendship/:path_id", { :controller => "friendships", :action => "destroy" })

  #------------------------------

  # Routes for the Workout resource:

  # CREATE
  post("/insert_workout", { :controller => "workouts", :action => "create" })

  # READ
  get("/workouts", { :controller => "workouts", :action => "index" })

  get("/workouts/:path_id", { :controller => "workouts", :action => "show" })

  # UPDATE

  post("/modify_workout/:path_id", { :controller => "workouts", :action => "update" })

  # DELETE
  get("/delete_workout/:path_id", { :controller => "workouts", :action => "destroy" })

  #------------------------------

  # Routes for the Category resource:

  # CREATE
  post("/insert_category", { :controller => "categories", :action => "create" })

  # READ
  get("/categories", { :controller => "categories", :action => "index" })

  get("/categories/:path_id", { :controller => "categories", :action => "show" })

  # UPDATE

  post("/modify_category/:path_id", { :controller => "categories", :action => "update" })

  # DELETE
  get("/delete_category/:path_id", { :controller => "categories", :action => "destroy" })

  #------------------------------

  devise_for :users
  # This is a blank app! Pick your first screen, build out the RCAV, and go from there. E.g.:
  # get("/your_first_screen", { :controller => "pages", :action => "first" })
end

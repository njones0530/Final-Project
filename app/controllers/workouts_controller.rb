class WorkoutsController < ApplicationController
  def index
    matching_workouts = Workout.all

    @list_of_workouts = matching_workouts.order({ :created_at => :desc })

    render({ :template => "workout_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_workouts = Workout.where({ :id => the_id })

    @the_workout = matching_workouts.at(0)

    render({ :template => "workout_templates/show" })
  end

  def create
    the_workout = Workout.new
    the_workout.title = params.fetch("query_title")
    the_workout.workout_date = params.fetch("query_workout_date")
    the_workout.duration_minutes = params.fetch("query_duration_minutes")
    the_workout.distance_km = params.fetch("query_distance_km")
    the_workout.heart_rate_avg = params.fetch("query_heart_rate_avg")
    the_workout.heart_rate_max = params.fetch("query_heart_rate_max")
    the_workout.calories = params.fetch("query_calories")
    the_workout.source = params.fetch("query_source")
    the_workout.raw_data = params.fetch("query_raw_data")
    the_workout.notes = params.fetch("query_notes")
    the_workout.user_id = params.fetch("query_user_id")
    the_workout.category_id = params.fetch("query_category_id")

    if the_workout.valid?
      the_workout.save
      redirect_to("/workouts", { :notice => "Workout created successfully." })
    else
      redirect_to("/workouts", { :alert => the_workout.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_workout = Workout.where({ :id => the_id }).at(0)

    the_workout.title = params.fetch("query_title")
    the_workout.workout_date = params.fetch("query_workout_date")
    the_workout.duration_minutes = params.fetch("query_duration_minutes")
    the_workout.distance_km = params.fetch("query_distance_km")
    the_workout.heart_rate_avg = params.fetch("query_heart_rate_avg")
    the_workout.heart_rate_max = params.fetch("query_heart_rate_max")
    the_workout.calories = params.fetch("query_calories")
    the_workout.source = params.fetch("query_source")
    the_workout.raw_data = params.fetch("query_raw_data")
    the_workout.notes = params.fetch("query_notes")
    the_workout.user_id = params.fetch("query_user_id")
    the_workout.category_id = params.fetch("query_category_id")

    if the_workout.valid?
      the_workout.save
      redirect_to("/workouts/#{the_workout.id}", { :notice => "Workout updated successfully." } )
    else
      redirect_to("/workouts/#{the_workout.id}", { :alert => the_workout.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_workout = Workout.where({ :id => the_id }).at(0)

    the_workout.destroy

    redirect_to("/workouts", { :notice => "Workout deleted successfully." } )
  end
end

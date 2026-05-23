class WorkoutsController < ApplicationController
  def index
    @workouts = current_user.workouts.recent.includes(:category)

    # Optional filtering
    if params[:category_id].present?
      @workouts = @workouts.where(category_id: params[:category_id])
    end

    @categories = Category.all

    render("workouts/index")
  end

  def show
    @workout = current_user.workouts.find(params[:id])

    render("workouts/show")
  end

  def new_form
    render("workouts/new_form")
  end

  def create
    @workout = Workout.new
    @workout.user_id = current_user.id
    @workout.title = params.fetch("title")
    @workout.workout_date = params.fetch("workout_date")
    @workout.duration_minutes = params.fetch("duration_minutes")
    @workout.distance_km = params.fetch("distance_km")
    @workout.heart_rate_avg = params.fetch("heart_rate_avg")
    @workout.heart_rate_max = params.fetch("heart_rate_max")
    @workout.calories = params.fetch("calories")
    @workout.source = "manual"
    @workout.notes = params.fetch("notes")

    # Use AI to categorize if no category was selected
    if params[:category_id].present?
      @workout.category_id = params.fetch("category_id")
    else
      categorizer = WorkoutCategorizer.new(@workout)
      @workout.category = categorizer.categorize
    end

    if @workout.save
      redirect_to workout_path(@workout), notice: "Workout logged! Categorized as #{@workout.category_name}."
    else
      render("workouts/new_form")
    end
  end

  def edit_form
    @workout = current_user.workouts.find(params[:id])

    render("workouts/edit_form")
  end

  def update
    @workout = current_user.workouts.find(params[:id])
    @workout.title = params.fetch("title")
    @workout.workout_date = params.fetch("workout_date")
    @workout.duration_minutes = params.fetch("duration_minutes")
    @workout.distance_km = params.fetch("distance_km")
    @workout.heart_rate_avg = params.fetch("heart_rate_avg")
    @workout.heart_rate_max = params.fetch("heart_rate_max")
    @workout.calories = params.fetch("calories")
    @workout.notes = params.fetch("notes")
    @workout.category_id = params.fetch("category_id") if params[:category_id].present?

    if @workout.save
      redirect_to workout_path(@workout), notice: "Workout updated."
    else
      render("workouts/edit_form")
    end
  end

  def destroy
    @workout = current_user.workouts.find(params[:id])
    @workout.destroy

    redirect_to workouts_path, notice: "Workout deleted."
  end

  # --- File Upload ---

  def upload_form
    render("workouts/upload_form")
  end

  def upload
    file = params.fetch("workout_file")

    if file.blank?
      redirect_to upload_form_workouts_path, alert: "Please select a file."
      return
    end

    parser = WorkoutParser.new(file, current_user)
    results = parser.parse_and_create

    if results[:errors].any?
      redirect_to workouts_path, alert: "Imported #{results[:created]} workouts. #{results[:errors].length} rows had errors."
    else
      redirect_to workouts_path, notice: "Successfully imported #{results[:created]} workouts!"
    end
  end
end


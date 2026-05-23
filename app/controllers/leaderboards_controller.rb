class LeaderboardsController < ApplicationController
  def index
    # Get the user's friends plus themselves
    friend_ids = current_user.following.pluck(:id) + [current_user.id]

    @time_period = params.fetch("period", "all_time")

    workouts_scope = Workout.where(user_id: friend_ids)

    case @time_period
    when "this_week"
      workouts_scope = workouts_scope.this_week
    when "this_month"
      workouts_scope = workouts_scope.this_month
    end

    # Leaderboard: total workouts
    @by_total_workouts = User.where(id: friend_ids)
      .left_joins(:workouts)
      .select("users.*, COUNT(workouts.id) as workout_count")
      .merge(time_filter(Workout, @time_period))
      .group("users.id")
      .order("workout_count DESC")

    # Leaderboard: total duration
    @by_total_duration = User.where(id: friend_ids)
      .left_joins(:workouts)
      .select("users.*, COALESCE(SUM(workouts.duration_minutes), 0) as total_duration")
      .merge(time_filter(Workout, @time_period))
      .group("users.id")
      .order("total_duration DESC")

    # Leaderboard: total distance
    @by_total_distance = User.where(id: friend_ids)
      .left_joins(:workouts)
      .select("users.*, COALESCE(SUM(workouts.distance_km), 0) as total_distance")
      .merge(time_filter(Workout, @time_period))
      .group("users.id")
      .order("total_distance DESC")

    # Leaderboard: total calories
    @by_total_calories = User.where(id: friend_ids)
      .left_joins(:workouts)
      .select("users.*, COALESCE(SUM(workouts.calories), 0) as total_calories")
      .merge(time_filter(Workout, @time_period))
      .group("users.id")
      .order("total_calories DESC")

    @categories = Category.all

    render("leaderboards/index")
  end

  private

  def time_filter(model, period)
    case period
    when "this_week"
      model.where("workouts.workout_date >= ?", Date.today.beginning_of_week)
    when "this_month"
      model.where("workouts.workout_date >= ?", Date.today.beginning_of_month)
    else
      model.all
    end
  end
end


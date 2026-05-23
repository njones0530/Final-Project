class DashboardController < ApplicationController
  def index
    @user = current_user
    @recent_workouts = @user.workouts.recent.limit(5).includes(:category)
    @total_workouts = @user.total_workouts
    @total_duration = @user.total_duration
    @total_distance = @user.total_distance
    @total_calories = @user.total_calories
    @workouts_this_week = @user.workouts_this_week

    @workouts_by_category = @user.workouts
      .joins(:category)
      .group("categories.name")
      .count

    @workouts_by_week = @user.workouts
      .where("workout_date >= ?", 8.weeks.ago)
      .order(:workout_date)
      .group_by { |w| w.workout_date.beginning_of_week.strftime("%b %d") }
      .transform_values(&:count)

    @duration_by_category = @user.workouts
      .joins(:category)
      .group("categories.name")
      .sum(:duration_minutes)

    render("dashboard/index")
  end
end

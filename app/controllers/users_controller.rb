class UsersController < ApplicationController
  def index
    @users = User.where.not(id: current_user.id).order(:username)

    if params[:query].present?
      @users = @users.where("username ILIKE ? OR email ILIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    end

    render("users/index")
  end

  def show
    @user = User.find(params[:id])
    @workouts = @user.workouts.recent.includes(:category).limit(10)
    @is_following = current_user.follows?(@user)

    @workouts_by_category = @user.workouts
      .joins(:category)
      .group("categories.name")
      .count

    render("users/show")
  end
end

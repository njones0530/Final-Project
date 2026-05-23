class FriendshipsController < ApplicationController
  def create
    @user = User.find(params.fetch("followed_id"))
    current_user.follow(@user)

    redirect_back(fallback_location: users_path, notice: "You are now following #{@user.display_name}!")
  end

  def destroy
    @friendship = Friendship.find(params[:id])

    if @friendship.follower_id == current_user.id
      @user = @friendship.followed
      @friendship.destroy
      redirect_back(fallback_location: users_path, notice: "You unfollowed #{@user.display_name}.")
    else
      redirect_back(fallback_location: users_path, alert: "Not authorized.")
    end
  end
end

